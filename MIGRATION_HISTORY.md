# Migration History

The Godot 3 → Godot 4 migration in this branch was completed by Claude (Anthropic) in **August 2025** as a series of in-place edits — see commits `b4bca8a` ("BEGIN Claude helping") through `5472104` ("Basically able to play one level"). API changes are documented in `CLAUDE.md` under "Migration Status".

A separate attempt with Gemini 3 Pro (via Google's Antigravity IDE) was started in **February 2026** in a sibling repo (`~/work/rob/conswiconai/conswi`, branch `godot4-migration`). That attempt produced essentially the same API fixes via a different path (Godot's auto-converter + surgical Conventional-Commits fixes), but was abandoned in favor of the Claude branch — one commit (`f877970`) shipped truncated `connect_signals()` code with stream-of-thought comments left in source.

The Feb 2026 planning session below is preserved as historical context. The "bottom-up `git mv`" strategy described was **not** the strategy ultimately used.

---

# Session 001: Migration Strategy Definition (the road not taken)

**Date:** 06 February 2026
**Goal:** Define a Godot 3 to 4 migration path that preserves Git history.

## The Challenge
- **History Preservation:** We might keep the git history of every file.
- **Path Dependencies:** Godot uses `res://` paths which are relative to `project.godot`. Moving a file to a new subdirectory (e.g., `conswi/4/`) breaks its internal `res://` references if the target files haven't moved yet.

## The "Bottom-Up" Strategy (Leaves First)
To minimize friction and broken references, migrate dependencies *before* the code that depends on them.

### 1. Setup
- Create the new project directory (e.g., `4/` inside `conswi/`).
- Initialize a blank Godot 4 project (`project.godot`).

### 2. Execution Order
Use `git mv` to move files from the legacy root to the new directory.

1. **Phase 1: Assets (The Leaves)**
   - Images (`images/`)
   - Audio (`audio/`)
   - Fonts
   - *Why:* These have no dependencies on other files.

2. **Phase 2: Independent Scripts**
   - Autoloads with no dependencies (e.g., `Globals.gd`).
   - Helper scripts (`Helpers.gd` — likely depends on Assets).
   - Data scripts (`Data.gd`, `Databases`).

3. **Phase 3: Core Logic (The Trunk)**
   - Component Scripts.
   - Main Game Logic (`Game.gd`).
   - *Why:* When these arrive in the new project, the `Globals` and `Assets` they reference are already there.

### 3. The Process
For each file/batch:
1. `mkdir -p conswi_v4/target_dir`
2. `git mv conswi/path/to/file.gd conswi_v4/path/to/file.gd`
3. Fix syntax errors in Godot 4 (export, onready, etc.).
4. Commit.
