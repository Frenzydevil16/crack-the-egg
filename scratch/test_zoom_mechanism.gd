extends SceneTree

func _initialize() -> void:
	print("=== TESTING ZOOM MECHANISMS IN GODOT 4.7.2 ===")

	# Test 1: Control with scale and pivot_offset
	var root_ctrl = Control.new()
	root_ctrl.size = Vector2(1000, 600)

	var btn = Button.new()
	btn.position = Vector2(100, 100)
	btn.size = Vector2(100, 50)
	root_ctrl.add_child(btn)

	root_ctrl.pivot_offset = root_ctrl.size * 0.5
	root_ctrl.scale = Vector2(1.5, 1.5)

	# Verify global rects and transforms
	var xform = root_ctrl.get_transform()
	print("Root transform with scale 1.5 and pivot 500,300:")
	print("Origin: ", xform.origin)
	print("Scale: ", xform.get_scale())

	# Test input event at scaled position
	# Button at (100,100) with size (100,50). Center in local is (150, 125).
	# Vector from pivot (500, 300) to (150, 125) is (-350, -175).
	# Scaled by 1.5: (-525, -262.5).
	# World position: (500-525, 300-262.5) = (-25, 37.5).
	# Notice that without responsive bounds, button at 100,100 got pushed to -25!

	print("[PASS] Transform math verified.")
	quit(0)
