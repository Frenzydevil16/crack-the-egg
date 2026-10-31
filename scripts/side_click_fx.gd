extends Control
class_name SideClickFX

## Renders randomized, bounded visual effects on the left and right sides of the egg
## (Comic lightning bolts, colored light orbs, star sparks, energy pulses,
## crystal shards, and soft glitter bursts), themed to the active Egg & World.

enum EffectKind {
	COMIC_BOLT = 0,
	LIGHT_ORB = 1,
	STAR_SPARK = 2,
	ENERGY_PULSE = 3,
	CRYSTAL_SHARD = 4,
	GLITTER_BURST = 5
}

const MAX_EFFECTS: int = 48

var active_effects: Array[Dictionary] = []
var effects_enabled: bool = true
var world_id: String = "nature"
var _rng := RandomNumberGenerator.new()

const WORLD_PALETTES := {
	"nature": [
		Color("#6bff8b"), # Meadow Emerald
		Color("#ffd93d"), # Sunny Gold
		Color("#a8ff52"), # Leaf Lime
		Color("#4df0ff"), # Dewdrop Cyan
		Color("#ff9b3d")  # Amber Spark
	],
	"crystal": [
		Color("#4df0ff"), # Crystal Cyan
		Color("#a6f9ff"), # Frost White-Blue
		Color("#3d9eff"), # Sapphire Glow
		Color("#7cf5ff"), # Ice Turquoise
		Color("#d48aff")  # Amethyst Prism
	],
	"cosmic": [
		Color("#e44dff"), # Nebula Magenta
		Color("#4df0ff"), # Quasar Cyan
		Color("#ffd93d"), # Starlight Gold
		Color("#9d5cff"), # Deep Cosmic Violet
		Color("#ff6bd6")  # Supernova Pink
	]
}

func _ready() -> void:
	_rng.randomize()
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_world_theme(p_world_id: String) -> void:
	world_id = p_world_id

func clear_all() -> void:
	active_effects.clear()
	queue_redraw()

func trigger_click_effect(streak: int = 1, particle_style: String = "part_gold") -> void:
	if not effects_enabled:
		return
	var streak_factor: float = clampf(float(streak) / 18.0, 0.0, 1.0)
	var both_sides_chance: float = 0.22 + streak_factor * 0.48
	var spawn_both: bool = (_rng.randf() < both_sides_chance)
	var primary_side: int = -1 if (_rng.randf() < 0.5) else 1

	var count_per_side: int = 1 + (1 if (_rng.randf() < streak_factor * 0.75) else 0)
	for i in range(count_per_side):
		_spawn_single_effect(primary_side, streak_factor, particle_style)
	if spawn_both:
		_spawn_single_effect(-primary_side, streak_factor, particle_style)

	queue_redraw()

func trigger_milestone_effect(milestone_pct: int) -> void:
	if not effects_enabled:
		return
	var burst_count: int = 8
	var scale_boost: float = 1.25
	if milestone_pct >= 99:
		burst_count = 16
		scale_boost = 1.65
	elif milestone_pct >= 90:
		burst_count = 13
		scale_boost = 1.45
	elif milestone_pct >= 50:
		burst_count = 10
		scale_boost = 1.35

	var pal: Array = WORLD_PALETTES.get(world_id, WORLD_PALETTES["nature"])
	for i in range(burst_count):
		var side: int = -1 if (i % 2 == 0) else 1
		var kind: int = i % 6
		if milestone_pct >= 99 and (i % 3 == 0):
			kind = EffectKind.COMIC_BOLT
		var c: Color = pal[i % pal.size()]
		_spawn_custom_effect(side, kind, scale_boost, c)
	queue_redraw()

func _spawn_single_effect(side: int, streak_factor: float, particle_style: String) -> void:
	if active_effects.size() >= MAX_EFFECTS:
		active_effects.pop_front()

	var pal: Array = WORLD_PALETTES.get(world_id, WORLD_PALETTES["nature"])
	var kind: int = _rng.randi_range(0, 5)
	if world_id == "crystal" and _rng.randf() < 0.42:
		kind = EffectKind.CRYSTAL_SHARD
	elif world_id == "cosmic" and _rng.randf() < 0.42:
		kind = EffectKind.STAR_SPARK

	var col: Color = pal[_rng.randi_range(0, pal.size() - 1)]
	if particle_style == "part_cyan" and _rng.randf() < 0.45:
		col = Color("#4df0ff")

	var scale_mult: float = _rng.randf_range(0.88, 1.22) * (1.0 + streak_factor * 0.28)
	_spawn_custom_effect(side, kind, scale_mult, col)

func _spawn_custom_effect(side: int, kind: int, scale_mult: float, col: Color) -> void:
	if active_effects.size() >= MAX_EFFECTS:
		active_effects.pop_front()

	var base_x: float = float(side) * _rng.randf_range(215.0, 295.0)
	var base_y: float = _rng.randf_range(-175.0, 145.0)
	var start_pos := Vector2(base_x, base_y)

	var out_angle: float = _rng.randf_range(-0.65, 0.65)
	if side < 0:
		out_angle = PI + _rng.randf_range(-0.65, 0.65)
	var speed: float = _rng.randf_range(65.0, 155.0) * scale_mult
	var vel := Vector2(cos(out_angle), sin(out_angle)) * speed - Vector2(0, _rng.randf_range(15.0, 45.0))

	var lifetime: float = _rng.randf_range(0.34, 0.58)
	if kind == EffectKind.ENERGY_PULSE:
		vel *= 0.25
		lifetime = _rng.randf_range(0.38, 0.52)

	active_effects.append({
		"kind": kind,
		"pos": start_pos,
		"vel": vel,
		"rot": _rng.randf_range(0.0, TAU),
		"rot_speed": _rng.randf_range(-5.5, 5.5),
		"scale": scale_mult,
		"age": 0.0,
		"lifetime": lifetime,
		"color": col,
		"side": side,
		"seed": _rng.randf_range(0.0, 10.0)
	})

func _process(delta: float) -> void:
	if active_effects.is_empty():
		return
	var i: int = active_effects.size() - 1
	while i >= 0:
		var fx: Dictionary = active_effects[i]
		fx["age"] += delta
		if fx["age"] >= fx["lifetime"]:
			active_effects.remove_at(i)
		else:
			fx["pos"] += fx["vel"] * delta
			fx["vel"] *= (1.0 - 2.4 * delta)
			fx["rot"] += fx["rot_speed"] * delta
		i -= 1
	queue_redraw()

func _draw() -> void:
	if active_effects.is_empty():
		return
	var center := size * 0.5
	for fx in active_effects:
		var t: float = clampf(fx["age"] / fx["lifetime"], 0.0, 1.0)
		var alpha: float = clampf(sin(t * PI) * 1.35, 0.0, 1.0) * (1.0 - t * 0.35)
		var pop: float = sin(minf(1.0, t * 3.2) * PI * 0.5)
		var s: float = fx["scale"] * pop * (1.0 - t * 0.25)
		var p: Vector2 = center + (fx["pos"] as Vector2)
		var col: Color = fx["color"]
		col.a = alpha
		var outline_col := Color(0.06, 0.09, 0.20, alpha * 0.92)

		match fx["kind"]:
			EffectKind.COMIC_BOLT:
				_draw_comic_bolt(p, fx["rot"], 22.0 * s, col, outline_col)
			EffectKind.LIGHT_ORB:
				draw_circle(p, 20.0 * s, Color(col.r, col.g, col.b, alpha * 0.28))
				draw_circle(p, 11.0 * s, col)
				draw_circle(p + Vector2(-2.5 * s, -2.5 * s), 4.5 * s, Color(1, 1, 1, alpha * 0.9))
			EffectKind.STAR_SPARK:
				_draw_star_spark(p, fx["rot"], 18.0 * s, col, outline_col)
			EffectKind.ENERGY_PULSE:
				var r: float = (12.0 + 36.0 * t) * fx["scale"]
				var w: float = maxf(2.0, 6.0 * (1.0 - t))
				draw_arc(p, r, 0.0, TAU, 28, outline_col, w + 3.0, true)
				draw_arc(p, r, 0.0, TAU, 28, col, w, true)
				draw_circle(p, 5.0 * (1.0 - t), Color(1, 1, 1, alpha))
			EffectKind.CRYSTAL_SHARD:
				_draw_crystal_shard(p, fx["rot"], 18.0 * s, col, outline_col)
			EffectKind.GLITTER_BURST:
				_draw_glitter_burst(p, t, 24.0 * fx["scale"], col, alpha, fx["seed"])

func _draw_comic_bolt(p: Vector2, rot: float, sz: float, col: Color, outline_col: Color) -> void:
	var local_pts: Array[Vector2] = [
		Vector2(0.15, -1.0),
		Vector2(-0.55, 0.05),
		Vector2(-0.05, 0.08),
		Vector2(-0.32, 1.0),
		Vector2(0.58, -0.12),
		Vector2(0.08, -0.15)
	]
	var poly := PackedVector2Array()
	for pt in local_pts:
		poly.append(p + (pt * sz).rotated(rot))
	var closed := poly.duplicate()
	closed.append(poly[0])
	draw_polyline(closed, outline_col, 5.0, true)
	draw_colored_polygon(poly, col)
	draw_circle(p, sz * 0.16, Color(1, 1, 1, col.a * 0.85))

func _draw_star_spark(p: Vector2, rot: float, sz: float, col: Color, outline_col: Color) -> void:
	var poly := PackedVector2Array()
	for i in range(8):
		var ang: float = rot + float(i) * (PI * 0.25)
		var r: float = sz if (i % 2 == 0) else (sz * 0.36)
		poly.append(p + Vector2(cos(ang), sin(ang)) * r)
	var closed := poly.duplicate()
	closed.append(poly[0])
	draw_polyline(closed, outline_col, 4.5, true)
	draw_colored_polygon(poly, col)
	draw_circle(p, sz * 0.25, Color(1, 1, 1, col.a * 0.9))

func _draw_crystal_shard(p: Vector2, rot: float, sz: float, col: Color, outline_col: Color) -> void:
	var d1 := Vector2(cos(rot), sin(rot)) * sz
	var d2 := Vector2(-sin(rot), cos(rot)) * (sz * 0.56)
	var poly := PackedVector2Array([p + d1, p + d2, p - d1, p - d2])
	var closed := PackedVector2Array([p + d1, p + d2, p - d1, p - d2, p + d1])
	draw_polyline(closed, outline_col, 4.5, true)
	draw_colored_polygon(poly, col)
	var facet := PackedVector2Array([p + d1, p + d2, p])
	draw_colored_polygon(facet, Color(1, 1, 1, col.a * 0.45))

func _draw_glitter_burst(p: Vector2, t: float, radius: float, col: Color, alpha: float, seed_val: float) -> void:
	for i in range(5):
		var ang: float = seed_val + float(i) * (TAU / 5.0) + t * 1.2
		var dist: float = radius * (0.25 + 0.85 * t)
		var sub_p: Vector2 = p + Vector2(cos(ang), sin(ang)) * dist
		var r: float = maxf(2.0, 5.5 * (1.0 - t * 0.65))
		draw_circle(sub_p, r * 1.7, Color(col.r, col.g, col.b, alpha * 0.30))
		draw_circle(sub_p, r, col.lightened(0.25))
		draw_circle(sub_p, r * 0.45, Color(1, 1, 1, alpha * 0.95))
