# AnimeOrganizer

## Quick start

```powershell
# Dry run (default: current directory)
.\AnimeOrganizer.ps1 -DryRun

# Specify a directory
.\AnimeOrganizer.ps1 -SourcePath "D:\Anime" -DryRun

# Verbose output (shows per-file matching details)
.\AnimeOrganizer.ps1 -DryRun -Verbose
```

## What it does

Scans a directory for anime video files (`.mkv`, `.mp4`, `.avi`, `.webm`) and moves them into per-series folders. Detects series names from filenames using 11 regex patterns covering `[Group] Series - S01E01`, plain episode numbers, dot-separated, OVA, Special, Movie, and no-group-tag formats (e.g., `Series (Year) - S01E01`).

## Gotchas

- Files with `.txt` sidecars (nfo, subs, etc.) are **not** moved — only video files
- Unmatched files are listed at the end with no action taken
- The script prompts for confirmation before moving files (skipped in `-DryRun` mode)
- Destination file conflicts are skipped silently (not overwritten)
