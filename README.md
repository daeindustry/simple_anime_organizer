markdown

# 📺 Anime File Organizer

Automatically organize anime episode files into series-specific folders by intelligently parsing filenames.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)

## 📖 Overview

This PowerShell script automatically organizes anime files into series-specific folders by parsing filenames. Perfect for managing large collections of anime downloads from release groups like SubsPlease, Erai-raws, HorribleSubs, and more.

**What it does:**
- 🔍 Scans a folder for anime video files
- 🧠 Extracts series names from filenames using intelligent pattern matching
- 📁 Creates folders for each series
- 🚀 Moves episodes into their respective folders
- ✅ Handles episodes, OVAs, movies, and specials

---

## 💾 Requirements

- **Windows 10/11** or **Windows Server 2016+**
- **PowerShell 5.1 or higher**
- **Read/Write permissions** on the source folder
- Works on **local drives** and **network shares**



📝 Usage
Basic Usage

Navigate to your anime folder and run:

powershell

cd D:\Downloads\Anime
D:\Scripts\AnimeOrganizer.ps1

Or specify the path directly:

powershell

D:\Scripts\AnimeOrganizer.ps1 -SourcePath "D:\Downloads\Anime"

Command Line Options
Parameter	Description	Example
-SourcePath	Path to folder containing anime files	-SourcePath "D:\Anime"
-DryRun	Preview changes without moving files	-DryRun
Examples

powershell

# Preview changes without moving files (RECOMMENDED FIRST!)
.\AnimeOrganizer.ps1 -DryRun

# Organize current directory
.\AnimeOrganizer.ps1

# Organize specific directory
.\AnimeOrganizer.ps1 -SourcePath "D:\Downloads\Anime"

# Organize network share
.\AnimeOrganizer.ps1 -SourcePath "\\NAS\Anime\Downloads"

📂 Supported Filename Formats

The script recognizes these common anime filename patterns:
✅ Standard Episodes

[SubsPlease] Frieren - 01 (1080p) [HASH].mkv
[Erai-raws] One Piece - 1090 [1080p].mkv
[HorribleSubs] Demon Slayer - 03 (720p).mp4

✅ OVAs (Original Video Animations)

[SubsPlease] Golden Kamuy - OVA1 (1080p).mkv
[SubsPlease] Konosuba - OVA2 (1080p).mkv

✅ Movies and Specials

[SubsPlease] Kizumonogatari - Koyomi Vamp (1080p).mkv
[SubsPlease] Demon Slayer - Mugen Train (1080p).mkv

✅ Multi-Part Episodes

[SubsPlease] Touken Ranbu - Hanamaru - Hana no Maki (1080p).mkv
[SubsPlease] Series Name - Part 1 (1080p).mkv

✅ Multi-Season Shows

[SubsPlease] Konosuba S3 - 01 (1080p).mkv
[Erai-raws] Overlord S4 - 12 [1080p].mkv

🎬 Supported Video Formats

    .mkv (most common)
    .mp4
    .avi
    .webm

📋 Step-by-Step Guide
Method 1: Safest Approach (Recommended)

Step 1: Preview with Dry Run

powershell

cd D:\Downloads\Anime
D:\Scripts\AnimeOrganizer.ps1 -DryRun

Review the output to see what would happen.

Step 2: Run for Real

powershell

D:\Scripts\AnimeOrganizer.ps1

Step 3: Confirm when prompted

Ready to move files into folders.
Continue? (y/n): y

Method 2: Network Share

powershell

# Option A: Direct path
D:\Scripts\AnimeOrganizer.ps1 -SourcePath "\\NAS\Anime\Downloads"

# Option B: Map drive first
net use Z: \\NAS\Anime
D:\Scripts\AnimeOrganizer.ps1 -SourcePath "Z:\Downloads"

📊 Before and After Example
Before Running Script

D:\Downloads\Anime\
├── [SubsPlease] Frieren - 01 (1080p).mkv
├── [SubsPlease] Frieren - 02 (1080p).mkv
├── [SubsPlease] Frieren - 03 (1080p).mkv
├── [SubsPlease] One Piece - 1090 (1080p).mkv
├── [SubsPlease] One Piece - 1091 (1080p).mkv
├── [SubsPlease] Demon Slayer - 01 (1080p).mkv
└── [Erai-raws] Spy Family - 01 [1080p].mkv

After Running Script

D:\Downloads\Anime\
├── Frieren\
│   ├── [SubsPlease] Frieren - 01 (1080p).mkv
│   ├── [SubsPlease] Frieren - 02 (1080p).mkv
│   └── [SubsPlease] Frieren - 03 (1080p).mkv
├── One Piece\
│   ├── [SubsPlease] One Piece - 1090 (1080p).mkv
│   └── [SubsPlease] One Piece - 1091 (1080p).mkv
├── Demon Slayer\
│   └── [SubsPlease] Demon Slayer - 01 (1080p).mkv
└── Spy Family\
    └── [Erai-raws] Spy Family - 01 [1080p].mkv

🎯 Common Use Cases
1. Weekly Anime Downloads

Create a batch file for quick access:

File: OrganizeAnime.bat

batch

@echo off
cd /d D:\Downloads\Anime
powershell.exe -ExecutionPolicy Bypass -File "D:\Scripts\AnimeOrganizer.ps1"
pause

Double-click to run!
2. Multiple Download Folders

Create a master organization script:

File: OrganizeAll.ps1

powershell

$folders = @(
    "D:\Downloads\Anime",
    "D:\Torrents\Completed",
    "\\NAS\Anime\New"
)

foreach ($folder in $folders) {
    Write-Host "Organizing: $folder" -ForegroundColor Cyan
    & "D:\Scripts\AnimeOrganizer.ps1" -SourcePath $folder
}

3. Scheduled Task (Windows Task Scheduler)

    Open Task Scheduler
    Create Basic Task
    Trigger: Weekly (or your preference)
    Action: Start a Program
    Program: powershell.exe
    Arguments: -ExecutionPolicy Bypass -File "D:\Scripts\AnimeOrganizer.ps1" -SourcePath "D:\Downloads\Anime"

⚠️ Important Notes
What the Script DOES

    ✅ Creates folders based on series names
    ✅ Moves video files into appropriate folders
    ✅ Preserves original filenames
    ✅ Works with local and network drives
    ✅ Handles episodes, OVAs, movies, and specials
    ✅ Skips files already in destination

What the Script DOES NOT Do

    ❌ Does not delete anything
    ❌ Does not rename files
    ❌ Does not modify video content
    ❌ Does not organize files already in subfolders
    ❌ Does not download anime
    ❌ Does not modify source files

Safety Features

    🛡️ Only moves files, never deletes
    🛡️ Files moved to subfolders in same location
    🛡️ Original filenames preserved
    🛡️ Skips if file already exists in destination
    🛡️ Dry run mode for safe testing

🔧 Troubleshooting
Problem: "Script cannot be loaded"

Error:

File cannot be loaded because running scripts is disabled on this system.

Solution:

powershell

# Run PowerShell as Administrator
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Problem: "Parameter '-File' not found"

Cause: Old PowerShell version (< 3.0)

Check version:

powershell

$PSVersionTable.PSVersion

Solution: Upgrade to PowerShell 5.1 or higher

    Download: https://aka.ms/PSWindows

Problem: Files not matching pattern

Symptom: Script says "NO MATCH" for your files

Solution:

    Check filename format matches one of these patterns:
        [Group] Series Name - 01 (quality).mkv
        [Group] Series Name - OVA1 (quality).mkv
        [Group] Movie Name (quality).mkv

    Look at the "Unmatched files:" section in output

    If needed, share unmatched filenames for pattern adjustment

Problem: "Access Denied" on network share

Solution 1: Run PowerShell as Administrator

Solution 2: Map network drive with credentials:

powershell

net use Z: \\NAS\Share /user:username password
D:\Scripts\AnimeOrganizer.ps1 -SourcePath "Z:\Anime"

Solution 3: Use UNC path with proper permissions:

powershell

# Ensure your Windows user has access to the share
D:\Scripts\AnimeOrganizer.ps1 -SourcePath "\\NAS\Anime"


🎓 Tips and Best Practices
1. Always Test First

powershell

# Use -DryRun before actually moving files
.\AnimeOrganizer.ps1 -DryRun


This is intentional - filenames preserve release group info.
📄 Quick Reference
╔════════════════════════════════════════════════════════════╗
║              ANIME ORGANIZER QUICK REFERENCE               ║
╠════════════════════════════════════════════════════════════╣
║ Basic Usage:                                               ║
║   .\AnimeOrganizer.ps1                                     ║
║                                                            ║
║ Dry Run (Test):                                            ║
║   .\AnimeOrganizer.ps1 -DryRun                             ║
║                                                            ║
║ Specific Folder:                                           ║
║   .\AnimeOrganizer.ps1 -SourcePath "D:\Anime"             ║
║                                                            ║
║ Network Share:                                             ║
║   .\AnimeOrganizer.ps1 -SourcePath "\\NAS\Anime"          ║
║                                                            ║
║ Supported Formats:                                         ║
║   [Group] Series - 01 (quality).mkv                        ║
║   [Group] Series - OVA1 (quality).mkv                      ║
║   [Group] Movie Name (quality).mkv                         ║
║   [Group] Series - Special Name (quality).mkv              ║
╚════════════════════════════════════════════════════════════╝
