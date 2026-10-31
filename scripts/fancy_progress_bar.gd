extends Control
class_name FancyProgressBar

## Custom collector-game progress bar supporting dynamic click targets (1,000..10,000)
## and world-themed color palettes ("nature", "crystal", "cosmic").
## - Smoothly interpolated fill movement
## - Traveling shimmer highlight band across the fill
## - Milestone markers (50%, 75%, 90%) + milestone glow flash
## - High-voltage tension pulse at target-1 & golden finale glow at 100%
## - Strictly clamped to [0, target_clicks] / [0.0, 100.0%].

var current_clicks: int = 0
var target_clicks: int = 10000
var world_id: String = "nature"
var _target_ratio: float = 0.0
var _display_ratio: float = 0.0
var _shimmer_pos: float = 0.0
var _flash_intensity: float = 0.0
var _time_sec: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_world_theme(p_world_id: String) -> void:
	world_id = p_world_id
	queue_redraw()

func set_progress(clicks: int, immediate: bool = false, p_target: int = -1) -> void:
	if p_target > 0:
		target_clicks = maxi(1, p_target)
	var clamped: int = clampi(clicks, 0, target_clicks)
	current_clicks = clamped
	_target_ratio = clampf(float(clamped) / float(target_clicks), 0.0, 1.0)
	if immediate or clamped == 0 or clamped >= target_clicks:
		_display_ratio = _target_ratio
	queue_redraw()

func trigger_milestone_flash(strength: float = 1.0) -> void:
	_flash_intensity = clampf(strength, 0.0, 1.5)
	queue_redraw()

func _process(delta: float) -> void:
	_time_sec += delta
	_shimmer_pos = fmod(_shimmer_pos + delta * 0.55, 1.35)
	if not is_equal_approx(_display_ratio, _target_ratio):
		_display_ratio = lerpf(_display_ratio, _target_ratio, clampf(delta * 14.0, 0.0, 1.0))
		if absf(_display_ratio - _target_ratio) < 0.0005:
			_display_ratio = _target_ratio
	if _flash_intensity > 0.0:
		_flash_intensity = maxf(0.0, _flash_intensity - delta * 2.2)
	queue_redraw()

func _draw() -> void:
	if size.x <= 16.0 or size.y <= 16.0:
		return

	var w: float = size.x
	var h: float = size.y
	var radius: float = h * 0.5

	# 1. Soft drop shadow
	var shadow_sb := StyleBoxFlat.new()
	shadow_sb.bg_color = Color(0.01, 0.03, 0.09, 0.48)
	shadow_sb.set_corner_radius_all(int(radius))
	draw_style_box(shadow_sb, Rect2(0, 5, w, h))

	# 2. World-themed outer frame
	var border_col := Color("#2e9e5b")
	if world_id == "crystal":
		border_col = Color("#28b8ff")
	elif world_id == "cosmic":
		border_col = Color("#a845ff")

	if current_clicks >= target_clicks:
		border_col = Color("#ffd93d").lerp(Color("#ffffff"), 0.35 + 0.35 * sin(_time_sec * 8.0))
	elif current_clicks == target_clicks - 1:
		border_col = Color("#ff5e3a").lerp(Color("#ffd93d"), 0.5 + 0.5 * sin(_time_sec * 14.0))
	elif _flash_intensity > 0.01:
		border_col = border_col.lerp(Color("#ffd93d"), clampf(_flash_intensity, 0.0, 1.0))

	var outer_sb := StyleBoxFlat.new()
	outer_sb.bg_color = Color("#0a1329")
	outer_sb.border_color = border_col
	outer_sb.set_border_width_all(4)
	outer_sb.set_corner_radius_all(int(radius))
	draw_style_box(outer_sb, Rect2(0, 0, w, h))

	# 3. Recessed inner track
	var pad: float = 7.0
	var track_rect := Rect2(pad, pad, w - pad * 2.0, h - pad * 2.0)
	var track_r: int = maxi(6, int(track_rect.size.y * 0.5))
	var track_sb := StyleBoxFlat.new()
	track_sb.bg_color = Color("#122042")
	track_sb.set_corner_radius_all(track_r)
	draw_style_box(track_sb, track_rect)

	# 4. Smooth gradient fill bar matching active world
	var ratio: float = clampf(_display_ratio, 0.0, 1.0)
	if ratio > 0.001:
		var fill_w: float = maxf(float(track_r * 2), track_rect.size.x * ratio)
		fill_w = minf(fill_w, track_rect.size.x)
		var fill_rect := Rect2(track_rect.position.x, track_rect.position.y, fill_w, track_rect.size.y)

		var c_start := Color("#2ee67a")
		var c_mid := Color("#88ff4d")
		var c_end := Color("#ffb922")
		if world_id == "crystal":
			c_start = Color("#1ec8ff")
			c_mid = Color("#4df5ff")
			c_end = Color("#7088ff")
		elif world_id == "cosmic":
			c_start = Color("#8f3dff")
			c_mid = Color("#e845ff")
			c_end = Color("#3df5ff")

		var base_col: Color
		if ratio < 0.5:
			base_col = c_start.lerp(c_mid, ratio * 2.0)
		elif ratio < 0.9:
			base_col = c_mid.lerp(c_end, (ratio - 0.5) / 0.4)
		else:
			base_col = c_end.lerp(Color("#ff5268"), (ratio - 0.9) / 0.1)

		if current_clicks >= target_clicks:
			base_col = Color("#ffd52e").lerp(Color("#fff394"), 0.4 + 0.3 * sin(_time_sec * 6.0))
		elif current_clicks == target_clicks - 1:
			base_col = Color("#ff4b3a").lerp(Color("#ffd52e"), 0.5 + 0.5 * sin(_time_sec * 16.0))

		if _flash_intensity > 0.01:
			base_col = base_col.lerp(Color.WHITE, clampf(_flash_intensity * 0.55, 0.0, 0.75))

		var fill_sb := StyleBoxFlat.new()
		fill_sb.bg_color = base_col
		fill_sb.set_corner_radius_all(track_r)
		draw_style_box(fill_sb, fill_rect)

		# Upper glossy reflection strip inside the fill
		var gloss_rect := Rect2(fill_rect.position.x + 6.0, fill_rect.position.y + 3.0, maxf(0.0, fill_rect.size.x - 12.0), fill_rect.size.y * 0.42)
		if gloss_rect.size.x > 4.0:
			var gloss_sb := StyleBoxFlat.new()
			gloss_sb.bg_color = Color(1.0, 1.0, 1.0, 0.32)
			gloss_sb.set_corner_radius_all(maxi(3, int(gloss_rect.size.y * 0.5)))
			draw_style_box(gloss_sb, gloss_rect)

		# Traveling shimmer wave across the fill
		var shimmer_center_x: float = fill_rect.position.x + (_shimmer_pos - 0.15) * fill_rect.size.x
		var shimmer_half_w: float = 28.0
		var s_left: float = clampf(shimmer_center_x - shimmer_half_w, fill_rect.position.x + float(track_r), fill_rect.end.x - float(track_r))
		var s_right: float = clampf(shimmer_center_x + shimmer_half_w, fill_rect.position.x + float(track_r), fill_rect.end.x - float(track_r))
		if s_right - s_left > 4.0:
			var shim_rect := Rect2(s_left, fill_rect.position.y + 2.0, s_right - s_left, fill_rect.size.y - 4.0)
			var shim_sb := StyleBoxFlat.new()
			shim_sb.bg_color = Color(1.0, 1.0, 1.0, 0.26)
			shim_sb.set_corner_radius_all(8)
			draw_style_box(shim_sb, shim_rect)

		# Leading edge glow orb
		if ratio > 0.02 and ratio < 0.995:
			var tip_pos := Vector2(fill_rect.end.x - 6.0, fill_rect.get_center().y)
			draw_circle(tip_pos, track_rect.size.y * 0.42, Color(1.0, 1.0, 1.0, 0.35))
			draw_circle(tip_pos, track_rect.size.y * 0.22, Color(1.0, 1.0, 1.0, 0.85))

	# 5. Milestone markers at 50%, 75%, 90%
	var milestones: Array[float] = [0.50, 0.75, 0.90]
	for m in milestones:
		var mx: float = track_rect.position.x + track_rect.size.x * m
		var reached: bool = (ratio >= m)
		var tick_col: Color = Color("#fff38a") if reached else Color(0.55, 0.68, 0.92, 0.45)
		draw_line(Vector2(mx, track_rect.position.y + 3.0), Vector2(mx, track_rect.end.y - 3.0), tick_col, 2.0)
		var d_center := Vector2(mx, track_rect.position.y + 3.0)
		var d_r: float = 5.5 if reached else 4.0
		var d_poly := PackedVector2Array([
			d_center + Vector2(0, -d_r),
			d_center + Vector2(d_r, 0),
			d_center + Vector2(0, d_r),
			d_center + Vector2(-d_r, 0)
		])
		draw_colored_polygon(d_poly, Color("#ffd93d") if reached else Color("#283d6e"))

	# 6. Outer flash overlay when milestone reached
	if _flash_intensity > 0.01:
		var flash_sb := StyleBoxFlat.new()
		flash_sb.bg_color = Color(1.0, 0.95, 0.55, _flash_intensity * 0.25)
		flash_sb.border_color = Color(1.0, 0.96, 0.65, _flash_intensity * 0.85)
		flash_sb.set_border_width_all(3)
		flash_sb.set_corner_radius_all(int(radius))
		draw_style_box(flash_sb, Rect2(0, 0, w, h))
