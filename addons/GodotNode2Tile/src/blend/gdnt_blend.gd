@tool

extends Node3D
class_name GDNTBlend

class VertexBlend:
	var Position : Vector3
	var Normal : Vector3
	var TexCoord : Vector2
	var MaterialID : int
	
	var _Id : int
	
	func _init(pos : Vector3, normal : Vector3, tex_coord : Vector2, material_id : int) -> void:
		_Id = randi()
		
		Position = pos
		Normal = normal
		TexCoord = tex_coord
		MaterialID = material_id

class FaceBlend:
	var Vertices : Array[int]
	
	func _init() -> void:
		return
	
	func create() -> void:
		if Vertices.size() < 3:
			return

@export var _vertices_array : Array[GDNTVertex]
@export var _faces_array : Array[GDNTFace]

var _basemesh : RID
var _instance : RID

#WARNING: Editor only
var _pointdrawinstance : RID
var _pointdrawmeshbase : RID
var _selected_vertices : Array[GDNTVertex]

var DEFAULT_MATERIAL = StandardMaterial3D.new()

@export var surfaces : Array[StandardMaterial3D]

func _select_vertex_with_and_gizmo() -> void:
	#EditorInterface.get_selection().add_node()
	
	var cam = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
	
	for i in _vertices_array.size():
		if cam.unproject_position(_vertices_array[i].Position).distance_to(get_viewport().get_mouse_position()) < 1:
			print(_vertices_array[i])

func draw_model() -> void:
	RenderingServer.mesh_clear(_basemesh)
	
	var _surface_data : Array
	
	for i in surfaces.size():
		if not surfaces[i]:
			continue
		
		_surface_data.clear()
		_surface_data.resize(ArrayMesh.ARRAY_MAX)
		_surface_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array([])
		
		for j in _faces_array.size():
			if _faces_array[j].Vertices.size() > 2 and _vertices_array.size() >= _faces_array[j].Vertices.size():
				for k in _faces_array[j].Vertices.size():
					var _vertex = _vertices_array[_faces_array[j].Vertices[k]]
					
					if _vertex.MaterialID == i:
						_surface_data[ArrayMesh.ARRAY_VERTEX].append(_vertex.Position)
		
		if _surface_data[ArrayMesh.ARRAY_VERTEX].size() < 3:
			continue
		
		RenderingServer.mesh_add_surface_from_arrays(_basemesh, RenderingServer.PRIMITIVE_TRIANGLES, _surface_data)
		RenderingServer.mesh_surface_set_material(_basemesh, i, surfaces[i])
	


func draw_vertices() -> void:
	var _mesh_data : Array
	_mesh_data.resize(ArrayMesh.ARRAY_MAX)
	var _points = []
	
	for i in _vertices_array.size():
		_points.append(_vertices_array[i].Position)
	
	_mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(_points)
	
	RenderingServer.mesh_clear(_pointdrawmeshbase)
	RenderingServer.mesh_add_surface_from_arrays(_pointdrawmeshbase, RenderingServer.PRIMITIVE_POINTS, _mesh_data, [], {}, RenderingServer.ARRAY_FLAG_USE_DYNAMIC_UPDATE)
	RenderingServer.mesh_surface_set_material(_pointdrawmeshbase, 0, DEFAULT_MATERIAL)

func _enter_tree() -> void:
	_instance = RenderingServer.instance_create()
	_basemesh = RenderingServer.mesh_create()
	
	RenderingServer.instance_set_base		(_instance, _basemesh)
	RenderingServer.instance_set_scenario	(_instance, get_world_3d().scenario)
	
	if Engine.is_editor_hint():
		_pointdrawinstance = RenderingServer.instance_create()
		_pointdrawmeshbase = RenderingServer.mesh_create()
		
		RenderingServer.instance_set_scenario	(_pointdrawinstance, get_world_3d().scenario)
		RenderingServer.instance_set_base		(_pointdrawinstance, _pointdrawmeshbase)
		
		EditorInterface.get_editor_main_screen().gui_input.connect(
			func(event):
				if event is InputEventMouseButton:
					if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
						_select_vertex_with_and_gizmo())

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		RenderingServer.free_rid(_pointdrawinstance)
		RenderingServer.free_rid(_pointdrawmeshbase)
	
	RenderingServer.free_rid(_instance)
	RenderingServer.free_rid(_basemesh)

func _init() -> void:
	DEFAULT_MATERIAL.use_point_size = true
	DEFAULT_MATERIAL.point_size = 6
	DEFAULT_MATERIAL.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	_vertices_array.append(GDNTVertex.new(Vector3(0, 0, 0), Vector3.ZERO, Vector2.ZERO, 0))
	_vertices_array.append(GDNTVertex.new(Vector3(1, 0, 0), Vector3.ZERO, Vector2.ZERO, 0))
	_vertices_array.append(GDNTVertex.new(Vector3(1, 1, 0), Vector3.ZERO, Vector2.ZERO, 0))

func _ready() -> void:
	draw_model()


func _process(delta: float) -> void:
	RenderingServer.instance_set_transform(_instance, transform)
	
	if Engine.is_editor_hint():
		RenderingServer.instance_set_transform(_pointdrawinstance, transform)
		
		draw_model()
		draw_vertices()
