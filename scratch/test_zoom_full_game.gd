extends SceneTree

func _initialize() -> void:
	_run_tests()

func _run_tests() -> void:
	print("=== RUNNING IN-ENGINE FULL ZOOM & SETTINGS TEST ===")

	var main_scene: PackedScene = load("res://scenes/main.tscn")
	assert(main_scene != null, "Main scene must load")

	var main = main_scene.instantiate()
	root.add_child(main)

	# Allow one frame for _ready() to complete
	await process_frame

	# 1. Verify GameView creation & hierarchy
	assert(main.game_view != null, "GameView must be instantiated")
	assert(main.background_rect.get_parent() == main.game_view, "Background must be in GameView")
	assert(main.world_backdrop.get_parent() == main.game_view, "WorldBackdrop must be in GameView")
	assert(main.safe_container.get_parent() == main.game_view, "SafeContainer must be in GameView")
	assert(main.pet_companion.get_parent() == main.game_view, "PetCompanion must be in GameView")
	print("[PASS] 1. Central GameView architecture verified.")

	# 2. Verify Settings Modal UI
	main._populate_settings_modal()
	var vbox = main.settings_options_vbox
	assert(vbox.get_child_count() > 0, "Settings options must be populated")
	var zoom_card = vbox.get_child(0)
	assert(zoom_card != null, "First settings card must be Spiel-Zoom")

	# Find slider, reset button, and pct label by name
	var slider: HSlider = zoom_card.find_child("ZoomSlider", true, false)
	var reset_btn: Button = zoom_card.find_child("ZoomResetBtn", true, false)
	var pct_lbl: Label = zoom_card.find_child("ZoomPctLabel", true, false)

	assert(slider != null, "Zoom HSlider must exist")
	assert(reset_btn != null, "Reset button must exist")
	assert(pct_lbl != null, "Percentage label must exist")

	assert(is_equal_approx(slider.min_value, 0.70), "Min zoom must be 0.70 (70%)")
	assert(is_equal_approx(slider.max_value, 1.50), "Max zoom must be 1.50 (150%)")
	assert(is_equal_approx(slider.step, 0.01), "Step must be 0.01 (stepless)")
	assert(is_equal_approx(slider.value, 1.0), "Default zoom must be 1.0 (100%)")
	assert(pct_lbl.text == "100 %", "Default label must be 100 %")
	print("[PASS] 2. Settings Modal UI (Slider, Percent Label, Reset Button) verified.")

	# 3. Test Zoom 150%
	slider.value = 1.50
	assert(is_equal_approx(main.setting_game_zoom, 1.50), "Setting zoom must update to 1.50")
	assert(pct_lbl.text == "150 %", "Label must display 150 %")
	assert(is_equal_approx(main.game_view.scale.x, 1.50), "GameView scale X must be 1.50")
	assert(is_equal_approx(main.game_view.scale.y, 1.50), "GameView scale Y must be 1.50")
	print("[PASS] 3. Zoom 150% successfully applied.")

	# 4. Test Click Mechanics under Zoom 1.50
	var prev_clicks = main.current_clicks
	main._apply_effective_clicks(1, Vector2(100, 100), true)
	assert(main.current_clicks == prev_clicks + 1, "Clicks must increment properly under 150% zoom")
	print("[PASS] 4. Click mechanics function seamlessly under 150% zoom.")

	# 5. Test Zoom 70%
	slider.value = 0.70
	assert(is_equal_approx(main.setting_game_zoom, 0.70), "Setting zoom must update to 0.70")
	assert(pct_lbl.text == "70 %", "Label must display 70 %")
	assert(is_equal_approx(main.game_view.scale.x, 0.70), "GameView scale X must be 0.70")
	assert(is_equal_approx(main.game_view.scale.y, 0.70), "GameView scale Y must be 0.70")
	print("[PASS] 5. Zoom 70% successfully applied.")

	# 6. Test Reset Button
	reset_btn.emit_signal("pressed")
	assert(is_equal_approx(main.setting_game_zoom, 1.0), "Reset button must restore zoom to 1.0")
	assert(is_equal_approx(slider.value, 1.0), "Slider value must reset to 1.0")
	assert(pct_lbl.text == "100 %", "Label must display 100 %")
	assert(is_equal_approx(main.game_view.scale.x, 1.0), "GameView scale must reset to 1.0")
	print("[PASS] 6. Reset button restored zoom to 100% cleanly.")

	# 7. Test Save & Load Persistence
	slider.value = 1.25
	var save_json = main._serialize_save()
	var parsed = JSON.parse_string(save_json)
	assert(parsed.has("game_zoom"), "Save JSON must persist game_zoom")
	assert(is_equal_approx(float(parsed["game_zoom"]), 1.25), "game_zoom in save must be 1.25")

	# Restore into fresh state
	main.setting_game_zoom = 1.0
	main._apply_loaded_json(save_json)
	assert(is_equal_approx(main.setting_game_zoom, 1.25), "Loaded zoom must be restored to 1.25")
	assert(is_equal_approx(main.game_view.scale.x, 1.25), "GameView scale must match restored zoom")
	print("[PASS] 7. Save and load persistence verified.")

	print("=== ALL FULL ZOOM & SETTINGS CHECKS PASSED SUCCESSFULLY ===")
	quit(0)
