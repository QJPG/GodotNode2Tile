@tool
class_name VertexAttachment extends Node3D

@export var vertex : int = -1 : set = set_vertex_index
@export var offset : VertexAttachment

var last_transform : Transform3D

func set_vertex_index(index : int) -> void:
	vertex = index

	if get_parent() is BrushForm:
		if vertex < get_parent().positions.size():
			transform.origin = get_parent().positions[vertex]

func _init():
	pass

func _ready():
	last_transform = transform

func transform_vertex() -> void:
	if get_parent() is BrushForm:
		if vertex < get_parent().positions.size() and vertex > -1:
			get_parent().positions[vertex] = transform.origin# * get_parent().positions[vertex]

func _process(delta):
	if offset:
		global_transform.origin = offset.global_transform.origin
		
		transform_vertex()
		return
	
	if not visible:
		transform = last_transform
	
	transform_vertex()
	
	last_transform = transform
