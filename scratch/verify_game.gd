extends SceneTree

func _initialize() -> void:
	print("=== CRACK THE EGG: MULTI-WORLD & 18-SLIME VERIFICATION ===")
	var all_ok: bool = true

	# 1. Verify all 3 Egg Worlds & background/egg textures exist
	for egg_id in EggWorldData.EGG_IDS:
		var w: Dictionary = EggWorldData.EGG_WORLDS[egg_id]
		if not ResourceLoader.exists(w["egg_texture"]):
			push_error("Missing egg texture: " + str(w["egg_texture"]))
			all_ok = false
		if not ResourceLoader.exists(w["bg_texture"]):
			push_error("Missing bg texture: " + str(w["bg_texture"]))
			all_ok = false
	print("[PASS] 1. All 3 Egg Worlds & textures verified.")

	# 2. Verify Random Click Target table (1,000 to 10,000, sum = 100%)
	var target_weight_sum: float = 0.0
	var valid_targets: Array[int] = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
	for entry in EggWorldData.CLICK_TARGET_TABLE:
		target_weight_sum += float(entry["weight"])
		if not (int(entry["target"]) in valid_targets):
			push_error("Invalid click target in table: " + str(entry["target"]))
			all_ok = false
	if not is_equal_approx(target_weight_sum, 100.0):
		push_error("Click target weights do not sum to 100%: " + str(target_weight_sum))
		all_ok = false
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	for i in range(200):
		var rolled = EggWorldData.roll_click_target(rng)
		if not (rolled in valid_targets):
			push_error("Rolled invalid target: " + str(rolled))
			all_ok = false
	print("[PASS] 2. Click Target Table sums to 100.0% and rolls valid targets (1,000..10,000).")

	# 3. Verify 18 Slimes (6 per egg, 1 per rarity per egg) & textures
	if EggWorldData.SLIME_CATALOG.size() != 18:
		push_error("Expected 18 slimes, got " + str(EggWorldData.SLIME_CATALOG.size()))
		all_ok = false
	for egg_id in EggWorldData.EGG_IDS:
		for rarity in EggWorldData.RARITY_ORDER:
			var s = EggWorldData.get_slime_by_egg_and_rarity(egg_id, rarity)
			if s.is_empty() or s["egg_id"] != egg_id or s["rarity"] != rarity:
				push_error("Missing slime for " + egg_id + " / " + rarity)
				all_ok = false
			if not ResourceLoader.exists(s["path"]):
				push_error("Missing slime texture: " + str(s["path"]))
				all_ok = false
	print("[PASS] 3. All 18 unique slimes (6 per egg) and textures verified.")

	# 4. Instantiate Main Scene & test gameplay mechanics
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	var main = main_scene.instantiate()
	root.add_child(main)

	# Verify Luck Tables sum to 100%
	for tier_key in main.LUCK_TABLES:
		var ch: Dictionary = main.LUCK_TABLES[tier_key]["chances"]
		var sum_p: float = 0.0
		for r_key in ch:
			sum_p += float(ch[r_key])
		if not is_equal_approx(sum_p, 100.0):
			push_error("Luck tier " + tier_key + " sum != 100%: " + str(sum_p))
			all_ok = false
	print("[PASS] 4. All Luck Drop Tables sum to exact 100.0%.")

	# Reset state cleanly for deterministic progression test
	main._init_egg_states()
	main.egg_states["nature"]["unlocked"] = true
	main.egg_states["crystal"]["unlocked"] = false
	main.egg_states["cosmic"]["unlocked"] = false
	main.active_egg_id = "nature"
	main.egg_states["nature"]["target_clicks"] = 2000
	main.egg_states["nature"]["current_clicks"] = 1998
	main._sync_active_egg_from_dict()

	# Test clamping with 5x click power at 1998 / 2000
	main.owned_click_upgrades.append("click_5x")
	main.active_click_upgrade = "click_5x"
	main._apply_effective_clicks(main.get_effective_click_power(), Vector2(360, 640), true)
	if main.current_clicks != 2000:
		push_error("Click clamping failed! Expected 2000, got " + str(main.current_clicks))
		all_ok = false
	if not main.is_hatched:
		push_error("Egg should be hatched at target_clicks!")
		all_ok = false
	if not bool(main.egg_states["crystal"]["unlocked"]):
		push_error("Crystal Egg should unlock after 1st Nature Egg hatch!")
		all_ok = false
	if main.active_egg_id != "nature":
		push_error("Unlocking Crystal Egg must NOT auto-switch active_egg_id!")
		all_ok = false
	print("[PASS] 5. Click clamping at target_clicks (2000) & Crystal Egg unlock (no auto-switch) verified.")

	# Verify drop isolation per egg
	for eid in ["nature", "crystal", "cosmic"]:
		for i in range(30):
			var drop = main._roll_slime_rarity(eid)
			if drop["egg_id"] != eid:
				push_error("Drop isolation violated! Egg " + eid + " dropped " + str(drop["id"]))
				all_ok = false
	print("[PASS] 6. Per-egg drop isolation verified (90 rolls across 3 eggs).")

	# Verify round reset & switching eggs preserves state
	main.active_egg_id = "nature"
	main._on_confirm_drop_pressed()
	if main.current_clicks != 0 or not EggWorldData.is_valid_click_target(main.target_clicks):
		push_error("Round reset failed after drop confirmation!")
		all_ok = false
	var nat_target = main.target_clicks
	main.current_clicks = 345
	main.select_egg("crystal", false)
	if main.active_egg_id != "crystal":
		push_error("Failed to switch to unlocked Crystal Egg!")
		all_ok = false
	main.select_egg("nature", false)
	if main.current_clicks != 345 or main.target_clicks != nat_target:
		push_error("Egg state not preserved across switches!")
		all_ok = false
	print("[PASS] 7. Egg switching & per-egg state persistence verified.")

	# 8. Verify 1:1 Pet Wheel Assets, 11 Segments, 100.0% Probabilities, and Ticket Mechanics
	if not ResourceLoader.exists("res://assets/wheel/wheel_disc.png") or not ResourceLoader.exists("res://assets/wheel/wheel_frame_ui.png"):
		push_error("Missing 1:1 wheel textures!")
		all_ok = false
	if PetData.PET_CATALOG.size() != 11 or PetData.WHEEL_SEGMENTS.size() != 11:
		push_error("Expected 11 pets and 11 segments on the wheel!")
		all_ok = false
	var r_weight_sum: float = 0.0
	for rw in PetData.RARITY_WEIGHTS:
		r_weight_sum += float(rw["weight"])
	if not is_equal_approx(r_weight_sum, 100.0):
		push_error("Pet Wheel rarity weights do not sum to 100.0%: " + str(r_weight_sum))
		all_ok = false
	for i in range(11):
		var p = PetData.PET_CATALOG[i]
		if int(p["segment_index"]) != i:
			push_error("Segment index mismatch at " + str(i))
			all_ok = false
		if not ResourceLoader.exists(p["path"]):
			push_error("Missing pet texture: " + str(p["path"]))
			all_ok = false
		var roll_res = PetData.spin_wheel(rng)
		var r_seg: int = int(roll_res["segment_index"])
		if r_seg < 0 or r_seg >= 11 or roll_res["pet"]["id"] != PetData.WHEEL_SEGMENTS[r_seg]["pet_id"]:
			push_error("Wheel spin result does not match segment pet_id!")
			all_ok = false
	print("[PASS] 8. 1:1 Pet Wheel (11 segments, 100.0% rarity weights, matching segment -> pet mapping) verified.")

	if all_ok:
		print("=== ALL MULTI-WORLD VERIFICATION CHECKS PASSED SUCCESSFULLY ===")
		quit(0)
	else:
		print("=== VERIFICATION FAILED ===")
		quit(1)
