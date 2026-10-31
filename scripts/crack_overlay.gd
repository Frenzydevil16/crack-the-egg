extends Control
class_name CrackOverlay

## High-detail programmatic vector crack rendering for "Crack the egg"
## Supports cumulative 14-stage fracture progression scaled to any target_clicks (1,000..10,000)
## as well as world-native ("nature", "crystal", "cosmic") and shop cosmetic crack styles.

var current_clicks: int = 0
var target_clicks: int = 10000
var normalized_clicks: int = 0
var crack_style: String = "normal" # "normal"/"nature", "crystal", "cosmic", "gold", "magma", "ice"
var world_id: String = "nature"
var jitter_intensity: float = 0.0
var _rng = RandomNumberGenerator.new()

# Crack branches keyed by stage threshold (normalized 0..10000 progress inside egg silhouette)
var crack_stages: Array[Dictionary] = []

func _ready() -> void:
	_rng.randomize()
	_init_crack_data()

func set_clicks(clicks: int, p_target: int = -1) -> void:
	if p_target > 0:
		target_clicks = maxi(1, p_target)
	current_clicks = clampi(clicks, 0, target_clicks)
	if current_clicks <= 0:
		normalized_clicks = 0
	elif current_clicks >= target_clicks:
		normalized_clicks = 10000
	else:
		var ratio: float = clampf(float(current_clicks) / float(target_clicks), 0.0, 1.0)
		normalized_clicks = int(round(ratio * 10000.0))
		if current_clicks == target_clicks - 1:
			normalized_clicks = maxi(normalized_clicks, 9999)

	if normalized_clicks >= 8000:
		jitter_intensity = clampf((normalized_clicks - 8000.0) / 2000.0, 0.0, 1.0)
	else:
		jitter_intensity = 0.0
	queue_redraw()

func set_world_id(p_world_id: String) -> void:
	world_id = p_world_id
	queue_redraw()

func set_crack_style(style_id: String) -> void:
	crack_style = style_id
	queue_redraw()

func trigger_click_shake() -> void:
	if normalized_clicks >= 8000:
		queue_redraw()

func _get_style_colors() -> Dictionary:
	var effective_style: String = crack_style
	if effective_style == "normal" or effective_style == "":
		effective_style = world_id

	match effective_style:
		"gold":
			return {
				"shadow": Color(0.28, 0.16, 0.04, 0.85),
				"main": Color(1.0, 0.84, 0.18, 0.98),
				"bevel": Color(1.0, 0.97, 0.72, 0.85),
				"glow": Color(1.0, 0.75, 0.1, 0.32)
			}
		"magma":
			return {
				"shadow": Color(0.18, 0.05, 0.03, 0.92),
				"main": Color(1.0, 0.34, 0.06, 0.98),
				"bevel": Color(1.0, 0.88, 0.30, 0.90),
				"glow": Color(1.0, 0.22, 0.02, 0.38)
			}
		"ice", "crystal":
			return {
				"shadow": Color(0.04, 0.18, 0.42, 0.90),
				"main": Color(0.22, 0.88, 1.0, 0.98),
				"bevel": Color(0.90, 0.99, 1.0, 0.92),
				"glow": Color(0.15, 0.78, 1.0, 0.38)
			}
		"cosmic":
			return {
				"shadow": Color(0.12, 0.02, 0.26, 0.92),
				"main": Color(0.92, 0.28, 1.0, 0.98),
				"bevel": Color(0.35, 0.96, 1.0, 0.92),
				"glow": Color(0.75, 0.18, 1.0, 0.42)
			}
		_:
			# Nature Egg: classic dark shell fissure with subtle emerald life-energy glow
			return {
				"shadow": Color(0.32, 0.24, 0.16, 0.50),
				"main": Color(0.19, 0.12, 0.07, 0.95),
				"bevel": Color(0.85, 0.98, 0.82, 0.70),
				"glow": Color(0.28, 0.92, 0.45, 0.20)
			}

func _init_crack_data() -> void:
	crack_stages.clear()

	# Stage 100 (1%): First tiny hairline cracks (upper right)
	crack_stages.append({
		"threshold": 100,
		"width": 2.2,
		"lines": [
			[Vector2(0.67, 0.27), Vector2(0.70, 0.31), Vector2(0.72, 0.34), Vector2(0.70, 0.38)],
			[Vector2(0.70, 0.31), Vector2(0.74, 0.30)]
		]
	})

	# Stage 500 (5%): Small cracks visible (lower left + micro forks)
	crack_stages.append({
		"threshold": 500,
		"width": 2.5,
		"lines": [
			[Vector2(0.31, 0.59), Vector2(0.34, 0.63), Vector2(0.36, 0.66), Vector2(0.39, 0.68)],
			[Vector2(0.34, 0.63), Vector2(0.29, 0.65)]
		]
	})

	# Stage 1000 (10%): Multiple fine cracks on surface
	crack_stages.append({
		"threshold": 1000,
		"width": 2.8,
		"lines": [
			[Vector2(0.48, 0.17), Vector2(0.51, 0.22), Vector2(0.54, 0.26), Vector2(0.57, 0.29)],
			[Vector2(0.51, 0.22), Vector2(0.46, 0.24)],
			[Vector2(0.70, 0.38), Vector2(0.75, 0.41), Vector2(0.79, 0.43), Vector2(0.82, 0.46)]
		]
	})

	# Stage 2000 (20%): Longer and more branched cracks
	crack_stages.append({
		"threshold": 2000,
		"width": 3.1,
		"lines": [
			[Vector2(0.36, 0.66), Vector2(0.32, 0.71), Vector2(0.30, 0.75), Vector2(0.33, 0.80)],
			[Vector2(0.36, 0.66), Vector2(0.41, 0.63), Vector2(0.45, 0.59), Vector2(0.47, 0.56)],
			[Vector2(0.75, 0.41), Vector2(0.73, 0.46)]
		]
	})

	# Stage 3000 (30%): First major crack groups
	crack_stages.append({
		"threshold": 3000,
		"width": 3.4,
		"lines": [
			[Vector2(0.64, 0.67), Vector2(0.68, 0.72), Vector2(0.71, 0.76), Vector2(0.73, 0.80)],
			[Vector2(0.68, 0.72), Vector2(0.65, 0.78), Vector2(0.63, 0.83)],
			[Vector2(0.23, 0.47), Vector2(0.27, 0.50), Vector2(0.31, 0.53), Vector2(0.35, 0.54)],
			[Vector2(0.27, 0.50), Vector2(0.25, 0.55)]
		]
	})

	# Stage 4000 (40%): Distinct crack network across shell regions
	crack_stages.append({
		"threshold": 4000,
		"width": 3.7,
		"lines": [
			[Vector2(0.47, 0.56), Vector2(0.51, 0.53), Vector2(0.55, 0.54), Vector2(0.59, 0.56)],
			[Vector2(0.51, 0.22), Vector2(0.45, 0.28), Vector2(0.41, 0.33), Vector2(0.38, 0.37)],
			[Vector2(0.57, 0.29), Vector2(0.62, 0.31), Vector2(0.67, 0.27)],
			[Vector2(0.41, 0.33), Vector2(0.35, 0.32)]
		]
	})

	# Stage 5000 (50%): Halfway damaged (major structural fault lines)
	crack_stages.append({
		"threshold": 5000,
		"width": 4.1,
		"lines": [
			[Vector2(0.38, 0.37), Vector2(0.41, 0.42), Vector2(0.44, 0.47), Vector2(0.47, 0.51)],
			[Vector2(0.59, 0.56), Vector2(0.63, 0.60), Vector2(0.65, 0.64), Vector2(0.64, 0.67)],
			[Vector2(0.47, 0.51), Vector2(0.51, 0.53)],
			[Vector2(0.44, 0.47), Vector2(0.39, 0.49)]
		]
	})

	# Stage 6000 (60%): Many cracks interconnecting into polygon cells
	crack_stages.append({
		"threshold": 6000,
		"width": 4.3,
		"lines": [
			[Vector2(0.31, 0.53), Vector2(0.37, 0.49), Vector2(0.41, 0.42)],
			[Vector2(0.70, 0.38), Vector2(0.65, 0.43), Vector2(0.61, 0.48), Vector2(0.58, 0.51)],
			[Vector2(0.58, 0.51), Vector2(0.59, 0.56)],
			[Vector2(0.47, 0.56), Vector2(0.49, 0.64), Vector2(0.51, 0.70), Vector2(0.52, 0.75)]
		]
	})

	# Stage 7000 (70%): Large fault lines covering most of the shell
	crack_stages.append({
		"threshold": 7000,
		"width": 4.6,
		"lines": [
			[Vector2(0.49, 0.64), Vector2(0.56, 0.67), Vector2(0.64, 0.67)],
			[Vector2(0.52, 0.75), Vector2(0.49, 0.81), Vector2(0.48, 0.85), Vector2(0.50, 0.89)],
			[Vector2(0.48, 0.17), Vector2(0.46, 0.12), Vector2(0.49, 0.08)],
			[Vector2(0.65, 0.43), Vector2(0.73, 0.48), Vector2(0.79, 0.52), Vector2(0.84, 0.55)]
		]
	})

	# Stage 8000 (80%): Very brittle look, plates defined
	crack_stages.append({
		"threshold": 8000,
		"width": 4.9,
		"lines": [
			[Vector2(0.18, 0.42), Vector2(0.23, 0.47)],
			[Vector2(0.38, 0.37), Vector2(0.32, 0.39), Vector2(0.26, 0.41), Vector2(0.21, 0.44)],
			[Vector2(0.30, 0.75), Vector2(0.37, 0.77), Vector2(0.43, 0.80), Vector2(0.48, 0.85)],
			[Vector2(0.73, 0.48), Vector2(0.72, 0.56), Vector2(0.69, 0.61), Vector2(0.63, 0.60)]
		]
	})

	# Stage 9000 (90%): Almost completely fractured, dense mosaic
	crack_stages.append({
		"threshold": 9000,
		"width": 5.2,
		"lines": [
			[Vector2(0.46, 0.12), Vector2(0.39, 0.17), Vector2(0.35, 0.23), Vector2(0.33, 0.29)],
			[Vector2(0.33, 0.29), Vector2(0.38, 0.37)],
			[Vector2(0.57, 0.29), Vector2(0.64, 0.25), Vector2(0.71, 0.22)],
			[Vector2(0.72, 0.34), Vector2(0.80, 0.35), Vector2(0.86, 0.39)],
			[Vector2(0.63, 0.83), Vector2(0.67, 0.89)],
			[Vector2(0.31, 0.59), Vector2(0.22, 0.61), Vector2(0.17, 0.64)]
		]
	})

	# Stage 9500 (95%): Intense pre-shatter spiderwebbing
	crack_stages.append({
		"threshold": 9500,
		"width": 5.5,
		"lines": [
			[Vector2(0.49, 0.08), Vector2(0.53, 0.04)],
			[Vector2(0.50, 0.89), Vector2(0.52, 0.95)],
			[Vector2(0.41, 0.42), Vector2(0.48, 0.41), Vector2(0.54, 0.43), Vector2(0.61, 0.48)],
			[Vector2(0.36, 0.66), Vector2(0.41, 0.72), Vector2(0.45, 0.77)],
			[Vector2(0.63, 0.60), Vector2(0.59, 0.63), Vector2(0.56, 0.67)],
			[Vector2(0.25, 0.55), Vector2(0.31, 0.59)]
		]
	})

	# Stage 9999 (99.99%): Final tension fractures right before rupture
	crack_stages.append({
		"threshold": 9999,
		"width": 6.0,
		"lines": [
			[Vector2(0.53, 0.04), Vector2(0.50, 0.01)],
			[Vector2(0.52, 0.95), Vector2(0.50, 0.98)],
			[Vector2(0.14, 0.40), Vector2(0.18, 0.42)],
			[Vector2(0.84, 0.55), Vector2(0.89, 0.57)],
			[Vector2(0.45, 0.28), Vector2(0.50, 0.33), Vector2(0.55, 0.31), Vector2(0.62, 0.31)]
		]
	})

func _draw() -> void:
	var w = size.x
	var h = size.y
	if w <= 0 or h <= 0 or normalized_clicks < 100:
		return

	var colors = _get_style_colors()
	var shadow_col: Color = colors["shadow"]
	var main_col: Color = colors["main"]
	var bevel_col: Color = colors["bevel"]
	var glow_col: Color = colors["glow"]

	for s_idx in range(crack_stages.size()):
		var stage = crack_stages[s_idx]
		if normalized_clicks < stage["threshold"]:
			break

		var group_jitter = Vector2.ZERO
		if jitter_intensity > 0.0 and normalized_clicks >= 8000 and normalized_clicks < 10000:
			var max_j = jitter_intensity * 2.0
			var angle = float(s_idx) * 1.7 + float(current_clicks % 7)
			group_jitter = Vector2(cos(angle), sin(angle)) * max_j

		var line_width: float = stage["width"]
		for poly in stage["lines"]:
			var pts = PackedVector2Array()
			var bevel_pts = PackedVector2Array()
			for p in poly:
				var px = Vector2(p.x * w, p.y * h) + group_jitter
				pts.append(px)
				bevel_pts.append(px + Vector2(1.4, 1.4))

			if pts.size() >= 2:
				if glow_col.a > 0.01:
					draw_polyline(pts, glow_col, line_width + 6.0, true)
				draw_polyline(bevel_pts, bevel_col, maxf(1.2, line_width * 0.6), true)
				draw_polyline(pts, shadow_col, line_width + 2.2, true)
				draw_polyline(pts, main_col, line_width, true)
