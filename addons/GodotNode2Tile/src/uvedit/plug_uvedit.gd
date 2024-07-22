extends EditorInspectorPlugin

static var pressing = false
static var moving = false
static var moving_view = false
static var _EditorTexture = TextureRect.new()

class UVEditRef:
	var ref_obj_x : SpinBox
	var ref_obj_y : SpinBox
	var ref_index : int

static var UVVectors : Array[UVEditRef]

func _can_handle(object: Object) -> bool:
	return object is BrushForm

func _parse_begin(object: Object) -> void:
	if object is BrushForm:
		var UV_selecteds = []
		UVVectors.clear()
		
		if not object.material:
			return
		
		if not object.material is StandardMaterial3D:
			return
		
		if not object.material.albedo_texture:
			return
		
		var _lb_title = Label.new()
		_lb_title.text = "UV Editor"
	
		add_custom_control(_lb_title)
		add_custom_control(HSeparator.new())
	
		#var _uvedit_prop = preload("res://addons/GodotNode2Tile/src/uvedit/plug_uvedit_prop.gd").new()
		#_uvedit_prop._Object = object
		#add_custom_control(_uvedit_prop)
		
		var _grid_size = SpinBox.new()
		_grid_size.prefix = "Grid Snap:"
		_grid_size.step = 0.01
		_grid_size.value = 0.05
		
		add_custom_control(_grid_size)
		
		var _texture_zoom = HSlider.new()
		_texture_zoom.min_value = 0.5
		_texture_zoom.max_value = 3.0
		_texture_zoom.value = 1.0
		_texture_zoom.step = 0.05
		_texture_zoom.value_changed.connect(func(v):
			_EditorTexture.scale = Vector2.ONE * v)
		
		add_custom_control(_texture_zoom)
		
		var _texture_ctn = PanelContainer.new()
		
		if object.uvs.size() > 2:
			_EditorTexture = TextureRect.new()
			_EditorTexture.texture = (object.material as StandardMaterial3D).albedo_texture
			_EditorTexture.texture_filter = (object.material as StandardMaterial3D).texture_filter
			_EditorTexture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			_EditorTexture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
			#_EditorTexture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
			#_EditorTexture.custom_minimum_size = Vector2(129, 129)
			#_EditorTexture.size_flags_vertical = Control.SIZE_EXPAND_FILL
			#_EditorTexture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_EditorTexture.set_anchor	(SIDE_BOTTOM, 1.0)
			_EditorTexture.set_anchor	(SIDE_RIGHT, 1.0)
			
			_EditorTexture.draw.connect(
				func():
					var color = EditorInterface.get_editor_settings().get_setting("interface/theme/accent_color")
					var color_point = Color.WHITE
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
						
						_EditorTexture.draw_circle(object.uvs[index] * size, 6.0, color_point, !true, 1.0, true)
						_EditorTexture.draw_circle(object.uvs[index1] * size, 6.0, color_point, !true, 1.0, true)
						_EditorTexture.draw_circle(object.uvs[index2] * size, 6.0, color_point, !true, 1.0, true)
					)
			
			_EditorTexture.tooltip_text = "Mouse Left to Snap | Mouse Right to Move All UVs | Mouse Middle to Move Texture View"
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
							elif event.button_index == MOUSE_BUTTON_RIGHT:
								moving = true
							elif event.button_index == MOUSE_BUTTON_MIDDLE:
								moving_view = true
							
						else:
							pressing = false
							moving = false
							moving_view = false
							
					if event is InputEventMouseMotion:
						if pressing:
							if UV_selecteds.size() > 0:
								for i in UV_selecteds.size():
									var pos = event.position / size #object.uvs[UV_selecteds[i]] * size - event.position
									pos = floor(pos / _grid_size.value) * _grid_size.value
									#print(pos)
									#object.uvs[UV_selecteds[i]] + event.relative / size
									#pos = pos.snapped(Vector2.ONE * 0.05)
									
									if pos.x >= 0 and pos.y >= 0 and pos.x <= 1 and pos.y <= 1:
										object.uvs[UV_selecteds[i]] = pos
										
										for _int in UVVectors:
											if _int.ref_index == UV_selecteds[i]:
												_int.ref_obj_x.value = pos.x
												_int.ref_obj_y.value = pos.y
									#print(UV_selecteds[i])# += event.relative
						elif moving:
							for i in object.uvs.size():
								for _int in UVVectors:
									if _int.ref_index == i:
										#AUTO UPDATE COORDS
										var _x = _int.ref_obj_x.value + event.relative.x / size.x
										var _y = _int.ref_obj_y.value + event.relative.y / size.y
										
										if _x >= 0 and _x <= 1 and _y >= 0 and _y <= 1:
											_int.ref_obj_x.value = _x
											_int.ref_obj_y.value = _y
						elif moving_view:
							_EditorTexture.position += event.relative * _EditorTexture.scale
						
						else:
							pass
					
					_EditorTexture.queue_redraw())
			
			_texture_ctn.clip_contents = true
			_texture_ctn.add_child(_EditorTexture)
			
			add_custom_control(_texture_ctn)
		
		add_custom_control(HSeparator.new())
		
		for i in object.uvs.size():
			var ref = UVEditRef.new()
			
			ref.ref_index = i
			
			ref.ref_obj_x = SpinBox.new()
			ref.ref_obj_y = SpinBox.new()
			
			ref.ref_obj_x.step = 0.01
			ref.ref_obj_y.step = 0.01
			
			ref.ref_obj_x.prefix = "UV(%s) X:" % i
			ref.ref_obj_y.prefix = "UV(%s) Y:" % i
			
			ref.ref_obj_x.value = object.uvs[i].x
			ref.ref_obj_y.value = object.uvs[i].y
			
			ref.ref_obj_x.value_changed.connect(func(v):
				object.uvs[ref.ref_index].x = ref.ref_obj_x.value
				_EditorTexture.queue_redraw()
				return)
			ref.ref_obj_y.value_changed.connect(func(v):
				object.uvs[ref.ref_index].y = ref.ref_obj_y.value
				_EditorTexture.queue_redraw()
				return)
			
			ref.ref_obj_x.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			ref.ref_obj_y.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			UVVectors.append(ref)
			
			var _hbox = HBoxContainer.new()
			_hbox.add_child(ref.ref_obj_x)
			_hbox.add_child(VSeparator.new())
			_hbox.add_child(ref.ref_obj_y)
			
			add_custom_control(_hbox)
			add_custom_control(HSeparator.new())
