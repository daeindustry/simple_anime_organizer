param(
    [string]$SourcePath = (Get-Location).Path,
    [switch]$DryRun
)

# Store the original source path
$ORIGINAL_SOURCE_PATH = $SourcePath

Write-Host ""
Write-Host "Enhanced Anime Organizer" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host "Source: $ORIGINAL_SOURCE_PATH"
Write-Host "DryRun: $DryRun"
Write-Host ""

# Initialize counters
$movedCount = 0
$errorCount = 0
$foldersCreated = 0
$skippedCount = 0

# Get all video files
$videoFiles = Get-ChildItem -LiteralPath $ORIGINAL_SOURCE_PATH -File | Where-Object {
    $_.Extension -match '\.(mkv|mp4|avi|webm)$'
}

Write-Host "Found $($videoFiles.Count) video files" -ForegroundColor Green
Write-Host ""

if ($videoFiles.Count -eq 0) {
    Write-Host "No video files found!" -ForegroundColor Yellow
    exit
}

$seriesGroups = @{}
$unmatched = @()

# Enhanced regex patterns (in order of specificity)
$patterns = @(
    # Pattern 1: [Group] Series Name - S01E01 / S01E01v2
    @{
        Regex = '^[\[]([^\]]+)[\]]\s+(.+?)\s+-\s+(S\d{2}E\d{2})(?:v\d+)?(?:\s|\.|$)'
        Type = "Episode"
        GroupSeries = 2
        GroupEpisode = 3
    },
    
    # Pattern 2: [Group] Series Name - EpisodeNumber (plain digits, no S01E01)
    @{
        Regex = '^[\[]([^\]]+)[\]]\s+(.+?)\s+-\s+(\d+)(?:\s|\.|$)'
        Type = "Episode"
        GroupSeries = 2
        GroupEpisode = 3
    },
    
    # Pattern 3: Series.Name.S01E01 (dot-separated, no group tag)
    @{
        Regex = '^(.+?)\.(S\d{2}E\d{2})(?:\.|$)'
        Type = "Episode"
        GroupSeries = 1
        GroupEpisode = 2
    },
    
    # Pattern 4: [Group] Series Name - OVA - Title
    @{
        Regex = '^[\[]([^\]]+)[\]]\s+(.+?)\s+-\s+OVA\s+-\s+(.+?)(?:\s*\(|$)'
        Type = "OVA"
        GroupSeries = 2
    },
    
    # Pattern 5: [Group] Series Name - Special Name (DVD Rip, BluRay, etc.)
    @{
        Regex = '^[\[]([^\]]+)[\]]\s+(.+?)\s+-\s+(.+?)\s+\('
        Type = "Special"
        GroupSeries = 2
    },
    
    # Pattern 6: [Group] Movie/Special Name (no episode number, has parentheses)
    @{
        Regex = '^[\[]([^\]]+)[\]]\s+(.+?)\s+\('
        Type = "Movie"
        GroupSeries = 2
    },
    
    # Pattern 7: Series (Year) - S01E01 - Title (no group tag)
    @{
        Regex = '^(.+?\(20\d{2}\))\s+-\s+(S\d{2}E\d{2})(?:v\d+)?(?:\s|\.|$)'
        Type = "Episode"
        GroupSeries = 1
        GroupEpisode = 2
    },
    
    # Pattern 8: Series (Year) - OVA - Title (no group tag)
    @{
        Regex = '^(.+?\(20\d{2}\))\s+-\s+OVA\s+-\s+(.+?)(?:\s*\(|$)'
        Type = "OVA"
        GroupSeries = 1
    },
    
    # Pattern 9: Series (Year) - Movie/Special (no group tag)
    @{
        Regex = '^(.+?\(20\d{2}\))\s+\((?:Movie|Special)\)'
        Type = "Movie"
        GroupSeries = 1
    },
    
    # Pattern 10: Series - OVA - Title (no group, no year)
    @{
        Regex = '^(.+?)\s+-\s+OVA\s+-\s+(.+?)(?:\s*\(|$)'
        Type = "OVA"
        GroupSeries = 1
    },
    
    # Pattern 11: Dot-separated movie with year (e.g., Name.2025.1080p...)
    @{
        Regex = '^(.+?)\.(\d{4})\.\d{3,4}p'
        Type = "Movie"
        GroupSeries = 1
    }
)

Write-Host "Analyzing filenames..." -ForegroundColor Cyan
Write-Host ""

foreach ($file in $videoFiles) {
    $name = $file.BaseName
    $matched = $false
    
    Write-Host "Checking: $($file.Name)" -ForegroundColor Gray
    
    # Try each pattern
    foreach ($pattern in $patterns) {
        if ($name -match $pattern.Regex) {
            $releaseGroup = $Matches[$pattern.GroupRelease].Trim()
            $seriesName = $Matches[$pattern.GroupSeries].Trim()
            
            # Extract season/episode from S0xE0x format if applicable
            $seasonNum = $null
            $episodeNum = $null
            $episodeLabel = ""
            if ($pattern.GroupEpisode -and $Matches[$pattern.GroupEpisode] -match '^S(\d{2})E(\d{2})(?:v\d)?$') {
                $seasonNum = [int]$Matches[1]
                $episodeNum = [int]$Matches[2]
                $episodeLabel = "S$seasonNum E$episodeNum"
            } elseif ($pattern.GroupEpisode) {
                $episodeLabel = $Matches[$pattern.GroupEpisode]
            }
            
            # Sanitize series name: replace em dash with regular dash
            $seriesName = $seriesName -replace '\u2013', '-'
            # Remove forbidden filename characters
            $seriesName = $seriesName -replace '[<>:"/\\|?*]', '_'
            
            Write-Host "  MATCHED ($($pattern.Type))!" -ForegroundColor Green
            Write-Host "  Release: $releaseGroup" -ForegroundColor Cyan
            Write-Host "  Series: $seriesName" -ForegroundColor Cyan
            Write-Host "  Episode/Type: $episodeLabel" -ForegroundColor Cyan
            
            # Group by series name
            if (-not $seriesGroups.ContainsKey($seriesName)) {
                $seriesGroups[$seriesName] = @()
            }
            $seriesGroups[$seriesName] += $file
            
            $matched = $true
            break  # Stop trying patterns once we find a match
        }
    }
    
    if (-not $matched) {
        $unmatched += $file
        Write-Host "  NO MATCH" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

Write-Host ""
Write-Host "=========================" -ForegroundColor Cyan
Write-Host "Found $($seriesGroups.Count) series" -ForegroundColor Green
Write-Host ""

if ($seriesGroups.Count -eq 0) {
    Write-Host "No series detected!" -ForegroundColor Red
    
    if ($unmatched.Count -gt 0) {
        Write-Host ""
        Write-Host "Unmatched files:" -ForegroundColor Yellow
        foreach ($file in $unmatched | Select-Object -First 10) {
            Write-Host "  - $($file.Name)" -ForegroundColor Gray
        }
    }
    exit
}

# Show series summary
foreach ($series in $seriesGroups.Keys | Sort-Object) {
    Write-Host "  $series - $($seriesGroups[$series].Count) files" -ForegroundColor White
}

if ($unmatched.Count -gt 0) {
    Write-Host ""
    Write-Host "Unmatched: $($unmatched.Count) files" -ForegroundColor Yellow
}

Write-Host ""

# Confirm
if (-not $DryRun) {
    Write-Host "Ready to move files into folders." -ForegroundColor Yellow
    $response = Read-Host "Continue? (y/n)"
    if ($response -ne 'y') {
        Write-Host "Cancelled" -ForegroundColor Yellow
        exit
    }
}

Write-Host ""
Write-Host "=========================" -ForegroundColor Cyan
Write-Host "Processing files..." -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# Process each series
foreach ($series in $seriesGroups.Keys | Sort-Object) {
    Write-Host ""
    Write-Host "--- Series: $series ---" -ForegroundColor Cyan
    Write-Host ""
    
    # Build folder path
    $folderPath = Join-Path -Path $ORIGINAL_SOURCE_PATH -ChildPath $series
    
    # Create folder if needed
    if (-not (Test-Path -LiteralPath $folderPath)) {
        if ($DryRun) {
            Write-Host "[DRY RUN] Would create: $folderPath" -ForegroundColor Yellow
        } else {
            try {
                New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
                
                if (Test-Path -LiteralPath $folderPath) {
                    Write-Host "[OK] Folder created" -ForegroundColor Green
                    $foldersCreated++
                } else {
                    Write-Host "[ERROR] Folder creation failed" -ForegroundColor Red
                    continue
                }
            } catch {
                Write-Host "[ERROR] Exception creating folder: $_" -ForegroundColor Red
                continue
            }
        }
    } else {
        Write-Host "Folder exists: $series" -ForegroundColor Gray
    }
    
    Write-Host ""
    
    # Move each file
    foreach ($file in $seriesGroups[$series]) {
        $sourceFile = $file.FullName
        $destFile = Join-Path -Path $folderPath -ChildPath $file.Name
        
        Write-Host "File: $($file.Name)" -ForegroundColor White
        
        # Check source exists
        if (-not (Test-Path -LiteralPath $sourceFile)) {
            Write-Host "  [ERROR] Source doesn't exist!" -ForegroundColor Red
            $errorCount++
            Write-Host ""
            continue
        }
        
        # Check if destination already exists
        if (Test-Path -LiteralPath $destFile) {
            Write-Host "  [SKIPPED] Already exists in destination" -ForegroundColor Yellow
            $skippedCount++
            Write-Host ""
            continue
        }
        
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would move to: $series\" -ForegroundColor Yellow
        } else {
            try {
                Move-Item -LiteralPath $sourceFile -Destination $destFile -Force -ErrorAction Stop
                
                # Verify
                if (Test-Path -LiteralPath $destFile) {
                    Write-Host "  [SUCCESS] Moved!" -ForegroundColor Green
                    $movedCount++
                } else {
                    Write-Host "  [ERROR] Move reported success but file not at destination" -ForegroundColor Red
                    $errorCount++
                }
            } catch {
                Write-Host "  [ERROR] Move failed: $_" -ForegroundColor Red
                $errorCount++
            }
        }
        Write-Host ""
    }
}

# Summary
Write-Host ""
Write-Host "=========================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "DRY RUN - No changes made" -ForegroundColor Yellow
} else {
    Write-Host "Folders created: $foldersCreated" -ForegroundColor White
    Write-Host "Files moved: $movedCount" -ForegroundColor Green
    Write-Host "Files skipped: $skippedCount" -ForegroundColor Yellow
    Write-Host "Errors: $errorCount" -ForegroundColor $(if($errorCount -gt 0){"Red"}else{"Green"})
}

if ($unmatched.Count -gt 0) {
    Write-Host "Unmatched files: $($unmatched.Count)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Unmatched files list:" -ForegroundColor Yellow
    foreach ($file in $unmatched) {
        Write-Host "  - $($file.Name)" -ForegroundColor Gray
    }
}
Write-Host ""