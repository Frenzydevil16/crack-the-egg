extends SceneTree

func _initialize() -> void:
	print("=== TESTING INPUT DISPATCH ON SCALED ROOT CONTROL ===")

	var root_ctrl = Control.new()
	root_ctrl.name = "RootGameView"
	var vp_size = Vector2(1000, 600)
	var zoom = 1.4

	root_ctrl.position = Vector2.ZERO
	root_ctrl.size = vp_size / zoom
	root_ctrl.scale = Vector2(zoom, zoom)
	root_ctrl.pivot_offset = Vector2.ZERO
	root.add_child(root_ctrl)

	var btn = Button.new()
	btn.name = "TestButton"
	btn.position = Vector2(200, 100)
	btn.size = Vector2(120, 50)
	var clicked = false
	btn.pressed.connect(func():
		clicked = true
		print("[EVENT] Button pressed successfully!")
	)
	root_ctrl.add_child(btn)

	var screen_pos = Vector2(364, 175)

	# Verify global rect
	var g_rect = btn.get_global_rect()
	print("Button local rect: ", btn.get_rect())
	print("Button global rect: ", g_rect)
	print("Screen pos inside global rect? ", g_rect.has_point(screen_pos))
	assert(g_rect.has_point(screen_pos), "Button global rect must contain scaled screen point!")
	print("[PASS] Global rect transformation verified!")
	quit(0)
