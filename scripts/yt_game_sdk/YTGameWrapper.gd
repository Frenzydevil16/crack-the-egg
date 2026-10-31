# ==================================================
# YouTube Playables integration for Godot 4
# Based on official Google Playables Godot Wrapper
# ==================================================
extends Node

## Bridge to YouTube Playables JS SDK for Godot 4 Web builds.
## Configured as an Autoload singleton (Node Name: YTGameWrapper).

signal audio_enabled_changed(is_enabled: bool)
signal game_paused
signal game_resumed
signal save_data_success
signal save_data_failed(error_message: String)
signal load_data_received(data: String)
signal ad_request_success
signal ad_request_failed(error_message: String)

const YT_GAME_SDK_JS_WINDOW_OBJECT = "window.YTGameSDK_Godot"

# Retain references to callbacks to prevent garbage collection in Godot 4
var _js_callbacks: Dictionary = {}

func _ready() -> void:
	if OS.has_feature("web"):
		_setup_web_callbacks()

func _setup_web_callbacks() -> void:
	# Ensure the global GodotYTCallbacks object exists in JS
	JavaScriptBridge.eval("""
		window.GodotYTCallbacks = window.GodotYTCallbacks || {};
	""")
	
	var godot_callbacks = JavaScriptBridge.get_interface("GodotYTCallbacks")
	if godot_callbacks != null:
		# Create persistent callbacks using JavaScriptBridge.create_callback
		_js_callbacks["onAudioEnabledChanged"] = JavaScriptBridge.create_callback(_on_js_audio_enabled_changed)
		_js_callbacks["onGamePaused"] = JavaScriptBridge.create_callback(_on_js_game_paused)
		_js_callbacks["onGameResumed"] = JavaScriptBridge.create_callback(_on_js_game_resumed)
		_js_callbacks["onLoadDataReceived"] = JavaScriptBridge.create_callback(_on_js_load_data_received)
		_js_callbacks["onSaveSuccess"] = JavaScriptBridge.create_callback(_on_js_save_success)
		_js_callbacks["onSaveFailed"] = JavaScriptBridge.create_callback(_on_js_save_failed)
		_js_callbacks["onAdSuccess"] = JavaScriptBridge.create_callback(_on_js_ad_success)
		_js_callbacks["onAdFailed"] = JavaScriptBridge.create_callback(_on_js_ad_failed)
		
		# Assign callbacks to the JS object
		for key in _js_callbacks:
			godot_callbacks[key] = _js_callbacks[key]
		
		# Tell the JS library to hook up to YouTube Playables SDK
		var js_code = "%s.setAllCallbacks();" % YT_GAME_SDK_JS_WINDOW_OBJECT
		JavaScriptBridge.eval(js_code)
		print("[YTGameWrapper] Web callbacks registered.")
	else:
		push_warning("[YTGameWrapper] Unable to access window.GodotYTCallbacks interface.")

# --- Public API ---

## Returns YouTube Playables SDK version string
func get_sdk_version() -> String:
	if OS.has_feature("web"):
		var res = JavaScriptBridge.eval("%s.getSDKVersion();" % YT_GAME_SDK_JS_WINDOW_OBJECT)
		return str(res) if res != null else "N/A"
	return "N/A"

## Sends player's score to YouTube (MUST be an integer)
func send_score(score: int) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("%s.sendScore(%d);" % [YT_GAME_SDK_JS_WINDOW_OBJECT, int(score)])

## Notifies YouTube that the game's first frame is ready to be shown
func first_frame_ready() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("%s.firstFrameReady();" % YT_GAME_SDK_JS_WINDOW_OBJECT)
		print("[YTGameWrapper] firstFrameReady() invoked.")

## Notifies YouTube that the game is ready for user interaction
func game_ready() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("%s.gameReady();" % YT_GAME_SDK_JS_WINDOW_OBJECT)
		print("[YTGameWrapper] gameReady() invoked.")

## Saves game data string to the YouTube cloud. Emits save_data_success or save_data_failed
func save_data(data: String) -> void:
	if OS.has_feature("web"):
		var sdk = JavaScriptBridge.get_interface("YTGameSDK_Godot")
		if sdk != null:
			sdk.saveData(data)
		else:
			# Fallback via eval if interface handle not available
			var json_escaped = JSON.stringify(data)
			JavaScriptBridge.eval("%s.saveData(%s);" % [YT_GAME_SDK_JS_WINDOW_OBJECT, json_escaped])

## Requests to load game data from YouTube cloud. Emits load_data_received
func load_data() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("%s.loadData();" % YT_GAME_SDK_JS_WINDOW_OBJECT)

## Logs an error to YouTube developer health dashboard
func log_error(message: String) -> void:
	if OS.has_feature("web"):
		var sdk = JavaScriptBridge.get_interface("YTGameSDK_Godot")
		if sdk != null:
			sdk.logError(message)
		else:
			JavaScriptBridge.eval("%s.logError(%s);" % [YT_GAME_SDK_JS_WINDOW_OBJECT, JSON.stringify(message)])
	else:
		push_error("[YTGameWrapper] " + message)

## Logs a warning to YouTube developer health dashboard
func log_warning(message: String) -> void:
	if OS.has_feature("web"):
		var sdk = JavaScriptBridge.get_interface("YTGameSDK_Godot")
		if sdk != null:
			sdk.logWarning(message)
		else:
			JavaScriptBridge.eval("%s.logWarning(%s);" % [YT_GAME_SDK_JS_WINDOW_OBJECT, JSON.stringify(message)])
	else:
		push_warning("[YTGameWrapper] " + message)

## Returns whether game audio is enabled in YouTube settings
func is_audio_enabled() -> bool:
	if OS.has_feature("web"):
		var res = JavaScriptBridge.eval("%s.isAudioEnabled();" % YT_GAME_SDK_JS_WINDOW_OBJECT)
		if res != null:
			return bool(res)
	return true

## Returns whether currently running in a YouTube Playables environment
func in_playables_env() -> bool:
	if OS.has_feature("web"):
		var res = JavaScriptBridge.eval("%s.inPlayablesEnv();" % YT_GAME_SDK_JS_WINDOW_OBJECT)
		if res != null:
			return bool(res)
	return false

## Requests an Interstitial Ad
func request_interstitial_ad() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("%s.requestInterstitialAd();" % YT_GAME_SDK_JS_WINDOW_OBJECT)

# --- Internal JS Callbacks (receive Array of arguments) ---

func _on_js_audio_enabled_changed(args: Array) -> void:
	var is_enabled: bool = true
	if args.size() > 0 and args[0] != null:
		is_enabled = bool(args[0])
	audio_enabled_changed.emit(is_enabled)

func _on_js_game_paused(_args: Array) -> void:
	game_paused.emit()

func _on_js_game_resumed(_args: Array) -> void:
	game_resumed.emit()

func _on_js_load_data_received(args: Array) -> void:
	var data: String = ""
	if args.size() > 0 and args[0] != null:
		data = str(args[0])
	load_data_received.emit(data)

func _on_js_save_success(_args: Array) -> void:
	save_data_success.emit()

func _on_js_save_failed(args: Array) -> void:
	var err: String = "Save failed"
	if args.size() > 0 and args[0] != null:
		err = str(args[0])
	save_data_failed.emit(err)

func _on_js_ad_success(_args: Array) -> void:
	ad_request_success.emit()

func _on_js_ad_failed(args: Array) -> void:
	var err: String = "Ad request failed"
	if args.size() > 0 and args[0] != null:
		err = str(args[0])
	ad_request_failed.emit(err)
