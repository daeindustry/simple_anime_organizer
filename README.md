markdown

# 📺 Anime File Organizer

Automatically organize anime episode files into series-specific folders by intelligently parsing filenames.

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


Basic Usage:
.\AnimeOrganizer.ps1

Dry Run (Test):
.\AnimeOrganizer.ps1 -DryRun  

Specific Folder: 
.\AnimeOrganizer.ps1 -SourcePath "D:\Anime" 

Network Share:
.\AnimeOrganizer.ps1 -SourcePath "\\NAS\Anime"
