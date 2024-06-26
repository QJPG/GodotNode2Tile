@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Brush",
		"Brush",
		preload("res://addons/GodotNode2Tile/src/cl_brush.gd"),
		preload("res://addons/GodotNode2Tile/misc/icon_brush.png"))
	
	add_custom_type("BrushForm",
		"BrushForm",
		preload("res://addons/GodotNode2Tile/src/cl_form.gd"),
		preload("res://addons/GodotNode2Tile/misc/icon_form.png"))
	
	add_custom_type("VertexAttachment",
		"VertexAttachment",
		preload("res://addons/GodotNode2Tile/src/cl_vertex_attachment.gd"),
		preload("res://addons/GodotNode2Tile/misc/icon_vatt.png"))


func _exit_tree():
	remove_custom_type("Brush")
	remove_custom_type("BrushForm")
	remove_custom_type("VertexAttachment")
