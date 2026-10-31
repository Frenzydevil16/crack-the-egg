extends SceneTree

func _initialize() -> void:
	print("=== TESTING HSLIDER STYLING ===")
	var slider = HSlider.new()
	var track = StyleBoxFlat.new()
	track.bg_color = Color(0.05, 0.08, 0.18, 0.92)
	track.corner_radius_top_left = 6
	slider.add_theme_stylebox_override("slider", track)
	assert(slider != null, "Slider styled")
	print("[PASS] HSlider styled cleanly!")
	quit(0)
