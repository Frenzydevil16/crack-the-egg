extends Control
class_name DropRevealEffect

## Renders rarity-specific rotating light rays, expanding shockwaves,
## and animated rarity particles (Leaves, Crystals, Magic Sparks, Golden Rays, Cosmic Orbits)
## for the Epic Drop Reveal Menu.

var active: bool = false
var rarity_id: String = "common"
var extra_aura: bool = false
var time_elapsed: float = 0.0
var particles: Array[Dictionary] = []
var _rng = RandomNumberGenerator.new()

const RARITY_CFG = {
	"common": {
		"ray_count": 8,
		"ray_color": Color(0.85, 0.92, 1.0, 0.28),
		"core_color": Color(0.90, 0.95, 1.0, 0.35),
		"particle_color": Color(0.92, 0.95, 1.0, 0.85),
		"particle_count": 14,
		"speed": 0.45
	},
	"uncommon": {
		"ray_count": 10,
		"ray_color": Color(0.25, 0.95, 0.45, 0.32),
		"core_color": Color(0.40, 1.0, 0.55, 0.42),
		"particle_color": Color(0.40, 1.0, 0.45, 0.90),
		"particle_count": 22,
		"speed": 0.65
	},
	"rare": {
		"ray_count": 12,
		"ray_color": Color(0.20, 0.75, 1.0, 0.38),
		"core_color": Color(0.35, 0.90, 1.0, 0.48),
		"particle_color": Color(0.40, 0.92, 1.0, 0.95),
		"particle_count": 30,
		"speed": 0.85
	},
	"epic": {
		"ray_count": 14,
		"ray_color": Color(0.80, 0.30, 1.0, 0.42),
		"core_color": Color(0.90, 0.45, 1.0, 0.55),
		"particle_color": Color(0.94, 0.58, 1.0, 0.98),
		"particle_count": 38,
		"speed": 1.1
	},
	"legendary": {
		"ray_count": 16,
		"ray_color": Color(1.0, 0.84, 0.20, 0.48),
		"core_color": Color(1.0, 0.95, 0.50, 0.65),
		"particle_color": Color(1.0, 0.94, 0.40, 1.0),
		"particle_count": 50,
		"speed": 1.35
	},
	"mythic": {
		"ray_count": 20,
		"ray_color": Color(0.88, 0.20, 0.98, 0.52),
		"core_color": Color(0.25, 0.96, 1.0, 0.68),
		"particle_color": Color(0.35, 0.98, 1.0, 1.0),
		"particle_count": 64,
		"speed": 1.6
	}
}

func _ready() -> void:
	_rng.randomize()
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func start_reveal(p_rarity_id: String, p_extra_aura: bool = false) -> void:
	rarity_id = p_rarity_id if RARITY_CFG.has(p_rarity_id) else "common"
	extra_aura = p_extra_aura
	time_elapsed = 0.0
	active = true
	_spawn_particles()
	queue_redraw()

func stop_reveal() -> void:
	active = false
	particles.clear()
	queue_redraw()

func _spawn_particles() -> void:
	particles.clear()
	var cfg = RARITY_CFG[rarity_id]
	var count: int = cfg["particle_count"] + (16 if extra_aura else 0)
	for i in range(count):
		particles.append({
			"angle": _rng.randf_range(0.0, TAU),
			"dist": _rng.randf_range(20.0, 240.0),
			"speed": _rng.randf_range(35.0, 110.0) * cfg["speed"],
			"size": _rng.randf_range(5.0, 13.0),
			"phase": _rng.randf_range(0.0, TAU),
			"alt_color": (i % 2 == 0)
		})

func _process(delta: float) -> void:
	if not active:
		return
	time_elapsed += delta
	for p in particles:
		p["dist"] += p["speed"] * delta
		p["angle"] += 0.35 * delta
		if p["dist"] > 340.0:
			p["dist"] = _rng.randf_range(15.0, 50.0)
	queue_redraw()

func _draw() -> void:
	if not active:
		return
	var center = size * 0.5
	var cfg = RARITY_CFG[rarity_id]
	var ray_count: int = cfg["ray_count"]
	var ray_col: Color = cfg["ray_color"]
	var core_col: Color = cfg["core_color"]
	var rot_speed: float = cfg["speed"] * 0.45

	# 1. Multi-Stage Blooming Ambient Corona (Exponential radial glow)
	var corona_pulse = 1.0 + 0.08 * sin(time_elapsed * 3.2)
	draw_circle(center, 240.0 * corona_pulse, Color(core_col.r, core_col.g, core_col.b, 0.06))
	draw_circle(center, 180.0 * corona_pulse, Color(core_col.r, core_col.g, core_col.b, 0.12))
	draw_circle(center, 125.0 * corona_pulse, Color(core_col.r, core_col.g, core_col.b, 0.22))
	draw_circle(center, 75.0 * corona_pulse, Color(minf(1.0, core_col.r + 0.25), minf(1.0, core_col.g + 0.25), minf(1.0, core_col.b + 0.25), 0.38))

	# 2. Modern Volumetric God-Rays (Dual Counter-Rotating Layers + Smooth Alpha Gradient)
	var max_radius: float = min(size.x, size.y) * 0.52

	# --- Layer A: Ambient Counter-Rotating Background Rays ---
	var bg_count: int = int(ray_count * 0.75) + 3
	var bg_rot: float = -rot_speed * 0.40
	for i in range(bg_count):
		var base_angle: float = (float(i) / float(bg_count)) * TAU + time_elapsed * bg_rot
		var half_spread: float = (TAU / float(bg_count)) * 0.32
		var r_dist: float = max_radius * 1.08
		var p1: Vector2 = center
		var p2: Vector2 = center + Vector2(cos(base_angle - half_spread), sin(base_angle - half_spread)) * r_dist
		var p3: Vector2 = center + Vector2(cos(base_angle + half_spread), sin(base_angle + half_spread)) * r_dist
		var col_bg: Color = ray_col
		if rarity_id == "mythic":
			col_bg = Color(0.72, 0.22, 0.95, 0.25) if (i % 2 == 0) else Color(0.12, 0.78, 0.95, 0.22)
		else:
			col_bg.a = ray_col.a * 0.55
		var c_center := Color(col_bg.r, col_bg.g, col_bg.b, col_bg.a)
		var c_tip := Color(col_bg.r, col_bg.g, col_bg.b, 0.0)
		draw_polygon(PackedVector2Array([p1, p2, p3]), PackedColorArray([c_center, c_tip, c_tip]))

	# --- Layer B: Primary Radiant Luminous Light Shafts (Clockwise) ---
	for i in range(ray_count):
		var base_angle: float = (float(i) / float(ray_count)) * TAU + time_elapsed * rot_speed
		var half_spread: float = (TAU / float(ray_count)) * 0.24
		var pulse_len: float = max_radius * (0.94 + 0.08 * sin(time_elapsed * 2.8 + float(i) * 1.3))
		var p1: Vector2 = center
		var p2: Vector2 = center + Vector2(cos(base_angle - half_spread), sin(base_angle - half_spread)) * pulse_len
		var p3: Vector2 = center + Vector2(cos(base_angle + half_spread), sin(base_angle + half_spread)) * pulse_len

		var col: Color = ray_col
		if rarity_id == "mythic":
			# Alternating celestial cyan and cosmic amethyst
			col = Color(0.18, 0.92, 1.0, 0.48) if (i % 2 == 0) else Color(0.88, 0.22, 0.96, 0.52)

		# Outer soft fan with gradient falloff (seamlessly disappears at tips)
		var c_inner := Color(col.r, col.g, col.b, col.a)
		var c_tip := Color(col.r, col.g, col.b, 0.0)
		draw_polygon(PackedVector2Array([p1, p2, p3]), PackedColorArray([c_inner, c_tip, c_tip]))

		# Inner brilliant high-energy core shaft (narrow beam with radiant highlight)
		var core_spread: float = half_spread * 0.44
		var p2_c: Vector2 = center + Vector2(cos(base_angle - core_spread), sin(base_angle - core_spread)) * (pulse_len * 0.90)
		var p3_c: Vector2 = center + Vector2(cos(base_angle + core_spread), sin(base_angle + core_spread)) * (pulse_len * 0.90)
		var c_core := Color(minf(1.0, col.r * 1.35 + 0.18), minf(1.0, col.g * 1.35 + 0.18), minf(1.0, col.b * 1.35 + 0.18), minf(1.0, col.a * 1.25))
		draw_polygon(PackedVector2Array([p1, p2_c, p3_c]), PackedColorArray([c_core, c_tip, c_tip]))

	# 3. Mythic / Legendary Orbital Rings & Smooth Shockwaves
	if rarity_id == "mythic" or rarity_id == "legendary" or extra_aura:
		var ring_r: float = fmod(time_elapsed * 170.0, 300.0)
		var ring_alpha: float = clampf(1.0 - (ring_r / 300.0), 0.0, 1.0) * 0.80
		draw_arc(center, ring_r, 0.0, TAU, 64, Color(core_col.r, core_col.g, core_col.b, ring_alpha), 3.5, true)
		if rarity_id == "mythic":
			var ring2_r: float = 160.0 + 12.0 * sin(time_elapsed * 2.8)
			draw_arc(center, ring2_r, 0.0, TAU, 64, Color(0.25, 0.95, 1.0, 0.45), 2.5, true)

	# 4. Core Starlight Glint Behind Center
	var glint_pulse: float = 0.85 + 0.15 * sin(time_elapsed * 6.0)
	var g_sz: float = 24.0 * glint_pulse
	var glint1 = PackedVector2Array([
		center + Vector2(0, -g_sz * 1.6),
		center + Vector2(g_sz * 0.35, 0),
		center + Vector2(0, g_sz * 1.6),
		center + Vector2(-g_sz * 0.35, 0)
	])
	var glint2 = PackedVector2Array([
		center + Vector2(-g_sz * 1.6, 0),
		center + Vector2(0, g_sz * 0.35),
		center + Vector2(g_sz * 1.6, 0),
		center + Vector2(0, -g_sz * 0.35)
	])
	draw_colored_polygon(glint1, Color(1, 1, 1, 0.65))
	draw_colored_polygon(glint2, Color(1, 1, 1, 0.65))

	# 5. Rarity-Specific Particles
	var p_col: Color = cfg["particle_color"]
	for p in particles:
		var pos = center + Vector2(cos(p["angle"]), sin(p["angle"])) * p["dist"]
		var sz: float = p["size"] * (0.75 + 0.25 * sin(time_elapsed * 5.0 + p["phase"]))
		var col = p_col
		if rarity_id == "mythic" and p["alt_color"]:
			col = Color(0.88, 0.30, 1.0, 0.95)
		elif extra_aura and p["alt_color"]:
			col = Color(1.0, 0.92, 0.35, 0.95)

		match rarity_id:
			"uncommon":
				# Leaf / Nature diamond shape
				var dir = Vector2(cos(p["angle"] + time_elapsed), sin(p["angle"] + time_elapsed))
				var perp = Vector2(-dir.y, dir.x) * (sz * 0.55)
				var leaf = PackedVector2Array([
					pos + dir * sz,
					pos + perp,
					pos - dir * sz,
					pos - perp
				])
				draw_colored_polygon(leaf, col)
			"rare", "mythic":
				# Glowing Crystal Shard
				var dir = Vector2(cos(p["angle"]), sin(p["angle"]))
				var perp = Vector2(-dir.y, dir.x) * (sz * 0.5)
				var crystal = PackedVector2Array([
					pos + dir * (sz * 1.4),
					pos + perp,
					pos - dir * (sz * 1.4),
					pos - perp
				])
				draw_colored_polygon(crystal, col)
			"epic", "legendary":
				# 4-Point Star Sparkle
				var s1 = PackedVector2Array([
					pos + Vector2(0, -sz * 1.4),
					pos + Vector2(sz * 0.38, 0),
					pos + Vector2(0, sz * 1.4),
					pos + Vector2(-sz * 0.38, 0)
				])
				var s2 = PackedVector2Array([
					pos + Vector2(-sz * 1.4, 0),
					pos + Vector2(0, sz * 0.38),
					pos + Vector2(sz * 1.4, 0),
					pos + Vector2(0, -sz * 0.38)
				])
				draw_colored_polygon(s1, col)
				draw_colored_polygon(s2, col)
			_:
				# Soft glowing orb
				draw_circle(pos, sz * 0.65, col)
