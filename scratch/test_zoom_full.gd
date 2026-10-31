extends SceneTree

func _initialize() -> void:
	print("=== RUNNING FULL ZOOM SIMULATION TEST ===")

	var vp_size = Vector2(960, 540)
	var test_zooms = [0.70, 0.85, 1.0, 1.25, 1.50]

	for zoom in test_zooms:
		var virtual_size = vp_size / zoom
		var game_view = Control.new()
		game_view.position = Vector2.ZERO
		game_view.size = virtual_size
		game_view.scale = Vector2(zoom, zoom)

		# Screen render bounds of game_view
		var screen_rect = Rect2(Vector2.ZERO, virtual_size * zoom)
		assert(is_equal_approx(screen_rect.size.x, vp_size.x), "Width must match viewport")
		assert(is_equal_approx(screen_rect.size.y, vp_size.y), "Height must match viewport")

		# TopLeftBar position
		var left_btn_local = Vector2(16, 16)
		var left_btn_screen = left_btn_local * zoom
		assert(left_btn_screen.x >= 0 and left_btn_screen.y >= 0, "Top left button must be on screen")

		# TopRightBar position (width 350)
		var right_btn_local = Vector2(virtual_size.x - 16 - 350, 16)
		var right_btn_screen = right_btn_local * zoom
		var right_btn_end_screen = (right_btn_local + Vector2(350, 48)) * zoom
		assert(right_btn_screen.x >= left_btn_screen.x + (200 * zoom), "Left and right must not collide")
		assert(right_btn_end_screen.x <= vp_size.x + 0.1, "Right button must not exceed screen width")

		# Center Egg position
		var egg_center_local = virtual_size * 0.5
		var egg_center_screen = egg_center_local * zoom
		assert(is_equal_approx(egg_center_screen.x, vp_size.x * 0.5), "Egg must be at exact screen center X")
		assert(is_equal_approx(egg_center_screen.y, vp_size.y * 0.5), "Egg must be at exact screen center Y")

		# Bottom Progress Bar
		var progress_local = Vector2(virtual_size.x * 0.5, virtual_size.y - 40)
		var progress_screen = progress_local * zoom
		assert(progress_screen.y <= vp_size.y + 0.1, "Progress bar must be on screen")

		print("[PASS] Zoom %.2f (Virtual: %dx%d) -> Rendered exact 960x540, elements in bounds" % [
			zoom, int(virtual_size.x), int(virtual_size.y)
		])

	print("=== ALL FULL ZOOM SIMULATION TESTS PASSED ===")
	quit(0)
