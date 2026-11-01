extends RefCounted
class_name EggWorldData

## Central configuration for the 3 Unique Eggs & Worlds, Random Click Target Distribution,
## 18 Unique Slimes (6 per Egg), and Rarity Drop Tables.

const EGG_IDS: Array[String] = ["nature", "crystal", "cosmic"]

const EGG_WORLDS: Dictionary = {
	"nature": {
		"id": "nature",
		"name": "Nature Egg",
		"title_de": "Nature Egg – Naturwelt",
		"subtitle": "Lebendige Wiese, alte Bäume & Naturmagie",
		"egg_texture": "res://assets/egg_nature.svg",
		"bg_texture": "res://assets/bg_nature.png",
		"crack_style": "nature",
		"accent_color": Color("#47eb5c"),
		"card_palette": "green",
		"shell_color": Color(0.96, 0.91, 0.80),
		"unlock_text": "Von Beginn an freigeschaltet",
		"unlock_req_egg": "",
		"desc": "Cremefarbenes Natur-Ei mit Moos-Akzenten. Enthält 6 Natur-, Wald-, Wasser- und Pflanzen-Slimes."
	},
	"crystal": {
		"id": "crystal",
		"name": "Crystal Egg",
		"title_de": "Crystal Egg – Kristallhöhle",
		"subtitle": "Magische Kristallgrotte & leuchtende Eiskristalle",
		"egg_texture": "res://assets/egg_crystal.svg",
		"bg_texture": "res://assets/bg_crystal.png",
		"crack_style": "crystal",
		"accent_color": Color("#38d4ff"),
		"card_palette": "blue",
		"shell_color": Color(0.45, 0.88, 1.0),
		"unlock_text": "Freischaltung: Öffne 1x das Nature Egg",
		"unlock_req_egg": "nature",
		"desc": "Leuchtendes Kristall-Ei mit Kristallspitzen. Enthält 6 Eis-, Wasser- und Kristall-Slimes."
	},
	"cosmic": {
		"id": "cosmic",
		"name": "Cosmic Egg",
		"title_de": "Cosmic Egg – Kosmoswelt",
		"subtitle": "Ferne Galaxien, Sternennebel & dunkle Energie",
		"egg_texture": "res://assets/egg_cosmic.svg",
		"bg_texture": "res://assets/bg_cosmic.png",
		"crack_style": "cosmic",
		"accent_color": Color("#d44dff"),
		"card_palette": "purple",
		"shell_color": Color(0.42, 0.18, 0.78),
		"unlock_text": "Freischaltung: Öffne 1x das Crystal Egg",
		"unlock_req_egg": "crystal",
		"desc": "Mysteriöses Kosmos-Ei mit Energieadern. Enthält 6 Weltraum-, Schatten-, Sternen- und Galaxie-Slimes."
	}
}

## Section 2: Exact Random Click Target probability distribution (Sum = 100%)
const CLICK_TARGET_TABLE: Array[Dictionary] = [
	{ "target": 1000,  "weight": 1 },
	{ "target": 2000,  "weight": 2 },
	{ "target": 3000,  "weight": 3 },
	{ "target": 4000,  "weight": 4 },
	{ "target": 5000,  "weight": 5 },
	{ "target": 6000,  "weight": 7 },
	{ "target": 7000,  "weight": 8 },
	{ "target": 8000,  "weight": 10 },
	{ "target": 9000,  "weight": 15 },
	{ "target": 10000, "weight": 45 }
]

const RARITY_ORDER: Array[String] = ["common", "uncommon", "rare", "epic", "legendary", "mythic", "secret"]

const RARITY_META: Dictionary = {
	"common":    { "name": "COMMON",    "base_chance": 70.0, "color": Color(0.82, 0.88, 0.96) },
	"uncommon":  { "name": "UNCOMMON",  "base_chance": 20.0, "color": Color(0.32, 0.94, 0.42) },
	"rare":      { "name": "RARE",      "base_chance": 7.0,  "color": Color(0.24, 0.80, 1.00) },
	"epic":      { "name": "EPIC",      "base_chance": 2.0,  "color": Color(0.80, 0.36, 1.00) },
	"legendary": { "name": "LEGENDARY", "base_chance": 0.8,  "color": Color(1.00, 0.84, 0.16) },
	"mythic":    { "name": "MYTHIC",    "base_chance": 0.2,  "color": Color(0.95, 0.26, 0.92) },
	"secret":    { "name": "???",       "base_chance": 0.5,  "color": Color(1.00, 0.45, 0.95) }
}

## Section 5: 18 Unique Slimes (6 per Egg)
const SLIME_CATALOG: Array[Dictionary] = [
	# --- Nature Egg Slimes (6) ---
	{
		"id": "nature_common",
		"egg_id": "nature",
		"rarity": "common",
		"rarity_name": "COMMON",
		"name": "Pebble Slime",
		"base_chance": 70.0,
		"reward_coins": 1500,
		"color": Color(0.82, 0.88, 0.96),
		"desc": "Grauer, friedlicher Kiesel-Slime mit glatter, steinartiger Oberfläche.",
		"path": "res://assets/slimes/nature_common.png"
	},
	{
		"id": "nature_uncommon",
		"egg_id": "nature",
		"rarity": "uncommon",
		"rarity_name": "UNCOMMON",
		"name": "Leaf Slime",
		"base_chance": 20.0,
		"reward_coins": 2000,
		"color": Color(0.32, 0.94, 0.42),
		"desc": "Lebendiger grüner Natur-Slime mit frischen kleinen Blättern auf dem Kopf.",
		"path": "res://assets/slimes/nature_uncommon.png"
	},
	{
		"id": "nature_rare",
		"egg_id": "nature",
		"rarity": "rare",
		"rarity_name": "RARE",
		"name": "River Slime",
		"base_chance": 7.0,
		"reward_coins": 3500,
		"color": Color(0.24, 0.80, 1.0),
		"desc": "Reiner Flusswasser-Slime mit fließenden Wellen und funkelnden Wassertropfen.",
		"path": "res://assets/slimes/nature_rare.png"
	},
	{
		"id": "nature_epic",
		"egg_id": "nature",
		"rarity": "epic",
		"rarity_name": "EPIC",
		"name": "Forest Spirit",
		"base_chance": 2.0,
		"reward_coins": 7000,
		"color": Color(0.80, 0.36, 1.0),
		"desc": "Magischer violett-grüner Waldgeist-Slime mit leuchtenden Geweih-Ranken und Runen.",
		"path": "res://assets/slimes/nature_epic.png"
	},
	{
		"id": "nature_legendary",
		"egg_id": "nature",
		"rarity": "legendary",
		"rarity_name": "LEGENDARY",
		"name": "Golden Guardian",
		"base_chance": 0.8,
		"reward_coins": 16000,
		"color": Color(1.0, 0.84, 0.16),
		"desc": "Goldener Wächter-Slime des Waldes mit Krone, Flügeln und strahlender Naturmagie!",
		"path": "res://assets/slimes/nature_legendary.png"
	},
	{
		"id": "nature_mythic",
		"egg_id": "nature",
		"rarity": "mythic",
		"rarity_name": "MYTHIC",
		"name": "Ancient Nature",
		"base_chance": 0.2,
		"reward_coins": 51000,
		"color": Color(0.95, 0.26, 0.92),
		"desc": "Einzigartiger Urzeit-Slime mit leuchtenden Lotusblüten, magischen Ranken und Sporen-Aura!",
		"path": "res://assets/slimes/nature_mythic.png"
	},

	# --- Crystal Egg Slimes (6) ---
	{
		"id": "crystal_common",
		"egg_id": "crystal",
		"rarity": "common",
		"rarity_name": "COMMON",
		"name": "Frost Slime",
		"base_chance": 70.0,
		"reward_coins": 1800,
		"color": Color(0.82, 0.88, 0.96),
		"desc": "Hellblauer Gletscher-Slime mit kühler, glänzender Eisstruktur.",
		"path": "res://assets/slimes/crystal_common.png"
	},
	{
		"id": "crystal_uncommon",
		"egg_id": "crystal",
		"rarity": "uncommon",
		"rarity_name": "UNCOMMON",
		"name": "Aqua Slime",
		"base_chance": 20.0,
		"reward_coins": 2500,
		"color": Color(0.32, 0.94, 0.42),
		"desc": "Türkiser Kristallquellen-Slime mit schwebenden Wasserblasen im Inneren.",
		"path": "res://assets/slimes/crystal_uncommon.png"
	},
	{
		"id": "crystal_rare",
		"egg_id": "crystal",
		"rarity": "rare",
		"rarity_name": "RARE",
		"name": "Crystal Slime",
		"base_chance": 7.0,
		"reward_coins": 4200,
		"color": Color(0.24, 0.80, 1.0),
		"desc": "Tiefblauer Edelstein-Slime mit leuchtenden Kristallspitzen auf dem Kopf!",
		"path": "res://assets/slimes/crystal_rare.png"
	},
	{
		"id": "crystal_epic",
		"egg_id": "crystal",
		"rarity": "epic",
		"rarity_name": "EPIC",
		"name": "Ice Wizard",
		"base_chance": 2.0,
		"reward_coins": 8500,
		"color": Color(0.80, 0.36, 1.0),
		"desc": "Violett-blauer Magier-Slime mit Kristallhut, Zauberstab und schwebenden Eisrunen!",
		"path": "res://assets/slimes/crystal_epic.png"
	},
	{
		"id": "crystal_legendary",
		"egg_id": "crystal",
		"rarity": "legendary",
		"rarity_name": "LEGENDARY",
		"name": "Diamond King",
		"base_chance": 0.8,
		"reward_coins": 20000,
		"color": Color(1.0, 0.84, 0.16),
		"desc": "Strahlend diamantblauer Herrscher-Slime mit funkelnder Juwelenkrone!",
		"path": "res://assets/slimes/crystal_legendary.png"
	},
	{
		"id": "crystal_mythic",
		"egg_id": "crystal",
		"rarity": "mythic",
		"rarity_name": "MYTHIC",
		"name": "Prismatic Crystal",
		"base_chance": 0.2,
		"reward_coins": 65000,
		"color": Color(0.95, 0.26, 0.92),
		"desc": "Außergewöhnlicher Mythic-Slime mit schillernden Kristallen und Regenbogenreflexionen!",
		"path": "res://assets/slimes/crystal_mythic.png"
	},

	# --- Cosmic Egg Slimes (6) ---
	{
		"id": "cosmic_common",
		"egg_id": "cosmic",
		"rarity": "common",
		"rarity_name": "COMMON",
		"name": "Shadow Slime",
		"base_chance": 70.0,
		"reward_coins": 2200,
		"color": Color(0.82, 0.88, 0.96),
		"desc": "Dunkler Sternenschatten-Slime mit sanft leuchtenden violetten Akzenten.",
		"path": "res://assets/slimes/cosmic_common.png"
	},
	{
		"id": "cosmic_uncommon",
		"egg_id": "cosmic",
		"rarity": "uncommon",
		"rarity_name": "UNCOMMON",
		"name": "Moon Slime",
		"base_chance": 20.0,
		"reward_coins": 3000,
		"color": Color(0.32, 0.94, 0.42),
		"desc": "Silberblauer Mondlicht-Slime mit leuchtender goldener Mondsichel.",
		"path": "res://assets/slimes/cosmic_uncommon.png"
	},
	{
		"id": "cosmic_rare",
		"egg_id": "cosmic",
		"rarity": "rare",
		"rarity_name": "RARE",
		"name": "Star Slime",
		"base_chance": 7.0,
		"reward_coins": 5000,
		"color": Color(0.24, 0.80, 1.0),
		"desc": "Nachtblauer Astral-Slime mit strahlend goldenen Sternen und Sternenstaub.",
		"path": "res://assets/slimes/cosmic_rare.png"
	},
	{
		"id": "cosmic_epic",
		"egg_id": "cosmic",
		"rarity": "epic",
		"rarity_name": "EPIC",
		"name": "Nebula Slime",
		"base_chance": 2.0,
		"reward_coins": 10000,
		"color": Color(0.80, 0.36, 1.0),
		"desc": "Violetter Galaxie-Slime mit tiefen kosmischen Sternennebel-Mustern und Krone.",
		"path": "res://assets/slimes/cosmic_epic.png"
	},
	{
		"id": "cosmic_legendary",
		"egg_id": "cosmic",
		"rarity": "legendary",
		"rarity_name": "LEGENDARY",
		"name": "Solar King",
		"base_chance": 0.8,
		"reward_coins": 25000,
		"color": Color(1.0, 0.84, 0.16),
		"desc": "Majestätischer gold-magentafarbener Sonnen-Slime mit flammender Sonnenkrone!",
		"path": "res://assets/slimes/cosmic_legendary.png"
	},
	{
		"id": "cosmic_mythic",
		"egg_id": "cosmic",
		"rarity": "mythic",
		"rarity_name": "MYTHIC",
		"name": "Black Hole Slime",
		"base_chance": 0.2,
		"reward_coins": 80000,
		"color": Color(0.95, 0.26, 0.92),
		"desc": "Ultimativer kosmischer Singularitäts-Slime mit Ereignishorizont-Ring und leuchtenden Augen!",
		"path": "res://assets/slimes/cosmic_mythic.png"
	},
	# --- Secret Mythical Slime (All Eggs) ---
	{
		"id": "secret_slime",
		"egg_id": "all",
		"egg_name": "Alle Eier",
		"rarity": "secret",
		"rarity_name": "???",
		"name": "??? Slime",
		"base_chance": 0.5,
		"reward_coins": 150000,
		"color": Color(1.0, 0.45, 0.95),
		"desc": "Ein sagenumwobener, gottgleicher ???-Slime mit kosmischer Regenbogen-Aura, schwebender Krone und funkelnden Sternen!",
		"path": "res://assets/slimes/secret_slime.png"
	}
]

## Roll a random click target strictly following Section 2 weights (sum = 100)
static func roll_click_target(rng: RandomNumberGenerator) -> int:
	var roll: int = rng.randi_range(1, 100)
	var cumulative: int = 0
	for entry in CLICK_TARGET_TABLE:
		cumulative += int(entry["weight"])
		if roll <= cumulative:
			return int(entry["target"])
	return 10000

static func is_valid_click_target(val: int) -> bool:
	for entry in CLICK_TARGET_TABLE:
		if int(entry["target"]) == val:
			return true
	return false

static func get_slimes_for_egg(egg_id: String) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for s in SLIME_CATALOG:
		if s["egg_id"] == egg_id or s["egg_id"] == "all":
			out.append(s)
	return out

static func get_slime_by_id(id: String) -> Dictionary:
	for s in SLIME_CATALOG:
		if s["id"] == id:
			return s
	return {}

static func get_slime_by_egg_and_rarity(egg_id: String, rarity_id: String) -> Dictionary:
	for s in SLIME_CATALOG:
		if s["egg_id"] == egg_id and s["rarity"] == rarity_id:
			return s
	# Fallback to first slime of that egg
	for s in SLIME_CATALOG:
		if s["egg_id"] == egg_id:
			return s
	return SLIME_CATALOG[0]

static func migrate_legacy_slime_id(legacy_id: String) -> String:
	match legacy_id:
		"common": return "nature_common"
		"uncommon": return "nature_uncommon"
		"rare": return "crystal_rare"
		"epic": return "cosmic_epic"
		"legendary": return "nature_legendary"
		"mythic": return "cosmic_mythic"
		_: return legacy_id
