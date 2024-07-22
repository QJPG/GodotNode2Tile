extends EditorInspector

var _Object : BrushForm
var _Pivot : Vector2

func _draw() -> void:
	pass

func _enter_tree() -> void:
	return

func _exit_tree() -> void:
	return

func _process(delta: float) -> void:
	queue_redraw()
