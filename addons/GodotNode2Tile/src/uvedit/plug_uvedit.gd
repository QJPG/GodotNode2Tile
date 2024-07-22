extends EditorInspectorPlugin

static var pressing = false

func _can_handle(object: Object) -> bool:
	return object is BrushForm

func _parse_begin(object: Object) -> void:
	if object is BrushForm:
		var UV_selecteds = []
		
		var _lb_title = Label.new()
		_lb_title.text = "UV Editor"
	
		add_custom_control(_lb_title)
		add_custom_control(HSeparator.new())
	
		#var _uvedit_prop = preload("res://addons/GodotNode2Tile/src/uvedit/plug_uvedit_prop.gd").new()
		#_uvedit_prop._Object = object
		#add_custom_control(_uvedit_prop)
		
		var _grid_size = SpinBox.new()
		_grid_size.prefix = "Grid:"
		_grid_size.step = 0.01
		_grid_size.value = 0.25
		add_custom_control(_grid_size)
		
		
		
		if object.uvs.size() > 2:
			var _EditorTexture = TextureRect.new()
			_EditorTexture.texture = object.material.albedo_texture
			_EditorTexture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			_EditorTexture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			_EditorTexture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
			#_EditorTexture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
			#_EditorTexture.custom_minimum_size = Vector2(129, 129)
			#_EditorTexture.size_flags_vertical = Control.SIZE_EXPAND_FILL
			_EditorTexture.set_anchor	(SIDE_BOTTOM, 1.0)
			_EditorTexture.set_anchor	(SIDE_RIGHT, 1.0)
			
			_EditorTexture.draw.connect(
				func():
					var color = Color.GREEN_YELLOW
					var size = _EditorTexture.size
					
					var a = null
					var b = null
					var c = null
					
					for i in range(0, object.indices.size(), 3):
						var index = object.indices[i]
						var index1 = object.indices[i + 1]
						var index2 = object.indices[i + 2]
						
						_EditorTexture.draw_line(
							object.uvs[index] * size,
							object.uvs[index1] * size,
							color, 1.0, true
						)
						
						_EditorTexture.draw_line(
							object.uvs[index1] * size,
							object.uvs[index2] * size,
							color, 1.0, true
						)
						
						_EditorTexture.draw_line(
							object.uvs[index2] * size,
							object.uvs[index] * size,
							color, 1.0, true
						)
					)
			
			
			_EditorTexture.gui_input.connect(
				func(event):
					var size = _EditorTexture.size
					
					if event is InputEventMouseButton:
						if event.pressed:
							if event.button_index == MOUSE_BUTTON_LEFT:
								pressing = true
								UV_selecteds.clear()
								
								for i in object.indices.size():
									if (size * object.uvs[object.indices[i]]).distance_to(event.position) < 12.5:
										UV_selecteds.append(object.indices[i])
						else:
							pressing = false
							
					if event is InputEventMouseMotion:
						if pressing and UV_selecteds.size() > 0:
							for i in UV_selecteds.size():
								var pos = event.position / size #object.uvs[UV_selecteds[i]] * size - event.position
								pos = floor(pos / _grid_size.value) * _grid_size.value
								#print(pos)
								#object.uvs[UV_selecteds[i]] + event.relative / size
								#pos = pos.snapped(Vector2.ONE * 0.05)
								
								if pos.x >= 0 and pos.y >= 0 and pos.x <= 1 and pos.y <= 1:
									object.uvs[UV_selecteds[i]] = pos
								#print(UV_selecteds[i])# += event.relative
						
					_EditorTexture.queue_redraw())
			
			add_custom_control(_EditorTexture)
		
		add_custom_control(HSeparator.new())
