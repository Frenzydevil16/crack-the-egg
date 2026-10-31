extends Control

## Crack the Egg – 10,000 Clicks (Complete Visual Overhaul, Main Menu, AI Slimes, Shop & Drop System)
## Fully YouTube Playables compliant (SDK lifecycle, Cloud + Local Save, Audio Mute, Pause, Responsive).

const MAX_CLICKS: int = 10000
const SAVE_PATH: String = "user://egg_save.json"

# --- HUD & World Nodes ---
@onready var background_rect: TextureRect = $Background
@onready var world_backdrop: WorldBackdrop = $WorldBackdrop
@onready var atmosphere_overlay: ColorRect = $AtmosphereOverlay
@onready var safe_container: Control = $SafeContainer
@onready var header_container: VBoxContainer = $SafeContainer/HeaderContainer
@onready var title_line1: Label = $SafeContainer/HeaderContainer/TitleLine1
@onready var title_line2: RichTextLabel = $SafeContainer/HeaderContainer/TitleLine2

# Top-Left & Top-Right Bars
@onready var top_left_bar: HBoxContainer = $SafeContainer/TopLeftBar
@onready var menu_btn: Button = $SafeContainer/TopLeftBar/MenuButton
@onready var collection_btn: Button = $SafeContainer/TopLeftBar/CollectionButton
@onready var collection_new_badge: PanelContainer = $SafeContainer/TopLeftBar/CollectionButton/NewBadge
@onready var power_pill: PanelContainer = $SafeContainer/TopLeftBar/PowerPill
@onready var power_badge_label: Label = $SafeContainer/TopLeftBar/PowerPill/PowerLabel
@onready var booster_status_bar: HBoxContainer = $SafeContainer/TopLeftBar/BoosterStatusBar

@onready var top_right_bar: HBoxContainer = $SafeContainer/TopRightBar
@onready var counter_pill: PanelContainer = $SafeContainer/TopRightBar/CounterPill
@onready var counter_label: Label = $SafeContainer/TopRightBar/CounterPill/HBox/CounterLabel
@onready var coin_pill: PanelContainer = $SafeContainer/TopRightBar/CoinPill
@onready var coin_label: Label = $SafeContainer/TopRightBar/CoinPill/HBox/CoinLabel
@onready var shop_btn: Button = $SafeContainer/TopRightBar/ShopButton
@onready var shop_coin_hint: Label = $SafeContainer/TopRightBar/ShopButton/Content/ShopCoinLabel
@onready var settings_btn: Button = $SafeContainer/TopRightBar/SettingsButton

# Bottom Progress Bar & Milestone Banner
@onready var progress_pill: PanelContainer = $SafeContainer/BottomAnchor/ProgressPill
@onready var fancy_bar: FancyProgressBar = $SafeContainer/BottomAnchor/ProgressPill/FancyBar
@onready var progress_fill: ColorRect = $SafeContainer/BottomAnchor/ProgressPill/FillClip/FillBar
@onready var progress_label: Label = $SafeContainer/BottomAnchor/ProgressPill/ProgressLabel
@onready var milestone_banner: PanelContainer = $SafeContainer/MilestoneBanner
@onready var milestone_label: Label = $SafeContainer/MilestoneBanner/MilestoneLabel

# --- Centered Egg Nodes ---
# EggCenterAnchor & EggContainer never move during animations;
# all shake/squash animations run strictly on EggVisual!
@onready var egg_anchor: Control = $SafeContainer/EggCenterAnchor
@onready var egg_shadow: TextureRect = $SafeContainer/EggCenterAnchor/EggShadow
@onready var side_click_fx: SideClickFX = $SafeContainer/EggCenterAnchor/SideClickFX
@onready var shard_container: Node2D = $SafeContainer/EggCenterAnchor/ShardContainer
@onready var egg_container: Control = $SafeContainer/EggCenterAnchor/EggContainer
@onready var egg_visual: Control = $SafeContainer/EggCenterAnchor/EggContainer/EggVisual
@onready var egg_sprite: TextureRect = $SafeContainer/EggCenterAnchor/EggContainer/EggVisual/EggSprite
@onready var crack_overlay: CrackOverlay = $SafeContainer/EggCenterAnchor/EggContainer/EggVisual/CrackOverlay
@onready var egg_highlight: TextureRect = $SafeContainer/EggCenterAnchor/EggContainer/EggVisual/EggHighlight
@onready var egg_touch_area: Control = $SafeContainer/EggCenterAnchor/EggContainer/TouchArea
@onready var fx_container: Control = $SafeContainer/EggCenterAnchor/EggContainer/FXContainer

# --- Epic Drop Reveal Menu Nodes ---
@onready var drop_dim_scrim: ColorRect = $DropDimScrim
@onready var flash_overlay: ColorRect = $FlashOverlay
@onready var drop_overlay: Control = $DropRevealOverlay
@onready var drop_effect: DropRevealEffect = $DropRevealOverlay/RevealEffect
@onready var drop_card: PanelContainer = $DropRevealOverlay/CenterContainer/DropCard
@onready var drop_header_label: Label = $DropRevealOverlay/CenterContainer/DropCard/VBox/HeaderLabel
@onready var drop_rarity_banner: PanelContainer = $DropRevealOverlay/CenterContainer/DropCard/VBox/RarityBanner
@onready var drop_rarity_label: Label = $DropRevealOverlay/CenterContainer/DropCard/VBox/RarityBanner/RarityLabel
@onready var drop_slime_holder: Control = $DropRevealOverlay/CenterContainer/DropCard/VBox/SlimeHolder
@onready var drop_slime_icon: TextureRect = $DropRevealOverlay/CenterContainer/DropCard/VBox/SlimeHolder/SlimeIcon
@onready var drop_new_tag: PanelContainer = $DropRevealOverlay/CenterContainer/DropCard/VBox/SlimeHolder/NewUnlockTag
@onready var drop_slime_name: Label = $DropRevealOverlay/CenterContainer/DropCard/VBox/SlimeNameLabel
@onready var drop_slime_desc: Label = $DropRevealOverlay/CenterContainer/DropCard/VBox/SlimeDescLabel
@onready var drop_reward_box: PanelContainer = $DropRevealOverlay/CenterContainer/DropCard/VBox/RewardBox
@onready var drop_reward_label: Label = $DropRevealOverlay/CenterContainer/DropCard/VBox/RewardBox/RewardLabel
@onready var drop_confirm_btn: Button = $DropRevealOverlay/CenterContainer/DropCard/VBox/ConfirmDropButton

# --- Shop Modal Nodes ---
@onready var shop_overlay: Control = $ShopOverlay
@onready var shop_panel: PanelContainer = $ShopOverlay/CenterContainer/ShopPanel
@onready var shop_title_label: Label = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/TopBar/ShopTitle
@onready var shop_balance_label: Label = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/TopBar/CoinBox/ShopBalanceLabel
@onready var shop_close_btn: Button = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/TopBar/CloseShopButton
@onready var shop_tab_bar: HBoxContainer = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/TabBar
@onready var shop_feedback_label: Label = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/FeedbackLabel
@onready var shop_items_vbox: VBoxContainer = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/ScrollContainer/ItemsVBox
@onready var shop_odds_box: PanelContainer = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/OddsPreviewBox
@onready var shop_odds_label: RichTextLabel = $ShopOverlay/CenterContainer/ShopPanel/MainVBox/OddsPreviewBox/OddsRichText

# --- Collection / Inventory Modal Nodes ---
@onready var collection_overlay: Control = $CollectionOverlay
@onready var collection_panel: PanelContainer = $CollectionOverlay/CenterContainer/CollectionPanel
@onready var collection_title_label: Label = $CollectionOverlay/CenterContainer/CollectionPanel/MainVBox/TopBar/TitleLabel
@onready var collection_close_btn: Button = $CollectionOverlay/CenterContainer/CollectionPanel/MainVBox/TopBar/CloseCollectionButton
@onready var collection_summary_label: Label = $CollectionOverlay/CenterContainer/CollectionPanel/MainVBox/TopBar/SummaryLabel
@onready var collection_grid: GridContainer = $CollectionOverlay/CenterContainer/CollectionPanel/MainVBox/ScrollContainer/SlimeGrid

# --- Settings Modal Nodes ---
@onready var settings_overlay: Control = $SettingsOverlay
@onready var settings_panel: PanelContainer = $SettingsOverlay/CenterContainer/SettingsPanel
@onready var settings_title_label: Label = $SettingsOverlay/CenterContainer/SettingsPanel/MainVBox/TopBar/TitleLabel
@onready var settings_close_btn: Button = $SettingsOverlay/CenterContainer/SettingsPanel/MainVBox/TopBar/CloseSettingsButton
@onready var settings_options_vbox: VBoxContainer = $SettingsOverlay/CenterContainer/SettingsPanel/MainVBox/OptionsVBox

# --- Main Menu Overlay Nodes ---
@onready var main_menu_overlay: Control = $MainMenuOverlay
@onready var menu_aura: DropRevealEffect = $MainMenuOverlay/MenuAura
@onready var menu_card: PanelContainer = $MainMenuOverlay/CenterContainer/MenuCard
@onready var menu_coin_pill: PanelContainer = $MainMenuOverlay/CenterContainer/MenuCard/VBox/TopStatsBar/MenuCoinPill
@onready var menu_coin_label: Label = $MainMenuOverlay/CenterContainer/MenuCard/VBox/TopStatsBar/MenuCoinPill/MenuCoinLabel
@onready var menu_slime_pill: PanelContainer = $MainMenuOverlay/CenterContainer/MenuCard/VBox/TopStatsBar/MenuSlimePill
@onready var menu_slime_label: Label = $MainMenuOverlay/CenterContainer/MenuCard/VBox/TopStatsBar/MenuSlimePill/MenuSlimeLabel
@onready var menu_title: Label = $MainMenuOverlay/CenterContainer/MenuCard/VBox/MenuTitle
@onready var menu_subtitle: Label = $MainMenuOverlay/CenterContainer/MenuCard/VBox/MenuSubtitle
@onready var hero_stage: Control = $MainMenuOverlay/CenterContainer/MenuCard/VBox/HeroStage
@onready var hero_egg: TextureRect = $MainMenuOverlay/CenterContainer/MenuCard/VBox/HeroStage/HeroEgg
@onready var hero_slime: TextureRect = $MainMenuOverlay/CenterContainer/MenuCard/VBox/HeroStage/HeroSlime
@onready var menu_progress_box: PanelContainer = $MainMenuOverlay/CenterContainer/MenuCard/VBox/ProgressStatusBox
@onready var menu_progress_label: Label = $MainMenuOverlay/CenterContainer/MenuCard/VBox/ProgressStatusBox/MenuProgressLabel
@onready var start_game_btn: Button = $MainMenuOverlay/CenterContainer/MenuCard/VBox/StartGameButton
@onready var menu_shop_btn: Button = $MainMenuOverlay/CenterContainer/MenuCard/VBox/NavGrid/MenuShopBtn
@onready var menu_collection_btn: Button = $MainMenuOverlay/CenterContainer/MenuCard/VBox/NavGrid/MenuCollectionBtn
@onready var menu_upgrades_btn: Button = $MainMenuOverlay/CenterContainer/MenuCard/VBox/NavGrid/MenuUpgradesBtn
@onready var menu_settings_btn: Button = $MainMenuOverlay/CenterContainer/MenuCard/VBox/NavGrid/MenuSettingsBtn

# --- Pause Overlay ---
@onready var pause_overlay: ColorRect = $PauseOverlay
@onready var resume_button: Button = $PauseOverlay/PauseCard/ResumeButton

# --- Audio Players ---
@onready var tap_player: AudioStreamPlayer = $Audio/TapPlayer
@onready var crack_player: AudioStreamPlayer = $Audio/CrackPlayer
@onready var shatter_player: AudioStreamPlayer = $Audio/ShatterPlayer
@onready var buy_player: AudioStreamPlayer = $Audio/BuyPlayer

# --- Game State Variables ---
var active_egg_id: String = "nature"
var current_clicks: int = 0
var target_clicks: int = 10000
var total_lifetime_clicks: int = 0
var coins: int = 300 # Starter coins so player can immediately test Shop upgrades
var is_hatched: bool = false
var is_revealing_drop: bool = false
var reward_claimed_for_current_egg: bool = false
var last_hatched_slime_id: String = "nature_common"
var milestones_claimed: Dictionary = {} # Tracks milestone % per egg round

# Per-Egg Persistent State: { "nature": {...}, "crystal": {...}, "cosmic": {...} }
var egg_states: Dictionary = {}
var egg_unseen_unlocks: Dictionary = {} # egg_id -> bool

# Dynamically created UI nodes for Egg Selection & Collection Filter
var eggs_hud_btn: Button
var eggs_new_badge: PanelContainer
var menu_eggs_btn: Button
var egg_select_overlay: Control
var egg_select_panel: PanelContainer
var egg_cards_hbox: BoxContainer
var collection_filter_bar: HBoxContainer
var _collection_filter_egg: String = "all"

# Pet & Wheel System
var pet_tokens: int = 1 # 1 free starter spin!
var owned_pets: Array[String] = [] # Pet IDs
var equipped_pet_id: String = ""
var pet_companion: PetCompanion
var pet_auto_click_timer: float = 0.0

var pets_hud_btn: Button
var pets_new_badge: PanelContainer
var pet_modal_overlay: Control
var pet_modal_panel: PanelContainer
var pet_wheel_container: Control
var pet_inventory_grid: GridContainer
var pet_inv_scroll: ScrollContainer
var pet_token_label: Label
var pet_spin_button: Button
var pet_spin_dim_rect: ColorRect
var wheel_stage_wrap: Control
var wheel_stage_root: Control
var wheel_reveal_overlay: Control
var wheel_reveal_effect: DropRevealEffect
var wheel_reveal_card: PanelContainer
var wheel_reveal_icon: TextureRect
var wheel_reveal_halo: PanelContainer
var wheel_reveal_title: Label
var wheel_reveal_rarity_pill: PanelContainer
var wheel_reveal_rarity: Label
var wheel_reveal_bonus: Label
var wheel_reveal_lore: Label
var wheel_pointer: Control
var wheel_disk: Control
var is_wheel_spinning: bool = false
var _pet_modal_tab: String = "wheel"
var _wheel_pet_float_tween: Tween

# Upgrades & Boosters
var owned_click_upgrades: Array[String] = [] # "click_2x", "click_3x", "click_5x"
var active_click_upgrade: String = "base"
var owned_luck_upgrades: Array[String] = [] # "luck_charm", "luck_epic", "luck_mythic"
var active_luck_upgrade: String = "base"

var booster_2x_time: float = 0.0
var booster_auto_time: float = 0.0
var booster_5x_time: float = 0.0
var _auto_click_accum: float = 0.0

# Cosmetics
var owned_cosmetics: Array[String] = ["egg_classic", "crack_normal", "part_gold", "bg_day", "aura_normal"]
var equipped_egg_skin: String = "egg_classic"
var equipped_crack_style: String = "crack_normal"
var equipped_particle_style: String = "part_gold"
var equipped_bg_theme: String = "bg_day"
var equipped_reveal_aura: String = "aura_normal"

# Slime Collection & Inventory (18 unique slimes across 3 eggs)
var slime_counts: Dictionary = {}
var slime_unseen: Dictionary = {} # slime_id -> bool

# User Settings (persisted in save v3)
var setting_sfx_volume: float = 1.0
var setting_particles_enabled: bool = true
var setting_reduced_shake: bool = false
var setting_game_zoom: float = 1.0
var _yt_audio_allowed: bool = true

# Click streak tracking for dynamic side effects
var _click_streak: int = 0
var _streak_decay_timer: float = 0.0

# Cloud & Save tracking
var is_cloud_data_loaded: bool = false
var _save_dirty: bool = false
var _save_timer: float = 0.0
var _current_shop_tab: String = "clicks"
var _opened_from_main_menu: bool = false

# Animation state
var _egg_base_scale: Vector2 = Vector2.ONE
var _egg_tween: Tween
var _banner_tween: Tween
var _slime_float_tween: Tween
var _menu_hero_tween: Tween
var _rng := RandomNumberGenerator.new()

# --- Data Tables (Delegated to EggWorldData) ---
const EGG_WORLDS: Dictionary = EggWorldData.EGG_WORLDS
const CLICK_TARGET_TABLE: Array[Dictionary] = EggWorldData.CLICK_TARGET_TABLE
const SLIME_CATALOG: Array[Dictionary] = EggWorldData.SLIME_CATALOG

# Mathematically exact 100.0% drop probability tables per Luck Tier
const LUCK_TABLES: Dictionary = {
	"base": {
		"name": "Standard-Glück",
		"chances": { "common": 70.0, "uncommon": 20.0, "rare": 7.0, "epic": 2.0, "legendary": 0.8, "mythic": 0.2 }
	},
	"luck_charm": {
		"name": "Lucky Charm",
		"chances": { "common": 55.0, "uncommon": 25.0, "rare": 14.0, "epic": 4.2, "legendary": 1.4, "mythic": 0.4 }
	},
	"luck_epic": {
		"name": "Epic Luck",
		"chances": { "common": 40.0, "uncommon": 25.0, "rare": 20.0, "epic": 10.0, "legendary": 4.0, "mythic": 1.0 }
	},
	"luck_mythic": {
		"name": "Mythic Luck",
		"chances": { "common": 25.0, "uncommon": 22.0, "rare": 25.0, "epic": 16.0, "legendary": 8.5, "mythic": 3.5 }
	}
}

const SHOP_CATALOG: Dictionary = {
	"clicks": [
		{
			"id": "click_2x",
			"title": "Doppelklick (2x Klickkraft)",
			"desc": "Jeder gültige Klick zählt permanent als 2 effektive Klicks.",
			"price": 250,
			"power": 2
		},
		{
			"id": "click_3x",
			"title": "Dreifachklick (3x Klickkraft)",
			"desc": "Jeder gültige Klick zählt permanent als 3 effektive Klicks.",
			"price": 1000,
			"power": 3
		},
		{
			"id": "click_5x",
			"title": "Superklick (5x Klickkraft)",
			"desc": "Jeder gültige Klick zählt permanent als 5 effektive Klicks.",
			"price": 5000,
			"power": 5
		}
	],
	"boosters": [
		{
			"id": "booster_2x",
			"title": "Klick-Booster (2x für 30s)",
			"desc": "Verdoppelt deine effektive Klickkraft für 30 Sekunden.",
			"price": 500,
			"duration": 30.0
		},
		{
			"id": "booster_auto",
			"title": "Auto-Klicker (60s)",
			"desc": "Fügt automatisch 1 effektiven Klick pro Sekunde für 60 Sekunden hinzu.",
			"price": 1500,
			"duration": 60.0
		},
		{
			"id": "booster_5x",
			"title": "Turbo-Booster (5x für 15s)",
			"desc": "Verfünffacht deine effektive Klickkraft für 15 Sekunden!",
			"price": 2000,
			"duration": 15.0
		}
	],
	"luck": [
		{
			"id": "luck_charm",
			"title": "Lucky Charm",
			"desc": "Erhöht die Chance auf Rare (14%), Epic (4,2%), Legendary (1,4%) & Mythic (0,4%).",
			"price": 2500
		},
		{
			"id": "luck_epic",
			"title": "Epic Luck",
			"desc": "Starker Glücksbonus: Rare 20%, Epic 10%, Legendary 4,0%, Mythic 1,0%!",
			"price": 10000
		},
		{
			"id": "luck_mythic",
			"title": "Mythic Luck",
			"desc": "Ultimatives Glück: Epic 16%, Legendary 8,5% und Mythic 3,5% Chance!",
			"price": 50000
		}
	],
	"cosmetics": [
		{
			"id": "egg_classic",
			"slot": "egg",
			"title": "Ei-Farbe: Klassisch Creme",
			"desc": "Das natürliche, glänzende Creme-Ei (Rein optisch).",
			"price": 0
		},
		{
			"id": "egg_gold",
			"slot": "egg",
			"title": "Ei-Farbe: Sonnen-Gold",
			"desc": "Edle goldene Eierschale mit warmem Schimmer (Rein optisch).",
			"price": 800
		},
		{
			"id": "egg_crystal",
			"slot": "egg",
			"title": "Ei-Farbe: Kristall-Azur",
			"desc": "Eisblaue Schale wie aus reinem Gletscherkristall (Rein optisch).",
			"price": 1200
		},
		{
			"id": "egg_dragon",
			"slot": "egg",
			"title": "Ei-Farbe: Amethyst-Drache",
			"desc": "Mystische violette Schale (Rein optisch).",
			"price": 2000
		},
		{
			"id": "crack_normal",
			"slot": "crack",
			"title": "Riss-Effekt: Natur-Risse",
			"desc": "Klassische detaillierte Schalenrisse (Rein optisch).",
			"price": 0
		},
		{
			"id": "crack_gold",
			"slot": "crack",
			"title": "Riss-Effekt: Gold-Kintsugi",
			"desc": "Risse leuchten in flüssigem Gold (Rein optisch).",
			"price": 1500
		},
		{
			"id": "crack_magma",
			"slot": "crack",
			"title": "Riss-Effekt: Magma-Glut",
			"desc": "Feurig glühende Lava-Risse auf der Schale (Rein optisch).",
			"price": 2500
		},
		{
			"id": "crack_ice",
			"slot": "crack",
			"title": "Riss-Effekt: Frost-Kristall",
			"desc": "Eisblau leuchtende Kristallrisse (Rein optisch).",
			"price": 2500
		},
		{
			"id": "part_gold",
			"slot": "particle",
			"title": "Klick-Partikel: Sonnenfunken",
			"desc": "Goldgelbe Funken bei jedem Klick (Rein optisch).",
			"price": 0
		},
		{
			"id": "part_cyan",
			"slot": "particle",
			"title": "Klick-Partikel: Sternenstaub",
			"desc": "Türkis-blaue Sternenfunken beim Klicken (Rein optisch).",
			"price": 1000
		},
		{
			"id": "part_rainbow",
			"slot": "particle",
			"title": "Klick-Partikel: Konfetti-Party",
			"desc": "Bunte Regenbogen-Partikel bei jedem Klick (Rein optisch).",
			"price": 2000
		},
		{
			"id": "bg_day",
			"slot": "bg",
			"title": "Hintergrund: Sommerwiese",
			"desc": "Strahlender Himmel und saftige Slime-Wiese (Rein optisch).",
			"price": 0
		},
		{
			"id": "bg_sunset",
			"slot": "bg",
			"title": "Hintergrund: Abendrot-Tal",
			"desc": "Romantisches goldenes Abendlicht (Rein optisch).",
			"price": 3000
		},
		{
			"id": "bg_night",
			"slot": "bg",
			"title": "Hintergrund: Sternennacht",
			"desc": "Magische Nachtstimmung im Tal (Rein optisch).",
			"price": 4500
		},
		{
			"id": "aura_normal",
			"slot": "aura",
			"title": "Drop-Effekt: Standard-Glanz",
			"desc": "Klassische Enthüllungsstrahlen beim Schlüpfen (Rein optisch).",
			"price": 0
		},
		{
			"id": "aura_supernova",
			"slot": "aura",
			"title": "Drop-Effekt: Supernova-Aura",
			"desc": "Zusätzliche Schockwellen & Sternenpartikel beim Schlüpfen (Rein optisch).",
			"price": 3500
		}
	]
}

func _ready() -> void:
	_rng.randomize()
	_init_egg_states()

	# Build Egg Selection UI & Collection Egg Filter Bar dynamically
	_build_egg_selection_ui()
	_build_collection_filter_bar()
	_build_pet_system_ui()

	_spawn_pet_companion()

	# Load local save state
	_load_local_data()

	# Reparent power_pill and booster_status_bar into header_container
	# so they are symmetrically centered above the egg and never collide with top buttons/pills!
	if power_pill and header_container and power_pill.get_parent() != header_container:
		power_pill.get_parent().remove_child(power_pill)
		header_container.add_child(power_pill)
		power_pill.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	if booster_status_bar and header_container and booster_status_bar.get_parent() != header_container:
		booster_status_bar.get_parent().remove_child(booster_status_bar)
		header_container.add_child(booster_status_bar)
		booster_status_bar.alignment = BoxContainer.ALIGNMENT_CENTER

	# Apply modern casual UIKit theme & Fredoka typography across HUD and Modals
	_apply_visual_overhaul_theme()

	# Apply restored camera zoom
	_apply_game_zoom()

	# Hide modals at startup
	if shop_overlay:
		shop_overlay.visible = false
	if collection_overlay:
		collection_overlay.visible = false
	if settings_overlay:
		settings_overlay.visible = false
	if egg_select_overlay:
		egg_select_overlay.visible = false
	if main_menu_overlay:
		main_menu_overlay.visible = false
	if drop_overlay:
		drop_overlay.visible = false
	if drop_dim_scrim:
		drop_dim_scrim.visible = false
	if flash_overlay:
		flash_overlay.visible = false
	if pause_overlay:
		pause_overlay.visible = false
	if milestone_banner:
		milestone_banner.modulate.a = 0.0

	# Connect egg click area
	if egg_touch_area:
		egg_touch_area.gui_input.connect(_on_egg_gui_input)

	# Connect Pets HUD Button in Top Left Bar
	if top_left_bar and not pets_hud_btn:
		pets_hud_btn = Button.new()
		pets_hud_btn.custom_minimum_size = Vector2(104, 48)
		pets_hud_btn.text = "🐾 Pets"
		UIKit.style_button(pets_hud_btn, "orange", 16, 16, 12.0, 5.0)
		pets_hud_btn.pressed.connect(func():
			_opened_from_main_menu = false
			_open_pet_modal()
		)
		top_left_bar.add_child(pets_hud_btn)
		top_left_bar.move_child(pets_hud_btn, 2)

	# Connect Top Bar & Modal buttons
	if menu_btn:
		menu_btn.pressed.connect(_open_main_menu)
	if settings_btn:
		settings_btn.pressed.connect(func():
			_opened_from_main_menu = false
			_open_settings()
		)
	if shop_btn:
		shop_btn.pressed.connect(func():
			_opened_from_main_menu = false
			_open_shop("clicks")
		)
	if shop_close_btn:
		shop_close_btn.pressed.connect(_close_shop)
	if collection_btn:
		collection_btn.pressed.connect(func():
			_opened_from_main_menu = false
			_open_collection()
		)
	if collection_close_btn:
		collection_close_btn.pressed.connect(_close_collection)
	if settings_close_btn:
		settings_close_btn.pressed.connect(_close_settings)
	if drop_confirm_btn:
		drop_confirm_btn.pressed.connect(_on_confirm_drop_pressed)
	if resume_button:
		resume_button.pressed.connect(_on_resume_button_pressed)

	# Connect Main Menu buttons
	if start_game_btn:
		start_game_btn.pressed.connect(func():
			_opened_from_main_menu = false
			_close_main_menu()
		)
	if menu_shop_btn:
		menu_shop_btn.pressed.connect(func():
			_opened_from_main_menu = true
			_close_main_menu()
			_open_shop("clicks")
		)
	if menu_collection_btn:
		menu_collection_btn.pressed.connect(func():
			_opened_from_main_menu = true
			_close_main_menu()
			_open_collection()
		)
	if menu_upgrades_btn:
		menu_upgrades_btn.pressed.connect(func():
			_opened_from_main_menu = true
			_close_main_menu()
			_open_upgrades()
		)
	if menu_settings_btn:
		menu_settings_btn.pressed.connect(func():
			_opened_from_main_menu = true
			_close_main_menu()
			_open_settings()
		)

	# Connect Shop Category Tabs & Settings Content
	_setup_shop_tabs()
	_populate_settings_modal()

	# Connect YouTube Playables SDK events
	YTGameWrapper.game_paused.connect(_on_yt_game_paused)
	YTGameWrapper.game_resumed.connect(_on_yt_game_resumed)
	YTGameWrapper.audio_enabled_changed.connect(_on_yt_audio_changed)
	YTGameWrapper.load_data_received.connect(_on_yt_load_data_received)
	YTGameWrapper.save_data_success.connect(_on_yt_save_success)
	YTGameWrapper.save_data_failed.connect(_on_yt_save_failed)

	# Responsive layout hook
	get_viewport().size_changed.connect(_on_viewport_size_changed)

	# Apply audio mute state from YouTube & user settings
	_yt_audio_allowed = YTGameWrapper.is_audio_enabled()
	_apply_audio_state(_yt_audio_allowed)
	_apply_user_settings()

	# Apply active world, cosmetics, crack state, and responsive layout
	_apply_world_visuals(active_egg_id, false)
	_apply_all_cosmetics()
	if crack_overlay:
		crack_overlay.set_clicks(current_clicks, target_clicks)
	if fancy_bar:
		fancy_bar.set_progress(current_clicks, true, target_clicks)
	_update_responsive_layout()
	_update_hud()

	if is_hatched and current_clicks >= target_clicks:
		_restore_hatched_view()
	else:
		_open_main_menu()

	# YouTube Playables SDK lifecycle order: firstFrameReady -> loadData -> gameReady
	YTGameWrapper.first_frame_ready()
	YTGameWrapper.load_data()

	if get_tree():
		await get_tree().process_frame
	YTGameWrapper.game_ready()

func _init_egg_states() -> void:
	for s in SLIME_CATALOG:
		var sid: String = s["id"]
		if not slime_counts.has(sid):
			slime_counts[sid] = 0
	for eid in EggWorldData.EGG_IDS:
		if not egg_states.has(eid):
			egg_states[eid] = {
				"unlocked": (eid == "nature"),
				"current_clicks": 0,
				"target_clicks": roll_click_target(),
				"drops_count": 0,
				"hatched": false,
				"milestones_claimed": {}
			}
	_sync_active_egg_from_dict()

func roll_click_target() -> int:
	return EggWorldData.roll_click_target(_rng)

func _sync_active_egg_to_dict() -> void:
	if not egg_states.has(active_egg_id):
		return
	var st: Dictionary = egg_states[active_egg_id]
	st["current_clicks"] = current_clicks
	st["target_clicks"] = target_clicks
	st["hatched"] = is_hatched
	st["milestones_claimed"] = milestones_claimed.duplicate()

func _sync_active_egg_from_dict() -> void:
	if not egg_states.has(active_egg_id):
		active_egg_id = "nature"
	var st: Dictionary = egg_states[active_egg_id]
	target_clicks = int(st.get("target_clicks", 10000))
	if not EggWorldData.is_valid_click_target(target_clicks):
		target_clicks = roll_click_target()
		st["target_clicks"] = target_clicks
	current_clicks = clampi(int(st.get("current_clicks", 0)), 0, target_clicks)
	is_hatched = bool(st.get("hatched", false))
	reward_claimed_for_current_egg = is_hatched
	var mc = st.get("milestones_claimed", {})
	milestones_claimed = mc.duplicate() if typeof(mc) == TYPE_DICTIONARY else {}

func select_egg(egg_id: String, animate_transition: bool = true) -> bool:
	if not EGG_WORLDS.has(egg_id):
		return false
	if not is_egg_unlocked(egg_id):
		return false
	if is_revealing_drop:
		return false

	# Save current egg's round progress before switching
	_sync_active_egg_to_dict()
	active_egg_id = egg_id
	egg_unseen_unlocks.erase(egg_id)
	_sync_active_egg_from_dict()

	_apply_world_visuals(active_egg_id, animate_transition)
	_apply_all_cosmetics()
	if crack_overlay:
		crack_overlay.set_clicks(current_clicks, target_clicks)
	if fancy_bar:
		fancy_bar.set_progress(current_clicks, true, target_clicks)
	if side_click_fx:
		side_click_fx.clear_all()

	_save_progress()
	_update_hud()
	return true

func is_egg_unlocked(egg_id: String) -> bool:
	if egg_id == "nature":
		return true
	if egg_states.has(egg_id):
		return bool(egg_states[egg_id].get("unlocked", false))
	return false

func _apply_world_visuals(egg_id: String, animate_transition: bool = false) -> void:
	var w_cfg: Dictionary = EGG_WORLDS.get(egg_id, EGG_WORLDS["nature"])
	if background_rect and ResourceLoader.exists(w_cfg["bg_texture"]):
		background_rect.texture = load(w_cfg["bg_texture"])
	if egg_sprite and ResourceLoader.exists(w_cfg["egg_texture"]):
		egg_sprite.texture = load(w_cfg["egg_texture"])
	if hero_egg and ResourceLoader.exists(w_cfg["egg_texture"]):
		hero_egg.texture = load(w_cfg["egg_texture"])
	if world_backdrop:
		world_backdrop.set_world_theme(egg_id)
	if side_click_fx:
		side_click_fx.set_world_theme(egg_id)
	if fancy_bar:
		fancy_bar.set_world_theme(egg_id)
	if crack_overlay:
		crack_overlay.set_world_id(egg_id)

	if animate_transition and flash_overlay:
		flash_overlay.visible = true
		flash_overlay.color = w_cfg["accent_color"]
		flash_overlay.modulate.a = 0.38
		var tw := create_tween()
		tw.tween_property(flash_overlay, "modulate:a", 0.0, 0.32)
		tw.tween_callback(func(): flash_overlay.visible = false)

func _apply_visual_overhaul_theme() -> void:
	# Style Top Bar Buttons & Pills using modern UIKit
	UIKit.style_button(menu_btn, "purple", 18, 22, 14.0, 8.0)
	UIKit.style_button(collection_btn, "blue", 18, 22, 14.0, 8.0)
	if eggs_hud_btn:
		UIKit.style_button(eggs_hud_btn, "green", 18, 22, 14.0, 8.0)
	UIKit.style_button(shop_btn, "orange", 20, 22, 16.0, 8.0)
	UIKit.style_button(settings_btn, "navy", 18, 22, 10.0, 8.0)

	var pill_world_kind = "pill_world"
	if active_egg_id == "crystal":
		pill_world_kind = "pill_crystal"
	elif active_egg_id == "cosmic":
		pill_world_kind = "pill_cosmic"
	UIKit.style_panel(power_pill, pill_world_kind, 16.0, 6.0)
	UIKit.style_panel(counter_pill, "pill_counter", 16.0, 6.0)
	UIKit.style_panel(coin_pill, "pill_coin", 16.0, 6.0)
	UIKit.style_panel(milestone_banner, "banner", 20.0, 10.0)

	# Style Header & HUD typography with clean modern Fredoka Bold styling
	UIKit.style_label(title_line1, 38, Color.WHITE, 6, Color(0.04, 0.07, 0.18), true, true)
	UIKit.style_label(title_line2, 28, Color.WHITE, 6, Color(0.04, 0.07, 0.18), true, true)
	UIKit.style_label(power_badge_label, 15, Color(0.92, 0.98, 0.96), 2, Color(0.02, 0.06, 0.04), true, true)
	UIKit.style_label(counter_label, 20, Color.WHITE, 2, Color(0.02, 0.05, 0.12), true, true)
	UIKit.style_label(coin_label, 20, Color("#ffe047"), 2, Color(0.12, 0.06, 0.01), true, true)
	UIKit.style_label(shop_coin_hint, 20, Color.WHITE, 6, Color(0.28, 0.12, 0.02))
	UIKit.style_label(progress_label, 26, Color.WHITE, 8, Color(0.03, 0.06, 0.16), true, true)
	UIKit.style_label(milestone_label, 20, Color("#ffe047"), 7, Color(0.08, 0.05, 0.02))

	# Style Modals (Shop, Collection, Settings, Drop Reveal, Main Menu)
	UIKit.style_panel(shop_panel, "modal", 24.0, 20.0)
	UIKit.style_panel(collection_panel, "modal_blue", 24.0, 20.0)
	UIKit.style_panel(settings_panel, "modal_blue", 24.0, 20.0)
	UIKit.style_panel(drop_card, "modal", 24.0, 20.0)
	UIKit.style_panel(menu_card, "modal", 26.0, 22.0)
	UIKit.style_panel(menu_coin_pill, "chip_gold", 14.0, 6.0)
	UIKit.style_panel(menu_slime_pill, "chip", 14.0, 6.0)
	UIKit.style_panel(menu_progress_box, "inset", 16.0, 10.0)
	UIKit.style_panel(drop_rarity_banner, "chip", 16.0, 8.0)
	UIKit.style_panel(drop_reward_box, "chip_gold", 16.0, 8.0)
	UIKit.style_panel(shop_odds_box, "inset", 14.0, 10.0)

	UIKit.style_label(shop_title_label, 26, Color("#ffe047"), 7, Color(0.08, 0.05, 0.02))
	UIKit.style_label(shop_balance_label, 22, Color("#ffe047"), 6, Color(0.12, 0.06, 0.02))
	UIKit.style_label(shop_feedback_label, 16, Color(0.84, 0.93, 1.0), 4, Color(0.04, 0.08, 0.18))
	UIKit.style_label(collection_title_label, 26, Color("#6ee2ff"), 7, Color(0.04, 0.10, 0.24))
	UIKit.style_label(collection_summary_label, 16, Color(0.90, 0.95, 1.0), 4, Color(0.04, 0.08, 0.18))
	UIKit.style_label(settings_title_label, 26, Color("#9ce8ff"), 7, Color(0.04, 0.10, 0.24))

	UIKit.style_button(shop_close_btn, "red", 17, 18, 14.0, 6.0)
	UIKit.style_button(collection_close_btn, "red", 17, 18, 14.0, 6.0)
	UIKit.style_button(settings_close_btn, "red", 17, 18, 14.0, 6.0)
	UIKit.style_button(drop_confirm_btn, "green", 20, 24, 22.0, 10.0)
	UIKit.style_button(resume_button, "green", 20, 22, 20.0, 10.0)

	# Style Main Menu Typography & Buttons
	UIKit.style_label(menu_title, 44, Color("#ffe047"), 12, Color(0.06, 0.08, 0.22), true, true)
	UIKit.style_label(menu_subtitle, 19, Color(0.88, 0.96, 1.0), 6, Color(0.04, 0.08, 0.20))
	UIKit.style_label(menu_coin_label, 18, Color("#ffe047"), 5, Color(0.12, 0.06, 0.02))
	UIKit.style_label(menu_slime_label, 18, Color("#7ae8ff"), 5, Color(0.04, 0.10, 0.24))
	UIKit.style_label(menu_progress_label, 18, Color.WHITE, 5, Color(0.04, 0.08, 0.20))

	UIKit.style_button(start_game_btn, "green", 26, 28, 24.0, 12.0)
	UIKit.style_button(menu_shop_btn, "orange", 20, 22, 16.0, 10.0)
	UIKit.style_button(menu_collection_btn, "blue", 20, 22, 16.0, 10.0)
	UIKit.style_button(menu_upgrades_btn, "purple", 20, 22, 16.0, 10.0)
	UIKit.style_button(menu_settings_btn, "navy", 20, 22, 16.0, 10.0)
	if menu_eggs_btn:
		UIKit.style_button(menu_eggs_btn, "green", 20, 22, 16.0, 10.0)

	# Drop Reveal Labels
	UIKit.style_label(drop_header_label, 24, Color("#ffe047"), 8, Color(0.12, 0.07, 0.02))
	UIKit.style_label(drop_rarity_label, 22, Color.WHITE, 7, Color(0.05, 0.06, 0.14))
	UIKit.style_label(drop_slime_name, 26, Color.WHITE, 8, Color(0.05, 0.06, 0.14))
	UIKit.style_label(drop_slime_desc, 16, Color(0.88, 0.93, 1.0), 4, Color(0.04, 0.07, 0.16), false)
	UIKit.style_label(drop_reward_label, 20, Color("#ffe047"), 6, Color(0.12, 0.07, 0.02))

func _process(delta: float) -> void:
	# 1. Process active timed boosters
	var boosters_changed: bool = false
	if booster_2x_time > 0.0:
		booster_2x_time = max(0.0, booster_2x_time - delta)
		boosters_changed = true
	if booster_5x_time > 0.0:
		booster_5x_time = max(0.0, booster_5x_time - delta)
		boosters_changed = true
	if booster_auto_time > 0.0:
		booster_auto_time = max(0.0, booster_auto_time - delta)
		boosters_changed = true
		if not is_hatched and not is_revealing_drop and current_clicks < target_clicks:
			_auto_click_accum += delta
			if _auto_click_accum >= 1.0:
				var ticks = int(floor(_auto_click_accum))
				_auto_click_accum -= float(ticks)
				_apply_effective_clicks(ticks, egg_container.size * 0.5, false)
	else:
		_auto_click_accum = 0.0

	if boosters_changed:
		_update_booster_hud()

	# 2. Pet passive auto-click interval (e.g. Mossy Turtle, Star Ray)
	if not equipped_pet_id.is_empty() and not is_hatched and not is_revealing_drop and current_clicks < target_clicks:
		var p_data = PetData.get_pet_by_id(equipped_pet_id)
		var p_interval: float = float(p_data.get("auto_click_interval", 0.0))
		if p_interval > 0.0:
			pet_auto_click_timer += delta
			if pet_auto_click_timer >= p_interval:
				pet_auto_click_timer = 0.0
				var egg_pos = egg_container.size * 0.5 if egg_container else Vector2.ZERO
				_apply_effective_clicks(1, egg_pos, false)

	# 3. Click streak decay for random left/right click effects
	if _click_streak > 0:
		_streak_decay_timer -= delta
		if _streak_decay_timer <= 0.0:
			_click_streak = maxi(0, _click_streak - 2)
			_streak_decay_timer = 0.25

	# 3. Throttled auto-save every 2.0s when state changed
	if _save_dirty:
		_save_timer += delta
		if _save_timer >= 2.0:
			_save_timer = 0.0
			_save_progress()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_on_resume_button_pressed()
		elif egg_select_overlay and egg_select_overlay.visible:
			_close_egg_select()
		elif pet_modal_overlay and pet_modal_overlay.visible:
			_close_pet_modal()
		elif settings_overlay and settings_overlay.visible:
			_close_settings()
		elif shop_overlay and shop_overlay.visible:
			_close_shop()
		elif collection_overlay and collection_overlay.visible:
			_close_collection()
		elif main_menu_overlay and main_menu_overlay.visible:
			_close_main_menu()

func _is_any_modal_open() -> bool:
	if get_tree().paused:
		return true
	if egg_select_overlay and egg_select_overlay.visible:
		return true
	if pet_modal_overlay and pet_modal_overlay.visible:
		return true
	if shop_overlay and shop_overlay.visible:
		return true
	if collection_overlay and collection_overlay.visible:
		return true
	if settings_overlay and settings_overlay.visible:
		return true
	if main_menu_overlay and main_menu_overlay.visible:
		return true
	if drop_overlay and drop_overlay.visible:
		return true
	if is_revealing_drop:
		return true
	return false

# ---Redesigned Main Menu & Settings Modal (Section 1) ---

func _open_main_menu() -> void:
	if is_revealing_drop:
		return
	if egg_select_overlay:
		egg_select_overlay.visible = false
	if shop_overlay:
		shop_overlay.visible = false
	if collection_overlay:
		collection_overlay.visible = false
	if settings_overlay:
		settings_overlay.visible = false
	_update_main_menu_content()
	if menu_aura:
		menu_aura.start_reveal("mythic", true)
	UIKit.open_overlay(main_menu_overlay, menu_card)
	_start_menu_hero_animation()

func _close_main_menu() -> void:
	if _menu_hero_tween and _menu_hero_tween.is_valid():
		_menu_hero_tween.kill()
	if menu_aura:
		menu_aura.stop_reveal()
	UIKit.close_overlay(main_menu_overlay, menu_card)

func _update_main_menu_content() -> void:
	if menu_coin_label:
		menu_coin_label.text = "🪙 %s Münzen" % _format_number(coins)
	var unlocked_types: int = 0
	for s in SLIME_CATALOG:
		if int(slime_counts.get(s["id"], 0)) > 0:
			unlocked_types += 1
	if menu_slime_label:
		menu_slime_label.text = "📘 Slimes: %d / %d" % [unlocked_types, SLIME_CATALOG.size()]
	var w_cfg: Dictionary = EGG_WORLDS.get(active_egg_id, EGG_WORLDS["nature"])
	var pct_val: float = clampf((float(current_clicks) / float(maxi(1, target_clicks))) * 100.0, 0.0, 100.0)
	if menu_progress_label:
		menu_progress_label.text = "%s: %s / %s Klicks (%s %%)" % [
			w_cfg["name"],
			_format_number(current_clicks),
			_format_number(target_clicks),
			_format_pct(pct_val)
		]
	if start_game_btn:
		start_game_btn.text = "WEITERSPIELEN" if current_clicks > 0 else "SPIEL STARTEN"
	if hero_egg:
		if ResourceLoader.exists(w_cfg["egg_texture"]):
			hero_egg.texture = load(w_cfg["egg_texture"])
		hero_egg.modulate = _get_egg_skin_color(equipped_egg_skin)

func _start_menu_hero_animation() -> void:
	if _menu_hero_tween and _menu_hero_tween.is_valid():
		_menu_hero_tween.kill()
	if not hero_egg or not hero_slime:
		return
	var stage_w: float = hero_stage.size.x if (hero_stage and hero_stage.size.x > 0.0) else 460.0
	var stage_h: float = hero_stage.size.y if (hero_stage and hero_stage.size.y > 0.0) else 220.0
	var egg_w: float = hero_egg.size.x if hero_egg.size.x > 0.0 else 160.0
	var egg_h: float = hero_egg.size.y if hero_egg.size.y > 0.0 else 170.0
	var slime_w: float = hero_slime.size.x if hero_slime.size.x > 0.0 else 160.0
	var slime_h: float = hero_slime.size.y if hero_slime.size.y > 0.0 else 160.0

	var egg_base_x: float = (stage_w * 0.5) - egg_w - 10.0
	var egg_base_y: float = (stage_h - egg_h) * 0.5
	var slime_base_x: float = (stage_w * 0.5) + 10.0
	var slime_base_y: float = (stage_h - slime_h) * 0.5

	hero_egg.position = Vector2(egg_base_x, egg_base_y)
	hero_slime.position = Vector2(slime_base_x, slime_base_y)

	_menu_hero_tween = create_tween().set_loops().set_parallel(true)
	_menu_hero_tween.tween_property(hero_egg, "rotation", 0.04, 1.2).set_trans(Tween.TRANS_SINE)
	_menu_hero_tween.tween_property(hero_slime, "position:y", slime_base_y - 10.0, 1.2).set_trans(Tween.TRANS_SINE)
	_menu_hero_tween.chain().tween_property(hero_egg, "rotation", -0.04, 1.2).set_trans(Tween.TRANS_SINE)
	_menu_hero_tween.parallel().tween_property(hero_slime, "position:y", slime_base_y, 1.2).set_trans(Tween.TRANS_SINE)

func _open_upgrades() -> void:
	_open_shop("clicks")

func _open_settings() -> void:
	if is_revealing_drop:
		return
	if shop_overlay:
		shop_overlay.visible = false
	if collection_overlay:
		collection_overlay.visible = false
	_populate_settings_modal()
	UIKit.open_overlay(settings_overlay, settings_panel)

func _close_settings() -> void:
	UIKit.close_overlay(settings_overlay, settings_panel)
	if _opened_from_main_menu:
		_opened_from_main_menu = false
		_open_main_menu()

func _populate_settings_modal() -> void:
	if not settings_options_vbox:
		return
	for child in settings_options_vbox.get_children():
		child.queue_free()

	# 1. Spiel-Zoom Slider Row (70% .. 150%, Stepless, Reset Button)
	var zoom_card := PanelContainer.new()
	UIKit.style_panel(zoom_card, "card", 18.0, 12.0)
	var zoom_vbox := VBoxContainer.new()
	zoom_vbox.add_theme_constant_override("separation", 10)
	zoom_card.add_child(zoom_vbox)

	var zoom_header := HBoxContainer.new()
	zoom_header.add_theme_constant_override("separation", 10)
	zoom_vbox.add_child(zoom_header)

	var zoom_title_lbl := Label.new()
	zoom_title_lbl.text = "🔍 Spiel-Zoom"
	zoom_title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIKit.style_label(zoom_title_lbl, 19, Color.WHITE, 5)
	zoom_header.add_child(zoom_title_lbl)

	var zoom_pct_lbl := Label.new()
	zoom_pct_lbl.name = "ZoomPctLabel"
	zoom_pct_lbl.text = "%d %%" % int(round(setting_game_zoom * 100.0))
	UIKit.style_label(zoom_pct_lbl, 19, Color("#ffe047"), 5)
	zoom_header.add_child(zoom_pct_lbl)

	var zoom_reset_btn := Button.new()
	zoom_reset_btn.name = "ZoomResetBtn"
	zoom_reset_btn.custom_minimum_size = Vector2(110, 38)
	zoom_reset_btn.text = "Zurücksetzen"
	UIKit.style_button(zoom_reset_btn, "gray", 14, 14, 10.0, 4.0)
	zoom_header.add_child(zoom_reset_btn)

	var zoom_slider_hbox := HBoxContainer.new()
	zoom_slider_hbox.add_theme_constant_override("separation", 10)
	zoom_vbox.add_child(zoom_slider_hbox)

	var zoom_min_lbl := Label.new()
	zoom_min_lbl.text = "70%"
	UIKit.style_label(zoom_min_lbl, 14, Color(0.75, 0.84, 0.95), 3)
	zoom_slider_hbox.add_child(zoom_min_lbl)

	var zoom_slider := HSlider.new()
	zoom_slider.name = "ZoomSlider"
	zoom_slider.min_value = 0.70
	zoom_slider.max_value = 1.50
	zoom_slider.step = 0.01
	zoom_slider.value = setting_game_zoom
	zoom_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	zoom_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	UIKit.style_slider(zoom_slider)
	zoom_slider_hbox.add_child(zoom_slider)

	var zoom_max_lbl := Label.new()
	zoom_max_lbl.text = "150%"
	UIKit.style_label(zoom_max_lbl, 14, Color(0.75, 0.84, 0.95), 3)
	zoom_slider_hbox.add_child(zoom_max_lbl)

	zoom_slider.value_changed.connect(func(new_val: float):
		setting_game_zoom = clampf(new_val, 0.70, 1.50)
		zoom_pct_lbl.text = "%d %%" % int(round(setting_game_zoom * 100.0))
		_apply_game_zoom()
		_save_progress()
	)

	zoom_reset_btn.pressed.connect(func():
		setting_game_zoom = 1.0
		zoom_slider.value = 1.0
		zoom_pct_lbl.text = "100 %"
		_apply_game_zoom()
		_save_progress()
		_play_tap_audio()
	)

	settings_options_vbox.add_child(zoom_card)

	# 2. Sound Volume Row
	var sfx_card := PanelContainer.new()
	UIKit.style_panel(sfx_card, "card", 18.0, 12.0)
	var sfx_hbox := HBoxContainer.new()
	sfx_hbox.add_theme_constant_override("separation", 12)
	sfx_card.add_child(sfx_hbox)
	var sfx_lbl := Label.new()
	sfx_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sfx_lbl.text = "🔊 Sound-Lautstärke"
	UIKit.style_label(sfx_lbl, 19, Color.WHITE, 5)
	sfx_hbox.add_child(sfx_lbl)
	var sfx_btn := Button.new()
	sfx_btn.custom_minimum_size = Vector2(150, 46)
	var pct_int := int(round(setting_sfx_volume * 100.0))
	sfx_btn.text = "Stumm (0%)" if pct_int <= 0 else ("%d %%" % pct_int)
	UIKit.style_button(sfx_btn, "green" if pct_int > 0 else "gray", 18, 18, 14.0, 6.0)
	sfx_btn.pressed.connect(func():
		if setting_sfx_volume > 0.85:
			setting_sfx_volume = 0.7
		elif setting_sfx_volume > 0.5:
			setting_sfx_volume = 0.35
		elif setting_sfx_volume > 0.1:
			setting_sfx_volume = 0.0
		else:
			setting_sfx_volume = 1.0
		_apply_user_settings()
		_play_tap_audio()
		_save_progress()
		_populate_settings_modal()
	)
	sfx_hbox.add_child(sfx_btn)
	settings_options_vbox.add_child(sfx_card)

	# 3. Particles & Background Effects Row
	var part_card := PanelContainer.new()
	UIKit.style_panel(part_card, "card", 18.0, 12.0)
	var part_hbox := HBoxContainer.new()
	part_hbox.add_theme_constant_override("separation", 12)
	part_card.add_child(part_hbox)
	var part_lbl := Label.new()
	part_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	part_lbl.text = "✨ Partikel & Welt-Effekte"
	UIKit.style_label(part_lbl, 19, Color.WHITE, 5)
	part_hbox.add_child(part_lbl)
	var part_btn := Button.new()
	part_btn.custom_minimum_size = Vector2(150, 46)
	part_btn.text = "Aktiviert ✓" if setting_particles_enabled else "Aus"
	UIKit.style_button(part_btn, "green" if setting_particles_enabled else "gray", 18, 18, 14.0, 6.0)
	part_btn.pressed.connect(func():
		setting_particles_enabled = not setting_particles_enabled
		_apply_user_settings()
		_save_progress()
		_populate_settings_modal()
	)
	part_hbox.add_child(part_btn)
	settings_options_vbox.add_child(part_card)

	# 3. Shake Intensity Row
	var shake_card := PanelContainer.new()
	UIKit.style_panel(shake_card, "card", 18.0, 12.0)
	var shake_hbox := HBoxContainer.new()
	shake_hbox.add_theme_constant_override("separation", 12)
	shake_card.add_child(shake_hbox)
	var shake_lbl := Label.new()
	shake_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shake_lbl.text = "🥚 Schüttel-Animationen"
	UIKit.style_label(shake_lbl, 19, Color.WHITE, 5)
	shake_hbox.add_child(shake_lbl)
	var shake_btn := Button.new()
	shake_btn.custom_minimum_size = Vector2(150, 46)
	shake_btn.text = "Sanft" if setting_reduced_shake else "Dynamisch"
	UIKit.style_button(shake_btn, "blue" if setting_reduced_shake else "orange", 18, 18, 14.0, 6.0)
	shake_btn.pressed.connect(func():
		setting_reduced_shake = not setting_reduced_shake
		_save_progress()
		_populate_settings_modal()
	)
	shake_hbox.add_child(shake_btn)
	settings_options_vbox.add_child(shake_card)

	# 4. Player Stats Summary Card
	var stats_card := PanelContainer.new()
	UIKit.style_panel(stats_card, "inset", 18.0, 12.0)
	var stats_lbl := Label.new()
	var total_slimes: int = 0
	for s in SLIME_CATALOG:
		total_slimes += int(slime_counts.get(s["id"], 0))
	stats_lbl.text = "📊 Statistik:\nGesamte Klicks: %s  |  Geschlüpfte Slimes: %d\nEffektive Klickkraft: %dx  |  Glücks-Stufe: %s" % [
		_format_number(total_lifetime_clicks),
		total_slimes,
		get_effective_click_power(),
		LUCK_TABLES.get(active_luck_upgrade, LUCK_TABLES["base"])["name"]
	]
	stats_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIKit.style_label(stats_lbl, 16, Color(0.86, 0.94, 1.0), 4)
	stats_card.add_child(stats_lbl)
	settings_options_vbox.add_child(stats_card)

	# 5. Quick button to open Main Menu from Settings
	var to_menu_btn := Button.new()
	to_menu_btn.custom_minimum_size = Vector2(260, 50)
	to_menu_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	to_menu_btn.text = "🏠 Zum Hauptmenü"
	UIKit.style_button(to_menu_btn, "purple", 19, 20, 18.0, 8.0)
	to_menu_btn.pressed.connect(func():
		_close_settings()
		_open_main_menu()
	)
	settings_options_vbox.add_child(to_menu_btn)

func _apply_game_zoom() -> void:
	_update_responsive_layout()

func _apply_user_settings() -> void:
	if world_backdrop:
		world_backdrop.particles_enabled = setting_particles_enabled
	if side_click_fx:
		side_click_fx.effects_enabled = setting_particles_enabled
	_apply_audio_state(_yt_audio_allowed)

# --- Responsive Layout & Centered Egg Guarantee ---

func _on_viewport_size_changed() -> void:
	_update_responsive_layout()

func _update_responsive_layout() -> void:
	var vp_size = get_viewport().get_visible_rect().size
	# Defense against 0x0 initial viewport height in YouTube WebView / Test Suite
	if vp_size.x <= 0 or vp_size.y <= 0:
		return

	var zoom: float = clampf(setting_game_zoom, 0.70, 1.50)

	var is_compact = vp_size.x < 720.0
	var is_tiny = vp_size.x < 580.0

	var safe_top: float = max(68.0, 52.0 * zoom)
	var safe_bottom: float = max(24.0, 24.0 * zoom)
	var safe_side: float = 16.0 if is_compact else 28.0

	if safe_container:
		safe_container.anchor_left = 0.0
		safe_container.anchor_top = 0.0
		safe_container.anchor_right = 1.0
		safe_container.anchor_bottom = 1.0
		safe_container.offset_left = safe_side
		safe_container.offset_top = safe_top
		safe_container.offset_right = -safe_side
		safe_container.offset_bottom = -safe_bottom

	var play_w = max(260.0, vp_size.x - safe_side * 2.0)
	var play_h = max(260.0, vp_size.y - safe_top - safe_bottom)

	if pet_companion and pet_companion.visible:
		pet_companion.scale = Vector2(zoom, zoom)
		pet_companion.position = Vector2(maxf(10.0, (vp_size.x * 0.5) - 250.0 * zoom), (vp_size.y * 0.5) + 60.0 * zoom)

	# Buttons & HUD Scaling according to Game Zoom (Buttons and Egg bigger!)
	var btn_h = (42.0 if is_tiny else (46.0 if is_compact else 50.0)) * zoom
	var btn_font = int(round((13 if is_tiny else (15 if is_compact else 17)) * zoom))
	var pill_font = int(round((15 if is_tiny else (17 if is_compact else 21)) * zoom))

	if menu_btn:
		menu_btn.custom_minimum_size = Vector2((80.0 if is_tiny else (96.0 if is_compact else 114.0)) * zoom, btn_h)
		menu_btn.add_theme_font_size_override("font_size", btn_font)
	if collection_btn:
		collection_btn.custom_minimum_size = Vector2((100.0 if is_tiny else (120.0 if is_compact else 144.0)) * zoom, btn_h)
		collection_btn.add_theme_font_size_override("font_size", btn_font)
	if eggs_hud_btn:
		eggs_hud_btn.custom_minimum_size = Vector2((74.0 if is_tiny else (86.0 if is_compact else 96.0)) * zoom, btn_h)
		eggs_hud_btn.add_theme_font_size_override("font_size", btn_font)
	if shop_btn:
		shop_btn.custom_minimum_size = Vector2((90.0 if is_tiny else (106.0 if is_compact else 126.0)) * zoom, btn_h)
	if shop_coin_hint:
		shop_coin_hint.add_theme_font_size_override("font_size", int(round(18 * zoom)))
	if settings_btn:
		settings_btn.custom_minimum_size = Vector2((46.0 if is_tiny else (48.0 if is_compact else 52.0)) * zoom, btn_h)
	if pets_hud_btn:
		pets_hud_btn.custom_minimum_size = Vector2((74.0 if is_tiny else (86.0 if is_compact else 96.0)) * zoom, btn_h)
		pets_hud_btn.add_theme_font_size_override("font_size", btn_font)
	if counter_pill:
		counter_pill.custom_minimum_size = Vector2((80.0 if is_tiny else (90.0 if is_compact else 98.0)) * zoom, btn_h)
	if counter_label:
		counter_label.add_theme_font_size_override("font_size", pill_font)
	if coin_pill:
		coin_pill.custom_minimum_size = Vector2((92.0 if is_tiny else (104.0 if is_compact else 116.0)) * zoom, btn_h)
	if coin_label:
		coin_label.add_theme_font_size_override("font_size", pill_font)

	if power_pill:
		power_pill.visible = true
	if power_badge_label:
		power_badge_label.add_theme_font_size_override("font_size", int(round(14 * zoom)))

	# Header positioning below top bar so it never collides with buttons
	if header_container:
		header_container.offset_top = (58.0 if is_compact else 54.0) * zoom
		header_container.offset_bottom = header_container.offset_top + ((150.0 if is_compact else 164.0) * zoom)
	if title_line1:
		title_line1.add_theme_font_size_override("font_size", int(round((28 if is_compact else 36) * zoom)))
	if title_line2:
		title_line2.add_theme_font_size_override("normal_font_size", int(round((20 if is_compact else 26) * zoom)))
		title_line2.add_theme_font_size_override("bold_font_size", int(round((20 if is_compact else 26) * zoom)))

	# Center Egg scaling: EggCenterAnchor stays strictly at (0.5, 0.5) of SafeContainer (screen center)
	if egg_anchor:
		var reserved_vertical = (280.0 if is_compact else 270.0) * min(zoom, 1.15)
		var avail_h = max(180.0, play_h - reserved_vertical)
		var avail_w = max(180.0, play_w * 0.85)
		var target_egg_h = min(avail_h * 0.82, avail_w * 0.90)
		target_egg_h = clampf(target_egg_h, 200.0, 520.0)
		var scale_factor = (target_egg_h / 520.0) * zoom
		_egg_base_scale = Vector2(scale_factor, scale_factor)
		egg_anchor.scale = _egg_base_scale

	# Responsive width for bottom progress bar
	if progress_pill:
		var bar_w = clampf(play_w * 0.82, 280.0, 640.0) * min(zoom, 1.25)
		progress_pill.offset_left = -bar_w * 0.5
		progress_pill.offset_right = bar_w * 0.5
		progress_pill.offset_top = -84.0 * zoom
		progress_pill.offset_bottom = -6.0
	if progress_label:
		progress_label.add_theme_font_size_override("font_size", int(round((21 if is_compact else 26) * zoom)))

	# Adapt modal card sizes on compact screens (modals sized relative to window)
	var modal_w: float = clampf(vp_size.x - 32.0, 320.0, 580.0)
	var modal_h: float = clampf(vp_size.y - 48.0, 420.0, 640.0)
	if shop_panel:
		shop_panel.custom_minimum_size = Vector2(modal_w, modal_h)
	if collection_panel:
		collection_panel.custom_minimum_size = Vector2(modal_w, modal_h)
	if settings_panel:
		settings_panel.custom_minimum_size = Vector2(minf(modal_w, 520.0), minf(modal_h, 560.0))
	if menu_card:
		menu_card.custom_minimum_size = Vector2(minf(modal_w, 560.0), minf(modal_h, 640.0))
	if drop_card:
		drop_card.custom_minimum_size = Vector2(minf(modal_w, 490.0), minf(modal_h, 560.0))
	if pet_modal_panel:
		var pet_w: float = clampf(vp_size.x - 20.0, 340.0, 740.0)
		var pet_h: float = clampf(vp_size.y - 24.0, 440.0, 720.0)
		pet_modal_panel.offset_left = -pet_w * 0.5
		pet_modal_panel.offset_right = pet_w * 0.5
		pet_modal_panel.offset_top = -pet_h * 0.5
		pet_modal_panel.offset_bottom = pet_h * 0.5
		call_deferred("_layout_wheel_stage")

# --- Click Processing & Multiplier Calculation ---

func get_base_click_power() -> int:
	if "click_5x" in owned_click_upgrades and active_click_upgrade == "click_5x":
		return 5
	if "click_3x" in owned_click_upgrades and active_click_upgrade == "click_3x":
		return 3
	if "click_2x" in owned_click_upgrades and active_click_upgrade == "click_2x":
		return 2
	return 1

func get_booster_multiplier() -> int:
	var mult: int = 1
	if booster_2x_time > 0.0:
		mult *= 2
	if booster_5x_time > 0.0:
		mult *= 5
	return mult

func get_effective_click_power() -> int:
	var base = get_base_click_power()
	# Pet click power bonus (e.g. Sproutling, Pebble Golem, Forest Stag)
	if not equipped_pet_id.is_empty():
		var p_data = PetData.get_pet_by_id(equipped_pet_id)
		base += int(p_data.get("click_power_add", 0))

	var total = base * get_booster_multiplier()

	# Pet Critical Click Chance (e.g. Diamond Sovereign)
	if not equipped_pet_id.is_empty():
		var p_data = PetData.get_pet_by_id(equipped_pet_id)
		var crit_chance = float(p_data.get("crit_chance", 0.0))
		if crit_chance > 0.0 and _rng.randf() < crit_chance:
			total *= 4

	return total

func _on_egg_gui_input(event: InputEvent) -> void:
	if is_hatched or _is_any_modal_open():
		return

	var is_click: bool = false
	var click_pos: Vector2 = Vector2.ZERO

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_click = true
		click_pos = event.position
	elif event is InputEventScreenTouch and event.pressed:
		is_click = true
		click_pos = event.position

	if is_click:
		get_viewport().set_input_as_handled()
		var gain = get_effective_click_power()
		_apply_effective_clicks(gain, click_pos, true)

func _apply_effective_clicks(gain: int, local_pos: Vector2, is_manual: bool) -> void:
	if is_hatched or is_revealing_drop or current_clicks >= target_clicks:
		return

	var prev_clicks = current_clicks
	current_clicks = mini(target_clicks, current_clicks + gain)
	var actual_added = current_clicks - prev_clicks
	total_lifetime_clicks += actual_added
	_sync_active_egg_to_dict()

	if is_manual:
		var coin_gain = 1 + (4 if (total_lifetime_clicks % 10 == 0) else 0)
		if not equipped_pet_id.is_empty():
			var p_data = PetData.get_pet_by_id(equipped_pet_id)
			var mult = float(p_data.get("coin_mult", 0.0))
			if mult > 0.0:
				coin_gain = int(ceil(float(coin_gain) * (1.0 + mult)))
		coins += coin_gain
		_click_streak = mini(35, _click_streak + 1)
		_streak_decay_timer = 1.25
		_play_tap_audio()

	_play_click_animation(is_manual)
	if pet_companion and pet_companion.visible:
		pet_companion.on_egg_clicked()
	_spawn_floating_text(local_pos, "+%d" % actual_added)
	if is_manual:
		_spawn_click_sparks(local_pos)
		if side_click_fx:
			side_click_fx.trigger_click_effect(_click_streak, equipped_particle_style)

	if crack_overlay:
		crack_overlay.set_clicks(current_clicks, target_clicks)
		crack_overlay.trigger_click_shake()

	_check_milestone_crossings(prev_clicks, current_clicks)

	_save_dirty = true
	_update_hud()

	if current_clicks >= target_clicks:
		_trigger_grand_finale()

func _play_click_animation(is_manual: bool = true) -> void:
	if not egg_visual:
		return
	if _egg_tween and _egg_tween.is_valid():
		_egg_tween.kill()

	egg_visual.position = Vector2.ZERO
	egg_visual.rotation = 0.0
	egg_visual.scale = Vector2.ONE

	_egg_tween = create_tween()

	var ratio: float = float(current_clicks) / float(maxi(1, target_clicks))
	var shake_mult: float = 0.45 if setting_reduced_shake else 1.0
	var rot_amp: float = (0.036 if is_manual else 0.018) * shake_mult
	var pos_amp: float = (4.2 if is_manual else 2.0) * shake_mult
	if ratio >= 0.90:
		rot_amp = 0.078 * shake_mult
		pos_amp = 8.5 * shake_mult
	elif ratio >= 0.50:
		rot_amp = 0.052 * shake_mult
		pos_amp = 5.6 * shake_mult

	var dir_sign = 1.0 if (_rng.randf() > 0.5) else -1.0

	egg_visual.scale = Vector2(1.045, 0.94)
	egg_visual.rotation = rot_amp * dir_sign
	egg_visual.position = Vector2(pos_amp * dir_sign, 2.0)

	_egg_tween.tween_property(egg_visual, "rotation", -rot_amp * 0.6 * dir_sign, 0.055)
	_egg_tween.parallel().tween_property(egg_visual, "position", Vector2(-pos_amp * 0.5 * dir_sign, 0.0), 0.055)
	_egg_tween.parallel().tween_property(egg_visual, "scale", Vector2(0.98, 1.02), 0.055)

	_egg_tween.tween_property(egg_visual, "rotation", 0.0, 0.09).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_egg_tween.parallel().tween_property(egg_visual, "position", Vector2.ZERO, 0.09).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_egg_tween.parallel().tween_property(egg_visual, "scale", Vector2.ONE, 0.09).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _check_milestone_crossings(prev_c: int, new_c: int) -> void:
	var t_f: float = float(maxi(1, target_clicks))
	var prev_pct: float = (float(prev_c) / t_f) * 100.0
	var new_pct: float = (float(new_c) / t_f) * 100.0

	if prev_pct < 10.0 and new_pct >= 10.0 and not milestones_claimed.get(10, false):
		milestones_claimed[10] = true
		coins += 75
		_show_milestone("10% GESCHAFFT! ERSTE RISSE! (+75 Münzen)")
		_play_crack_sound()
		_play_milestone_shake(5.0, 5)
		if side_click_fx:
			side_click_fx.trigger_milestone_effect(10)
		if fancy_bar:
			fancy_bar.trigger_milestone_flash(0.8)
	elif prev_pct < 25.0 and new_pct >= 25.0 and not milestones_claimed.get(25, false):
		milestones_claimed[25] = true
		coins += 150
		_show_milestone("25% GESCHAFFT! (+150 Münzen)")
		_play_crack_sound()
		_play_milestone_shake(6.5, 6)
		if side_click_fx:
			side_click_fx.trigger_milestone_effect(25)
		if fancy_bar:
			fancy_bar.trigger_milestone_flash(0.9)
	elif prev_pct < 50.0 and new_pct >= 50.0 and not milestones_claimed.get(50, false):
		milestones_claimed[50] = true
		coins += 300
		pet_tokens += 1
		_show_milestone("50% GESCHAFFT! (+300 Münzen & 🎟️ 1x Glücksrad-Ticket!)")
		_play_crack_sound()
		_play_milestone_shake(9.0, 8)
		if side_click_fx:
			side_click_fx.trigger_milestone_effect(50)
		if fancy_bar:
			fancy_bar.trigger_milestone_flash(1.1)
		_save_progress()
	elif prev_pct < 75.0 and new_pct >= 75.0 and not milestones_claimed.get(75, false):
		milestones_claimed[75] = true
		coins += 500
		_show_milestone("75% GESCHAFFT! HALTE DURCH! (+500 Münzen)")
		_play_crack_sound()
		_play_milestone_shake(11.0, 9)
		if side_click_fx:
			side_click_fx.trigger_milestone_effect(75)
		if fancy_bar:
			fancy_bar.trigger_milestone_flash(1.2)
		_save_progress()
	elif prev_pct < 90.0 and new_pct >= 90.0 and not milestones_claimed.get(90, false):
		milestones_claimed[90] = true
		coins += 750
		_show_milestone("90% GESCHAFFT! GLEICH BRICHT ES AUF! (+750 Münzen)")
		_play_crack_sound()
		_play_milestone_shake(14.0, 10)
		if side_click_fx:
			side_click_fx.trigger_milestone_effect(90)
		if fancy_bar:
			fancy_bar.trigger_milestone_flash(1.3)
		_save_progress()
	elif new_c == target_clicks - 1:
		_show_milestone("FAST OFFEN! NOCH EIN EINZIGER KLICK!")
		_play_crack_sound()
		_play_milestone_shake(16.0, 14)
		if side_click_fx:
			side_click_fx.trigger_milestone_effect(99)
		if fancy_bar:
			fancy_bar.trigger_milestone_flash(1.5)

func _play_milestone_shake(amplitude: float, steps: int = 8) -> void:
	if not egg_visual:
		return
	if _egg_tween and _egg_tween.is_valid():
		_egg_tween.kill()
	egg_visual.position = Vector2.ZERO
	egg_visual.rotation = 0.0
	egg_visual.scale = Vector2.ONE

	var mult: float = 0.45 if setting_reduced_shake else 1.0
	var amp: float = amplitude * mult

	_egg_tween = create_tween()
	for i in range(steps):
		var s = 1.0 if (i % 2 == 0) else -1.0
		var decay = 1.0 - (float(i) / float(steps)) * 0.5
		var off = Vector2(amp * s * decay, _rng.randf_range(-amp * 0.4, amp * 0.4))
		var rot = 0.08 * s * decay * mult
		_egg_tween.tween_property(egg_visual, "position", off, 0.028)
		_egg_tween.parallel().tween_property(egg_visual, "rotation", rot, 0.028)
	_egg_tween.tween_property(egg_visual, "position", Vector2.ZERO, 0.05)
	_egg_tween.parallel().tween_property(egg_visual, "rotation", 0.0, 0.05)

func _show_milestone(msg: String) -> void:
	if not milestone_banner or not milestone_label:
		return
	milestone_label.text = msg
	if _banner_tween and _banner_tween.is_valid():
		_banner_tween.kill()
	_banner_tween = create_tween()
	milestone_banner.scale = Vector2(0.85, 0.85)
	_banner_tween.tween_property(milestone_banner, "modulate:a", 1.0, 0.18)
	_banner_tween.parallel().tween_property(milestone_banner, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_banner_tween.tween_interval(2.4)
	_banner_tween.tween_property(milestone_banner, "modulate:a", 0.0, 0.28)

func _spawn_floating_text(pos: Vector2, text: String) -> void:
	if not fx_container or not setting_particles_enabled:
		return
	var label = Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UIKit.style_label(label, 26, Color(1.0, 0.90, 0.18), 7, Color(0.10, 0.06, 0.02))

	fx_container.add_child(label)
	label.position = pos + Vector2(_rng.randf_range(-26, 26), -20)

	var tw = create_tween().set_parallel(true)
	tw.tween_property(label, "position:y", label.position.y - 56.0, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(label, "modulate:a", 0.0, 0.45).set_delay(0.1)
	tw.chain().tween_callback(label.queue_free)

func _spawn_click_sparks(pos: Vector2) -> void:
	if not fx_container or not setting_particles_enabled:
		return
	for i in range(5):
		var spark = ColorRect.new()
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		spark.custom_minimum_size = Vector2(8, 8)
		spark.size = Vector2(8, 8)
		spark.pivot_offset = Vector2(4, 4)
		spark.rotation = _rng.randf_range(0.0, TAU)

		match equipped_particle_style:
			"part_cyan":
				spark.color = Color(0.25, 0.92, 1.0) if (i % 2 == 0) else Color(0.75, 0.98, 1.0)
			"part_rainbow":
				spark.color = Color.from_hsv(float(i) / 5.0, 0.85, 1.0)
			_:
				if active_egg_id == "crystal":
					spark.color = Color(0.32, 0.95, 1.0) if (i % 2 == 0) else Color(0.82, 0.99, 1.0)
				elif active_egg_id == "cosmic":
					spark.color = Color(0.92, 0.35, 1.0) if (i % 2 == 0) else Color(0.35, 0.95, 1.0)
				else:
					spark.color = Color(0.45, 0.98, 0.55) if (i % 2 == 0) else Color(1.0, 0.92, 0.35)

		fx_container.add_child(spark)
		spark.position = pos - Vector2(4, 4)

		var angle = _rng.randf_range(0.0, TAU)
		var dist = _rng.randf_range(28.0, 68.0)
		var target = spark.position + Vector2(cos(angle), sin(angle)) * dist

		var tw = create_tween().set_parallel(true)
		tw.tween_property(spark, "position", target, 0.26).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tw.tween_property(spark, "scale", Vector2.ZERO, 0.26)
		tw.chain().tween_callback(spark.queue_free)

# --- Epic Drop System & Finale (Section 6 & 7) ---

func _roll_slime_rarity(for_egg_id: String = "") -> Dictionary:
	var target_egg: String = active_egg_id if for_egg_id.is_empty() else for_egg_id
	var table_id = active_luck_upgrade if LUCK_TABLES.has(active_luck_upgrade) else "base"
	var chances: Dictionary = LUCK_TABLES[table_id]["chances"]

	# Step 1: Roll Rarity Tier according to normalized 100.0% distribution
	var roll: float = _rng.randf_range(0.0, 100.0)
	var cumulative: float = 0.0
	var chosen_rarity: String = "common"
	for r_key in EggWorldData.RARITY_ORDER:
		cumulative += maxf(0.0, float(chances.get(r_key, 0.0)))
		if roll <= cumulative:
			chosen_rarity = r_key
			break

	# Step 2: Pick the Slime belonging strictly to `target_egg` and `chosen_rarity`
	return EggWorldData.get_slime_by_egg_and_rarity(target_egg, chosen_rarity)

func _trigger_grand_finale() -> void:
	if is_revealing_drop or reward_claimed_for_current_egg:
		return

	current_clicks = target_clicks
	is_hatched = true
	is_revealing_drop = true
	reward_claimed_for_current_egg = true

	if egg_select_overlay:
		egg_select_overlay.visible = false
	if shop_overlay:
		shop_overlay.visible = false
	if collection_overlay:
		collection_overlay.visible = false
	if settings_overlay:
		settings_overlay.visible = false
	if main_menu_overlay:
		main_menu_overlay.visible = false

	if fancy_bar:
		fancy_bar.set_progress(target_clicks, true, target_clicks)
		fancy_bar.trigger_milestone_flash(1.5)

	# 1. Roll Slime from the active egg's table immediately
	var dropped_slime: Dictionary = _roll_slime_rarity(active_egg_id)
	var sid: String = dropped_slime["id"]
	var r_tier: String = dropped_slime["rarity"]
	last_hatched_slime_id = sid

	var is_first_unlock: bool = (int(slime_counts.get(sid, 0)) == 0)
	slime_counts[sid] = int(slime_counts.get(sid, 0)) + 1
	slime_unseen[sid] = true

	var coin_reward: int = int(dropped_slime["reward_coins"])
	if not equipped_pet_id.is_empty():
		var p_data = PetData.get_pet_by_id(equipped_pet_id)
		var mult = float(p_data.get("coin_mult", 0.0))
		if mult > 0.0:
			coin_reward = int(ceil(float(coin_reward) * (1.0 + mult)))
	coins += coin_reward

	# Award 1 Pet Wheel Ticket per successfully opened egg (Section 3: "Für jede erfolgreiche Eiöffnung erhält der Spieler ein Glücksrad-Ticket.")
	pet_tokens += 1
	_show_milestone("🎟️ +1 GLÜCKSRAD-TICKET GEWONNEN!")

	# Update per-egg drop count & check sequential egg unlock (Nature -> Crystal -> Cosmic)
	# IMPORTANT (Section 4): Never auto-select the newly unlocked egg!
	var newly_unlocked_egg_name: String = ""
	if egg_states.has(active_egg_id):
		egg_states[active_egg_id]["drops_count"] = int(egg_states[active_egg_id].get("drops_count", 0)) + 1
	if active_egg_id == "nature" and egg_states.has("crystal") and not bool(egg_states["crystal"].get("unlocked", false)):
		egg_states["crystal"]["unlocked"] = true
		egg_unseen_unlocks["crystal"] = true
		newly_unlocked_egg_name = "Crystal Egg"
	elif active_egg_id == "crystal" and egg_states.has("cosmic") and not bool(egg_states["cosmic"].get("unlocked", false)):
		egg_states["cosmic"]["unlocked"] = true
		egg_unseen_unlocks["cosmic"] = true
		newly_unlocked_egg_name = "Cosmic Egg"

	_sync_active_egg_to_dict()
	_save_progress()
	_update_hud()

	if not newly_unlocked_egg_name.is_empty():
		_show_milestone("🔓 NEUES EI FREIGESCHALTET: %s!" % newly_unlocked_egg_name.to_upper())

	# 2. World-specific environment dimming (extra dark for Cosmic Egg)
	if drop_dim_scrim:
		drop_dim_scrim.visible = true
		drop_dim_scrim.modulate.a = 0.0
		var target_dim: float = 0.82 if active_egg_id == "cosmic" else 0.68
		var dim_tw = create_tween()
		dim_tw.tween_property(drop_dim_scrim, "modulate:a", target_dim, 0.35)

	# 3. Pre-rupture shake + world-specific energy gathering particles
	if _egg_tween and _egg_tween.is_valid():
		_egg_tween.kill()
	if egg_visual:
		egg_visual.position = Vector2.ZERO
		egg_visual.rotation = 0.0

	if side_click_fx:
		side_click_fx.trigger_milestone_effect(99)

	if egg_visual:
		var shake_steps = 16 if r_tier in ["legendary", "mythic", "epic"] else 12
		var shake_tw = create_tween()
		for i in range(shake_steps):
			var s = 1.0 if (i % 2 == 0) else -1.0
			var amp = 14.0 + float(i) * 0.6
			shake_tw.tween_property(egg_visual, "position", Vector2(amp * s, _rng.randf_range(-8, 8)), 0.028)
			shake_tw.parallel().tween_property(egg_visual, "rotation", 0.11 * s, 0.028)
		shake_tw.tween_property(egg_visual, "position", Vector2.ZERO, 0.03)
		shake_tw.parallel().tween_property(egg_visual, "rotation", 0.0, 0.03)
		await shake_tw.finished

	# 4. Hide egg shell & explode world-matched shards + light pulse
	if egg_visual:
		egg_visual.visible = false

	_spawn_shell_explosion()

	if shatter_player and not AudioServer.is_bus_mute(0):
		shatter_player.play()

	if flash_overlay:
		flash_overlay.visible = true
		var w_col: Color = EGG_WORLDS.get(active_egg_id, EGG_WORLDS["nature"])["accent_color"]
		flash_overlay.color = dropped_slime["color"].lerp(w_col, 0.35)
		flash_overlay.modulate.a = 0.78
		var f_tw = create_tween()
		f_tw.tween_property(flash_overlay, "modulate:a", 0.0, 0.45)
		f_tw.tween_callback(func(): flash_overlay.visible = false)

	if get_tree():
		await get_tree().create_timer(0.35).timeout

	# 5. Open Epic Drop Reveal Menu
	_present_drop_reveal_menu(dropped_slime, is_first_unlock, coin_reward, newly_unlocked_egg_name)

func _present_drop_reveal_menu(slime_data: Dictionary, is_first_unlock: bool, coin_reward: int, unlocked_egg_notice: String = "") -> void:
	if not drop_overlay:
		return

	var sid: String = slime_data["id"]
	var r_tier: String = slime_data.get("rarity", "common")
	var r_color: Color = slime_data["color"]
	var origin_egg_id: String = slime_data.get("egg_id", active_egg_id)
	var origin_egg_name: String = EGG_WORLDS.get(origin_egg_id, EGG_WORLDS["nature"])["name"]

	drop_overlay.visible = true
	drop_overlay.modulate.a = 0.0

	if drop_effect:
		drop_effect.start_reveal(r_tier, equipped_reveal_aura == "aura_supernova" or origin_egg_id == "cosmic")

	if drop_header_label:
		if not unlocked_egg_notice.is_empty():
			drop_header_label.text = "EI GEKNACKT! + %s FREIGESCHALTET!" % unlocked_egg_notice.to_upper()
		else:
			drop_header_label.text = "GESCHAFFT! %s GEÖFFNET!" % origin_egg_name.to_upper()

	if drop_rarity_label:
		var table_chances: Dictionary = LUCK_TABLES.get(active_luck_upgrade, LUCK_TABLES["base"])["chances"]
		var pct: float = float(table_chances.get(r_tier, slime_data["base_chance"]))
		drop_rarity_label.text = "★ %s (%s%%) • %s ★" % [slime_data["rarity_name"], _format_pct(pct), origin_egg_name]
		drop_rarity_label.add_theme_color_override("font_color", r_color)

	if drop_slime_icon:
		drop_slime_icon.texture = load(slime_data["path"])
		drop_slime_icon.scale = Vector2(0.15, 0.15)

	if drop_new_tag:
		drop_new_tag.visible = is_first_unlock

	if drop_slime_name:
		drop_slime_name.text = slime_data["name"]
		drop_slime_name.add_theme_color_override("font_color", r_color.lightened(0.25))

	if drop_slime_desc:
		drop_slime_desc.text = "%s\nHerkunft: %s • Ziel: %s / %s Klicks (100 %%) • Im Inventar: %dx" % [
			slime_data["desc"],
			origin_egg_name,
			_format_number(target_clicks),
			_format_number(target_clicks),
			int(slime_counts.get(sid, 1))
		]

	if drop_reward_label:
		drop_reward_label.text = "+%s Münzen Belohnung!" % _format_number(int(coin_reward))

	if drop_confirm_btn:
		drop_confirm_btn.disabled = true
		drop_confirm_btn.text = "Belohnung einsammeln & Pet-Glücksrad drehen 🎡"

	drop_card.scale = Vector2(0.65, 0.65)
	var entrance_dur = 0.55 if r_tier in ["legendary", "mythic"] else 0.35
	var tw = create_tween().set_parallel(true)
	tw.tween_property(drop_overlay, "modulate:a", 1.0, 0.25)
	tw.tween_property(drop_card, "scale", Vector2.ONE, entrance_dur).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if drop_slime_icon:
		tw.tween_property(drop_slime_icon, "scale", Vector2.ONE, entrance_dur + 0.1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	if _slime_float_tween and _slime_float_tween.is_valid():
		_slime_float_tween.kill()
	if drop_slime_icon:
		var holder_w: float = drop_slime_holder.size.x if (drop_slime_holder and drop_slime_holder.size.x > 0.0) else 260.0
		var holder_h: float = drop_slime_holder.size.y if (drop_slime_holder and drop_slime_holder.size.y > 0.0) else 220.0
		var icon_w: float = drop_slime_icon.size.x if drop_slime_icon.size.x > 0.0 else 190.0
		var icon_h: float = drop_slime_icon.size.y if drop_slime_icon.size.y > 0.0 else 190.0
		var slime_base_x: float = (holder_w - icon_w) * 0.5
		var slime_base_y: float = (holder_h - icon_h) * 0.5
		drop_slime_icon.position = Vector2(slime_base_x, slime_base_y)
		_slime_float_tween = create_tween().set_loops()
		_slime_float_tween.tween_property(drop_slime_icon, "position:y", slime_base_y - 10.0, 0.85).set_trans(Tween.TRANS_SINE)
		_slime_float_tween.tween_property(drop_slime_icon, "position:y", slime_base_y, 0.85).set_trans(Tween.TRANS_SINE)

	await tw.finished
	if drop_confirm_btn:
		drop_confirm_btn.disabled = false

func _restore_hatched_view() -> void:
	if egg_visual:
		egg_visual.visible = false
	if drop_dim_scrim:
		drop_dim_scrim.visible = true
		drop_dim_scrim.modulate.a = 0.65
	var s_data = _get_slime_by_id(last_hatched_slime_id)
	_present_drop_reveal_menu(s_data, false, int(s_data["reward_coins"]))

func _on_confirm_drop_pressed() -> void:
	# Start a fresh round for the active egg and roll a new random click target (1,000..10,000)
	if _slime_float_tween and _slime_float_tween.is_valid():
		_slime_float_tween.kill()
	if drop_effect:
		drop_effect.stop_reveal()
	if drop_overlay:
		drop_overlay.visible = false
	if drop_dim_scrim:
		drop_dim_scrim.visible = false

	current_clicks = 0
	target_clicks = roll_click_target()
	is_hatched = false
	is_revealing_drop = false
	reward_claimed_for_current_egg = false
	milestones_claimed.clear()
	_click_streak = 0
	_sync_active_egg_to_dict()

	if egg_visual:
		egg_visual.visible = true
		egg_visual.position = Vector2.ZERO
		egg_visual.rotation = 0.0
		egg_visual.scale = Vector2.ONE
	if crack_overlay:
		crack_overlay.set_clicks(0, target_clicks)
	if fancy_bar:
		fancy_bar.set_progress(0, true, target_clicks)
	if side_click_fx:
		side_click_fx.clear_all()

	_save_progress()
	_update_hud()

	# Automatically open the Wheel of Companions after hatching an egg!
	_open_pet_modal()

func _spawn_shell_explosion() -> void:
	if not shard_container:
		return
	var shard_shapes = [
		PackedVector2Array([Vector2(-42, -38), Vector2(12, -52), Vector2(34, -18), Vector2(-12, -8)]),
		PackedVector2Array([Vector2(-22, -22), Vector2(42, -32), Vector2(52, 22), Vector2(0, 32)]),
		PackedVector2Array([Vector2(-52, 0), Vector2(0, -32), Vector2(32, 12), Vector2(-22, 42)]),
		PackedVector2Array([Vector2(-32, 12), Vector2(22, 0), Vector2(42, 52), Vector2(-12, 62)]),
		PackedVector2Array([Vector2(-42, -22), Vector2(22, -42), Vector2(12, 22), Vector2(-32, 12)]),
		PackedVector2Array([Vector2(0, -42), Vector2(42, -22), Vector2(32, 32), Vector2(-12, 22)])
	]
	var w_cfg: Dictionary = EGG_WORLDS.get(active_egg_id, EGG_WORLDS["nature"])
	var shell_col: Color = w_cfg["shell_color"] * _get_egg_skin_color(equipped_egg_skin)
	for i in range(14):
		var piece = ShellPiece.new()
		piece.polygon = shard_shapes[i % shard_shapes.size()]
		piece.color = shell_col
		var angle = (float(i) / 14.0) * TAU + _rng.randf_range(-0.18, 0.18)
		var speed = _rng.randf_range(400.0, 760.0)
		piece.velocity = Vector2(cos(angle), sin(angle)) * speed
		piece.velocity.y -= _rng.randf_range(120.0, 280.0)
		piece.angular_velocity = _rng.randf_range(-12.0, 12.0)
		shard_container.add_child(piece)

# --- Shop System ---

func _setup_shop_tabs() -> void:
	if not shop_tab_bar:
		return
	var tabs = [
		{ "id": "clicks", "label": "⚡ Klick-Kraft", "pal": "orange" },
		{ "id": "boosters", "label": "🚀 Booster", "pal": "blue" },
		{ "id": "luck", "label": "🍀 Glück", "pal": "green" },
		{ "id": "cosmetics", "label": "🎨 Kosmetik", "pal": "purple" }
	]
	for child in shop_tab_bar.get_children():
		child.queue_free()
	for t in tabs:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(118, 48)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.text = t["label"]
		var tab_id: String = t["id"]
		UIKit.style_button(btn, t["pal"], 17, 18, 10.0, 6.0)
		btn.pressed.connect(func(): _switch_shop_tab(tab_id))
		shop_tab_bar.add_child(btn)

func _open_shop(initial_tab: String = "") -> void:
	if is_revealing_drop:
		return
	if not initial_tab.is_empty():
		_current_shop_tab = initial_tab
	if egg_select_overlay:
		egg_select_overlay.visible = false
	if collection_overlay:
		collection_overlay.visible = false
	if settings_overlay:
		settings_overlay.visible = false
	if shop_feedback_label:
		shop_feedback_label.text = "Wähle ein Upgrade oder Hilfsmittel aus!"
		shop_feedback_label.add_theme_color_override("font_color", Color(0.85, 0.93, 1.0))
	_populate_shop_tab(_current_shop_tab)
	_update_hud()
	UIKit.open_overlay(shop_overlay, shop_panel)

func _close_shop() -> void:
	UIKit.close_overlay(shop_overlay, shop_panel)
	if _opened_from_main_menu:
		_opened_from_main_menu = false
		_open_main_menu()

func _switch_shop_tab(tab_id: String) -> void:
	_current_shop_tab = tab_id
	_populate_shop_tab(tab_id)

func _populate_shop_tab(tab_id: String) -> void:
	if not shop_items_vbox:
		return
	for child in shop_items_vbox.get_children():
		child.queue_free()

	# Show probability breakdown table when on "luck" tab
	if shop_odds_box:
		shop_odds_box.visible = (tab_id == "luck")
		if tab_id == "luck":
			_update_shop_odds_preview()

	var items: Array = SHOP_CATALOG.get(tab_id, [])
	for item in items:
		var card = _create_shop_item_card(tab_id, item)
		shop_items_vbox.add_child(card)

func _update_shop_odds_preview() -> void:
	if not shop_odds_label:
		return
	var active_tbl = LUCK_TABLES.get(active_luck_upgrade, LUCK_TABLES["base"])
	var ch: Dictionary = active_tbl["chances"]
	var txt = "[b]Aktive Drop-Wahrscheinlichkeiten (%s – Summe 100%%):[/b]\n" % active_tbl["name"]
	txt += "[color=#d1dbe8]Common: %s%%[/color] | [color=#47eb5c]Uncommon: %s%%[/color] | [color=#38c7ff]Rare: %s%%[/color] | [color=#c752ff]Epic: %s%%[/color] | [color=#ffd629]Legendary: %s%%[/color] | [color=#f238e6]Mythic: %s%%[/color]" % [
		_format_pct(ch["common"]),
		_format_pct(ch["uncommon"]),
		_format_pct(ch["rare"]),
		_format_pct(ch["epic"]),
		_format_pct(ch["legendary"]),
		_format_pct(ch["mythic"])
	]
	shop_odds_label.text = txt

func _create_shop_item_card(tab_id: String, item: Dictionary) -> PanelContainer:
	var card = PanelContainer.new()
	UIKit.style_panel(card, "card", 18.0, 14.0)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 14)
	card.add_child(hbox)

	var info_vbox = VBoxContainer.new()
	info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_vbox.add_theme_constant_override("separation", 4)
	hbox.add_child(info_vbox)

	var title_lbl = Label.new()
	title_lbl.text = item["title"]
	UIKit.style_label(title_lbl, 20, Color(1.0, 0.92, 0.42), 5, Color(0.08, 0.05, 0.02))
	info_vbox.add_child(title_lbl)

	var desc_lbl = Label.new()
	desc_lbl.text = item["desc"]
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIKit.style_label(desc_lbl, 15, Color(0.88, 0.93, 1.0), 3, Color(0.04, 0.07, 0.16), false)
	info_vbox.add_child(desc_lbl)

	# If Luck tab, show full 100% probability table for this tier right on the card
	if tab_id == "luck" and LUCK_TABLES.has(item["id"]):
		var ch = LUCK_TABLES[item["id"]]["chances"]
		var odds_lbl = Label.new()
		odds_lbl.text = "Chancen: Common %s%% | Uncommon %s%% | Rare %s%% | Epic %s%% | Legendary %s%% | Mythic %s%% (Summe: 100%%)" % [
			_format_pct(ch["common"]), _format_pct(ch["uncommon"]), _format_pct(ch["rare"]),
			_format_pct(ch["epic"]), _format_pct(ch["legendary"]), _format_pct(ch["mythic"])
		]
		odds_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		UIKit.style_label(odds_lbl, 13, Color(0.62, 0.92, 1.0), 3)
		info_vbox.add_child(odds_lbl)

	var action_btn = Button.new()
	action_btn.custom_minimum_size = Vector2(158, 52)
	action_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(action_btn)

	var item_id: String = item["id"]
	var price: int = int(item["price"])

	match tab_id:
		"clicks":
			var owned = item_id in owned_click_upgrades
			var is_active = (active_click_upgrade == item_id)
			if is_active:
				action_btn.text = "AKTIV ✓"
				action_btn.disabled = true
				UIKit.style_button(action_btn, "green", 18, 18, 14.0, 6.0)
				UIKit.style_panel(card, "card_active", 18.0, 14.0)
			elif owned:
				action_btn.text = "Aktivieren"
				UIKit.style_button(action_btn, "blue", 18, 18, 14.0, 6.0)
				action_btn.pressed.connect(func():
					active_click_upgrade = item_id
					_on_shop_action_feedback("%s aktiviert!" % item["title"], true)
				)
			else:
				action_btn.text = "%s Münzen" % _format_number(price)
				UIKit.style_button(action_btn, "orange", 18, 18, 14.0, 6.0)
				action_btn.pressed.connect(func(): _try_buy_click_upgrade(item))
		"boosters":
			var rem = _get_booster_remaining(item_id)
			if rem > 0.0:
				action_btn.text = "Aktiv (%ds)\n+%s M." % [int(ceil(rem)), _format_number(price)]
				UIKit.style_button(action_btn, "green", 16, 18, 12.0, 6.0)
				UIKit.style_panel(card, "card_active", 18.0, 14.0)
			else:
				action_btn.text = "%s Münzen" % _format_number(price)
				UIKit.style_button(action_btn, "orange", 18, 18, 14.0, 6.0)
			action_btn.pressed.connect(func(): _try_buy_booster(item))
		"luck":
			var owned = item_id in owned_luck_upgrades
			var is_active = (active_luck_upgrade == item_id)
			if is_active:
				action_btn.text = "AKTIV ✓"
				action_btn.disabled = true
				UIKit.style_button(action_btn, "green", 18, 18, 14.0, 6.0)
				UIKit.style_panel(card, "card_active", 18.0, 14.0)
			elif owned:
				action_btn.text = "Aktivieren"
				UIKit.style_button(action_btn, "blue", 18, 18, 14.0, 6.0)
				action_btn.pressed.connect(func():
					active_luck_upgrade = item_id
					_on_shop_action_feedback("%s aktiviert!" % item["title"], true)
				)
			else:
				action_btn.text = "%s Münzen" % _format_number(price)
				UIKit.style_button(action_btn, "orange", 18, 18, 14.0, 6.0)
				action_btn.pressed.connect(func(): _try_buy_luck_upgrade(item))
		"cosmetics":
			var owned = item_id in owned_cosmetics
			var is_equipped = _is_cosmetic_equipped(item)
			if is_equipped:
				action_btn.text = "AUSGERÜSTET ✓"
				action_btn.disabled = true
				UIKit.style_button(action_btn, "green", 17, 18, 12.0, 6.0)
				UIKit.style_panel(card, "card_active", 18.0, 14.0)
			elif owned:
				action_btn.text = "Ausrüsten"
				UIKit.style_button(action_btn, "blue", 18, 18, 14.0, 6.0)
				action_btn.pressed.connect(func():
					_equip_cosmetic(item)
					_on_shop_action_feedback("%s ausgerüstet!" % item["title"], true)
				)
			else:
				action_btn.text = "%s Münzen" % _format_number(price)
				UIKit.style_button(action_btn, "purple", 18, 18, 14.0, 6.0)
				action_btn.pressed.connect(func(): _try_buy_cosmetic(item))

	return card

func _try_buy_click_upgrade(item: Dictionary) -> void:
	var price: int = int(item["price"])
	if coins < price:
		_on_shop_action_feedback("Nicht genug Münzen! Du benötigst %s Münzen." % _format_number(price), false)
		return
	coins -= price
	var id: String = item["id"]
	if not (id in owned_click_upgrades):
		owned_click_upgrades.append(id)
	active_click_upgrade = id
	_play_buy_sound()
	_on_shop_action_feedback("Gekauft & Aktiviert: %s!" % item["title"], true)

func _try_buy_booster(item: Dictionary) -> void:
	var price: int = int(item["price"])
	if coins < price:
		_on_shop_action_feedback("Nicht genug Münzen! Du benötigst %s Münzen." % _format_number(price), false)
		return
	coins -= price
	var id: String = item["id"]
	var dur: float = float(item["duration"])
	match id:
		"booster_2x":
			booster_2x_time += dur
		"booster_auto":
			booster_auto_time += dur
		"booster_5x":
			booster_5x_time += dur
	_play_buy_sound()
	_on_shop_action_feedback("%s gestartet!" % item["title"], true)

func _try_buy_luck_upgrade(item: Dictionary) -> void:
	var price: int = int(item["price"])
	if coins < price:
		_on_shop_action_feedback("Nicht genug Münzen! Du benötigst %s Münzen." % _format_number(price), false)
		return
	coins -= price
	var id: String = item["id"]
	if not (id in owned_luck_upgrades):
		owned_luck_upgrades.append(id)
	active_luck_upgrade = id
	_play_buy_sound()
	_on_shop_action_feedback("Glücks-Upgrade aktiviert: %s!" % item["title"], true)

func _try_buy_cosmetic(item: Dictionary) -> void:
	var price: int = int(item["price"])
	if coins < price:
		_on_shop_action_feedback("Nicht genug Münzen! Du benötigst %s Münzen." % _format_number(price), false)
		return
	coins -= price
	var id: String = item["id"]
	if not (id in owned_cosmetics):
		owned_cosmetics.append(id)
	_equip_cosmetic(item)
	_play_buy_sound()
	_on_shop_action_feedback("Kosmetik freigeschaltet & ausgerüstet: %s!" % item["title"], true)

func _on_shop_action_feedback(msg: String, success: bool) -> void:
	if shop_feedback_label:
		shop_feedback_label.text = msg
		shop_feedback_label.add_theme_color_override("font_color", Color(0.35, 1.0, 0.48) if success else Color(1.0, 0.42, 0.42))
	_save_progress()
	_update_hud()
	_populate_shop_tab(_current_shop_tab)

func _get_booster_remaining(id: String) -> float:
	match id:
		"booster_2x": return booster_2x_time
		"booster_auto": return booster_auto_time
		"booster_5x": return booster_5x_time
	return 0.0

func _is_cosmetic_equipped(item: Dictionary) -> bool:
	var id: String = item["id"]
	match item["slot"]:
		"egg": return equipped_egg_skin == id
		"crack": return equipped_crack_style == id
		"particle": return equipped_particle_style == id
		"bg": return equipped_bg_theme == id
		"aura": return equipped_reveal_aura == id
	return false

func _equip_cosmetic(item: Dictionary) -> void:
	var id: String = item["id"]
	match item["slot"]:
		"egg": equipped_egg_skin = id
		"crack": equipped_crack_style = id
		"particle": equipped_particle_style = id
		"bg": equipped_bg_theme = id
		"aura": equipped_reveal_aura = id
	_apply_all_cosmetics()

func _apply_all_cosmetics() -> void:
	if egg_sprite:
		egg_sprite.modulate = _get_egg_skin_color(equipped_egg_skin)
	if crack_overlay:
		var default_world_crack: String = EGG_WORLDS.get(active_egg_id, EGG_WORLDS["nature"])["crack_style"]
		match equipped_crack_style:
			"crack_gold": crack_overlay.set_crack_style("gold")
			"crack_magma": crack_overlay.set_crack_style("magma")
			"crack_ice": crack_overlay.set_crack_style("ice")
			_: crack_overlay.set_crack_style(default_world_crack)
	if atmosphere_overlay:
		match equipped_bg_theme:
			"bg_sunset":
				atmosphere_overlay.color = Color(1.0, 0.45, 0.15, 0.22)
				atmosphere_overlay.visible = true
			"bg_night":
				atmosphere_overlay.color = Color(0.05, 0.08, 0.28, 0.46)
				atmosphere_overlay.visible = true
			_:
				atmosphere_overlay.visible = false

func _get_egg_skin_color(skin_id: String) -> Color:
	match skin_id:
		"egg_gold": return Color(1.0, 0.88, 0.38)
		"egg_crystal": return Color(0.68, 0.93, 1.0)
		"egg_dragon": return Color(0.86, 0.65, 1.0)
		_: return Color(1.0, 1.0, 1.0)

# --- Pet Companion & Wheel of Companions UI ---

func _spawn_pet_companion() -> void:
	if pet_companion:
		return

	pet_companion = PetCompanion.new()
	pet_companion.name = "PetCompanion"
	# Position beside the main egg exactly where it was
	pet_companion.position = Vector2(40, 480)
	add_child(pet_companion)

	if not equipped_pet_id.is_empty():
		pet_companion.set_pet(equipped_pet_id)
	else:
		pet_companion.visible = false

func _build_pet_system_ui() -> void:
	if pet_modal_overlay:
		return

	pet_modal_overlay = ColorRect.new()
	pet_modal_overlay.name = "PetModalOverlay"
	pet_modal_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	pet_modal_overlay.color = Color(0.02, 0.04, 0.1, 0.88)
	pet_modal_overlay.visible = false
	pet_modal_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(pet_modal_overlay)

	pet_modal_panel = PanelContainer.new()
	pet_modal_panel.name = "PetModalPanel"
	pet_modal_panel.set_anchors_preset(Control.PRESET_CENTER)
	pet_modal_panel.offset_left = -350.0
	pet_modal_panel.offset_top = -470.0
	pet_modal_panel.offset_right = 350.0
	pet_modal_panel.offset_bottom = 470.0
	UIKit.style_panel(pet_modal_panel, "modal", 20.0, 16.0)
	pet_modal_overlay.add_child(pet_modal_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	pet_modal_panel.add_child(vbox)

	# Header with Title & Close
	var header = HBoxContainer.new()
	vbox.add_child(header)

	var title = Label.new()
	title.text = "🐾 BEGLEITER & GLÜCKSRAD"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIKit.style_label(title, 24, Color(1.0, 0.88, 0.35), 7)
	header.add_child(title)

	var close_btn = Button.new()
	close_btn.custom_minimum_size = Vector2(44, 44)
	close_btn.text = "✕"
	UIKit.style_button(close_btn, "red", 20, 14, 10.0, 4.0)
	close_btn.pressed.connect(_close_pet_modal)
	header.add_child(close_btn)

	# Tab bar: [ 🎡 Glücksrad ] & [ 🐾 Meine Begleiter (11) ]
	var tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 10)
	vbox.add_child(tab_bar)

	var tab_wheel = Button.new()
	tab_wheel.text = "🎡 Glücksrad"
	tab_wheel.custom_minimum_size = Vector2(150, 42)
	tab_wheel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIKit.style_button(tab_wheel, "orange", 16, 16, 10.0, 5.0)
	tab_wheel.pressed.connect(func(): _switch_pet_tab("wheel"))
	tab_bar.add_child(tab_wheel)

	var tab_inv = Button.new()
	tab_inv.text = "🐾 Meine Begleiter"
	tab_inv.custom_minimum_size = Vector2(150, 42)
	tab_inv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIKit.style_button(tab_inv, "blue", 16, 16, 10.0, 5.0)
	tab_inv.pressed.connect(func(): _switch_pet_tab("inventory"))
	tab_bar.add_child(tab_inv)

	# Content Container for Wheel (1:1 Provided Graphic)
	pet_wheel_container = VBoxContainer.new()
	pet_wheel_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pet_wheel_container.alignment = BoxContainer.ALIGNMENT_CENTER
	pet_wheel_container.add_theme_constant_override("separation", 6)
	vbox.add_child(pet_wheel_container)

	_build_wheel_ui(pet_wheel_container)

	# Content Container for Inventory Grid
	pet_inv_scroll = ScrollContainer.new()
	pet_inv_scroll.name = "PetInvScroll"
	pet_inv_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pet_inv_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	pet_inv_scroll.visible = false
	vbox.add_child(pet_inv_scroll)

	pet_inventory_grid = GridContainer.new()
	pet_inventory_grid.columns = 2
	pet_inventory_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pet_inventory_grid.add_theme_constant_override("h_separation", 12)
	pet_inventory_grid.add_theme_constant_override("v_separation", 12)
	pet_inv_scroll.add_child(pet_inventory_grid)

func _build_wheel_ui(parent: Control) -> void:
	# Responsive wrapper that scales the 1:1 979x785 wheel graphic without distortion
	wheel_stage_wrap = Control.new()
	wheel_stage_wrap.name = "WheelStageWrap"
	wheel_stage_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wheel_stage_wrap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	wheel_stage_wrap.custom_minimum_size = Vector2(300, 320)
	parent.add_child(wheel_stage_wrap)

	# Fixed-proportion 979x785 coordinate space matching the cropped 1024x1024 image (X=32..1010, Y=100..884)
	wheel_stage_root = Control.new()
	wheel_stage_root.name = "WheelStageRoot"
	wheel_stage_root.size = Vector2(979, 785)
	wheel_stage_wrap.add_child(wheel_stage_root)
	wheel_stage_wrap.resized.connect(_layout_wheel_stage)

	# 1. Rotating 11-segment Wheel Disc (676x676 centered at cx_stage=355, cy_stage=400)
	# Disc radius 338 extends 14px UNDER the golden rim (inner rim is 324) so there is ZERO gap!
	wheel_disk = TextureRect.new()
	wheel_disk.name = "WheelDisc"
	wheel_disk.size = Vector2(676, 676)
	wheel_disk.position = Vector2(17, 62) # (355 - 338, 400 - 338)
	wheel_disk.pivot_offset = Vector2(338, 338)
	wheel_disk.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	wheel_disk.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if ResourceLoader.exists("res://assets/wheel/wheel_disc.png"):
		wheel_disk.texture = load("res://assets/wheel/wheel_disc.png")
	wheel_stage_root.add_child(wheel_disk)

	# 2. Stationary 1:1 Frame, Top Diamond Pointer, Center Paw Medallion & Right "Wahrscheinlichkeiten" Panel
	var frame_rect = TextureRect.new()
	frame_rect.name = "WheelFrameUI"
	frame_rect.size = Vector2(1024, 1024)
	frame_rect.position = Vector2(-32, -100)
	frame_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if ResourceLoader.exists("res://assets/wheel/wheel_frame_ui.png"):
		frame_rect.texture = load("res://assets/wheel/wheel_frame_ui.png")
	wheel_stage_root.add_child(frame_rect)

	# Reference node at top pointer for tests/inspection
	wheel_pointer = Control.new()
	wheel_pointer.name = "WheelTopPointer"
	wheel_pointer.position = Vector2(355, 98)
	wheel_stage_root.add_child(wheel_pointer)

	# 3. Modern interactive UIKit Button & Ticket Counter directly inside the bottom slot of the right card
	pet_spin_button = Button.new()
	pet_spin_button.name = "WheelSpinButton"
	pet_spin_button.position = Vector2(706, 584)
	pet_spin_button.size = Vector2(230, 52)
	pet_spin_button.custom_minimum_size = Vector2(230, 52)
	pet_spin_button.text = "🐾 KOSTENLOS DREHEN"
	UIKit.style_button(pet_spin_button, "green", 18, 18, 16.0, 5.0)
	pet_spin_button.pressed.connect(_on_wheel_spin_pressed)
	wheel_stage_root.add_child(pet_spin_button)

	# 4. Clean Ticket Pill with crisp Fredoka font matching the rest of the game UI
	var token_pill = PanelContainer.new()
	token_pill.name = "TokenCountPill"
	token_pill.position = Vector2(706, 644)
	token_pill.size = Vector2(230, 38)
	token_pill.custom_minimum_size = Vector2(230, 38)
	UIKit.style_panel(token_pill, "inset", 12.0, 4.0)
	wheel_stage_root.add_child(token_pill)

	pet_token_label = Label.new()
	pet_token_label.name = "TokenCountLabel"
	pet_token_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pet_token_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	UIKit.style_label(pet_token_label, 15, Color(1.0, 0.94, 0.5), 3, Color(0.04, 0.04, 0.18), false)
	token_pill.add_child(pet_token_label)

	# 5. Epic Pet Reveal Overlay with Dynamic God-Rays, Shockwaves, Large Showcase & Animations
	wheel_reveal_overlay = ColorRect.new()
	wheel_reveal_overlay.name = "WheelRevealOverlay"
	wheel_reveal_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	wheel_reveal_overlay.color = Color(0.01, 0.02, 0.07, 0.92)
	wheel_reveal_overlay.visible = false
	wheel_reveal_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	pet_modal_overlay.add_child(wheel_reveal_overlay)

	# Dynamic background rays and particle swirls
	wheel_reveal_effect = DropRevealEffect.new()
	wheel_reveal_effect.name = "WheelRevealEffect"
	wheel_reveal_effect.set_anchors_preset(Control.PRESET_FULL_RECT)
	wheel_reveal_effect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wheel_reveal_overlay.add_child(wheel_reveal_effect)

	wheel_reveal_card = PanelContainer.new()
	wheel_reveal_card.name = "WheelRevealCard"
	wheel_reveal_card.set_anchors_preset(Control.PRESET_CENTER)
	wheel_reveal_card.custom_minimum_size = Vector2(420, 570)
	wheel_reveal_card.offset_left = -210.0
	wheel_reveal_card.offset_top = -285.0
	wheel_reveal_card.offset_right = 210.0
	wheel_reveal_card.offset_bottom = 285.0
	wheel_reveal_card.pivot_offset = Vector2(210, 285)
	UIKit.style_panel(wheel_reveal_card, "modal", 24.0, 18.0)
	wheel_reveal_overlay.add_child(wheel_reveal_card)

	var rev_vbox = VBoxContainer.new()
	rev_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	rev_vbox.add_theme_constant_override("separation", 8)
	wheel_reveal_card.add_child(rev_vbox)

	var rev_hdr = Label.new()
	rev_hdr.text = "✨ GLÜCKSRAD-GEWINN! ✨"
	rev_hdr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIKit.style_label(rev_hdr, 20, Color(1.0, 0.92, 0.35), 6)
	rev_vbox.add_child(rev_hdr)

	# Rarity Pill
	wheel_reveal_rarity_pill = PanelContainer.new()
	wheel_reveal_rarity_pill.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIKit.style_panel(wheel_reveal_rarity_pill, "chip", 14.0, 5.0)
	rev_vbox.add_child(wheel_reveal_rarity_pill)

	wheel_reveal_rarity = Label.new()
	wheel_reveal_rarity.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIKit.style_label(wheel_reveal_rarity, 16, Color.WHITE, 5)
	wheel_reveal_rarity_pill.add_child(wheel_reveal_rarity)

	# Meadow Stage Showcase Diorama (Lush green meadow, flowers, soft lighting & shadow)
	var meadow_panel = PanelContainer.new()
	meadow_panel.name = "MeadowStagePanel"
	meadow_panel.custom_minimum_size = Vector2(380, 215)
	meadow_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	meadow_panel.clip_contents = true
	UIKit.style_panel(meadow_panel, "inset", 16.0, 0.0)
	rev_vbox.add_child(meadow_panel)

	var meadow_root = Control.new()
	meadow_root.custom_minimum_size = Vector2(380, 215)
	meadow_panel.add_child(meadow_root)

	# 1. Meadow Landscape Background
	var meadow_bg = TextureRect.new()
	meadow_bg.name = "MeadowBg"
	meadow_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	meadow_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	meadow_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	if ResourceLoader.exists("res://assets/pets/pet_meadow_stage.png"):
		meadow_bg.texture = load("res://assets/pets/pet_meadow_stage.png")
	meadow_root.add_child(meadow_bg)

	# 2. Soft Ambient Golden Glow
	var meadow_glow = ColorRect.new()
	meadow_glow.set_anchors_preset(Control.PRESET_FULL_RECT)
	meadow_glow.color = Color(1.0, 0.95, 0.75, 0.08)
	meadow_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	meadow_root.add_child(meadow_glow)

	# 3. Soft grounding shadow under the pet on the meadow grass
	var pet_shadow = Panel.new()
	pet_shadow.custom_minimum_size = Vector2(130, 22)
	pet_shadow.position = Vector2(125, 180)
	var shadow_sb = StyleBoxFlat.new()
	shadow_sb.bg_color = Color(0.04, 0.20, 0.06, 0.50)
	shadow_sb.set_corner_radius_all(11)
	pet_shadow.add_theme_stylebox_override("panel", shadow_sb)
	meadow_root.add_child(pet_shadow)

	# 4. Large Pet Character Standing on the Meadow
	wheel_reveal_icon = TextureRect.new()
	wheel_reveal_icon.name = "PetMeadowSprite"
	wheel_reveal_icon.custom_minimum_size = Vector2(185, 185)
	wheel_reveal_icon.position = Vector2(98, 10)
	wheel_reveal_icon.pivot_offset = Vector2(92, 92)
	wheel_reveal_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	wheel_reveal_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	meadow_root.add_child(wheel_reveal_icon)

	wheel_reveal_title = Label.new()
	wheel_reveal_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIKit.style_label(wheel_reveal_title, 26, Color.WHITE, 6)
	rev_vbox.add_child(wheel_reveal_title)

	# Info Box for Lore & Ability Bonus
	var info_box = PanelContainer.new()
	info_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIKit.style_panel(info_box, "inset", 14.0, 10.0)
	rev_vbox.add_child(info_box)

	var info_vbox = VBoxContainer.new()
	info_vbox.add_theme_constant_override("separation", 4)
	info_box.add_child(info_vbox)

	wheel_reveal_lore = Label.new()
	wheel_reveal_lore.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wheel_reveal_lore.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIKit.style_label(wheel_reveal_lore, 13, Color(0.85, 0.92, 1.0), 3, Color(0.04, 0.07, 0.16), false)
	info_vbox.add_child(wheel_reveal_lore)

	wheel_reveal_bonus = Label.new()
	wheel_reveal_bonus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wheel_reveal_bonus.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIKit.style_label(wheel_reveal_bonus, 15, Color(1.0, 0.92, 0.35), 5)
	info_vbox.add_child(wheel_reveal_bonus)

	var rev_ok_btn = Button.new()
	rev_ok_btn.text = "Einsammeln & Weiter ✓"
	rev_ok_btn.custom_minimum_size = Vector2(220, 48)
	rev_ok_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIKit.style_button(rev_ok_btn, "green", 18, 18, 14.0, 6.0)
	rev_ok_btn.pressed.connect(func():
		if _wheel_pet_float_tween and _wheel_pet_float_tween.is_valid():
			_wheel_pet_float_tween.kill()
		if wheel_reveal_effect:
			wheel_reveal_effect.stop_reveal()
		wheel_reveal_overlay.visible = false
	)
	rev_vbox.add_child(rev_ok_btn)

	_update_wheel_hud()
	call_deferred("_layout_wheel_stage")

func _layout_wheel_stage() -> void:
	if not wheel_stage_wrap or not wheel_stage_root:
		return
	var avail_w: float = maxf(240.0, wheel_stage_wrap.size.x)
	var avail_h: float = maxf(240.0, wheel_stage_wrap.size.y)
	var base_w: float = 979.0
	var base_h: float = 785.0
	var s: float = minf(avail_w / base_w, avail_h / base_h)
	wheel_stage_root.scale = Vector2(s, s)
	wheel_stage_root.position = Vector2(
		(avail_w - base_w * s) * 0.5,
		(avail_h - base_h * s) * 0.5
	)

func _switch_pet_tab(tab_id: String) -> void:
	_pet_modal_tab = tab_id
	if pet_wheel_container:
		pet_wheel_container.visible = (tab_id == "wheel")
	if pet_inv_scroll:
		pet_inv_scroll.visible = (tab_id == "inventory")
	if tab_id == "inventory":
		_populate_pet_inventory()
	else:
		_update_wheel_hud()
		call_deferred("_layout_wheel_stage")

func _update_wheel_hud() -> void:
	var can_spin: bool = (not is_wheel_spinning) and (pet_tokens > 0)
	if pet_spin_button:
		pet_spin_button.disabled = not can_spin
		pet_spin_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if can_spin else Control.CURSOR_FORBIDDEN
		if is_wheel_spinning:
			pet_spin_button.text = "⏳ DREHT SICH..."
			UIKit.style_button(pet_spin_button, "blue", 17, 17, 16.0, 5.0)
		elif can_spin:
			pet_spin_button.text = "🐾 KOSTENLOS DREHEN"
			UIKit.style_button(pet_spin_button, "green", 17, 17, 16.0, 5.0)
		else:
			pet_spin_button.text = "🐾 KEINE TICKETS"
			UIKit.style_button(pet_spin_button, "orange", 17, 17, 16.0, 5.0)
			pet_spin_button.modulate = Color(0.75, 0.78, 0.88, 0.70)

	if pet_token_label:
		if pet_tokens == 1:
			pet_token_label.text = "🎟️ 1 Dreh verfügbar"
			pet_token_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.45))
		elif pet_tokens > 1:
			pet_token_label.text = "🎟️ %d Drehs verfügbar" % pet_tokens
			pet_token_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.45))
		else:
			pet_token_label.text = "🎟️ 0 Drehs (durch Eier)"
			pet_token_label.add_theme_color_override("font_color", Color(0.72, 0.78, 0.90))

func _on_wheel_spin_pressed() -> void:
	if is_wheel_spinning or pet_tokens <= 0:
		return
	pet_tokens -= 1
	is_wheel_spinning = true
	_update_wheel_hud()
	_save_progress()

	# Roll prize first according to exact 45% / 25% / 15% / 9% / 5% / 1% probabilities
	var result = PetData.spin_wheel(_rng)
	var seg_index: int = int(result["segment_index"])
	var seg_count: int = PetData.WHEEL_SEGMENTS.size() # 11 segments

	# Segment 0 (Hund) is at 12 o'clock (0 rad). Segment i is at +i * (TAU / 11) clockwise.
	# Rotating wheel_disk clockwise by final_rotation brings segment seg_index to 12 o'clock when:
	# final_rotation == -seg_index * (TAU / 11) (mod TAU)
	var current_mod: float = fposmod(wheel_disk.rotation, TAU)
	wheel_disk.rotation = current_mod
	var target_mod: float = fposmod(-float(seg_index) * (TAU / float(seg_count)), TAU)
	var delta_angle: float = fposmod(target_mod - current_mod, TAU)
	var extra_spins: float = TAU * float(_rng.randi_range(5, 7))
	var final_rotation: float = current_mod + extra_spins + delta_angle

	_play_tap_audio()
	var spin_tw = create_tween()
	spin_tw.tween_property(wheel_disk, "rotation", final_rotation, 3.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await spin_tw.finished

	wheel_disk.rotation = target_mod
	is_wheel_spinning = false
	_award_wheel_prize(result)
	_update_wheel_hud()
	_save_progress()

func _award_wheel_prize(result: Dictionary) -> void:
	var pet_info: Dictionary = result["pet"]
	var pid: String = pet_info["id"]
	var is_new: bool = not (pid in owned_pets)
	var r_name: String = pet_info["rarity_name"]
	var r_tier: String = pet_info.get("rarity", "common")
	var r_col: Color = pet_info.get("color", Color.WHITE)

	if is_new:
		owned_pets.append(pid)
		if equipped_pet_id.is_empty():
			equipped_pet_id = pid
			if pet_companion:
				pet_companion.set_pet(pid)
		_show_milestone("🎉 NEUES %s PET GEWONNEN: %s! (%s)" % [r_name.to_upper(), pet_info["name"], pet_info["bonus_desc"]])
	else:
		var dup_reward: int = int(pet_info.get("duplicate_coins", 1000))
		coins += dup_reward
		_show_milestone("✨ %s (Duplikat): +%s Münzen Bonus!" % [pet_info["name"], _format_number(dup_reward)])

	# Exciting, high-impact Pet Reveal Presentation
	if wheel_reveal_overlay and wheel_reveal_card:
		wheel_reveal_overlay.visible = true
		wheel_reveal_overlay.modulate.a = 0.0

		# 1. Start dynamic god-rays, expanding shockwaves, and swirling rarity particles
		if wheel_reveal_effect:
			wheel_reveal_effect.start_reveal(r_tier, r_tier in ["epic", "legendary", "mythic"])

		# 2. Configure Rarity Pill & Title
		if wheel_reveal_rarity:
			var stars: String = "★" if r_tier == "common" else ("★★" if r_tier in ["uncommon", "rare"] else "★★★")
			wheel_reveal_rarity.text = "%s %s %s" % [stars, r_name.to_upper(), stars]
			wheel_reveal_rarity.add_theme_color_override("font_color", r_col)
		if wheel_reveal_rarity_pill:
			UIKit.style_panel(wheel_reveal_rarity_pill, "chip_gold" if r_tier in ["legendary", "mythic"] else "chip", 14.0, 6.0)

		if wheel_reveal_title:
			wheel_reveal_title.text = pet_info["name"] + ("  [NEU!]" if is_new else "")
			wheel_reveal_title.add_theme_color_override("font_color", r_col.lightened(0.25))

		# 3. Configure Large Freestanding Pet on the Meadow Stage
		if wheel_reveal_icon and ResourceLoader.exists(pet_info["path"]):
			wheel_reveal_icon.texture = load(pet_info["path"])
			wheel_reveal_icon.scale = Vector2.ZERO

		# 4. Lore & Ability Bonus
		if wheel_reveal_lore:
			wheel_reveal_lore.text = pet_info.get("desc", "")
		if wheel_reveal_bonus:
			if is_new:
				var active_tag: String = " • Als aktiver Begleiter ausgerüstet!" if equipped_pet_id == pid else ""
				wheel_reveal_bonus.text = "⚡ Bonus: %s%s" % [pet_info["bonus_desc"], active_tag]
				wheel_reveal_bonus.add_theme_color_override("font_color", Color(1.0, 0.92, 0.35))
			else:
				var dup_c: int = int(pet_info.get("duplicate_coins", 1000))
				wheel_reveal_bonus.text = "✨ Duplikat im Besitz! +%s Münzen Belohnung!\n⚡ Bonus: %s" % [_format_number(dup_c), pet_info["bonus_desc"]]
				wheel_reveal_bonus.add_theme_color_override("font_color", Color(0.75, 0.92, 1.0))

		# 5. Screen flash & camera shake for high rarities (Epic, Legendary, Mythic)
		if r_tier in ["rare", "epic", "legendary", "mythic"] and flash_overlay:
			flash_overlay.visible = true
			flash_overlay.color = r_col
			flash_overlay.modulate.a = 0.55 if r_tier == "mythic" else 0.40
			var f_tw = create_tween()
			f_tw.tween_property(flash_overlay, "modulate:a", 0.0, 0.38)
			f_tw.tween_callback(func(): flash_overlay.visible = false)

		# 6. Dramatic Reveal Entrance Animation
		wheel_reveal_card.pivot_offset = wheel_reveal_card.size * 0.5 if wheel_reveal_card.size.x > 0 else Vector2(195, 245)
		wheel_reveal_card.scale = Vector2(0.3, 0.3)
		var dur: float = 0.55 if r_tier in ["legendary", "mythic"] else 0.42
		var r_tw = create_tween().set_parallel(true)
		r_tw.tween_property(wheel_reveal_overlay, "modulate:a", 1.0, 0.22)
		r_tw.tween_property(wheel_reveal_card, "scale", Vector2.ONE, dur).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		if wheel_reveal_icon:
			r_tw.tween_property(wheel_reveal_icon, "scale", Vector2.ONE, dur + 0.12).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

		# 7. Start smooth looping breathing/floating tween on the pet
		if _wheel_pet_float_tween and _wheel_pet_float_tween.is_valid():
			_wheel_pet_float_tween.kill()
		if wheel_reveal_icon:
			_wheel_pet_float_tween = create_tween().set_loops()
			_wheel_pet_float_tween.tween_property(wheel_reveal_icon, "position:y", 5.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			_wheel_pet_float_tween.parallel().tween_property(wheel_reveal_icon, "scale", Vector2(1.04, 1.04), 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			_wheel_pet_float_tween.chain().tween_property(wheel_reveal_icon, "position:y", 13.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			_wheel_pet_float_tween.parallel().tween_property(wheel_reveal_icon, "scale", Vector2.ONE, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	if shatter_player and r_tier in ["legendary", "mythic"] and not AudioServer.is_bus_mute(0):
		shatter_player.play()
	else:
		_play_buy_sound()

	_update_hud()

func _buy_pet_ticket() -> void:
	if coins < 2000:
		_show_milestone("Nicht genug Münzen! (Benötigt: 2.000)")
		return
	coins -= 2000
	pet_tokens += 1
	_play_buy_sound()
	_update_wheel_hud()
	_update_hud()
	_save_progress()

func _populate_pet_inventory() -> void:
	if not pet_inventory_grid:
		return
	for child in pet_inventory_grid.get_children():
		child.queue_free()

	for pet in PetData.PET_CATALOG:
		var pid = pet["id"]
		var owned = (pid in owned_pets)
		var is_active = (equipped_pet_id == pid)

		var card = PanelContainer.new()
		card.custom_minimum_size = Vector2(280, 130)
		UIKit.style_panel(card, "card_active" if is_active else ("card" if owned else "card_locked"), 14.0, 10.0)
		pet_inventory_grid.add_child(card)

		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 10)
		card.add_child(hbox)

		var icon = TextureRect.new()
		icon.custom_minimum_size = Vector2(80, 80)
		icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if ResourceLoader.exists(pet["path"]):
			icon.texture = load(pet["path"])
		if not owned:
			icon.modulate = Color(0.2, 0.25, 0.35, 0.8)
		hbox.add_child(icon)

		var vbox = VBoxContainer.new()
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.add_theme_constant_override("separation", 4)
		hbox.add_child(vbox)

		var name_lbl = Label.new()
		name_lbl.text = pet["name"] if owned else "???"
		UIKit.style_label(name_lbl, 17, pet["color"] if owned else Color(0.6, 0.65, 0.75), 4)
		vbox.add_child(name_lbl)

		var desc_lbl = Label.new()
		desc_lbl.text = pet["bonus_desc"] if owned else "Am Glücksrad freischaltbar"
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		UIKit.style_label(desc_lbl, 13, Color(0.85, 0.9, 1.0) if owned else Color(0.5, 0.55, 0.65), 3, Color(0, 0, 0), false)
		vbox.add_child(desc_lbl)

		if owned:
			var equip_btn = Button.new()
			equip_btn.custom_minimum_size = Vector2(120, 36)
			if is_active:
				equip_btn.text = "AKTIV ✓"
				equip_btn.disabled = true
				UIKit.style_button(equip_btn, "green", 13, 13, 8.0, 4.0)
			else:
				equip_btn.text = "Ausrüsten"
				UIKit.style_button(equip_btn, "blue", 13, 13, 8.0, 4.0)
				var chosen_pid = pid
				equip_btn.pressed.connect(func():
					equipped_pet_id = chosen_pid
					if pet_companion:
						pet_companion.set_pet(chosen_pid)
					_populate_pet_inventory()
					_update_hud()
					_save_progress()
				)
			vbox.add_child(equip_btn)

func _open_pet_modal() -> void:
	if is_revealing_drop:
		return
	if egg_select_overlay:
		egg_select_overlay.visible = false
	if shop_overlay:
		shop_overlay.visible = false
	if collection_overlay:
		collection_overlay.visible = false
	if settings_overlay:
		settings_overlay.visible = false
	_switch_pet_tab("wheel")
	UIKit.open_overlay(pet_modal_overlay, pet_modal_panel)

func _close_pet_modal() -> void:
	UIKit.close_overlay(pet_modal_overlay, pet_modal_panel)
	if _opened_from_main_menu:
		_opened_from_main_menu = false
		_open_main_menu()

# --- Egg Selection Menu & Collection Filter ---

func _build_egg_selection_ui() -> void:
	if egg_select_overlay:
		return

	egg_select_overlay = ColorRect.new()
	egg_select_overlay.name = "EggSelectOverlay"
	egg_select_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	egg_select_overlay.color = Color(0.03, 0.05, 0.12, 0.86)
	egg_select_overlay.visible = false
	egg_select_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(egg_select_overlay)

	egg_select_panel = PanelContainer.new()
	egg_select_panel.name = "EggSelectPanel"
	egg_select_panel.set_anchors_preset(Control.PRESET_CENTER)
	egg_select_panel.offset_left = -335.0
	egg_select_panel.offset_top = -510.0
	egg_select_panel.offset_right = 335.0
	egg_select_panel.offset_bottom = 510.0
	UIKit.style_panel(egg_select_panel, "modal", 28.0, 22.0)
	egg_select_overlay.add_child(egg_select_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	egg_select_panel.add_child(vbox)

	var header = HBoxContainer.new()
	vbox.add_child(header)

	var title = Label.new()
	title.text = "🥚 EIER & WELTEN AUSWÄHLEN"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIKit.style_label(title, 26, Color(1.0, 0.90, 0.30), 7)
	header.add_child(title)

	var close_btn = Button.new()
	close_btn.custom_minimum_size = Vector2(46, 46)
	close_btn.text = "✕"
	UIKit.style_button(close_btn, "red", 20, 14, 10.0, 4.0)
	close_btn.pressed.connect(_close_egg_select)
	header.add_child(close_btn)

	var sub_lbl = Label.new()
	sub_lbl.text = "Wähle ein Ei! Jedes Ei besitzt eine eigene Welt, ein zufälliges Klickziel (1.000–10.000) und 6 exklusive Slimes."
	sub_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIKit.style_label(sub_lbl, 14, Color(0.82, 0.90, 1.0), 3, Color(0.04, 0.07, 0.16), false)
	vbox.add_child(sub_lbl)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	egg_cards_hbox = VBoxContainer.new()
	egg_cards_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	egg_cards_hbox.add_theme_constant_override("separation", 14)
	scroll.add_child(egg_cards_hbox)

func _open_egg_select() -> void:
	if is_revealing_drop:
		return
	if shop_overlay:
		shop_overlay.visible = false
	if collection_overlay:
		collection_overlay.visible = false
	if settings_overlay:
		settings_overlay.visible = false
	egg_unseen_unlocks.clear()
	_populate_egg_cards()
	_save_progress()
	_update_hud()
	UIKit.open_overlay(egg_select_overlay, egg_select_panel)

func _close_egg_select() -> void:
	UIKit.close_overlay(egg_select_overlay, egg_select_panel)
	if _opened_from_main_menu:
		_opened_from_main_menu = false
		_open_main_menu()

func _populate_egg_cards() -> void:
	if not egg_cards_hbox:
		return
	for child in egg_cards_hbox.get_children():
		child.queue_free()

	for egg_id in ["nature", "crystal", "cosmic"]:
		var w_cfg: Dictionary = EGG_WORLDS[egg_id]
		var st: Dictionary = egg_states[egg_id]
		var unlocked: bool = bool(st["unlocked"])
		var is_active: bool = (active_egg_id == egg_id)

		var card = PanelContainer.new()
		var theme_key = "card_active" if is_active else ("card" if unlocked else "card_locked")
		UIKit.style_panel(card, theme_key, 20.0, 16.0)
		egg_cards_hbox.add_child(card)

		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 16)
		card.add_child(hbox)

		# Left preview column with Egg + Lock icon overlay if locked
		var preview_wrap = Control.new()
		preview_wrap.custom_minimum_size = Vector2(120, 148)
		hbox.add_child(preview_wrap)

		var egg_tex = TextureRect.new()
		egg_tex.set_anchors_preset(Control.PRESET_FULL_RECT)
		egg_tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		egg_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if ResourceLoader.exists(w_cfg["egg_texture"]):
			egg_tex.texture = load(w_cfg["egg_texture"])
		if not unlocked:
			egg_tex.modulate = Color(0.22, 0.25, 0.34, 0.85)
		preview_wrap.add_child(egg_tex)

		if not unlocked and ResourceLoader.exists("res://assets/lock_icon.svg"):
			var lock_icon = TextureRect.new()
			lock_icon.custom_minimum_size = Vector2(54, 54)
			lock_icon.size = Vector2(54, 54)
			lock_icon.position = Vector2(33, 47)
			lock_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			lock_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			lock_icon.texture = load("res://assets/lock_icon.svg")
			preview_wrap.add_child(lock_icon)

		# Middle info column
		var info_vbox = VBoxContainer.new()
		info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_vbox.add_theme_constant_override("separation", 5)
		hbox.add_child(info_vbox)

		var name_lbl = Label.new()
		var status_tag = " [AKTIV]" if is_active else (" [FREIGESCHALTET]" if unlocked else " [GESPERRT]")
		name_lbl.text = "%s%s" % [w_cfg["name"], status_tag]
		UIKit.style_label(name_lbl, 21, w_cfg["theme_color"] if unlocked else Color(0.65, 0.72, 0.82), 6)
		info_vbox.add_child(name_lbl)

		var sub_lbl = Label.new()
		sub_lbl.text = "%s — %s" % [w_cfg["subtitle"], w_cfg["description"]]
		sub_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		UIKit.style_label(sub_lbl, 14, Color(0.86, 0.92, 1.0), 3, Color(0.04, 0.07, 0.16), false)
		info_vbox.add_child(sub_lbl)

		var rar_lbl = Label.new()
		rar_lbl.text = "Mögliche Raritäten: Common • Uncommon • Rare • Epic • Legendary • Mythic (6 eigene Slimes)"
		rar_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		UIKit.style_label(rar_lbl, 13, Color(0.68, 0.92, 1.0), 3, Color(0.04, 0.07, 0.16), false)
		info_vbox.add_child(rar_lbl)

		var prog_lbl = Label.new()
		if unlocked:
			var c_val: int = int(st["current_clicks"])
			var t_val: int = int(st["target_clicks"])
			var pct_v: float = clampf((float(c_val) / float(maxi(1, t_val))) * 100.0, 0.0, 100.0)
			prog_lbl.text = "Aktuelles Klickziel: %s / %s (%s %%) | Geöffnet: %dx" % [
				_format_number(c_val), _format_number(t_val), _format_pct(pct_v), int(st.get("drops_count", 0))
			]
			UIKit.style_label(prog_lbl, 14, Color(1.0, 0.92, 0.38), 4)
		else:
			prog_lbl.text = "🔒 Freischaltbedingung: %s" % w_cfg["unlock_hint"]
			UIKit.style_label(prog_lbl, 14, Color(1.0, 0.62, 0.42), 4)
		prog_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		info_vbox.add_child(prog_lbl)

		# Right button column
		var sel_btn = Button.new()
		sel_btn.custom_minimum_size = Vector2(148, 54)
		sel_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		hbox.add_child(sel_btn)

		if is_active:
			sel_btn.text = "AUSGEWÄHLT ✓"
			sel_btn.disabled = true
			UIKit.style_button(sel_btn, "green", 16, 16, 12.0, 6.0)
		elif unlocked:
			sel_btn.text = "Auswählen"
			UIKit.style_button(sel_btn, "blue", 18, 16, 12.0, 6.0)
			var chosen_id: String = egg_id
			sel_btn.pressed.connect(func():
				select_egg(chosen_id)
				_close_egg_select()
			)
		else:
			sel_btn.text = "Gesperrt 🔒"
			sel_btn.disabled = true
			UIKit.style_button(sel_btn, "slate", 16, 16, 12.0, 6.0)

func _build_collection_filter_bar() -> void:
	if not collection_panel or collection_filter_bar:
		return
	var col_vbox = get_node_or_null("UILayer/CollectionOverlay/CollectionPanel/Margin/VBox")
	if not col_vbox:
		return
	collection_filter_bar = HBoxContainer.new()
	collection_filter_bar.name = "FilterBar"
	collection_filter_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	collection_filter_bar.add_theme_constant_override("separation", 8)
	col_vbox.add_child(collection_filter_bar)
	col_vbox.move_child(collection_filter_bar, 2)

	var filters = [
		{ "id": "all", "label": "Alle (18)", "pal": "blue" },
		{ "id": "nature", "label": "🌿 Nature (6)", "pal": "green" },
		{ "id": "crystal", "label": "💎 Crystal (6)", "pal": "blue" },
		{ "id": "cosmic", "label": "🌌 Cosmic (6)", "pal": "purple" }
	]
	for f in filters:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(124, 40)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.text = f["label"]
		var fid: String = f["id"]
		UIKit.style_button(btn, f["pal"], 14, 14, 8.0, 4.0)
		btn.pressed.connect(func():
			_collection_filter_egg = fid
			_populate_collection_grid()
		)
		collection_filter_bar.add_child(btn)

# --- Slime Collection / Inventory Modal ---

func _open_collection() -> void:
	if is_revealing_drop:
		return
	if egg_select_overlay:
		egg_select_overlay.visible = false
	if shop_overlay:
		shop_overlay.visible = false
	if settings_overlay:
		settings_overlay.visible = false
	_populate_collection_grid()
	# Clear unseen badges once player views collection
	slime_unseen.clear()
	_save_progress()
	_update_hud()
	UIKit.open_overlay(collection_overlay, collection_panel)

func _close_collection() -> void:
	UIKit.close_overlay(collection_overlay, collection_panel)
	if _opened_from_main_menu:
		_opened_from_main_menu = false
		_open_main_menu()

func _populate_collection_grid() -> void:
	if not collection_grid:
		return
	for child in collection_grid.get_children():
		child.queue_free()

	var unlocked_types: int = 0
	var total_hatched: int = 0
	for s in SLIME_CATALOG:
		var cnt: int = int(slime_counts.get(s["id"], 0))
		if cnt > 0:
			unlocked_types += 1
			total_hatched += cnt

	if collection_summary_label:
		collection_summary_label.text = "Freigeschaltet: %d / %d Arten | Gesamt geschlüpft: %d" % [
			unlocked_types, SLIME_CATALOG.size(), total_hatched
		]

	var active_chances: Dictionary = LUCK_TABLES.get(active_luck_upgrade, LUCK_TABLES["base"])["chances"]

	for slime in SLIME_CATALOG:
		if _collection_filter_egg != "all" and slime["egg_id"] != _collection_filter_egg:
			continue
		var sid: String = slime["id"]
		var count: int = int(slime_counts.get(sid, 0))
		var is_new: bool = bool(slime_unseen.get(sid, false))
		var r_col: Color = slime["color"]

		var card = PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		UIKit.style_panel(card, "card" if count > 0 else "card_locked", 14.0, 12.0)

		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_theme_constant_override("separation", 5)
		card.add_child(vbox)

		# Top header with Rarity + NEU badge
		var top_hbox = HBoxContainer.new()
		top_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_child(top_hbox)

		var r_lbl = Label.new()
		var r_tier: String = slime.get("rarity", "common")
		var pct: float = float(active_chances.get(r_tier, slime["base_chance"]))
		r_lbl.text = "★ %s (%s%%)" % [slime["rarity_name"], _format_pct(pct)]
		UIKit.style_label(r_lbl, 14, r_col, 4)
		top_hbox.add_child(r_lbl)

		if is_new:
			var new_lbl = Label.new()
			new_lbl.text = " [NEU!]"
			UIKit.style_label(new_lbl, 13, Color(1.0, 0.92, 0.2), 4)
			top_hbox.add_child(new_lbl)

		var egg_origin_lbl = Label.new()
		var egg_badge_prefix = "🌿 " if slime["egg_id"] == "nature" else ("💎 " if slime["egg_id"] == "crystal" else "🌌 ")
		egg_origin_lbl.text = egg_badge_prefix + str(slime.get("egg_name", "Nature Egg"))
		egg_origin_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		UIKit.style_label(egg_origin_lbl, 12, Color(0.75, 0.88, 1.0), 3, Color(0.04, 0.07, 0.16), false)
		vbox.add_child(egg_origin_lbl)

		# Slime Portrait
		var icon = TextureRect.new()
		icon.custom_minimum_size = Vector2(112, 114)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture = load(slime["path"])
		if count <= 0:
			icon.modulate = Color(0.06, 0.08, 0.14, 0.88) # Silhouette until unlocked
		vbox.add_child(icon)

		var name_lbl = Label.new()
		name_lbl.text = slime["name"] if count > 0 else "???"
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		UIKit.style_label(name_lbl, 16, Color.WHITE if count > 0 else Color(0.55, 0.62, 0.75), 5)
		vbox.add_child(name_lbl)

		var count_lbl = Label.new()
		count_lbl.text = "Gefunden: %dx" % count
		count_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		UIKit.style_label(count_lbl, 13, Color(0.82, 0.90, 1.0) if count > 0 else Color(0.45, 0.52, 0.65), 3, Color(0.04, 0.07, 0.16), false)
		vbox.add_child(count_lbl)

		collection_grid.add_child(card)

# --- HUD & Helper Functions ---

func _update_hud() -> void:
	var eff_target: int = maxi(1, target_clicks)
	var clamped_clicks: int = clampi(current_clicks, 0, eff_target)
	var formatted_clicks = _format_number(clamped_clicks)
	var formatted_target = _format_number(eff_target)
	var formatted_coins = _format_number(coins)

	if counter_label:
		counter_label.text = formatted_clicks
	if coin_label:
		coin_label.text = formatted_coins
	if shop_coin_hint:
		shop_coin_hint.text = "SHOP"
	if shop_balance_label:
		shop_balance_label.text = "%s Münzen" % formatted_coins

	var w_cfg: Dictionary = EGG_WORLDS.get(active_egg_id, EGG_WORLDS["nature"])
	if title_line1:
		title_line1.text = "Klicke auf das %s" % w_cfg["name"]
	if title_line2:
		title_line2.text = "[center][color=#ffe047]%s[/color] mal, um es zu öffnen![/center]" % formatted_target

	# Section 6: Progress bar displays clicks, dynamic target_clicks, and percentage (clamped <= 100%)
	var pct_val: float = clampf((float(clamped_clicks) / float(eff_target)) * 100.0, 0.0, 100.0)
	if progress_label:
		progress_label.text = "%s / %s  (%s %%)" % [formatted_clicks, formatted_target, _format_pct(pct_val)]
	if fancy_bar:
		fancy_bar.set_progress(clamped_clicks, false, eff_target)
	if progress_fill:
		var ratio = clampf(float(clamped_clicks) / float(eff_target), 0.0, 1.0)
		progress_fill.anchor_right = ratio

	if power_badge_label:
		var eff = get_effective_click_power()
		var luck_name = LUCK_TABLES.get(active_luck_upgrade, LUCK_TABLES["base"])["name"]
		power_badge_label.text = "⚡ %dx Klick   •   🍀 %s" % [eff, luck_name]
	if power_pill:
		var pill_k = "pill_world"
		if active_egg_id == "crystal":
			pill_k = "pill_crystal"
		elif active_egg_id == "cosmic":
			pill_k = "pill_cosmic"
		UIKit.style_panel(power_pill, pill_k, 16.0, 6.0)

	if collection_new_badge:
		collection_new_badge.visible = (slime_unseen.size() > 0)
	if eggs_new_badge:
		eggs_new_badge.visible = (egg_unseen_unlocks.size() > 0)

	if main_menu_overlay and main_menu_overlay.visible:
		_update_main_menu_content()

	_update_booster_hud()

func _update_booster_hud() -> void:
	if not booster_status_bar:
		return
	for child in booster_status_bar.get_children():
		child.queue_free()

	var active_list: Array[String] = []
	if booster_2x_time > 0.0:
		active_list.append("2x Boost: %ds" % int(ceil(booster_2x_time)))
	if booster_5x_time > 0.0:
		active_list.append("5x Turbo: %ds" % int(ceil(booster_5x_time)))
	if booster_auto_time > 0.0:
		active_list.append("Auto-Klick: %ds" % int(ceil(booster_auto_time)))

	for text_item in active_list:
		var lbl = Label.new()
		lbl.text = "⏱ " + text_item + "  "
		UIKit.style_label(lbl, 14, Color(1.0, 0.92, 0.35), 2, Color(0.12, 0.08, 0.02), true, true)
		booster_status_bar.add_child(lbl)

	if power_badge_label:
		var eff = get_effective_click_power()
		var luck_name = LUCK_TABLES.get(active_luck_upgrade, LUCK_TABLES["base"])["name"]
		power_badge_label.text = "⚡ %dx Klick   •   🍀 %s" % [eff, luck_name]
	if power_pill:
		var pill_k = "pill_world"
		if active_egg_id == "crystal":
			pill_k = "pill_crystal"
		elif active_egg_id == "cosmic":
			pill_k = "pill_cosmic"
		UIKit.style_panel(power_pill, pill_k, 16.0, 6.0)

func _get_slime_by_id(sid: String) -> Dictionary:
	var migrated_id = EggWorldData.migrate_legacy_slime_id(sid)
	for s in SLIME_CATALOG:
		if s["id"] == migrated_id:
			return s
	return SLIME_CATALOG[0]

func _format_number(val: int) -> String:
	var s = str(abs(val))
	var res = ""
	var count = 0
	for i in range(s.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			res = "." + res
		res = s[i] + res
		count += 1
	return ("-" + res) if val < 0 else res

func _format_pct(val: float) -> String:
	if is_equal_approx(val, round(val)):
		return str(int(round(val)))
	return ("%.1f" % val).replace(".", ",")

func _play_tap_audio() -> void:
	if tap_player and not AudioServer.is_bus_mute(0) and setting_sfx_volume > 0.01:
		tap_player.pitch_scale = _rng.randf_range(0.95, 1.05)
		tap_player.play()

func _play_crack_sound() -> void:
	if crack_player and not AudioServer.is_bus_mute(0) and setting_sfx_volume > 0.01:
		crack_player.pitch_scale = _rng.randf_range(0.95, 1.05)
		crack_player.play()

func _play_buy_sound() -> void:
	if buy_player and not AudioServer.is_bus_mute(0) and setting_sfx_volume > 0.01:
		buy_player.pitch_scale = _rng.randf_range(0.98, 1.04)
		buy_player.play()

# --- Local & YouTube Cloud Save System ---

func _serialize_save() -> String:
	_sync_active_egg_to_dict()
	var save_dict = {
		"v": 3,
		"active_egg": active_egg_id,
		"egg_states": egg_states,
		"egg_unseen": egg_unseen_unlocks,
		"pet_tokens": pet_tokens,
		"owned_pets": owned_pets,
		"equipped_pet": equipped_pet_id,
		"clicks": current_clicks,
		"target_clicks": target_clicks,
		"lifetime_clicks": total_lifetime_clicks,
		"coins": coins,
		"hatched": is_hatched,
		"last_slime": last_hatched_slime_id,
		"milestones": milestones_claimed,
		"owned_clicks": owned_click_upgrades,
		"active_click": active_click_upgrade,
		"owned_luck": owned_luck_upgrades,
		"active_luck": active_luck_upgrade,
		"b_2x": snappedf(booster_2x_time, 0.1),
		"b_auto": snappedf(booster_auto_time, 0.1),
		"b_5x": snappedf(booster_5x_time, 0.1),
		"cosmetics": owned_cosmetics,
		"eq_egg": equipped_egg_skin,
		"eq_crack": equipped_crack_style,
		"eq_part": equipped_particle_style,
		"eq_bg": equipped_bg_theme,
		"eq_aura": equipped_reveal_aura,
		"slimes": slime_counts,
		"unseen": slime_unseen,
		"sfx_vol": setting_sfx_volume,
		"part_on": setting_particles_enabled,
		"red_shake": setting_reduced_shake,
		"game_zoom": snappedf(setting_game_zoom, 0.01),
		"ts": int(Time.get_unix_time_from_system())
	}
	return JSON.stringify(save_dict)

func _save_progress() -> void:
	_save_dirty = false
	var save_json = _serialize_save()

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(save_json)
		file.close()

	# YouTube Cloud Save (only after loadData completed, per certification rules)
	if is_cloud_data_loaded:
		YTGameWrapper.save_data(save_json)

	# YouTube Score (MUST be integer)
	YTGameWrapper.send_score(max(current_clicks, total_lifetime_clicks))

func _load_local_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_str = file.get_as_text()
		file.close()
		_apply_loaded_json(json_str)

func _apply_loaded_json(json_str: String) -> void:
	if json_str.is_empty():
		return
	var json = JSON.new()
	if json.parse(json_str) != OK or typeof(json.data) != TYPE_DICTIONARY:
		return
	var d: Dictionary = json.data

	# Keep highest progress if merging local & cloud
	var loaded_lifetime = int(d.get("lifetime_clicks", d.get("clicks", 0)))
	if loaded_lifetime < total_lifetime_clicks and total_lifetime_clicks > 0:
		return

	if d.has("egg_states") and typeof(d["egg_states"]) == TYPE_DICTIONARY:
		var loaded_es: Dictionary = d["egg_states"]
		for egg_id in ["nature", "crystal", "cosmic"]:
			if loaded_es.has(egg_id) and typeof(loaded_es[egg_id]) == TYPE_DICTIONARY:
				var src: Dictionary = loaded_es[egg_id]
				var st: Dictionary = egg_states[egg_id]
				st["unlocked"] = bool(src.get("unlocked", egg_id == "nature"))
				st["drops_count"] = maxi(0, int(src.get("drops_count", src.get("times_opened", 0))))
				var t_c: int = int(src.get("target_clicks", 0))
				if not EggWorldData.is_valid_click_target(t_c):
					t_c = roll_click_target()
				st["target_clicks"] = t_c
				st["current_clicks"] = clampi(int(src.get("current_clicks", 0)), 0, t_c)
				st["hatched"] = bool(src.get("hatched", src.get("is_hatched", false)))
				var mc = src.get("milestones_claimed", src.get("milestones", {}))
				if typeof(mc) == TYPE_DICTIONARY:
					st["milestones_claimed"] = mc.duplicate()
	else:
		# Legacy v2 migration into nature egg state
		var legacy_clicks = clampi(int(d.get("clicks", 0)), 0, 10000)
		egg_states["nature"]["current_clicks"] = legacy_clicks
		egg_states["nature"]["target_clicks"] = 10000 if legacy_clicks > 0 else roll_click_target()
		egg_states["nature"]["hatched"] = bool(d.get("hatched", false))

	var req_active = str(d.get("active_egg", "nature"))
	if not egg_states.has(req_active) or not bool(egg_states[req_active]["unlocked"]):
		req_active = "nature"
	active_egg_id = req_active
	_sync_active_egg_from_dict()

	if d.has("egg_unseen") and typeof(d["egg_unseen"]) == TYPE_DICTIONARY:
		egg_unseen_unlocks.clear()
		for k in d["egg_unseen"]:
			if bool(d["egg_unseen"][k]):
				egg_unseen_unlocks[str(k)] = true

	total_lifetime_clicks = max(current_clicks, loaded_lifetime)
	coins = max(0, int(d.get("coins", 300)))
	last_hatched_slime_id = EggWorldData.migrate_legacy_slime_id(str(d.get("last_slime", "nature_common")))

	if d.has("owned_clicks") and typeof(d["owned_clicks"]) == TYPE_ARRAY:
		owned_click_upgrades.clear()
		for item in d["owned_clicks"]:
			owned_click_upgrades.append(str(item))
	active_click_upgrade = str(d.get("active_click", "base"))

	if d.has("owned_luck") and typeof(d["owned_luck"]) == TYPE_ARRAY:
		owned_luck_upgrades.clear()
		for item in d["owned_luck"]:
			owned_luck_upgrades.append(str(item))
	active_luck_upgrade = str(d.get("active_luck", "base"))

	booster_2x_time = max(0.0, float(d.get("b_2x", 0.0)))
	booster_auto_time = max(0.0, float(d.get("b_auto", 0.0)))
	booster_5x_time = max(0.0, float(d.get("b_5x", 0.0)))

	if d.has("cosmetics") and typeof(d["cosmetics"]) == TYPE_ARRAY:
		for item in d["cosmetics"]:
			var cid = str(item)
			if not (cid in owned_cosmetics):
				owned_cosmetics.append(cid)
	equipped_egg_skin = str(d.get("eq_egg", "egg_classic"))
	equipped_crack_style = str(d.get("eq_crack", "crack_normal"))
	equipped_particle_style = str(d.get("eq_part", "part_gold"))
	equipped_bg_theme = str(d.get("eq_bg", "bg_day"))
	equipped_reveal_aura = str(d.get("eq_aura", "aura_normal"))

	if d.has("slimes") and typeof(d["slimes"]) == TYPE_DICTIONARY:
		for k in d["slimes"]:
			var mig_key = EggWorldData.migrate_legacy_slime_id(str(k))
			var val = int(d["slimes"][k])
			if str(k) != mig_key:
				slime_counts[mig_key] = int(slime_counts.get(mig_key, 0)) + val
			else:
				slime_counts[mig_key] = val
	# Ensure if player already hatched nature slimes in v2, crystal egg is unlocked
	var nature_hatched_sum: int = 0
	for s in SLIME_CATALOG:
		if s["egg_id"] == "nature":
			nature_hatched_sum += int(slime_counts.get(s["id"], 0))
	if nature_hatched_sum > 0 and not bool(egg_states["crystal"]["unlocked"]):
		egg_states["crystal"]["unlocked"] = true
		egg_states["nature"]["drops_count"] = maxi(int(egg_states["nature"]["drops_count"]), nature_hatched_sum)

	if d.has("unseen") and typeof(d["unseen"]) == TYPE_DICTIONARY:
		slime_unseen.clear()
		for k in d["unseen"]:
			if bool(d["unseen"][k]):
				var mig_key = EggWorldData.migrate_legacy_slime_id(str(k))
				slime_unseen[mig_key] = true

	pet_tokens = maxi(0, int(d.get("pet_tokens", 1)))
	if d.has("owned_pets") and typeof(d["owned_pets"]) == TYPE_ARRAY:
		owned_pets.clear()
		for item in d["owned_pets"]:
			var mp := PetData.migrate_legacy_pet_id(str(item))
			if not (mp in owned_pets):
				owned_pets.append(mp)
	equipped_pet_id = PetData.migrate_legacy_pet_id(str(d.get("equipped_pet", "")))
	if pet_companion:
		pet_companion.set_pet(equipped_pet_id)
	_update_wheel_hud()

	setting_sfx_volume = clampf(float(d.get("sfx_vol", 1.0)), 0.0, 1.0)
	setting_particles_enabled = bool(d.get("part_on", true))
	setting_reduced_shake = bool(d.get("red_shake", false))
	setting_game_zoom = clampf(float(d.get("game_zoom", 1.0)), 0.70, 1.50)
	_apply_game_zoom()

	_apply_user_settings()
	_apply_world_visuals(active_egg_id, false)
	_apply_all_cosmetics()
	if crack_overlay:
		crack_overlay.set_clicks(current_clicks, target_clicks)
	if fancy_bar:
		fancy_bar.set_progress(current_clicks, true, target_clicks)
	_update_hud()

# --- YouTube Playables SDK Callbacks ---

func _on_yt_load_data_received(data: String) -> void:
	is_cloud_data_loaded = true
	_apply_loaded_json(data)

func _on_yt_save_success() -> void:
	pass

func _on_yt_save_failed(error_message: String) -> void:
	push_warning("[Main] Cloud save failed: " + error_message)

func _on_yt_game_paused() -> void:
	_save_progress()
	get_tree().paused = true
	if pause_overlay:
		pause_overlay.visible = true

func _on_yt_game_resumed() -> void:
	get_tree().paused = false
	if pause_overlay:
		pause_overlay.visible = false
	_yt_audio_allowed = YTGameWrapper.is_audio_enabled()
	_apply_audio_state(_yt_audio_allowed)
	_update_responsive_layout()

func _on_yt_audio_changed(is_enabled: bool) -> void:
	_yt_audio_allowed = is_enabled
	_apply_audio_state(is_enabled)

func _apply_audio_state(is_enabled: bool) -> void:
	var should_mute: bool = (not is_enabled) or (setting_sfx_volume <= 0.01)
	AudioServer.set_bus_mute(0, should_mute)
	if not should_mute:
		AudioServer.set_bus_volume_db(0, linear_to_db(clampf(setting_sfx_volume, 0.05, 1.0)))

func _on_resume_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		if pause_overlay:
			pause_overlay.visible = false
