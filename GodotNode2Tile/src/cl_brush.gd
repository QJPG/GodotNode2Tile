@tool
class_name Brush extends Node3D


@export var primitive : RenderingServer.PrimitiveType = RenderingServer.PRIMITIVE_TRIANGLES
@export var collision := true
@export var override_non_materials : Material = StandardMaterial3D.new()

var instance : RID
var base : RID
var body : RID
var shape : RID

func project_uv(p : Vector3, n : Vector3, step : float) -> Vector2:
	var w = n
	
	var uv3d = ((p - w * p.dot(w)) + Vector3.ONE * 0.5) / 1.0
	var uv = Vector2(uv3d.x, uv3d.z)
	
	return uv * step

func get_brush_forms() -> Array[BrushForm]:
	var forms : Array[BrushForm]
	
	for child in get_children():
		if child is BrushForm:
			forms.append(child)
	
	return forms

func fix_invalid_indices(indices : Array[int], positions : Array[Vector3]) -> void:
	if indices.size() % 2 == 0 and positions.size() % 3 == 0:
		indices.pop_back()
		indices.pop_back()
		indices.pop_back()
		
		fix_invalid_indices(indices, positions)
	return

func recalculate_normals(indices : Array[int], normals : Array[Vector3], positions : Array[Vector3]) -> void:
	for i in range(0, indices.size(), 3):
		var index = indices[i]
		var a = indices[i + 0]
		var b = indices[i + 1]
		var c = indices[i + 2]
		var plane = Plane(positions[a], positions[b], positions[c])
		var n = plane.normal
		
		normals[a] = n
		normals[b] = n
		normals[c] = n

func create_mesh_from_forms() -> void:
	RenderingServer.mesh_clear(base)
	
	if primitive == RenderingServer.PRIMITIVE_MAX:
		primitive = RenderingServer.PRIMITIVE_TRIANGLES
	
	var forms = get_brush_forms()
	var surfaces_total := 0
	var surfaces_positions : Array[Vector3]
	
	for i in range(forms.size()):
		var data : BrushForm = forms[i]
		
		if not data.visible:
			continue
		
		var surface_data : Array
		surface_data.resize(ArrayMesh.ARRAY_MAX)
		
		var final_positions : Array[Vector3]
		var final_indices : Array[int]
		var final_normals : Array[Vector3]
		var final_uvs : Array[Vector2]
		
		for vertex_index in data.indices:
			var transformed_position = data.transform * data.positions[vertex_index]
			
			if not transformed_position in final_positions:
				final_positions.append(transformed_position)
				final_normals.append(data.normals[vertex_index])
				final_uvs.append(data.uvs[vertex_index])
			
			final_indices.append(vertex_index)
			
			surfaces_positions.append(transformed_position)
		
		fix_invalid_indices(final_indices, final_positions)
		
		if data.recalculated_normals:
			recalculate_normals(final_indices, final_normals, final_positions)
		
		for n_i in range(final_normals.size()):
			final_normals[n_i] *= data.surface_normal
		
		#print(final_indices)
		#print(final_positions)
		
		if data.cubic_projection:
			for index in final_indices:
				final_uvs[index] = project_uv(final_positions[index], data.cubic_projection_plane, data.cubic_projection_step)
		
		surface_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(final_positions)
		surface_data[ArrayMesh.ARRAY_NORMAL] = PackedVector3Array(final_normals)
		surface_data[ArrayMesh.ARRAY_TEX_UV] = PackedVector2Array(final_uvs)
		surface_data[ArrayMesh.ARRAY_INDEX] = PackedInt32Array(final_indices)
		
		var material := data.material
		
		if not material:
			material = override_non_materials
		
		RenderingServer.mesh_add_surface_from_arrays(base, primitive, surface_data)
		RenderingServer.mesh_surface_set_material(base, surfaces_total, material)
	
		surfaces_total += 1

	if surfaces_positions and surfaces_positions.size() % 3 == 0:
		var poly_faces = ConcavePolygonShape3D.new()
		poly_faces.set_faces(surfaces_positions)
		
		if poly_faces.get_faces().size() > 0:
			PhysicsServer3D.shape_set_data(shape, {
				"faces": poly_faces.get_faces()
			})

func render_brush_forms() -> void:
	RenderingServer.mesh_clear(base)
	
	if not primitive:
		return
	
	if primitive == RenderingServer.PRIMITIVE_MAX:
		primitive = RenderingServer.PRIMITIVE_TRIANGLES
	
	var forms = get_brush_forms()
	var indices : Array[Vector3]
	var all_points : Array[Vector3]
	
	var surfaces := 0
	for i in range(forms.size()):
		var form_data : BrushForm = forms[i]
		
		if not form_data.visible:
			continue
		
		var local_indices : Array[int]
		var transformed_positions : Array[Vector3]
		var transformed_normals : Array[Vector3]
		var data : Array
		data.resize(ArrayMesh.ARRAY_MAX)
		
		for index in range(form_data.indices.size()):
			var pos = form_data.global_transform * form_data.positions[form_data.indices[index]]
			var idx = form_data.indices[index]
			var normal = form_data.global_transform * form_data.normals[form_data.indices[index]]
			
			if not pos in transformed_positions:
				transformed_positions.append(pos)
				transformed_normals.append(normal)
			
			if idx > transformed_positions.size():
				break
			
			all_points.append(pos)
			
			if not pos in indices:
				indices.append(pos)
			
			var fidx = indices.find(pos)
			local_indices.append(idx)
		
		#print(transformed_positions)
		#print(local_indices)
		#print(local_indices.size(), " ", form_data.positions.size())
		
		var projected_uvs = form_data.uvs.duplicate()
		var projected_normals = form_data.normals
		
		for j in range(0, form_data.indices.size(), 3):
			var ia : int = form_data.indices[j]
			var ib : int = form_data.indices[j + 1]
			var ic : int = form_data.indices[j + 2]
			
			var a : Vector3 = transformed_positions[ia % transformed_positions.size()]
			var b : Vector3 = transformed_positions[ib % transformed_positions.size()]
			var c : Vector3 = transformed_positions[ic % transformed_positions.size()]
			var n : Plane = Plane(a, b, c)
			
			projected_normals[ia] = n.normal
			projected_normals[ib] = n.normal
			projected_normals[ic] = n.normal
		
		if form_data.cubic_projection:
			for posidx in range(transformed_positions.size()):
				projected_uvs[posidx] = project_uv(
					transformed_positions[posidx], projected_normals[posidx], form_data.cubic_projection_step)
		
		data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(transformed_positions)
		data[ArrayMesh.ARRAY_NORMAL] = PackedVector3Array(projected_normals)
		data[ArrayMesh.ARRAY_TEX_UV] = PackedVector2Array(projected_uvs)
		data[ArrayMesh.ARRAY_INDEX] = PackedInt32Array(local_indices)
		
		RenderingServer.mesh_add_surface_from_arrays(base, primitive, data)
		RenderingServer.mesh_surface_set_material(base, surfaces, form_data.material)
	
		surfaces += 1
	
	#var x = ConcavePolygonShape3D.new()
	#x.set_faces()
	#PhysicsServer3D.shape_set_data(shape, null)
	
	if all_points:
		var faces = ConcavePolygonShape3D.new()
		faces.set_faces(all_points)
		if faces.get_faces().size() > 0:
			#print(faces.get_faces().size())
			PhysicsServer3D.shape_set_data(shape, {"faces": faces.get_faces()})

func _init():
	return

func _ready():
	create_mesh_from_forms()

func _process(delta):
	RenderingServer.instance_set_visible(instance, visible)
	RenderingServer.instance_set_transform(instance, transform)
	
	if Engine.is_editor_hint():
		create_mesh_from_forms()

func _physics_process(delta):
	PhysicsServer3D.body_set_shape_disabled(body, 0, not collision)

func _enter_tree():
	instance = RenderingServer.instance_create()
	base = RenderingServer.mesh_create()
	
	RenderingServer.instance_set_base(instance, base)
	
	body = PhysicsServer3D.body_create()
	shape = PhysicsServer3D.concave_polygon_shape_create()
	
	RenderingServer.instance_set_scenario(instance, get_world_3d().scenario)
	PhysicsServer3D.body_set_space(body, get_world_3d().space)
	
	PhysicsServer3D.body_set_mode(body, PhysicsServer3D.BODY_MODE_STATIC)
	PhysicsServer3D.body_add_shape(body, shape, Transform3D.IDENTITY)
	PhysicsServer3D.body_set_state(body, PhysicsServer3D.BODY_STATE_TRANSFORM, transform)

func _exit_tree():
	RenderingServer.free_rid(instance)
	RenderingServer.free_rid(base)
	
	print_debug("Brush RID's cleaned!")
