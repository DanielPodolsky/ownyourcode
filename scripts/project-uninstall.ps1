# OwnYourCode Project Uninstallation Script (Windows)
# Cleanly removes OwnYourCode from a project

$ErrorActionPreference = "Stop"

# Paths
$PROJECT_DIR = Get-Location
$MANIFEST = Join-Path $PROJECT_DIR ".claude/ownyourcode-manifest.json"

# Detect CLAUDE.md location from manifest (or fallback to legacy locations)
if (Test-Path $MANIFEST) {
    $manifestContent = Get-Content $MANIFEST -Raw | ConvertFrom-Json
    $CLAUDE_MD_REL = $manifestContent.claude_md_location

    # Check if backup_path is null (fresh install) or a path (merged install)
    if ($null -eq $manifestContent.backup_path) {
        $FRESH_INSTALL = $true
        $BACKUP = $null
    } else {
        $FRESH_INSTALL = $false
    }

    # Convert relative to absolute
    if ($CLAUDE_MD_REL -eq "./CLAUDE.md") {
        $CLAUDE_MD = Join-Path $PROJECT_DIR "CLAUDE.md"
        if (-not $FRESH_INSTALL) { $BACKUP = Join-Path $PROJECT_DIR "CLAUDE.md.pre-ownyourcode" }
    } else {
        $CLAUDE_MD = Join-Path $PROJECT_DIR ".claude/CLAUDE.md"
        if (-not $FRESH_INSTALL) { $BACKUP = Join-Path $PROJECT_DIR ".claude/CLAUDE.md.pre-ownyourcode" }
    }
    $HAS_MANIFEST = $true
} else {
    # Legacy fallback - check both locations
    $rootClaudeMd = Join-Path $PROJECT_DIR "CLAUDE.md"
    $rootContent = if (Test-Path $rootClaudeMd) { Get-Content $rootClaudeMd -Raw -ErrorAction SilentlyContinue } else { $null }
    if ($rootContent -and ($rootContent -match "OWNYOURCODE:")) {
        $CLAUDE_MD = $rootClaudeMd
        $BACKUP = Join-Path $PROJECT_DIR "CLAUDE.md.pre-ownyourcode"
    } else {
        $CLAUDE_MD = Join-Path $PROJECT_DIR ".claude/CLAUDE.md"
        $BACKUP = Join-Path $PROJECT_DIR ".claude/CLAUDE.md.pre-ownyourcode"
    }
    $HAS_MANIFEST = $false
    $FRESH_INSTALL = $false
}

# Colors
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Header
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║            OwnYourCode Uninstallation                     ║" -ForegroundColor Red
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

# ============================================================================
# STEP 0: Check if OwnYourCode is installed
# ============================================================================

$ownyourcodeDir = Join-Path $PROJECT_DIR "ownyourcode"
$commandsDir = Join-Path $PROJECT_DIR ".claude/commands/own"

if ((-not (Test-Path $ownyourcodeDir)) -and (-not (Test-Path $commandsDir))) {
    Write-Warn "OwnYourCode does not appear to be installed in this project."
    exit 0
}

# ============================================================================
# STEP 1: Confirm
# ============================================================================

Write-Info "This will remove OwnYourCode from: $PROJECT_DIR"
Write-Host ""
Write-Host "  Will remove:"
Write-Host "    - ownyourcode/ folder"
Write-Host "    - .claude/commands/own/"
Write-Host "    - .claude/skills/ (OwnYourCode skills only)"
Write-Host "    - OwnYourCode section from CLAUDE.md"
if ($HAS_MANIFEST) {
    Write-Host "    - .claude/ownyourcode-manifest.json"
}
Write-Host ""

$confirm = Read-Host "Continue? [y/N]"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Info "Cancelled."
    exit 0
}

Write-Host ""

# ============================================================================
# STEP 2: Handle CLAUDE.md
# ============================================================================

Write-Info "Handling CLAUDE.md..."

if (Test-Path $CLAUDE_MD) {
    if ($HAS_MANIFEST -and $FRESH_INSTALL) {
        # Fresh install - we created it, delete entirely
        Remove-Item $CLAUDE_MD -Force
        Write-OK "Removed CLAUDE.md (was created by OwnYourCode)"
    } elseif ($BACKUP -and (Test-Path $BACKUP)) {
        # Merged install with backup - restore original
        Copy-Item $BACKUP $CLAUDE_MD -Force
        Remove-Item $BACKUP -Force
        Write-OK "Restored original CLAUDE.md from backup"
    } elseif ((Get-Content $CLAUDE_MD -Raw) -match "OWNYOURCODE:") {
        # Legacy fallback - remove OwnYourCode section using regex
        $content = Get-Content $CLAUDE_MD -Raw
        $cleaned = $content -replace "# ═.*OWNYOURCODE[\s\S]*?# ═.*END OWNYOURCODE[^\n]*\n?", ""
        $cleaned = $cleaned.Trim()

        if ([string]::IsNullOrWhiteSpace($cleaned)) {
            Remove-Item $CLAUDE_MD -Force
            Write-OK "Removed CLAUDE.md (was only OwnYourCode content)"
        } else {
            Set-Content -Path $CLAUDE_MD -Value $cleaned
            Write-OK "Removed OwnYourCode section from CLAUDE.md"
        }
    } else {
        Write-Info "No OwnYourCode section found in CLAUDE.md"
    }
} else {
    Write-Info "No CLAUDE.md found"
}

# ============================================================================
# STEP 3: Remove commands
# ============================================================================

Write-Info "Removing commands..."

if (Test-Path $commandsDir) {
    Remove-Item $commandsDir -Recurse -Force
    Write-OK "Removed .claude/commands/own/"
} else {
    Write-Info "No commands folder found"
}

# Clean up empty commands directory
$parentCommandsDir = Join-Path $PROJECT_DIR ".claude/commands"
if ((Test-Path $parentCommandsDir) -and ((Get-ChildItem $parentCommandsDir | Measure-Object).Count -eq 0)) {
    Remove-Item $parentCommandsDir -Recurse -Force
    Write-Info "Removed empty .claude/commands/"
}

# ============================================================================
# STEP 4: Remove OwnYourCode skills (preserve user skills)
# ============================================================================

Write-Info "Removing OwnYourCode skills..."

$skillsDir = Join-Path $PROJECT_DIR ".claude/skills"
$oycSkillFolders = @("fundamentals", "gates", "career", "learned")

if (Test-Path $skillsDir) {
    foreach ($folder in $oycSkillFolders) {
        $folderPath = Join-Path $skillsDir $folder
        if (Test-Path $folderPath) {
            Remove-Item $folderPath -Recurse -Force
        }
    }
    Write-OK "Removed OwnYourCode skills (user skills preserved)"

    # Clean up empty skills directory
    if ((Get-ChildItem $skillsDir | Measure-Object).Count -eq 0) {
        Remove-Item $skillsDir -Recurse -Force
        Write-Info "Removed empty .claude/skills/"
    } else {
        Write-Info "Preserved user skills in .claude/skills/"
    }
} else {
    Write-Info "No skills folder found"
}

# ============================================================================
# STEP 5: Remove manifest
# ============================================================================

if (Test-Path $MANIFEST) {
    Remove-Item $MANIFEST -Force
    Write-OK "Removed manifest"
}

# Clean up empty .claude directory
$claudeDir = Join-Path $PROJECT_DIR ".claude"
if ((Test-Path $claudeDir) -and ((Get-ChildItem $claudeDir | Measure-Object).Count -eq 0)) {
    Remove-Item $claudeDir -Recurse -Force
    Write-Info "Removed empty .claude/"
}

# ============================================================================
# STEP 6: Remove ownyourcode folder
# ============================================================================

Write-Info "Removing ownyourcode folder..."

if (Test-Path $ownyourcodeDir) {
    # Check for active specs
    $activeSpecs = Join-Path $ownyourcodeDir "specs/active"
    if ((Test-Path $activeSpecs) -and ((Get-ChildItem $activeSpecs | Measure-Object).Count -gt 0)) {
        Write-Warn "You have active specs in ownyourcode/specs/active/"
        $deleteSpecs = Read-Host "Delete them too? [y/N]"
        if ($deleteSpecs -ne "y" -and $deleteSpecs -ne "Y") {
            # Backup specs
            $specsBackup = Join-Path $PROJECT_DIR "ownyourcode-specs-backup"
            Move-Item (Join-Path $ownyourcodeDir "specs") $specsBackup
            Write-OK "Backed up specs to ownyourcode-specs-backup/"
        }
    }

    Remove-Item $ownyourcodeDir -Recurse -Force
    Write-OK "Removed ownyourcode/"
} else {
    Write-Info "No ownyourcode folder found"
}

# ============================================================================
# COMPLETE
# ============================================================================

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          Uninstallation Complete!                         ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-OK "OwnYourCode has been removed from this project."
Write-Host ""

Write-Info "To reinstall later:"
Write-Host "  irm https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/project-install.ps1 | iex"
Write-Host ""
