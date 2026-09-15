extends Node
## Autoload singleton that loads monster species data from data/monsters.json
## and exposes lookup helpers. Original code, not ported from Tuxemon's
## Python engine.

const DATA_PATH := "res://data/monsters.json"

var _monsters_by_id: Dictionary = {}
var loaded: bool = false

func _ready() -> void:
	_load()

func _load() -> void:
	if not FileAccess.file_exists(DATA_PATH):
		push_error("MonsterDB: data file not found at %s" % DATA_PATH)
		return

	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	var text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if parsed == null or not parsed.has("monsters"):
		push_error("MonsterDB: failed to parse monsters.json")
		return

	for m in parsed["monsters"]:
		_monsters_by_id[m["id"]] = m

	loaded = true

## Returns the monster data dictionary for the given id, or an empty
## dictionary if not found.
func get_monster(id: String) -> Dictionary:
	return _monsters_by_id.get(id, {})

## Returns all monster ids currently loaded.
func get_all_ids() -> Array:
	return _monsters_by_id.keys()
