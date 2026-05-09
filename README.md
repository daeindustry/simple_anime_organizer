# Anime File Organizer

Automatically organize anime episode files into series-specific folders by intelligently parsing filenames.

## Overview

PowerShell script that scans a directory for anime video files and moves them into per-series folders. Detects series names from filenames matching `[Group] Series Name - Episode` patterns, including S01E01, OVA, Special, and Movie formats.

**Features:**

- Scans for `.mkv`, `.mp4`, `.avi`, `.webm` files
- 6 pattern matching strategies for robust filename detection
- Extracts season/episode from `S01E01` format
- Creates per-series folders and moves episodes
- Dry-run mode for safe testing
- Em dash sanitization for folder names

## Requirements

- Windows 10/11 or Windows Server 2016+
- PowerShell 5.1 or higher
- Read/Write permissions on the source folder
- Works on local drives and network shares

## Usage

```powershell
# Dry run (default: current directory)
.\AnimeOrganizer.ps1 -DryRun

# Specify a directory
.\AnimeOrganizer.ps1 -SourcePath "D:\Anime" -DryRun

# Execute the move
.\AnimeOrganizer.ps1 -SourcePath "D:\Anime"
```

## Filename Patterns

The script tries these patterns in order:

| # | Format | Example |
|---|--------|---------|
| 1 | `S01E01` / `S01E01v2` | `[Subgroup] Series Name - S01E01.mkv` |
| 2 | Plain episode number | `[Subgroup] Series Name - 12.mkv` |
| 3 | Dot-separated | `[Subgroup] Series.Name.S01E01.mkv` |
| 4 | OVA | `[Subgroup] Series Name - OVA - Title.mkv` |
| 5 | Special | `[Subgroup] Series Name - Special Name (DVD Rip).mkv` |
| 6 | Movie | `[Subgroup] Series Name - Movie Title (DVD Rip).mkv` |

## Gotchas

- `.txt` sidecar files (NFO, subs, etc.) are not moved — only video files
- Unmatched files are listed at the end with no action taken
- The script prompts for confirmation before moving files (skipped in `-DryRun` mode)
- Destination file conflicts are skipped silently (not overwritten)
- `(Year)` is kept in series names (e.g., `Hunter x Hunter (2011)`)
