class_name PetData
extends RefCounted

const RARITY_ORDER: Array[String] = ["common", "uncommon", "rare", "epic", "legendary", "mythic"]

const RARITY_META: Dictionary = {
	"common": { "name": "Common", "weight": 45.0, "color": Color(0.76, 0.80, 0.88), "glow": Color(0.5, 0.6, 0.75, 0.4) },
	"uncommon": { "name": "Uncommon", "weight": 25.0, "color": Color(0.28, 0.92, 0.36), "glow": Color(0.2, 0.85, 0.3, 0.5) },
	"rare": { "name": "Rare", "weight": 15.0, "color": Color(0.22, 0.78, 1.0), "glow": Color(0.15, 0.7, 1.0, 0.6) },
	"epic": { "name": "Epic", "weight": 9.0, "color": Color(0.78, 0.32, 1.0), "glow": Color(0.7, 0.25, 1.0, 0.65) },
	"legendary": { "name": "Legendary", "weight": 5.0, "color": Color(1.0, 0.84, 0.16), "glow": Color(1.0, 0.8, 0.1, 0.8) },
	"mythic": { "name": "Mythic", "weight": 1.0, "color": Color(0.95, 0.25, 0.72), "glow": Color(0.9, 0.15, 0.85, 0.9) }
}

# Exakt die 11 Tiere auf dem bereitgestellten Glücksrad im Uhrzeigersinn ab 12 Uhr (Segment 0..10):
# 0: Hund, 1: Katze, 2: Maus, 3: Hase, 4: Fuchs, 5: Frosch, 6: Panda, 7: Drache, 8: Phönix, 9: Einhorn, 10: Kosmischer Begleiter
const PET_CATALOG: Array[Dictionary] = [
	{
		"id": "pet_dog",
		"segment_index": 0,
		"name": "Hund",
		"animal": "Hund",
		"rarity": "common",
		"rarity_name": "Common",
		"color": Color(0.76, 0.80, 0.88),
		"desc": "Ein treuer, fröhlicher Vierbeiner mit Schlappohren und wedelndem Schwanz.",
		"bonus_desc": "+1 Klickkraft permanent.",
		"click_power_add": 1,
		"coin_mult": 0.0,
		"luck_mult": 0.0,
		"auto_click_interval": 0.0,
		"crit_chance": 0.0,
		"duplicate_coins": 500,
		"path": "res://assets/pets/pet_dog.png"
	},
	{
		"id": "pet_cat",
		"segment_index": 1,
		"name": "Katze",
		"animal": "Katze",
		"rarity": "common",
		"rarity_name": "Common",
		"color": Color(0.76, 0.80, 0.88),
		"desc": "Eine neugierige Schmusekatze, die sanft schnurrt und neugierig blinzelt.",
		"bonus_desc": "+10 % Münzen pro Klick.",
		"click_power_add": 0,
		"coin_mult": 0.10,
		"luck_mult": 0.0,
		"auto_click_interval": 0.0,
		"crit_chance": 0.0,
		"duplicate_coins": 500,
		"path": "res://assets/pets/pet_cat.png"
	},
	{
		"id": "pet_mouse",
		"segment_index": 2,
		"name": "Maus",
		"animal": "Maus",
		"rarity": "common",
		"rarity_name": "Common",
		"color": Color(0.76, 0.80, 0.88),
		"desc": "Eine flinke, winzige Maus mit großen Kulleraugen.",
		"bonus_desc": "+1 Klickkraft permanent.",
		"click_power_add": 1,
		"coin_mult": 0.0,
		"luck_mult": 0.0,
		"auto_click_interval": 0.0,
		"crit_chance": 0.0,
		"duplicate_coins": 500,
		"path": "res://assets/pets/pet_mouse.png"
	},
	{
		"id": "pet_bunny",
		"segment_index": 3,
		"name": "Hase",
		"animal": "Hase",
		"rarity": "uncommon",
		"rarity_name": "Uncommon",
		"color": Color(0.28, 0.92, 0.36),
		"desc": "Ein schneeweißer Flausch-Hase, der bei jedem Klick fröhlich in die Höhe hüpft.",
		"bonus_desc": "+20 % Münzen bei Ei-Öffnungen.",
		"click_power_add": 0,
		"coin_mult": 0.20,
		"luck_mult": 0.0,
		"auto_click_interval": 0.0,
		"crit_chance": 0.0,
		"duplicate_coins": 1000,
		"path": "res://assets/pets/pet_bunny.png"
	},
	{
		"id": "pet_fox",
		"segment_index": 4,
		"name": "Fuchs",
		"animal": "Fuchs",
		"rarity": "rare",
		"rarity_name": "Rare",
		"color": Color(0.22, 0.78, 1.0),
		"desc": "Ein schlauer Rotfuchs mit buschigem Schweif und funkelnden Augen.",
		"bonus_desc": "+2 Klickkraft & +15 % Slime-Glück.",
		"click_power_add": 2,
		"coin_mult": 0.0,
		"luck_mult": 0.15,
		"auto_click_interval": 0.0,
		"crit_chance": 0.0,
		"duplicate_coins": 2000,
		"path": "res://assets/pets/pet_fox.png"
	},
	{
		"id": "pet_frog",
		"segment_index": 5,
		"name": "Frosch",
		"animal": "Frosch",
		"rarity": "uncommon",
		"rarity_name": "Uncommon",
		"color": Color(0.28, 0.92, 0.36),
		"desc": "Ein glücklicher Laubfrosch mit glänzenden Augen und Sprungfeder-Beinen.",
		"bonus_desc": "Auto-Klick: Gibt alle 3 Sekunden 1 effektiven Klick.",
		"click_power_add": 0,
		"coin_mult": 0.0,
		"luck_mult": 0.0,
		"auto_click_interval": 3.0,
		"crit_chance": 0.0,
		"duplicate_coins": 1000,
		"path": "res://assets/pets/pet_frog.png"
	},
	{
		"id": "pet_panda",
		"segment_index": 6,
		"name": "Panda",
		"animal": "Panda",
		"rarity": "rare",
		"rarity_name": "Rare",
		"color": Color(0.22, 0.78, 1.0),
		"desc": "Ein gemütlicher Panda, der entspannt an seinem Bambusstab kaut.",
		"bonus_desc": "+30 % mehr Münzen aus allen Quellen.",
		"click_power_add": 0,
		"coin_mult": 0.30,
		"luck_mult": 0.0,
		"auto_click_interval": 0.0,
		"crit_chance": 0.0,
		"duplicate_coins": 2000,
		"path": "res://assets/pets/pet_panda.png"
	},
	{
		"id": "pet_dragon",
		"segment_index": 7,
		"name": "Drache",
		"animal": "Drache",
		"rarity": "epic",
		"rarity_name": "Epic",
		"color": Color(0.78, 0.32, 1.0),
		"desc": "Ein magischer Kristall-Drache mit leuchtenden Hörnern und Schwingen.",
		"bonus_desc": "+3 Klickkraft & +25 % Slime-Glück.",
		"click_power_add": 3,
		"coin_mult": 0.0,
		"luck_mult": 0.25,
		"auto_click_interval": 0.0,
		"crit_chance": 0.10,
		"duplicate_coins": 4000,
		"path": "res://assets/pets/pet_dragon.png"
	},
	{
		"id": "pet_phoenix",
		"segment_index": 8,
		"name": "Phönix",
		"animal": "Phönix",
		"rarity": "legendary",
		"rarity_name": "Legendary",
		"color": Color(1.0, 0.84, 0.16),
		"desc": "Ein majestätischer Feuer-Phönix mit golden leuchtenden Flammenfedern.",
		"bonus_desc": "+4 Klickkraft & 20 % Chance auf 4x Kritische Klicks!",
		"click_power_add": 4,
		"coin_mult": 0.35,
		"luck_mult": 0.0,
		"auto_click_interval": 0.0,
		"crit_chance": 0.20,
		"duplicate_coins": 8000,
		"path": "res://assets/pets/pet_phoenix.png"
	},
	{
		"id": "pet_unicorn",
		"segment_index": 9,
		"name": "Einhorn",
		"animal": "Einhorn",
		"rarity": "epic",
		"rarity_name": "Epic",
		"color": Color(0.78, 0.32, 1.0),
		"desc": "Ein zauberhaftes Sternen-Einhorn mit Regenbogen-Mähne und goldenem Horn.",
		"bonus_desc": "Auto-Klick: Gibt jede Sekunde 1 effektiven Klick.",
		"click_power_add": 2,
		"coin_mult": 0.20,
		"luck_mult": 0.0,
		"auto_click_interval": 1.0,
		"crit_chance": 0.0,
		"duplicate_coins": 4000,
		"path": "res://assets/pets/pet_unicorn.png"
	},
	{
		"id": "pet_cosmic_companion",
		"segment_index": 10,
		"name": "Kosmischer Begleiter",
		"animal": "Kosmischer Begleiter",
		"rarity": "mythic",
		"rarity_name": "Mythic",
		"color": Color(0.95, 0.25, 0.72),
		"desc": "Ein mystisches Wesen aus reinem Sternennebel und funkelnder Galaxie-Energie.",
		"bonus_desc": "Urkraft: +5 Klickkraft, +50 % Münzen & +50 % Slime-Glück!",
		"click_power_add": 5,
		"coin_mult": 0.50,
		"luck_mult": 0.50,
		"auto_click_interval": 0.8,
		"crit_chance": 0.20,
		"duplicate_coins": 20000,
		"path": "res://assets/pets/pet_cosmic_companion.png"
	}
]

# Exakte Wahrscheinlichkeiten laut Vorgabe (Summe = 100.0 %):
# Common: 45 %, Uncommon: 25 %, Rare: 15 %, Epic: 9 %, Legendary: 5 %, Mythic: 1 %
const RARITY_WEIGHTS: Array[Dictionary] = [
	{ "rarity": "common", "weight": 45.0 },
	{ "rarity": "uncommon", "weight": 25.0 },
	{ "rarity": "rare", "weight": 15.0 },
	{ "rarity": "epic", "weight": 9.0 },
	{ "rarity": "legendary", "weight": 5.0 },
	{ "rarity": "mythic", "weight": 1.0 }
]

# Die 11 Segmente auf dem Rad im Uhrzeigersinn (0 = 12 Uhr Zeiger oben):
const WHEEL_SEGMENTS: Array[Dictionary] = [
	{ "segment_index": 0, "pet_id": "pet_dog", "title": "Hund", "rarity": "common", "weight": 15.0 },
	{ "segment_index": 1, "pet_id": "pet_cat", "title": "Katze", "rarity": "common", "weight": 15.0 },
	{ "segment_index": 2, "pet_id": "pet_mouse", "title": "Maus", "rarity": "common", "weight": 15.0 },
	{ "segment_index": 3, "pet_id": "pet_bunny", "title": "Hase", "rarity": "uncommon", "weight": 12.5 },
	{ "segment_index": 4, "pet_id": "pet_fox", "title": "Fuchs", "rarity": "rare", "weight": 7.5 },
	{ "segment_index": 5, "pet_id": "pet_frog", "title": "Frosch", "rarity": "uncommon", "weight": 12.5 },
	{ "segment_index": 6, "pet_id": "pet_panda", "title": "Panda", "rarity": "rare", "weight": 7.5 },
	{ "segment_index": 7, "pet_id": "pet_dragon", "title": "Drache", "rarity": "epic", "weight": 4.5 },
	{ "segment_index": 8, "pet_id": "pet_phoenix", "title": "Phönix", "rarity": "legendary", "weight": 5.0 },
	{ "segment_index": 9, "pet_id": "pet_unicorn", "title": "Einhorn", "rarity": "epic", "weight": 4.5 },
	{ "segment_index": 10, "pet_id": "pet_cosmic_companion", "title": "Kosmischer Begleiter", "rarity": "mythic", "weight": 1.0 }
]

static func migrate_legacy_pet_id(pid: String) -> String:
	match pid:
		"pet_crystal_stag":
			return "pet_dragon"
		"pet_nebula_owl":
			return "pet_unicorn"
		"pet_cosmic_phoenix":
			return "pet_cosmic_companion"
		_:
			return pid

static func get_pet_by_id(pet_id: String) -> Dictionary:
	var clean_id := migrate_legacy_pet_id(pet_id)
	for p in PET_CATALOG:
		if p["id"] == clean_id:
			return p
	return {}

static func get_pets_by_rarity(rarity: String) -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for p in PET_CATALOG:
		if p["rarity"] == rarity:
			list.append(p)
	return list

static func spin_wheel(rng: RandomNumberGenerator) -> Dictionary:
	# Schritt 1: Exakt nach Seltenheits-Wahrscheinlichkeiten (45 / 25 / 15 / 9 / 5 / 1 = 100.0 %) auswürfeln
	var total_weight: float = 0.0
	for rw in RARITY_WEIGHTS:
		total_weight += float(rw["weight"])

	var roll: float = rng.randf_range(0.0, total_weight)
	var accum: float = 0.0
	var chosen_rarity: String = "common"

	for rw in RARITY_WEIGHTS:
		accum += float(rw["weight"])
		if roll <= accum:
			chosen_rarity = rw["rarity"]
			break

	# Schritt 2: Ein Tier dieser Seltenheit auf dem Glücksrad auswählen
	var candidates: Array[Dictionary] = get_pets_by_rarity(chosen_rarity)
	var picked_pet: Dictionary = candidates[rng.randi_range(0, candidates.size() - 1)] if not candidates.is_empty() else PET_CATALOG[0]
	var seg_index: int = int(picked_pet["segment_index"])
	var chosen_seg: Dictionary = WHEEL_SEGMENTS[seg_index]

	return {
		"segment_index": seg_index,
		"segment": chosen_seg,
		"rarity": chosen_rarity,
		"pet": picked_pet
	}
