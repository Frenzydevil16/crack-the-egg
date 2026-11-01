extends Control
class_name WorldBackdrop

## Renders subtle multi-layer atmospheric animations tailored to the active world:
## - "nature": Warm sunbeams, floating fireflies & emerald motes, swaying meadow flora
## - "crystal": Cool subterranean crystal rays, floating diamond shards & water bubbles
## - "cosmic": Deep nebula rays, twinkling 4-point stars & cosmic energy motes
## Never obscures the central egg or UI.

var time_sec: float = 0.0
var world_id: String = "nature"
var motes: Array[Dictionary] = []
var flora_clusters: Array[Dictionary] = []
var particles_enabled: bool = true
var _rng := RandomNumberGenerator.new()

const MAX_MOTES: int = 28

func _ready() -> void:
	_rng.randomize()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_init_layers()

func set_world_theme(p_world_id: String) -> void:
	if world_id == p_world_id and not motes.is_empty():
		return
	world_id = p_world_id
	_init_layers()
	queue_redraw()

func _init_layers() -> void:
	motes.clear()
	for i in range(MAX_MOTES):
		var on_left: bool = (i % 2 == 0)
		var nx: float = _rng.randf_range(0.04, 0.34) if on_left else _rng.randf_range(0.66, 0.96)
		if i % 5 == 0:
			nx = _rng.randf_range(0.15, 0.85)
		var ny: float = _rng.randf_range(0.15, 0.90)
		var palette_idx: int = i % 4
		var col: Color
		var shape_type: int = 0 # 0=orb, 1=crystal, 2=star, 3=leaf

		match world_id:
			"crystal":
				match palette_idx:
					0: col = Color(0.35, 0.96, 1.0, 0.85)
					1: col = Color(0.65, 0.92, 1.0, 0.80)
					2: col = Color(0.25, 0.72, 1.0, 0.78)
					_: col = Color(0.82, 0.98, 1.0, 0.88)
				shape_type = 1 if (i % 2 == 0) else 0
			"cosmic":
				match palette_idx:
					0: col = Color(1.0, 0.92, 0.45, 0.90)
					1: col = Color(0.95, 0.38, 1.0, 0.84)
					2: col = Color(0.28, 0.95, 1.0, 0.85)
					_: col = Color(0.72, 0.48, 1.0, 0.82)
				shape_type = 2 if (i % 2 == 0) else 1
			"forest":
				match palette_idx:
					0: col = Color(0.35, 0.95, 1.0, 0.85)
					1: col = Color(0.85, 0.40, 1.0, 0.82)
					2: col = Color(0.40, 1.0, 0.65, 0.80)
					_: col = Color(1.0, 0.92, 0.45, 0.85)
				shape_type = 3 if (i % 2 == 0) else 0
			"ocean":
				match palette_idx:
					0: col = Color(1.0, 0.85, 0.45, 0.88)
					1: col = Color(0.35, 0.95, 1.0, 0.82)
					2: col = Color(1.0, 0.60, 0.75, 0.80)
					_: col = Color(1.0, 0.96, 0.85, 0.90)
				shape_type = 2 if (i % 3 == 0) else 0
			"magma":
				match palette_idx:
					0: col = Color(1.0, 0.45, 0.15, 0.92)
					1: col = Color(1.0, 0.75, 0.20, 0.90)
					2: col = Color(1.0, 0.25, 0.10, 0.85)
					_: col = Color(1.0, 0.95, 0.40, 0.95)
				shape_type = 1 if (i % 2 == 0) else 2
			"celestial":
				match palette_idx:
					0: col = Color(1.0, 0.70, 0.85, 0.90)
					1: col = Color(1.0, 0.92, 0.50, 0.92)
					2: col = Color(0.65, 0.85, 1.0, 0.85)
					_: col = Color(1.0, 1.0, 1.0, 0.95)
				shape_type = 3 if (i % 2 == 0) else 2
			_: # "nature"
				match palette_idx:
					0: col = Color(1.0, 0.96, 0.55, 0.84)
					1: col = Color(0.45, 0.98, 0.62, 0.82)
					2: col = Color(0.62, 1.0, 0.72, 0.78)
					_: col = Color(0.45, 0.96, 1.0, 0.75)
				shape_type = 3 if (i % 3 == 0) else 0

		motes.append({
			"nx": nx,
			"ny": ny,
			"vx": _rng.randf_range(-0.012, 0.012),
			"vy": _rng.randf_range(-0.018, -0.006),
			"radius": _rng.randf_range(3.2, 7.0),
			"phase": _rng.randf_range(0.0, TAU),
			"pulse_speed": _rng.randf_range(1.6, 3.2),
			"color": col,
			"shape": shape_type
		})

	flora_clusters.clear()
	var positions: Array[float] = [0.06, 0.13, 0.21, 0.79, 0.87, 0.94]
	for px in positions:
		var fc_col: Color
		match world_id:
			"crystal":
				fc_col = Color(0.28, 0.92, 1.0, 0.46) if px < 0.5 else Color(0.45, 0.78, 1.0, 0.46)
			"cosmic":
				fc_col = Color(0.88, 0.35, 1.0, 0.44) if px < 0.5 else Color(0.32, 0.92, 1.0, 0.44)
			"forest":
				fc_col = Color(0.40, 0.95, 0.70, 0.44) if px < 0.5 else Color(0.75, 0.45, 0.95, 0.44)
			"ocean":
				fc_col = Color(0.35, 0.90, 0.95, 0.44) if px < 0.5 else Color(1.0, 0.70, 0.50, 0.44)
			"magma":
				fc_col = Color(1.0, 0.45, 0.20, 0.44) if px < 0.5 else Color(1.0, 0.75, 0.25, 0.44)
			"celestial":
				fc_col = Color(1.0, 0.75, 0.85, 0.44) if px < 0.5 else Color(1.0, 0.90, 0.55, 0.44)
			_:
				fc_col = Color(0.38, 0.95, 0.65, 0.44) if px < 0.5 else Color(0.55, 0.98, 0.72, 0.42)
		flora_clusters.append({
			"nx": px,
			"ny": _rng.randf_range(0.84, 0.93),
			"height": _rng.randf_range(26.0, 44.0),
			"phase": _rng.randf_range(0.0, TAU),
			"speed": _rng.randf_range(1.4, 2.2),
			"color": fc_col
		})

func _process(delta: float) -> void:
	if not particles_enabled:
		return
	time_sec += delta
	for m in motes:
		m["nx"] += m["vx"] * delta + sin(time_sec * 0.9 + m["phase"]) * 0.00015
		m["ny"] += m["vy"] * delta
		if m["ny"] < 0.10:
			m["ny"] = 0.92
		if m["nx"] < 0.02:
			m["nx"] = 0.96
		elif m["nx"] > 0.98:
			m["nx"] = 0.04
	queue_redraw()

func _draw() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return

	# 1. Atmospheric top light beams matching active world
	var beam_col := Color(1.0, 0.99, 0.85, 0.045)
	if world_id == "crystal":
		beam_col = Color(0.35, 0.95, 1.0, 0.055)
	elif world_id == "cosmic":
		beam_col = Color(0.82, 0.35, 1.0, 0.05)

	var sun_origin := Vector2(size.x * 0.5, -size.y * 0.08)
	var beam_len: float = size.y * 0.60
	for i in range(5):
		var base_ang: float = PI * 0.5 + (float(i - 2) * 0.18) + sin(time_sec * 0.25 + float(i)) * 0.03
		var spread: float = 0.045
		var p1 := sun_origin
		var p2 := sun_origin + Vector2(cos(base_ang - spread), sin(base_ang - spread)) * beam_len
		var p3 := sun_origin + Vector2(cos(base_ang + spread), sin(base_ang + spread)) * beam_len
		draw_colored_polygon(PackedVector2Array([p1, p2, p3]), beam_col)

	if not particles_enabled:
		return

	# 2. Edge accents near bottom corners (Meadow shoots / Crystal spires / Cosmic shards)
	for fc in flora_clusters:
		var base_pos := Vector2(fc["nx"] * size.x, fc["ny"] * size.y)
		var h: float = fc["height"]
		var sway: float = sin(time_sec * fc["speed"] + fc["phase"]) * 8.0
		var col: Color = fc["color"]
		if world_id == "crystal" or world_id == "cosmic":
			var crystal_poly := PackedVector2Array([
				base_pos + Vector2(-7.0, 0.0),
				base_pos + Vector2(sway * 0.35, -h),
				base_pos + Vector2(7.0, 0.0)
			])
			draw_colored_polygon(crystal_poly, col)
		else:
			for b in range(-1, 2):
				var bx: float = base_pos.x + float(b) * 10.0
				var tip := Vector2(bx + sway + float(b) * 5.0, base_pos.y - h * (1.0 - absf(float(b)) * 0.18))
				var mid := Vector2(bx + sway * 0.4, base_pos.y - h * 0.5)
				draw_line(Vector2(bx, base_pos.y), mid, col, 3.0, true)
				draw_line(mid, tip, col.lightened(0.25), 2.2, true)
				draw_circle(tip, 3.5, Color(col.r, col.g, col.b, col.a * 1.45))

	# 3. Floating ambient particles (Fireflies, Crystal Shards, Cosmic Stars, Leaves)
	for m in motes:
		var pos := Vector2(m["nx"] * size.x, m["ny"] * size.y)
		var pulse: float = 0.55 + 0.45 * sin(time_sec * m["pulse_speed"] + m["phase"])
		var r: float = m["radius"] * (0.85 + 0.25 * pulse)
		var c: Color = m["color"]
		var glow_col := Color(c.r, c.g, c.b, c.a * 0.26 * pulse)
		var core_col := Color(c.r, c.g, c.b, c.a * pulse)
		draw_circle(pos, r * 2.4, glow_col)

		match int(m["shape"]):
			1: # Crystal diamond
				var diamond := PackedVector2Array([
					pos + Vector2(0, -r * 1.35),
					pos + Vector2(r * 0.95, 0),
					pos + Vector2(0, r * 1.35),
					pos + Vector2(-r * 0.95, 0)
				])
				draw_colored_polygon(diamond, core_col)
				draw_circle(pos, r * 0.42, Color(1, 1, 1, 0.85 * pulse))
			2: # 4-Point Cosmic Star
				var s1 := PackedVector2Array([
					pos + Vector2(0, -r * 1.6),
					pos + Vector2(r * 0.42, 0),
					pos + Vector2(0, r * 1.6),
					pos + Vector2(-r * 0.42, 0)
				])
				var s2 := PackedVector2Array([
					pos + Vector2(-r * 1.6, 0),
					pos + Vector2(0, r * 0.42),
					pos + Vector2(r * 1.6, 0),
					pos + Vector2(0, -r * 0.42)
				])
				draw_colored_polygon(s1, core_col)
				draw_colored_polygon(s2, core_col)
				draw_circle(pos, r * 0.45, Color(1, 1, 1, 0.92 * pulse))
			3: # Nature leaf
				var ang: float = time_sec * 1.2 + m["phase"]
				var dir := Vector2(cos(ang), sin(ang)) * (r * 1.3)
				var perp := Vector2(-dir.y, dir.x) * 0.55
				draw_colored_polygon(PackedVector2Array([pos + dir, pos + perp, pos - dir, pos - perp]), core_col)
			_: # Glowing orb
				draw_circle(pos, r, core_col)
				draw_circle(pos, r * 0.45, Color(1, 1, 1, 0.9 * pulse))
