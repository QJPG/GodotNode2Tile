extends EditorNode3DGizmoPlugin

var grabbed: bool = false
var vertex: int = -1
var inPos : Vector2
var outPos := Vector3.ZERO

func _get_gizmo_name() -> String:
	return "Vertex Snapper"

func _get_handle_name(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> String:
	return "(Drag to move BrushForm) GZ : Vertex Coords"

func _get_handle_value(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> Variant:
	return gizmo.get_node_3d().transform * gizmo.get_node_3d().positions[vertex]

func _has_gizmo(for_node_3d: Node3D) -> bool:
	return for_node_3d is BrushForm

func _init():
	create_material			("main", Color(0, 1, 0), !true, true)
	create_handle_material	("handles")

func _redraw(gizmo):
	gizmo.clear()

	var node3d = gizmo.get_node_3d() as BrushForm
	var vertexHandles = PackedVector3Array()
	var vertexHandlesIds = PackedInt32Array()
	
	if node3d.positions.size() > 2:
		for vertex in node3d.positions.size():
			vertexHandles.append(node3d.positions[vertex])
			vertexHandlesIds.append(vertex)
			
			if grabbed:
				gizmo.add_lines([
					node3d.positions[vertex],
					(node3d.positions[vertex] + Vector3(1, 0, 0)),
				], get_material("main", gizmo), !true)
				
				gizmo.add_lines([
					node3d.positions[vertex],
					(node3d.positions[vertex] + Vector3(-1, 0, 0)),
				], get_material("main", gizmo), !true)
				
				gizmo.add_lines([
					node3d.positions[vertex],
					(node3d.positions[vertex] + Vector3(0, 1, 0)),
				], get_material("main", gizmo), !true)
				
				gizmo.add_lines([
					node3d.positions[vertex],
					(node3d.positions[vertex] + Vector3(0, -1, 0)),
				], get_material("main", gizmo), !true)
				
				gizmo.add_lines([
					node3d.positions[vertex],
					(node3d.positions[vertex] + Vector3(0, 0, 1)),
				], get_material("main", gizmo), !true)
				
				gizmo.add_lines([
					node3d.positions[vertex],
					(node3d.positions[vertex] + Vector3(0, 0, -1)),
				], get_material("main", gizmo), !true)
		
	gizmo.add_handles(vertexHandles, get_material("handles", gizmo), vertexHandlesIds, !true)
	
	
	
	"""
	var lines = PackedVector3Array()

	lines.push_back(Vector3(0, 1, 0))
	lines.push_back(Vector3(0, node3d.position.y, 0))

	var handles = PackedVector3Array()

	handles.push_back(Vector3(0, 1, 0))
	handles.push_back(Vector3(0, node3d.global_position.y, 0))

	gizmo.add_lines(lines, get_material("main", gizmo), false)
	gizmo.add_handles(handles, get_material("handles", gizmo), [])
	"""

func _is_handle_highlighted(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> bool:
	return false

func _commit_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, restore: Variant, cancel: bool) -> void:
	grabbed = false
	vertex = handle_id
	

func _begin_handle_action(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> void:
	outPos = Vector3.ZERO
	grabbed = true
	vertex = handle_id


func _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2) -> void:
	var ray_origin = camera.project_ray_origin(screen_pos)
	var ray_direction = camera.project_ray_normal(screen_pos)
	
	var xpos = gizmo.get_node_3d().global_transform * gizmo.get_node_3d().positions[handle_id]
	
	
	var plane = Plane(ray_direction, xpos)
	var intersect_pos = plane.intersects_ray(ray_origin, ray_direction)
	
	if not gizmo.get_plugin().outPos:
		gizmo.get_plugin().outPos = xpos
	
	var snap = intersect_pos.snapped(Vector3.ONE * 0.5) #camera.project_position(screen_pos, camera.global_position.distance_to(xpos)).snapped(Vector3.ONE * 0.5)
	
	gizmo.get_node_3d().transform.origin += (snap - gizmo.get_plugin().outPos)
	
	gizmo.get_plugin().outPos = snap
	
	#camera.project_position(screen_pos, camera.global_position.distance_to(Vector3.ZERO)).snapped(Vector3.ONE * 0.5)
