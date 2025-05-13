# FileManager.gd
extends Node

# Dictionary to map file extensions to file types
const FILE_TYPES = {
	"txt": "text",
	"json": "text",
	"csv": "text",
	"md": "text",
	"png": "image",
	"jpg": "image",
	"jpeg": "image",
	"webp": "image",
	"svg": "image",
	"bmp": "image",
	"wav": "audio",
	"mp3": "audio",
	"ogg": "audio",
	"glb": "model",
	"gltf": "model",
	"obj": "model",
	"blend": "model",
	"fbx": "model",
	"ttf": "font",
	"otf": "font",
	"woff": "font",
	"woff2": "font",
	"mp4": "video",
	"webm": "video",
	"zip": "archive",
	"rar": "archive",
	"7z": "archive",
	"doc": "document",
	"docx": "document",
	"pdf": "document",
	"xls": "spreadsheet",
	"xlsx": "spreadsheet",
	"import": "import",
	"html": "html"
}

# Main function to explore the data directory and build a structured dictionary
func explore_data_directory():
	var base_path = "res://data/"
	var data_structure = scan_directory(base_path)
	print("Data structure created successfully")
	return data_structure

# Recursive function to scan directories and create a dictionary structure
func scan_directory(path):
	var dir = DirAccess.open(path)
	
	if not dir:
		print("Error opening directory: ", DirAccess.get_open_error())
		return null
	
	# Create a directory entry with files array
	var directory_entry = {
		"type": "directory",
		"name": get_directory_name(path),
		"files": []
	}
	
	# Start scanning directory contents
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		# Skip hidden files and special directories
		if not file_name.begins_with(".") and file_name != "." and file_name != "..":
			var full_path = path + file_name
			
			if dir.current_is_dir():
				# Recursive call for subdirectories with trailing slash added
				var subdirectory = scan_directory(full_path + "/")
				if subdirectory:
					directory_entry.files.append(subdirectory)
			else:
				# Add file entry with determined type
				var file_type = identify_file_type(file_name)
				var file_entry = {
					"type": file_type,
					"name": file_name,
					"path": full_path
				}
				if file_entry.type != "import":
					directory_entry.files.append(file_entry)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return directory_entry

# Function to identify file type based on extension
func identify_file_type(file_name):
	var extension = file_name.get_extension().to_lower()
	
	if FILE_TYPES.has(extension):
		return FILE_TYPES[extension]
	else:
		return "unknown"

# Helper function to extract directory name from path
func get_directory_name(path):
	# Remove trailing slash if exists
	var clean_path = path
	if clean_path.ends_with("/"):
		clean_path = clean_path.substr(0, clean_path.length() - 1)
	
	# Get the directory name (last segment of the path)
	var segments = clean_path.split("/")
	return segments[segments.size() - 1]

# Function to print the data structure (for debugging)
func print_data_structure(data, indent_level = 0):
	var indent = "  ".repeat(indent_level)
	
	if data.type == "directory":
		print(indent + "📁 " + data.name)
		for item in data.files:
			print_data_structure(item, indent_level + 1)
	else:
		print(indent + "📄 " + data.name)

# Example usage
func _ready():
	# var data_structure = explore_data_directory()
	# print_data_structure(data_structure)
	#print(JSON.stringify(data_structure, "  "))
	pass
