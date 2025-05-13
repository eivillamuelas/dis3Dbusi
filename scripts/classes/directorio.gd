extends Node
class_name Directorio

var ELEMENT_SIZE = 0.1
var mesh: MeshInstance3D

func _init(directory):
	mesh = MeshInstance3D.new()
	mesh.name = "_" + directory.name
	
	var boxMesh = BoxMesh.new()
	boxMesh.size = Vector3(ELEMENT_SIZE, ELEMENT_SIZE, ELEMENT_SIZE)
	mesh.mesh = boxMesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 1.0, 0.0)
	boxMesh.material = material
	
	# Add a label with directory name
	Etiqueta.new(mesh, directory.name, ELEMENT_SIZE)

# Método para obtener el nodo de la caja
func get_mesh() -> MeshInstance3D:
	return mesh

# Método para establecer la posición
func set_position(position: Vector3):
	mesh.position = position
