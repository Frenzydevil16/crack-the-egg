class_name UIKit
extends RefCounted

## Reusable casual-game UI kit.
## Generates glossy, rounded, gradient 9-slice textures at runtime (cached, generated once)
## and applies consistent styles to buttons, panels, chips and labels.
## Hover / pressed / disabled states reuse the same texture via modulate to keep memory low.

const FONT_BOLD: FontVariation = preload("res://assets/fonts/fredoka_bold.tres")
const FONT_UI: FontVariation = preload("res://assets/fonts/fredoka_ui.tres")

const PALETTES: Dictionary = {
	"orange": { "top": Color("#ffd95a"), "bottom": Color("#ff8a1f"), "border": Color("#6e3200"), "lip": Color("#c45a08"), "outline": Color("#6b2e00") },
	"green": { "top": Color("#9cf56a"), "bottom": Color("#22b04a"), "border": Color("#0b4a1e"), "lip": Color("#138036"), "outline": Color("#0b4a1e") },
	"blue": { "top": Color("#7ad8ff"), "bottom": Color("#2b72e6"), "border": Color("#0c2c6e"), "lip": Color("#1b4fb0"), "outline": Color("#0b2a66") },
	"purple": { "top": Color("#d6a2ff"), "bottom": Color("#7a3ce0"), "border": Color("#2e0f6e"), "lip": Color("#5523ad"), "outline": Color("#2e0f6e") },
	"pink": { "top": Color("#ffa6d2"), "bottom": Color("#ef4f9a"), "border": Color("#6a0f3c"), "lip": Color("#b8306f"), "outline": Color("#6a0f3c") },
	"red": { "top": Color("#ff8f8f"), "bottom": Color("#e23a4a"), "border": Color("#5c0b14"), "lip": Color("#a8222f"), "outline": Color("#5c0b14") },
	"navy": { "top": Color("#3d5394"), "bottom": Color("#233066"), "border": Color("#0a1230"), "lip": Color("#161f48"), "outline": Color("#0a1230") },
	"gray": { "top": Color("#a9b3c6"), "bottom": Color("#6c768c"), "border": Color("#2b3142"), "lip": Color("#4d5568"), "outline": Color("#2b3142") },
	"gold": { "top": Color("#fff2a0"), "bottom": Color("#f2b31b"), "border": Color("#5e3a00"), "lip": Color("#b57d06"), "outline": Color("#5e3a00") },
}

const PANEL_KINDS: Dictionary = {
	"modal": { "top": Color(0.16, 0.22, 0.42, 0.98), "bottom": Color(0.07, 0.10, 0.22, 0.98), "border": Color("#ffd23f"), "radius": 30, "border_w": 4, "gloss": 0.10, "lip": 0 },
	"modal_blue": { "top": Color(0.14, 0.24, 0.46, 0.98), "bottom": Color(0.06, 0.10, 0.24, 0.98), "border": Color("#63d4ff"), "radius": 30, "border_w": 4, "gloss": 0.10, "lip": 0 },
	"card": { "top": Color(0.20, 0.27, 0.50, 0.96), "bottom": Color(0.11, 0.15, 0.31, 0.96), "border": Color(0.33, 0.45, 0.78, 1.0), "radius": 20, "border_w": 3, "gloss": 0.12, "lip": 0 },
	"card_active": { "top": Color(0.17, 0.42, 0.33, 0.97), "bottom": Color(0.08, 0.22, 0.20, 0.97), "border": Color("#5ff08a"), "radius": 20, "border_w": 3, "gloss": 0.12, "lip": 0 },
	"card_locked": { "top": Color(0.12, 0.15, 0.26, 0.94), "bottom": Color(0.07, 0.09, 0.17, 0.94), "border": Color(0.22, 0.27, 0.40, 1.0), "radius": 20, "border_w": 3, "gloss": 0.05, "lip": 0 },
	"pill": { "top": Color(0.08, 0.12, 0.24, 0.90), "bottom": Color(0.03, 0.06, 0.14, 0.94), "border": Color(0.35, 0.50, 0.82, 0.80), "radius": 20, "border_w": 2, "gloss": 0.04, "lip": 0 },
	"pill_coin": { "top": Color(0.16, 0.12, 0.04, 0.92), "bottom": Color(0.06, 0.04, 0.01, 0.95), "border": Color(1.0, 0.82, 0.24, 0.90), "radius": 20, "border_w": 2, "gloss": 0.05, "lip": 0 },
	"pill_counter": { "top": Color(0.04, 0.12, 0.24, 0.92), "bottom": Color(0.02, 0.05, 0.14, 0.95), "border": Color(0.28, 0.80, 1.0, 0.90), "radius": 20, "border_w": 2, "gloss": 0.05, "lip": 0 },
	"pill_world": { "top": Color(0.04, 0.15, 0.10, 0.92), "bottom": Color(0.02, 0.06, 0.04, 0.95), "border": Color(0.28, 0.92, 0.54, 0.85), "radius": 18, "border_w": 2, "gloss": 0.04, "lip": 0 },
	"pill_crystal": { "top": Color(0.04, 0.13, 0.24, 0.92), "bottom": Color(0.02, 0.05, 0.13, 0.95), "border": Color(0.38, 0.86, 1.0, 0.88), "radius": 18, "border_w": 2, "gloss": 0.04, "lip": 0 },
	"pill_cosmic": { "top": Color(0.13, 0.05, 0.24, 0.92), "bottom": Color(0.05, 0.02, 0.13, 0.95), "border": Color(0.85, 0.38, 1.0, 0.88), "radius": 18, "border_w": 2, "gloss": 0.04, "lip": 0 },
	"chip": { "top": Color(0.14, 0.20, 0.40, 0.90), "bottom": Color(0.07, 0.10, 0.22, 0.90), "border": Color(0.40, 0.55, 0.95, 0.9), "radius": 18, "border_w": 2, "gloss": 0.15, "lip": 0 },
	"chip_gold": { "top": Color(0.42, 0.30, 0.06, 0.92), "bottom": Color(0.24, 0.15, 0.02, 0.92), "border": Color("#ffd23f"), "radius": 18, "border_w": 2, "gloss": 0.18, "lip": 0 },
	"banner": { "top": Color(0.20, 0.13, 0.42, 0.96), "bottom": Color(0.09, 0.06, 0.22, 0.96), "border": Color("#ffd23f"), "radius": 24, "border_w": 3, "gloss": 0.18, "lip": 0 },
	"inset": { "top": Color(0.05, 0.08, 0.18, 0.78), "bottom": Color(0.08, 0.12, 0.26, 0.78), "border": Color(0.25, 0.35, 0.62, 0.8), "radius": 16, "border_w": 2, "gloss": 0.0, "lip": 0 },
}

static var _tex_cache: Dictionary = {}

# ---------------------------------------------------------------------------
# Texture generation
# ---------------------------------------------------------------------------

static func _sd_round_rect(p: Vector2, c: Vector2, half: Vector2, r: float) -> float:
	var q: Vector2 = (p - c).abs() - half + Vector2(r, r)
	return Vector2(maxf(q.x, 0.0), maxf(q.y, 0.0)).length() + minf(maxf(q.x, q.y), 0.0) - r

static func _blend(dst: Color, src: Color) -> Color:
	var a: float = src.a + dst.a * (1.0 - src.a)
	if a <= 0.0001:
		return Color(0, 0, 0, 0)
	var r: float = (src.r * src.a + dst.r * dst.a * (1.0 - src.a)) / a
	var g: float = (src.g * src.a + dst.g * dst.a * (1.0 - src.a)) / a
	var b: float = (src.b * src.a + dst.b * dst.a * (1.0 - src.a)) / a
	return Color(r, g, b, a)

## Builds a glossy rounded 9-slice texture with soft drop shadow, dark border,
## vertical gradient face, optional 3D lip and a top gloss highlight.
static func _build_texture(top: Color, bottom: Color, border: Color, lip_col: Color, radius: int, border_w: int, gloss: float, lip: int, shadow: bool) -> ImageTexture:
	var pad: int = 8 if shadow else 1
	var core: int = 24
	var w: int = pad * 2 + radius * 2 + core
	var h: int = pad * 2 + radius * 2 + core + lip
	var img: Image = Image.create(w, h, false, Image.FORMAT_RGBA8)
	var body_c: Vector2 = Vector2(w * 0.5, pad + (h - pad * 2) * 0.5)
	var body_half: Vector2 = Vector2((w - pad * 2) * 0.5, (h - pad * 2) * 0.5)
	var face_top: float = pad + border_w
	var face_bottom: float = h - pad - border_w - lip
	var face_c: Vector2 = Vector2(w * 0.5, (face_top + face_bottom) * 0.5)
	var face_half: Vector2 = Vector2(body_half.x - border_w, (face_bottom - face_top) * 0.5)
	var face_r: float = maxf(2.0, radius - border_w)
	var gloss_top: float = face_top + 2.0
	var gloss_bottom: float = face_top + (face_bottom - face_top) * 0.48
	var gloss_c: Vector2 = Vector2(w * 0.5, (gloss_top + gloss_bottom) * 0.5)
	var gloss_half: Vector2 = Vector2(face_half.x - 4.0, (gloss_bottom - gloss_top) * 0.5)
	for y in range(h):
		for x in range(w):
			var p: Vector2 = Vector2(x + 0.5, y + 0.5)
			var col: Color = Color(0, 0, 0, 0)
			if shadow:
				var sd: float = _sd_round_rect(p, body_c + Vector2(0, 3.0), body_half, radius)
				var sa: float = clampf(1.0 - (sd + 1.0) / 7.0, 0.0, 1.0)
				col = Color(0.0, 0.02, 0.08, sa * sa * 0.42)
			var bd: float = _sd_round_rect(p, body_c, body_half, radius)
			var ba: float = clampf(0.5 - bd, 0.0, 1.0)
			if ba > 0.0:
				col = _blend(col, Color(border.r, border.g, border.b, border.a * ba))
				# 3D lip below the face
				if lip > 0:
					var ld: float = _sd_round_rect(p, Vector2(face_c.x, face_c.y + lip), face_half, face_r)
					var la: float = clampf(0.5 - ld, 0.0, 1.0)
					if la > 0.0:
						col = _blend(col, Color(lip_col.r, lip_col.g, lip_col.b, lip_col.a * la))
				var fd: float = _sd_round_rect(p, face_c, face_half, face_r)
				var fa: float = clampf(0.5 - fd, 0.0, 1.0)
				if fa > 0.0:
					var t: float = clampf((p.y - face_top) / maxf(1.0, face_bottom - face_top), 0.0, 1.0)
					var fc: Color = top.lerp(bottom, t)
					# subtle inner top rim light
					var rim: float = clampf(1.0 - absf(p.y - (face_top + 1.5)) / 2.0, 0.0, 1.0) * 0.35
					fc = fc.lerp(Color(1, 1, 1, fc.a), rim)
					col = _blend(col, Color(fc.r, fc.g, fc.b, fc.a * fa))
					if gloss > 0.0:
						var gd: float = _sd_round_rect(p, gloss_c, gloss_half, maxf(2.0, face_r - 3.0))
						var ga: float = clampf(0.5 - gd, 0.0, 1.0)
						if ga > 0.0:
							var gt: float = clampf((p.y - gloss_top) / maxf(1.0, gloss_bottom - gloss_top), 0.0, 1.0)
							col = _blend(col, Color(1, 1, 1, gloss * (1.0 - gt) * ga))
			img.set_pixel(x, y, col)
	return ImageTexture.create_from_image(img)

static func _get_texture(key: String, top: Color, bottom: Color, border: Color, lip_col: Color, radius: int, border_w: int, gloss: float, lip: int, shadow: bool) -> ImageTexture:
	if _tex_cache.has(key):
		return _tex_cache[key]
	var tex: ImageTexture = _build_texture(top, bottom, border, lip_col, radius, border_w, gloss, lip, shadow)
	_tex_cache[key] = tex
	return tex

static func _box_from_texture(tex: Texture2D, radius: int, border_w: int, lip: int, shadow: bool, margin_h: float, margin_v: float) -> StyleBoxTexture:
	var pad: int = 8 if shadow else 1
	var sb: StyleBoxTexture = StyleBoxTexture.new()
	sb.texture = tex
	var m: float = float(pad + radius)
	sb.texture_margin_left = m
	sb.texture_margin_right = m
	sb.texture_margin_top = m
	sb.texture_margin_bottom = m + lip
	sb.expand_margin_left = pad
	sb.expand_margin_right = pad
	sb.expand_margin_top = pad
	sb.expand_margin_bottom = pad
	sb.content_margin_left = margin_h
	sb.content_margin_right = margin_h
	sb.content_margin_top = margin_v
	sb.content_margin_bottom = margin_v + lip
	return sb

## Button-style box for a palette (gradient + 3D lip + gloss).
static func button_box(palette: String, radius: int = 22, margin_h: float = 18.0, margin_v: float = 8.0) -> StyleBoxTexture:
	var pal: Dictionary = PALETTES.get(palette, PALETTES["blue"])
	var lip: int = 5
	var key: String = "btn_%s_%d" % [palette, radius]
	var tex: ImageTexture = _get_texture(key, pal["top"], pal["bottom"], pal["border"], pal["lip"], radius, 3, 0.38, lip, true)
	return _box_from_texture(tex, radius, 3, lip, true, margin_h, margin_v)

## Panel / card / chip box.
static func panel_box(kind: String, margin_h: float = -1.0, margin_v: float = -1.0) -> StyleBoxTexture:
	var k: Dictionary = PANEL_KINDS.get(kind, PANEL_KINDS["card"])
	var radius: int = k["radius"]
	var bw: int = k["border_w"]
	var lip: int = k["lip"]
	var key: String = "panel_%s" % kind
	var lip_col: Color = (k["bottom"] as Color).darkened(0.35)
	var tex: ImageTexture = _get_texture(key, k["top"], k["bottom"], k["border"], lip_col, radius, bw, k["gloss"], lip, true)
	var mh: float = margin_h if margin_h >= 0.0 else float(radius) * 0.8
	var mv: float = margin_v if margin_v >= 0.0 else float(radius) * 0.55
	return _box_from_texture(tex, radius, bw, lip, true, mh, mv)

# ---------------------------------------------------------------------------
# Style helpers
# ---------------------------------------------------------------------------

static func style_label(lbl: Control, font_size: int, color: Color = Color.WHITE, outline: int = 0, outline_color: Color = Color(0.03, 0.05, 0.14), bold: bool = true, shadow: bool = false) -> void:
	if lbl == null:
		return
	if lbl is RichTextLabel:
		var rtl: RichTextLabel = lbl
		rtl.add_theme_font_override("normal_font", FONT_BOLD if bold else FONT_UI)
		rtl.add_theme_font_override("bold_font", FONT_BOLD)
		rtl.add_theme_font_size_override("normal_font_size", font_size)
		rtl.add_theme_font_size_override("bold_font_size", font_size)
		rtl.add_theme_color_override("default_color", color)
		rtl.add_theme_constant_override("outline_size", outline)
		rtl.add_theme_color_override("font_outline_color", outline_color)
		if shadow:
			rtl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.35))
			rtl.add_theme_constant_override("shadow_offset_y", 4)
			rtl.add_theme_constant_override("shadow_offset_x", 0)
		return
	lbl.add_theme_font_override("font", FONT_BOLD if bold else FONT_UI)
	lbl.add_theme_font_size_override("font_size", font_size)
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_constant_override("outline_size", outline)
	lbl.add_theme_color_override("font_outline_color", outline_color)
	if shadow:
		lbl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.35))
		lbl.add_theme_constant_override("shadow_offset_y", 4)
		lbl.add_theme_constant_override("shadow_offset_x", 0)
		lbl.add_theme_constant_override("shadow_outline_size", outline)

static func style_panel(panel: Control, kind: String, margin_h: float = -1.0, margin_v: float = -1.0) -> void:
	if panel == null:
		return
	panel.add_theme_stylebox_override("panel", panel_box(kind, margin_h, margin_v))

## Applies the glossy palette to a Button with clear hover / pressed / disabled / focus states
## and adds a springy press animation (scale only, never moves layout position).
static func style_button(btn: Button, palette: String, font_size: int = 20, radius: int = 22, margin_h: float = 18.0, margin_v: float = 8.0) -> void:
	if btn == null:
		return
	var pal: Dictionary = PALETTES.get(palette, PALETTES["blue"])
	var normal: StyleBoxTexture = button_box(palette, radius, margin_h, margin_v)
	var hover: StyleBoxTexture = normal.duplicate()
	hover.modulate_color = Color(1.12, 1.12, 1.12, 1.0)
	var pressed: StyleBoxTexture = normal.duplicate()
	pressed.modulate_color = Color(0.86, 0.86, 0.9, 1.0)
	pressed.content_margin_top = normal.content_margin_top + 3.0
	pressed.content_margin_bottom = normal.content_margin_bottom - 3.0
	var disabled: StyleBoxTexture = button_box("gray", radius, margin_h, margin_v)
	disabled.modulate_color = Color(1, 1, 1, 0.8)
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_stylebox_override("hover_pressed", pressed)
	btn.add_theme_stylebox_override("disabled", disabled)
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	btn.add_theme_font_override("font", FONT_BOLD)
	btn.add_theme_font_size_override("font_size", font_size)
	for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_hover_pressed_color"]:
		btn.add_theme_color_override(c, Color.WHITE)
	btn.add_theme_color_override("font_disabled_color", Color(0.9, 0.92, 0.96, 0.85))
	btn.add_theme_color_override("font_outline_color", pal["outline"])
	btn.add_theme_constant_override("outline_size", maxi(4, int(font_size * 0.28)))
	btn.add_theme_color_override("icon_normal_color", Color.WHITE)
	btn.add_theme_color_override("icon_hover_color", Color.WHITE)
	btn.add_theme_color_override("icon_pressed_color", Color(0.92, 0.92, 0.92))
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_attach_press_feedback(btn)

static func _attach_press_feedback(btn: Button) -> void:
	if btn.has_meta("uikit_fx"):
		return
	btn.set_meta("uikit_fx", true)
	var update_pivot: Callable = func(): btn.pivot_offset = btn.size * 0.5
	btn.resized.connect(update_pivot)
	update_pivot.call()
	btn.button_down.connect(func():
		if btn.disabled:
			return
		var tw: Tween = btn.create_tween()
		tw.tween_property(btn, "scale", Vector2(0.94, 0.94), 0.06)
	)
	btn.button_up.connect(func():
		var tw: Tween = btn.create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	)
	btn.mouse_entered.connect(func():
		if btn.disabled or btn.button_pressed:
			return
		var tw: Tween = btn.create_tween()
		tw.tween_property(btn, "scale", Vector2(1.04, 1.04), 0.12).set_trans(Tween.TRANS_SINE)
	)
	btn.mouse_exited.connect(func():
		var tw: Tween = btn.create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_SINE)
	)

## Creates a tile button with an icon above a caption (used by the main menu).
static func make_icon_tile(caption: String, icon: Texture2D, palette: String, font_size: int = 20) -> Button:
	var btn: Button = Button.new()
	btn.custom_minimum_size = Vector2(132, 112)
	style_button(btn, palette, font_size, 24, 10.0, 8.0)
	var vb: VBoxContainer = VBoxContainer.new()
	vb.name = "TileContent"
	vb.set_anchors_preset(Control.PRESET_FULL_RECT)
	vb.offset_top = 8
	vb.offset_bottom = -12
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 4)
	btn.add_child(vb)
	var tr: TextureRect = TextureRect.new()
	tr.name = "Icon"
	tr.texture = icon
	tr.custom_minimum_size = Vector2(52, 52)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(tr)
	var lbl: Label = Label.new()
	lbl.name = "Caption"
	lbl.text = caption
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pal: Dictionary = PALETTES.get(palette, PALETTES["blue"])
	style_label(lbl, font_size, Color.WHITE, maxi(4, int(font_size * 0.3)), pal["outline"])
	vb.add_child(lbl)
	return btn

## Fade + pop-in transition for overlays. `panel` is the inner card that scales.
static func open_overlay(overlay: Control, panel: Control = null) -> void:
	if overlay == null:
		return
	overlay.visible = true
	overlay.modulate.a = 0.0
	var tw: Tween = overlay.create_tween().set_parallel(true)
	tw.tween_property(overlay, "modulate:a", 1.0, 0.18)
	if panel:
		panel.pivot_offset = panel.size * 0.5
		panel.scale = Vector2(0.9, 0.9)
		tw.tween_property(panel, "scale", Vector2.ONE, 0.26).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

static func close_overlay(overlay: Control, panel: Control = null) -> void:
	if overlay == null or not overlay.visible:
		return
	var tw: Tween = overlay.create_tween().set_parallel(true)
	tw.tween_property(overlay, "modulate:a", 0.0, 0.14)
	if panel:
		panel.pivot_offset = panel.size * 0.5
		tw.tween_property(panel, "scale", Vector2(0.92, 0.92), 0.14)
	tw.chain().tween_callback(func():
		overlay.visible = false
		overlay.modulate.a = 1.0
		if panel:
			panel.scale = Vector2.ONE
	)

## Styles an HSlider with modern rounded glassmorphism track and glowing fill.
static func style_slider(slider: HSlider) -> void:
	if slider == null:
		return
	var track := StyleBoxFlat.new()
	track.bg_color = Color(0.04, 0.08, 0.18, 0.95)
	track.border_color = Color(0.24, 0.38, 0.68, 0.85)
	track.border_width_left = 1
	track.border_width_right = 1
	track.border_width_top = 1
	track.border_width_bottom = 1
	track.corner_radius_top_left = 6
	track.corner_radius_top_right = 6
	track.corner_radius_bottom_left = 6
	track.corner_radius_bottom_right = 6
	track.content_margin_top = 5
	track.content_margin_bottom = 5

	var fill := StyleBoxFlat.new()
	fill.bg_color = Color(0.25, 0.75, 1.0, 0.95)
	fill.corner_radius_top_left = 6
	fill.corner_radius_bottom_left = 6
	fill.content_margin_top = 5
	fill.content_margin_bottom = 5

	slider.add_theme_stylebox_override("slider", track)
	slider.add_theme_stylebox_override("grabber_area", fill)
	slider.add_theme_stylebox_override("grabber_area_highlight", fill)
