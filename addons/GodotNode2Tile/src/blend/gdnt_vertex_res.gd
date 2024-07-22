extends Resource
class_name GDNTVertex

@export var Position : Vector3
@export var Normal : Vector3
@export var TexCoord : Vector2
@export var MaterialID : int

func _init(pos : Vector3, normal : Vector3, tex_coord : Vector2, material_id : int) -> void:
	Position = pos
	Normal = normal
	TexCoord = tex_coord
	MaterialID = material_id
