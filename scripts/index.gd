# TuNodoEscena3D.gd
extends Node3D

var GRID_SPACE = 1
var nivel = 0
var objeto = 0

func _ready():
	# Generate the initial data structure or retrieve it from Distribusi
	var data_structure = Distribusi.explore_data_directory()
	generate_Meshes(data_structure)

func generate_Meshes(data):
	if (data["type"] == "directory"):
		var directorio = Directorio.new(data)
		var mesh = directorio.get_mesh()
		directorio.set_position(Vector3(GRID_SPACE * nivel, 0, GRID_SPACE * objeto))
		add_child(mesh)
		nivel += 1
		if (data.files):
			for file in data.files:
				generate_Meshes(file)
		nivel -= 1
	else:
		# Crear el archivo y configurarlo
		var archivo = Archivo.new(data)
		var mesh = archivo.get_mesh()
		archivo.set_position(Vector3(GRID_SPACE * nivel, 0, GRID_SPACE * objeto))
		add_child(mesh)
		objeto += 1
