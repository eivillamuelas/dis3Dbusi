extends Node
class_name Archivo
var ELEMENT_SIZE = 0.1
var mesh: MeshInstance3D

# Constructor simplificado
func _init(file):
	# Crear la caja
	mesh = MeshInstance3D.new()
	mesh.name = "_" + file.name
	
	var boxMesh = BoxMesh.new()
	boxMesh.size = Vector3(ELEMENT_SIZE, ELEMENT_SIZE, ELEMENT_SIZE)
	mesh.mesh = boxMesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.0, 1.0, 1.0)
	boxMesh.material = material
	
	# Agregar etiqueta
	Etiqueta.new(mesh, file.name, ELEMENT_SIZE)
	
	# Si es una imagen, mostrarla encima del cubo
	if file.type == "image":
		print("Cargando imagen: ", file.path)  # Ayuda para depuración
		ImagenDisplay.new(mesh, file.path, ELEMENT_SIZE)

# Método para obtener el nodo de la caja
func get_mesh() -> MeshInstance3D:
	return mesh

# Método para establecer la posición
func set_position(position: Vector3):
	mesh.position = position
