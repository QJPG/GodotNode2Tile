@tool
class_name Brush extends Node3D

enum BrushPrimitives {
	TRIANGLE = RenderingServer.PRIMITIVE_TRIANGLES,
	TRIANGLE_STRIP = RenderingServer.PRIMITIVE_TRIANGLE_STRIP,
}

const TRIANGLE := "Triangle:%s" % RenderingServer.PRIMITIVE_TRIANGLES
const TRIANGLE_STRIP := "Triangle Strip:%s" % RenderingServer.PRIMITIVE_TRIANGLE_STRIP

@export var primitive : RenderingServer.PrimitiveType = RenderingServer.PRIMITIVE_TRIANGLES
@export var collision := true

var instance : RID
var base : RID
var body : RID
var shape : RID

func project_uv(p : Vector3, n : Vector3, step : float) -> Vector2:
	var w = n.normalized()
	
	var uv3d = ((p - w * p.dot(w)) + Vector3.ONE * 0.5) / 1.0
	var uv = Vector2(uv3d.x, uv3d.z)
	
	if uv3d.y > .5:
		uv.y = -uv3d.y
	
	return uv * step

func get_brush_forms() -> Array[BrushForm]:
	var forms : Array[BrushForm]
	
	for child in get_children():
		if child is BrushForm:
			forms.append(child)
	
	return forms

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
			
			var a : Vector3 = transformed_positions[ia]
			var b : Vector3 = transformed_positions[ib]
			var c : Vector3 = transformed_positions[ic]
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
	instance = RenderingServer.instance_create()
	base = RenderingServer.mesh_create()
	
	RenderingServer.instance_set_base(instance, base)
	
	body = PhysicsServer3D.body_create()
	shape = PhysicsServer3D.concave_polygon_shape_create()
	
	PhysicsServer3D.body_set_mode(body, PhysicsServer3D.BODY_MODE_STATIC)
	PhysicsServer3D.body_add_shape(body, shape, Transform3D.IDENTITY)
	PhysicsServer3D.body_set_state(body, PhysicsServer3D.BODY_STATE_TRANSFORM, transform)

func _ready():
	RenderingServer.instance_set_scenario(instance, get_world_3d().scenario)
	PhysicsServer3D.body_set_space(body, get_world_3d().space)

func _process(delta):
	RenderingServer.instance_set_transform(instance, transform)
	
	render_brush_forms()

func _physics_process(delta):
	PhysicsServer3D.body_set_shape_disabled(body, 0, not collision)
	#transform = PhysicsServer3D.body_get_state(body, PhysicsServer3D.BODY_STATE_TRANSFORM)

func _exit_tree():
	RenderingServer.free_rid(instance)
	RenderingServer.free_rid(base)
