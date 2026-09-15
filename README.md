# TuxemonIOS

A monster-catcher game built from scratch in Godot 4, inspired by
[Tuxemon](https://github.com/Tuxemon/Tuxemon) (an open-source, pygame-based
Pokemon-like game). Targeting iOS.

## Not a fork of Tuxemon

This project reuses none of Tuxemon's engine code. Tuxemon is written in
Python/pygame and licensed GPLv3; porting or copying its `.py` files would
require this project to also be GPLv3. To avoid that, **no Python source
was copied, ported, or referenced** — every `.gd` script here is original
code written for this project.

What *was* reused from Tuxemon is its **data and art assets** (monster
species data, sprites, tilesets), which the Tuxemon project publishes under
Creative Commons **CC BY-SA** (3.0/4.0 depending on asset). That's permitted
for reuse/remixing as long as attribution is given and derivative works
stay under a compatible share-alike license.

## Licensing (read carefully — two different licenses apply)

- **Original engine/game code** (everything under `scenes/`, `scripts/`,
  `project.godot`, and this README) is covered by the terms in `LICENSE`
  in this repo — an all-rights-reserved license with a non-commercial-use
  grant and a revenue-share requirement for commercial use. See `LICENSE`
  for the full terms.
- **Copied assets** (`assets/monsters/*.png`, `assets/tiles/*.png`, and
  `data/monsters.json`, which is derived from Tuxemon's monster database)
  originate from the [Tuxemon project](https://github.com/Tuxemon/Tuxemon)
  and remain under **CC BY-SA**. Attribution: "Monster sprites, tilesets,
  and species data adapted from the Tuxemon project
  (https://github.com/Tuxemon/Tuxemon), used under CC BY-SA." If you strip
  these assets out and replace them with your own original art, the
  CC BY-SA attribution requirement no longer applies to your fork — only
  the `LICENSE` terms would.
- No per-asset license audit has been done here beyond what Tuxemon
  states project-wide (CC BY-SA for art/data). Before any commercial
  release, verify individual asset provenance/licenses and add an
  in-app credits screen with attributions.

These two licenses are independent: the `LICENSE` file's terms govern the
*code*, and the CC BY-SA attribution above governs the *assets*. Don't
assume one covers the other.

## Current status

Vertical slice, not a full game:

- Godot 4.x project scaffolded, mobile-friendly viewport/stretch settings
  for eventual iOS export.
- `scripts/Player.gd`: `CharacterBody2D` with 4-direction movement via
  `Input.get_vector` (arrow keys / `ui_*` actions). Structured so a future
  virtual joystick or touch-drag handler can call `set_touch_direction()`
  instead of keyboard input — touch support itself is not implemented yet.
- `scenes/Main.tscn`: a small hand-built grass field (20x20 tiles) with an
  obstacle border, built procedurally at runtime from the copied
  `core_outdoor_nature.png` tileset, plus a `Player` node using a Tuxemon
  monster sprite as a placeholder character, followed by a `Camera2D`.
- `scripts/MonsterDB.gd` (autoload singleton): loads `data/monsters.json`
  via `FileAccess` + `JSON.parse_string()` at startup.
- `scripts/Main.gd`: on `_ready()`, builds the tilemap, then asks
  `MonsterDB` for the first loaded monster and prints its name, types,
  base stats, and moves to prove the data pipeline works end to end.
- `data/monsters.json`: 11 monsters converted from Tuxemon's YAML monster
  database (species, types, moveset). Tuxemon computes stats from a
  shape/level formula rather than storing flat base stats, so
  `base_stats` (`hp`/`atk`/`def`/`spd`) here are simplified placeholder
  values derived from each monster's id — replace with a real formula or
  hand-tuned values before shipping.
- No battle system, no capture mechanic, no NPCs/dialogue, no save system.

## Project layout

```
project.godot
scenes/Main.tscn        vertical slice scene
scripts/Main.gd         root script: builds tilemap, verifies MonsterDB load
scripts/Player.gd       CharacterBody2D 4-direction movement
scripts/MonsterDB.gd    autoload singleton: loads data/monsters.json
assets/monsters/        11 sample monster sprite sheets (Tuxemon, CC BY-SA)
assets/tiles/           2 tileset PNGs (Tuxemon, CC BY-SA)
assets/maps/            empty — Tuxemon .tmx maps not ported (format conversion skipped)
data/monsters.json      11 species: id, name, types, base_stats, moves
```

## Next steps

1. Battle system (turn order, damage formula, type chart, capture mechanic).
2. Import more of Tuxemon's assets (full monster roster, more tilesets,
   NPC sprites, UI) or commission/replace with original art.
3. Real player character sprite + walk animations (currently a placeholder
   monster sprite).
4. Touch controls (virtual joystick) for iOS, building on the
   `set_touch_direction()` hook in `Player.gd`.
5. iOS export presets (`export_presets.cfg`) — intentionally not created
   yet since it's machine/signing-specific; add via the Godot editor's
   Export dialog when ready.
6. Code signing with Daniel's existing paid Apple Developer account, then
   TestFlight upload.
