extends Node
class_name ImagenDisplay

var MAX_SIZE = 0.8  # Tamaño máximo para la imagen

# Constructor 
func _init(parent_node, image_path, base_size):
	# Crear un QuadMesh para mostrar la imagen
	var quad = MeshInstance3D.new()
	quad.name = "ImageDisplay"
	
	# Cargar la textura
	var texture = ResourceLoader.load(image_path)
	
	if texture:
		# Crear un material para el quad
		var material = StandardMaterial3D.new()
		material.albedo_texture = texture
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Visible desde ambos lados
		
		# Obtener dimensiones de la textura
		var width = texture.get_width()
		var height = texture.get_height()
		
		# Calcular proporciones
		var scale_factor = 1.0
		var final_width = MAX_SIZE
		var final_height = MAX_SIZE
		
		# Determinar qué dimensión es más grande y ajustar la otra proporcionalmente
		if width >= height:
			# Si el ancho es mayor, lo ajustamos a MAX_SIZE y calculamos el alto proporcionalmente
			scale_factor = MAX_SIZE / width
			final_height = height * scale_factor
		else:
			# Si el alto es mayor, lo ajustamos a MAX_SIZE y calculamos el ancho proporcionalmente
			scale_factor = MAX_SIZE / height
			final_width = width * scale_factor
		
		# Crear el mesh con las dimensiones calculadas
		var mesh = QuadMesh.new()
		mesh.size = Vector2(final_width, final_height)
		mesh.material = material
		
		quad.mesh = mesh
		
		# Posicionar encima del cubo
		quad.position = Vector3(0, base_size + (final_height/2), 0)
		
		# Agregar al nodo padre
		parent_node.add_child(quad)
	else:
		print("No se pudo cargar la imagen: ", image_path)
