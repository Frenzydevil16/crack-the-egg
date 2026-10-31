extends SceneTree

func _init() -> void:
	print("=== RUNNING IN-ENGINE MEADOW STAGE & WHEEL UI TEST ===")
	var main_scene = load("res://scenes/main.tscn")
	if not main_scene:
		printerr("FAILED to load main scene")
		quit(1)
		return

	var main_node = main_scene.instantiate()
	root.add_child(main_node)

	# 1. Test Wheel HUD with 0 tickets and 1 ticket
	main_node.pet_tokens = 0
	main_node._update_wheel_hud()
	assert(main_node.pet_spin_button != null, "Spin button exists")
	assert(main_node.pet_spin_button.disabled == true, "Disabled at 0 tokens")
	assert(main_node.pet_token_label.text.find("0 Drehs") != -1, "0 Drehs text matches")
	print("[PASS] Wheel HUD at 0 tickets verified.")

	main_node.pet_tokens = 1
	main_node._update_wheel_hud()
	assert(main_node.pet_spin_button.disabled == false, "Enabled at 1 token")
	assert(main_node.pet_token_label.text.find("1 Dreh verfügbar") != -1, "1 Dreh text matches")
	print("[PASS] Wheel HUD at 1 ticket verified.")

	# 2. Test Pet Award & Meadow Reveal Presentation for Mouse and Fox
	var test_pets = ["pet_mouse", "pet_fox", "pet_unicorn"]
	for pid in test_pets:
		var pinfo = PetData.get_pet_by_id(pid)
		var test_result = {
			"segment_index": 2,
			"pet": pinfo
		}
		main_node._award_wheel_prize(test_result)
		assert(main_node.wheel_reveal_overlay.visible == true, "Reveal overlay visible")
		assert(main_node.wheel_reveal_icon.texture != null, "Pet icon has valid texture")
		print("[PASS] Award reveal for %s succeeded with meadow texture %s" % [pid, main_node.wheel_reveal_icon.texture.resource_path])

	print("=== ALL MEADOW STAGE & WHEEL CHECKS PASSED ===")
	quit(0)
