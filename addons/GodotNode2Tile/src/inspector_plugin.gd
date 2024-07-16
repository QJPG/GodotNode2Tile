extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	return object is Brush


func _parse_begin(object: Object) -> void:
	if object is Brush:
		var new_button:Button = Button.new()
		new_button.text = "Add BrushForm"
		new_button.tooltip_text = "Adds a BrushForm as a child of the Brush"
		new_button.icon = preload("res://addons/GodotNode2Tile/misc/icon_form.png")
		add_custom_control(new_button)
		new_button.pressed.connect(
		func():
			var new_brush_form:BrushForm = BrushForm.new()
			new_brush_form.name = "BrushForm"
			object.add_child(new_brush_form, true)
			new_brush_form.set_owner(object.get_tree().edited_scene_root)
			)
