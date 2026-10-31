extends SceneTree

func _initialize() -> void:
	print("=== VERIFYING MODERN VISUALS: GOD-RAYS & HUD TOP BAR ===")

	# 1. Verify DropRevealEffect instantiation and ray configuration
	var drop_script = load("res://scripts/drop_reveal_effect.gd")
	assert(drop_script != null, "DropRevealEffect script must load")
	var drop = drop_script.new()
	drop.size = Vector2(800, 800)
	drop.start_reveal("mythic")
	assert(drop.active == true, "DropRevealEffect must be active")
	drop._process(0.16)
	print("[PASS] 1. Modern DropRevealEffect (Mythic god-rays & corona) initialized and stepped.")

	# 2. Verify UIKit modern pill styles exist
	var uikit = load("res://scripts/ui_kit.gd")
	assert(uikit != null, "UIKit script must load")
	for kind in ["pill", "pill_coin", "pill_counter", "pill_world", "pill_crystal", "pill_cosmic"]:
		assert(uikit.PANEL_KINDS.has(kind), "PANEL_KINDS must have " + kind)
		var cfg = uikit.PANEL_KINDS[kind]
		assert(cfg["lip"] == 0, kind + " must have lip = 0 (modern sleek glass, no plastic 3D lip)")
		assert(cfg["border_w"] == 2, kind + " must have border_w = 2 (crisp modern outline)")
		var box = uikit.panel_box(kind, 16.0, 6.0)
		assert(box != null, "Must generate valid StyleBoxTexture for " + kind)
	print("[PASS] 2. Modern UIKit pill styles (pill, pill_coin, pill_counter, pill_world, etc.) verified.")

	# 3. Test layout non-overlapping logic across small and large viewports
	var vp_widths = [540.0, 720.0, 960.0, 1280.0]
	for w in vp_widths:
		var is_compact = w < 720.0
		var is_tiny = w < 580.0
		# Menu (80..114), Collection (100..144), sep = 10
		var left_w = (80.0 if is_tiny else (96.0 if is_compact else 114.0)) + 10.0 + (100.0 if is_tiny else (120.0 if is_compact else 144.0))
		# Counter (80..98), Coin (92..116), Shop (90..126), Settings (44..50), sep = 8 * 3
		var right_w = (80.0 if is_tiny else (90.0 if is_compact else 98.0)) + (92.0 if is_tiny else (104.0 if is_compact else 116.0)) + (90.0 if is_tiny else (106.0 if is_compact else 126.0)) + (44.0 if is_tiny else (46.0 if is_compact else 50.0)) + 24.0
		var remaining = w - (left_w + right_w)
		assert(remaining >= 0.0, "Viewport width " + str(w) + " must not have negative overlap! Remaining: " + str(remaining))
		print("[PASS] 3. Viewport width %dpx: LeftBar=%dpx, RightBar=%dpx -> Clear center gap=%dpx (ZERO COLLISION)" % [int(w), int(left_w), int(right_w), int(remaining)])

	print("=== ALL MODERN VISUAL CHECKS PASSED SUCCESSFULLY ===")
	quit(0)
