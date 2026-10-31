class_name PetCompanion
extends Control

var current_pet_id: String = ""
var _pet_data: Dictionary = {}

var _sprite: TextureRect
var _shadow: Panel
var _name_bubble: PanelContainer
var _name_label: Label
var _float_tween: Tween
var _jump_tween: Tween

func _ready() -> void:
	custom_minimum_size = Vector2(130, 140)
	size = Vector2(130, 140)
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)

	# 1. Soft grounded shadow under the pet
	_shadow = Panel.new()
	_shadow.name = "PetShadow"
	_shadow.custom_minimum_size = Vector2(86, 20)
	_shadow.size = Vector2(86, 20)
	_shadow.position = Vector2(22, 112)
	var shadow_sb = StyleBoxFlat.new()
	shadow_sb.bg_color = Color(0.02, 0.08, 0.03, 0.45)
	shadow_sb.set_corner_radius_all(10)
	_shadow.add_theme_stylebox_override("panel", shadow_sb)
	add_child(_shadow)

	# 2. Main Pet Character Icon (High-res gold medal portrait)
	_sprite = TextureRect.new()
	_sprite.name = "PetSprite"
	_sprite.custom_minimum_size = Vector2(110, 110)
	_sprite.size = Vector2(110, 110)
	_sprite.position = Vector2(10, 8)
	_sprite.pivot_offset = Vector2(55, 55)
	_sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(_sprite)

	# 3. Floating name bubble centered safely above the pet (does NOT overlap the icon!)
	_name_bubble = PanelContainer.new()
	_name_bubble.name = "PetNameBubble"
	_name_bubble.position = Vector2(12, -22)
	_name_bubble.custom_minimum_size = Vector2(106, 26)
	UIKit.style_panel(_name_bubble, "pill", 10.0, 3.0)
	add_child(_name_bubble)

	_name_label = Label.new()
	_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	UIKit.style_label(_name_label, 13, Color(1.0, 0.95, 0.55), 3, Color(0.04, 0.08, 0.16), false)
	_name_bubble.add_child(_name_label)

	_start_floating_animation()

func set_pet(pet_id: String) -> void:
	current_pet_id = pet_id
	if pet_id.is_empty():
		visible = false
		return

	_pet_data = PetData.get_pet_by_id(pet_id)
	if _pet_data.is_empty():
		visible = false
		return

	visible = true
	if ResourceLoader.exists(_pet_data["path"]):
		_sprite.texture = load(_pet_data["path"])

	_name_label.text = _pet_data["name"]
	var r_col: Color = _pet_data.get("color", Color.WHITE)
	_name_label.add_theme_color_override("font_color", r_col.lightened(0.2))

	_start_floating_animation()

func on_egg_clicked() -> void:
	# Cheerful bounce when egg is clicked
	if not visible or not _sprite or (_jump_tween and _jump_tween.is_valid()):
		return
	var tw = create_tween()
	tw.tween_property(_sprite, "scale", Vector2(1.12, 0.90), 0.04)
	tw.tween_property(_sprite, "scale", Vector2(0.95, 1.08), 0.06)
	tw.tween_property(_sprite, "scale", Vector2.ONE, 0.08)

func _start_floating_animation() -> void:
	if _float_tween and _float_tween.is_valid():
		_float_tween.kill()

	if not _sprite:
		return

	_sprite.position = Vector2(10, 8)
	_float_tween = create_tween().set_loops()
	_float_tween.tween_property(_sprite, "position:y", 2.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_float_tween.parallel().tween_property(_shadow, "scale", Vector2(0.85, 0.85), 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_float_tween.chain().tween_property(_sprite, "position:y", 14.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_float_tween.parallel().tween_property(_shadow, "scale", Vector2.ONE, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_do_pet_salto()
	elif event is InputEventScreenTouch and event.pressed:
		_do_pet_salto()

func _do_pet_salto() -> void:
	if _jump_tween and _jump_tween.is_valid():
		return

	if _float_tween and _float_tween.is_valid():
		_float_tween.kill()

	_jump_tween = create_tween()
	_jump_tween.tween_property(_sprite, "position:y", -28.0, 0.20).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_jump_tween.parallel().tween_property(_sprite, "rotation", TAU, 0.40).set_trans(Tween.TRANS_CUBIC)
	_jump_tween.chain().tween_property(_sprite, "position:y", 8.0, 0.20).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_jump_tween.chain().tween_property(_sprite, "scale", Vector2(1.14, 0.88), 0.05)
	_jump_tween.chain().tween_property(_sprite, "scale", Vector2.ONE, 0.08)
	_jump_tween.tween_callback(func():
		_sprite.rotation = 0.0
		_start_floating_animation()
	)
