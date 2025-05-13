extends Node

class_name Etiqueta

func _init(mesh, text, altura):
	var label_3d = Label3D.new()
	label_3d.text = text
	label_3d.font_size = 20
	label_3d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label_3d.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label_3d.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label_3d.width = 200
	label_3d.position = Vector3(altura * 1.5, 0, 0)
	mesh.add_child(label_3d)
