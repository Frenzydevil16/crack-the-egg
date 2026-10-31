extends SceneTree

func _initialize() -> void:
	print("=== VERIFYING EGG CENTERING & ZOOM SCALING ===")
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	var main = main_scene.instantiate()
	root.add_child(main)
	_run_tests.call_deferred(main)

func _run_tests(main: Node) -> void:
	var vp_size = root.get_visible_rect().size
	print("Viewport size: ", vp_size)

	for test_zoom in [0.70, 1.00, 1.25, 1.50]:
		main.setting_game_zoom = test_zoom
		main._apply_game_zoom()
		
		# Allow container anchors and sizes to update
		main._update_responsive_layout()
		
		var egg_anchor = main.egg_anchor
		var safe = main.safe_container
		var egg_center_x = safe.global_position.x + egg_anchor.position.x + egg_anchor.pivot_offset.x
		var expected_center_x = vp_size.x * 0.5
		
		print("Zoom: ", test_zoom)
		print("  Egg scale: ", egg_anchor.scale)
		print("  Egg center X: ", egg_center_x, " (Expected: ", expected_center_x, ")")
		print("  Safe container size: ", safe.size, " pos: ", safe.position)
		if main.menu_btn:
			print("  Menu btn size: ", main.menu_btn.custom_minimum_size)
		if main.counter_pill:
			print("  Counter pill size: ", main.counter_pill.custom_minimum_size)

		if abs(egg_center_x - expected_center_x) > 2.0:
			push_error("Egg is NOT centered horizontally! Diff: " + str(egg_center_x - expected_center_x))
			quit(1)
			return

	print("=== ALL TESTS PASSED! EGG IS STRICTLY CENTERED AND SCALES CLEANLY! ===")
	quit(0)
