extends Node2D
## Root script for the vertical-slice Main scene. Original code.

const TILE_SIZE := 16
const GRASS_ATLAS_COORD := Vector2i(0, 0)
const OBSTACLE_ATLAS_COORD := Vector2i(1, 0)
const MAP_WIDTH := 20
const MAP_HEIGHT := 20

func _ready() -> void:
	_build_tilemap()
	_verify_monster_pipeline()

## Hand-built small grass field with a scattered obstacle border, using the
## Tuxemon "core_outdoor_nature" tileset PNG copied into assets/tiles/.
## Built procedurally instead of a hand-authored .tscn TileSet resource so
## it stays easy to verify headlessly.
func _build_tilemap() -> void:
	var tilemap := $TileMap as TileMap
	var tileset := TileSet.new()
	tileset.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)

	var texture := load("res://assets/tiles/core_outdoor_nature.png") as Texture2D
	var source := TileSetAtlasSource.new()
	source.texture = texture
	source.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)
	source.create_tile(GRASS_ATLAS_COORD)
	source.create_tile(OBSTACLE_ATLAS_COORD)

	var source_id := tileset.add_source(source)
	tilemap.tile_set = tileset

	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			var on_border := x == 0 or y == 0 or x == MAP_WIDTH - 1 or y == MAP_HEIGHT - 1
			var atlas_coord := OBSTACLE_ATLAS_COORD if on_border else GRASS_ATLAS_COORD
			tilemap.set_cell(0, Vector2i(x, y), source_id, atlas_coord)

func _verify_monster_pipeline() -> void:
	# Prove the JSON data pipeline works end to end: MonsterDB (an autoload)
	# loads data/monsters.json on startup, and we fetch + print one entry.
	if not MonsterDB.loaded:
		push_error("MonsterDB failed to load monster data")
		return

	var ids := MonsterDB.get_all_ids()
	if ids.is_empty():
		push_error("MonsterDB loaded but has no monsters")
		return

	var monster := MonsterDB.get_monster(ids[0])
	print("Loaded monster: " + str(monster.get("name", "?")))
	print("  types: " + str(monster.get("types", [])))
	print("  base_stats: " + str(monster.get("base_stats", {})))
	print("  moves: " + str(monster.get("moves", [])))
	print("Monster DB total entries: " + str(ids.size()))
