# AnimeOrganizer

PowerShell script that scans a directory for anime video files and organizes them into per-series folders.

## Quick start

```powershell
# Dry run (default: current directory)
.\AnimeOrganizer.ps1 -DryRun

# Specify a directory
.\AnimeOrganizer.ps1 -SourcePath "D:\Anime" -DryRun
```

## What it does

Scans a directory for anime video files (`.mkv`, `.mp4`, `.avi`, `.webm`) and moves them into per-series folders. Detects series names from filenames matching `[Group] Series Name - Episode` patterns (OVA, Episode, Special, Movie).

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `SourcePath` | `string` | Current directory | Directory to scan for anime files |
| `DryRun` | `switch` | `$false` | Preview changes without moving files |

## Detection patterns

1. `[Group] Series - OVA1` — OVA episodes
2. `[Group] Series - 12` — Regular episodes
3. `[Group] Series - Special (` — Specials/ED/OP collections
4. `[Group] Series (` — Movies or standalone specials

## Gotchas

- Files with `.txt` sidecars (nfo, subs, etc.) are **not** moved — only video files
- Unmatched files are listed at the end with no action taken
- The script prompts for confirmation before moving files (skipped in `-DryRun` mode)
- Destination file conflicts are skipped silently (not overwritten)
