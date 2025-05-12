import * as THREE from "https://esm.sh/three";
import { createImagePlane } from "./imageLoader.js";

// Creamos un cache para almacenar los metadatos
const metadataCache = {};

// Función para cargar los metadatos de un nodo
async function obtenerArchivos(nodeId) {
    try {
        const response = await fetch(`/data/${nodeId}/metadata.json`);
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        const metadata = await response.json();
        return metadata;
    } catch (error) {
        console.error(`Error al obtener metadatos:`, error);
        return {}; // Devuelve un objeto vacío en caso de error
    }
}

// Función para precargar todos los metadatos
async function precargarMetadatos(nodes) {
    // Crear un array de promesas para cargar todos los metadatos en paralelo
    const promesas = nodes.map(async (node) => {
        try {
            metadataCache[node.id] = await obtenerArchivos(node.id);
        } catch (error) {
            console.error(`Error al precargar metadatos para ${node.id}:`, error);
            metadataCache[node.id] = {};
        }
    });

    // Esperar a que todas las cargas terminen
    await Promise.all(promesas);
}

// Inicializar el grafo solo después de cargar los datos
async function inicializarGrafo() {
    try {
        // 1. Cargar estructura.json
        const response = await fetch("estructura.json");
        const data = await response.json();

        // 2. Precargar todos los metadatos
        await precargarMetadatos(data.nodes);

        // 3. Inicializar el grafo una vez que tenemos todos los metadatos
        const Graph = new ForceGraph3D(document.getElementById("3d-graph"), { controlType: "orbit" })
            .graphData(data) // Usamos directamente los datos cargados en lugar de jsonUrl
            .nodeLabel("id")
            .nodeThreeObject((node) => {
                // Ahora podemos acceder a los metadatos precargados inmediatamente
                const metadata = metadataCache[node.id] || {};

                // Crear un grupo para contener ambos objetos
                const group = new THREE.Group();

                // Crear el plano
                const sizePlane = 30;
                const plane = new THREE.Mesh(
                    new THREE.PlaneGeometry(sizePlane, sizePlane).rotateX(-90 * (Math.PI / 180)),
                    new THREE.MeshLambertMaterial({
                        // Podemos usar metadatos para el color si están disponibles
                        color: Math.round(Math.random() * Math.pow(2, 24)),
                        transparent: true,
                        opacity: 0.75,
                        wireframe: true,
                    })
                );

                // Añadir objetos al grupo
                group.add(plane);

                // Si hay archivos, podríamos ajustar el tamaño basado en la cantidad
                if (metadata.files && metadata.files.length) {
                    const escala = Math.max(0.5, Math.min(4, metadata.files.length / 4));
                    plane.scale.set(escala, escala, escala);

                    let distancia = 0;

                    metadata.files.map((file) => {
                        let mesh;

                        if (file.type == "image") {
                            const pathToImage = metadata.path + "/" + file.name;
                            // Usar la función importada
                            mesh = createImagePlane(pathToImage);
                        } else {
                            mesh = new THREE.Mesh(
                                new THREE.SphereGeometry(1, 10, 5),
                                new THREE.MeshLambertMaterial({
                                    color: Math.round(Math.random() * Math.pow(2, 24)),
                                    transparent: true,
                                    opacity: 0.9,
                                    wireframe: true,
                                })
                            );
                        }

                        if (file.data && file.data.rot) {
                            mesh.rotateY(file.data.rot[0] * (Math.PI / 180));
                            mesh.rotateX(file.data.rot[1] * (Math.PI / 180));
                            mesh.rotateZ(file.data.rot[2] * (Math.PI / 180));
                        } else {
                            // Aplicar rotación si se especifica
                            mesh.rotateY(45 * (Math.PI / 180));
                        }

                        if (file.data && file.data.pos) {
                            mesh.position.y = file.data.pos[0];
                            mesh.position.x = file.data.pos[1];
                            mesh.position.z = file.data.pos[2];
                        } else {
                            // Ajustes basados en metadatos
                            mesh.position.y = 5;
                            mesh.position.x = -(escala * sizePlane) / 2 + distancia;
                            mesh.position.z = -(escala * sizePlane) / 2;
                            distancia += 4;
                        }

                        group.add(mesh);
                    });
                }

                return group;
            });
    } catch (error) {
        console.error("Error al inicializar el grafo:", error);
    }
}

// Iniciar todo el proceso
inicializarGrafo();
