@tool
class_name BrushForm extends Node3D

@export_subgroup("data")
@export var positions : Array[Vector3]
@export var normals : Array[Vector3]
@export var uvs : Array[Vector2]
@export var indices : Array[int]

@export_subgroup("surface")
@export var material : Material = null
@export var recalculated_normals : bool = true
@export var surface_normal : Vector3 = Vector3.ONE

@export_subgroup("Experimental")
@export var cubic_projection := false
@export var cubic_projection_step := 1.0
@export var cubic_projection_plane : Vector3 = Vector3.ONE

var last_transform : Transform3D

func append_vatt() -> void:
	var vcount = positions.size()
	
	for child in get_children():
		if child is VertexAttachment:
			vcount -= 1
	
	for i in range(vcount):
		var v = VertexAttachment.new()
		v.name = "V_%s" % str(positions.size() - vcount)
		
		self.add_child(v, true)
		v.owner = get_tree().edited_scene_root
		
		v.vertex = positions.size() - vcount
		
		
		vcount -= 1

func _init():
	positions.append(Vector3(-0.5, 0, -0.5))
	positions.append(Vector3(0.5, 0, -0.5))
	positions.append(Vector3(0.5, 0, 0.5))
	positions.append(Vector3(-0.5, 0, 0.5))
	
	normals.append(Vector3.UP)
	normals.append(Vector3.UP)
	normals.append(Vector3.UP)
	normals.append(Vector3.UP)
	
	uvs.append(Vector2(0, 0))
	uvs.append(Vector2(1, 0))
	uvs.append(Vector2(1, 1))
	uvs.append(Vector2(0, 1))
	
	indices.append(0)
	indices.append(1)
	indices.append(2)
	
	indices.append(0)
	indices.append(2)
	indices.append(3)

func _enter_tree():
	append_vatt()

func _ready():
	last_transform = transform

func _process(delta):
	if not visible:
		transform = last_transform
	
	last_transform = transform
