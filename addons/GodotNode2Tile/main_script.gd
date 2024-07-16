@tool
extends EditorPlugin

const INSPECTOR_SCRIPT:GDScript = preload("res://addons/GodotNode2Tile/src/inspector_plugin.gd")
var inspector_plugin:EditorInspectorPlugin = INSPECTOR_SCRIPT.new()

const VertexGZMScr := preload("res://addons/GodotNode2Tile/src/vertex_gzmo.gd")
var vertexGZM := VertexGZMScr.new()

func _enter_tree():
	add_custom_type("Brush",
		"Brush",
		preload("../GodotNode2Tile/src/cl_brush.gd"),
		preload("../GodotNode2Tile/misc/icon_brush.png"))
	
	add_custom_type("BrushForm",
		"BrushForm",
		preload("../GodotNode2Tile/src/cl_form.gd"),
		preload("../GodotNode2Tile/misc/icon_form.png"))
	
	add_custom_type("VertexAttachment",
		"VertexAttachment",
		preload("../GodotNode2Tile/src/cl_vertex_attachment.gd"),
		preload("../GodotNode2Tile/misc/icon_vatt.png"))
	
	add_node_3d_gizmo_plugin(vertexGZM)
	add_inspector_plugin(inspector_plugin)


func _exit_tree():
	remove_custom_type("Brush")
	remove_custom_type("BrushForm")
	remove_custom_type("VertexAttachment")
	remove_node_3d_gizmo_plugin(vertexGZM)
	remove_inspector_plugin(inspector_plugin)
