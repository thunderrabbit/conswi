# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## GitHub access

Before running any `gh` command, run `source .gh-token` to load the conswi-scoped PAT (`GH_TOKEN`). Without it, `gh` falls back to Rob's user-wide token. Not needed for `git push/pull` (those use SSH).

## Project Overview

ConSwi is a swipe-based puzzle game built with Godot Engine 4. The game involves swiping patterns to collect animal tiles across different themed worlds (Dog, Cow, Lion, Monkey, Panda, Rabbit, Tiger, etc.). Players must complete specific swipe patterns to clear tiles and progress through levels.

**Note**: This project has been migrated from Godot 3 to Godot 4, with all major API changes updated for compatibility.

## Development Commands

### Running the Game
- Open project in Godot Editor: Launch Godot 4.x and open the `project.godot` file
- Test/Play: Press F5 or use the "Play" button in Godot Editor
- Export builds: Use Godot's export functionality with presets defined in `export_presets.cfg`
- **Important**: Must use Godot 4.x or later due to API changes from migration

### Export Platforms
The game supports multiple export targets:
- Android (`AndroidConSwi`)
- iOS (`iOS`)
- HTML5 (`HTML ConSwi`)

### Debug Features
- Set `debug_level = 1` in Game.gd for debug mode
- Set `fill_level = true` and `max_tiles_avail = 1000` for testing
- Use `always_play_level_zero = true` to always test level 0

## Architecture Overview

### Core Systems

**Game Flow Management:**
- `Game.gd` - Main game controller, handles level lifecycle, player movement, and game state
- `GameHUD.gd` - Manages UI overlays, buttons, and level information display
- `SceneSwitcher.gd` - Handles transitions between different scenes/screens

**Level System:**
- `levels/LevelDatabase.gd` - Central registry for all levels across different worlds
- `levels/NormalLevel.gd` - Base class for level definitions
- Individual level files in `levels/[AnimalName]World/normal_[XX].gd`

**Swipe Detection:**
- `GameSwipeDetector.gd` - Detects and validates player swipe patterns
- `helpers/ShapeDatabase.gd` - Defines all valid swipe patterns/shapes
- `helpers/named_swipes/` - Contains specific swipe pattern definitions

**World/Tile Management:**
- `helpers/TileDatabase.gd` - Manages different animal tile types
- `helpers/Helpers.gd` - Core utilities for game board management
- `helpers/Globals.gd` - Global constants, coordinates, and game configuration

### Key Autoloaded Singletons
- `G` (Globals.gd) - Global constants and helper functions
- `Helpers` - Game board utilities and common functions
- `SceneSwitcher` - Scene management
- `TileDatabase` - Tile type definitions
- `ShapeDatabase` - Swipe pattern definitions
- `LevelDatabase` - Level management
- `SoundManager` - Audio system (from addon)

### Asset Organization
- `images/world_skins/[animal]/` - Animal-specific backgrounds and tiles
- `audio/bgm/` - Background music
- `audio/se/` - Sound effects (organized by category)
- `levels/[AnimalName]World/` - Level definitions per world

## Swipe System

The game's core mechanic revolves around pattern recognition:
1. Players swipe across tiles to form specific shapes
2. Valid swipe patterns are defined in `helpers/named_swipes/`
3. Successful swipes remove tiles and contribute to level completion
4. Different animals/worlds may have different required patterns

## Adding New Content

### New Swipe Patterns
1. Add shape definition to `helpers/named_swipes/named_swipes.gd`
2. Patterns are defined as arrays representing the swipe path
3. Use debug mode to test and capture new swipe coordinates

### New Levels
1. Create new level file in appropriate `levels/[AnimalName]World/` directory
2. Follow naming convention: `normal_[XX].gd`
3. Extend from NormalLevel class
4. Define required tiles, time limits, and swipe requirements

### New Animal Worlds
1. Add animal type constant to `helpers/Globals.gd`
2. Create directory structure: `levels/[AnimalName]World/`
3. Add corresponding images in `images/world_skins/[animal]/`
4. Register in `LevelDatabase.gd`

## Testing Strategy

- Level 0 is designed for quick swipe functionality testing
- Use debug mode flags in Game.gd for development testing
- Test swipe detection by enabling debug output in GameSwipeDetector.gd

## Migration Status ✅ COMPLETE (Godot 3 → 4)

**Successfully migrated to Godot 4.4.1** - The game now runs without errors.

### Key API changes that were applied:
- **File API**: `File.new()` → `FileAccess.open()`, `file_exists()` → `FileAccess.file_exists()`
- **JSON handling**: `to_json()` → `JSON.stringify()`, `parse_json()` → `JSON.parse_string()`, `JSON.parse()` → `JSON.new().parse()`
- **Signal connections**: `connect("signal", node, "method")` → `connect("signal", node.method)`
- **Node types**: `Sprite` → `Sprite2D`
- **Resource management**: `instance()` → `instantiate()`
- **Control properties**: `rect_position` → `position`, `margin_top` → `position.y`
- **TextureButton methods**: `set_normal_texture()` → `texture_normal`, `set_button_icon()` → `icon`
- **Window/OS API**: `OS.get_window_size()` → `get_viewport().get_window().size`
- **Rendering**: `update()` → `queue_redraw()`
- **Export syntax**: `export var` → `@export var`
- **Onready**: `onready var` → `@onready var`
- **Tool scripts**: `tool` → `@tool`
- **Directory API**: `Directory` → `DirAccess`
- **Dictionary methods**: `.empty()` → `.is_empty()`
- **String constructor**: `String()` → `str()`
- **Project config**: Updated version and input maps for Godot 4

### Post-Migration Status:
✅ Game loads successfully  
✅ World selection interface functional  
✅ No runtime API errors  
✅ Sound Manager addon updated  
✅ All major systems operational

The ConSwi puzzle game is now fully compatible with Godot 4.x and ready for development.