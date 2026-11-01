class_name LoadingOverlay
extends Control

## High-performance, pixel-perfect genuine loading overlay for Crack the Egg.
## Accurately tracks real asset preloading, save restoration, and YouTube SDK lifecycle.
## Visually aligns with the loading screen artwork and provides a smooth, animated golden bar.

signal loading_completed

@export var bg_texture: Texture2D = preload("res://assets/loading_screen.png")
@export var font_fredoka: Font = preload("res://assets/fonts/Fredoka.ttf")

var bg_rect: TextureRect
var slot_container: Control
var fill_bar: Panel
var shimmer_bar: ColorRect
var percent_label: Label
var status_label: Label

var target_progress: float = 0.0
var visual_progress: float = 0.0
var is_complete: bool = false
var shimmer_tween: Tween

const BASE_IMG_SIZE: Vector2 = Vector2(699.0, 1024.0)
# Inner slot coordinates measured from user image:
const SLOT_ORIG_POS: Vector2 = Vector2(202.0, 926.0)
const SLOT_ORIG_SIZE: Vector2 = Vector2(295.0, 28.0)
const TEXT_ORIG_POS: Vector2 = Vector2(150.0, 886.0)
const TEXT_ORIG_SIZE: Vector2 = Vector2(400.0, 32.0)

func _init() -> void:
	name = "LoadingOverlay"
	z_index = 100
	z_as_relative = false
	layout_mode = 1
	anchors_preset = Control.PRESET_FULL_RECT
	mouse_filter = Control.MOUSE_FILTER_STOP

func _ready() -> void:
	_build_ui()
	_update_layout()
	get_viewport().size_changed.connect(_update_layout)
	_start_shimmer_animation()

func _process(delta: float) -> void:
	if visual_progress < target_progress:
		# Smooth, fluid bar interpolation
		visual_progress = move_toward(visual_progress, target_progress, delta * 2.2)
		_render_progress()

func _build_ui() -> void:
	# Full-screen background artwork
	bg_rect = TextureRect.new()
	bg_rect.name = "BackgroundArtwork"
	bg_rect.texture = bg_texture
	bg_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg_rect.layout_mode = 1
	bg_rect.anchors_preset = Control.PRESET_FULL_RECT
	bg_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg_rect)

	# Recessed slot container with clipping
	slot_container = Control.new()
	slot_container.name = "SlotContainer"
	slot_container.clip_contents = true
	slot_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(slot_container)

	# Golden glowing fill bar
	fill_bar = Panel.new()
	fill_bar.name = "FillBar"
	fill_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color(1.0, 0.76, 0.12, 1.0) # Radiant golden yellow
	fill_style.border_color = Color(1.0, 0.92, 0.55, 0.9) # Top golden glow
	fill_style.border_width_top = 2
	fill_style.border_width_bottom = 1
	fill_style.border_blend = true
	fill_style.shadow_color = Color(1.0, 0.65, 0.0, 0.45)
	fill_style.shadow_size = 6
	fill_bar.add_theme_stylebox_override("panel", fill_style)
	slot_container.add_child(fill_bar)

	# Shimmer / gleam highlight passing along the bar
	shimmer_bar = ColorRect.new()
	shimmer_bar.name = "Shimmer"
	shimmer_bar.color = Color(1.0, 1.0, 1.0, 0.35)
	shimmer_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot_container.add_child(shimmer_bar)

	# Exact percentage label centered inside the bar
	percent_label = Label.new()
	percent_label.name = "PercentLabel"
	percent_label.text = "0 %"
	percent_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	percent_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	percent_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if font_fredoka:
		percent_label.add_theme_font_override("font", font_fredoka)
	percent_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	percent_label.add_theme_color_override("font_outline_color", Color(0.18, 0.11, 0.03, 1.0))
	percent_label.add_theme_constant_override("outline_size", 4)
	percent_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.5))
	percent_label.add_theme_constant_override("shadow_offset_y", 1)
	slot_container.add_child(percent_label)

func _update_layout() -> void:
	if not slot_container:
		return
	var vp_size = get_viewport_rect().size
	if vp_size.x <= 0 or vp_size.y <= 0:
		return

	# Compute exact STRETCH_KEEP_ASPECT_COVERED transform
	var s = maxf(vp_size.x / BASE_IMG_SIZE.x, vp_size.y / BASE_IMG_SIZE.y)
	var offset = (vp_size - BASE_IMG_SIZE * s) * 0.5

	var slot_pos = offset + SLOT_ORIG_POS * s
	var slot_size = SLOT_ORIG_SIZE * s

	slot_container.position = slot_pos
	slot_container.size = slot_size

	# Update stylebox corner radius to pill shape
	var r = int(slot_size.y * 0.5)
	var fill_style: StyleBoxFlat = fill_bar.get_theme_stylebox("panel") as StyleBoxFlat
	if fill_style:
		fill_style.corner_radius_top_left = r
		fill_style.corner_radius_bottom_left = r
		fill_style.corner_radius_top_right = r
		fill_style.corner_radius_bottom_right = r

	# Update shimmer size
	shimmer_bar.size = Vector2(maxf(24.0, slot_size.x * 0.15), slot_size.y)

	# Update label font size and fill rect
	percent_label.size = slot_size
	percent_label.position = Vector2.ZERO
	var font_sz = int(clampf(slot_size.y * 0.68, 14.0, 26.0))
	percent_label.add_theme_font_size_override("font_size", font_sz)
	percent_label.add_theme_constant_override("outline_size", int(maxf(3.0, 4.0 * s)))

	_render_progress()

func _render_progress() -> void:
	if not slot_container or not fill_bar:
		return
	var w = slot_container.size.x
	var h = slot_container.size.y
	fill_bar.size = Vector2(w * visual_progress, h)
	percent_label.text = "%d %%" % int(round(visual_progress * 100.0))

func _start_shimmer_animation() -> void:
	if shimmer_tween and shimmer_tween.is_valid():
		shimmer_tween.kill()
	shimmer_tween = create_tween().set_loops()
	shimmer_tween.tween_property(shimmer_bar, "position:x", 0.0, 0.0)
	shimmer_tween.tween_property(shimmer_bar, "modulate:a", 0.0, 0.0)
	shimmer_tween.tween_property(shimmer_bar, "modulate:a", 0.45, 0.15)
	shimmer_tween.tween_property(shimmer_bar, "position:x", slot_container.size.x + 30.0, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	shimmer_tween.tween_property(shimmer_bar, "modulate:a", 0.0, 0.15)
	shimmer_tween.tween_interval(0.8)

func set_progress(val: float) -> void:
	target_progress = clampf(val, 0.0, 1.0)
	if target_progress >= 1.0 and not is_complete:
		is_complete = true

func is_ready_to_dismiss() -> bool:
	return is_complete and visual_progress >= 0.999

func fade_out_and_dismiss(on_finished_callback: Callable = Callable()) -> void:
	# Brief celebratory flash pulse on 100%
	visual_progress = 1.0
	_render_progress()
	
	var tw = create_tween()
	tw.tween_property(fill_bar, "modulate", Color(1.3, 1.3, 1.1, 1.0), 0.12)
	tw.tween_property(fill_bar, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.12)
	tw.tween_interval(0.1)
	tw.tween_property(self, "modulate:a", 0.0, 0.38).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_callback(func():
		loading_completed.emit()
		if on_finished_callback.is_valid():
			on_finished_callback.call()
		visible = false
		queue_free()
	)
