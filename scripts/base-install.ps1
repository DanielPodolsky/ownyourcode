# OwnYourCode Base Installation Script (Windows)
# AI-Mentored Development for Juniors
#
# Usage: irm https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/base-install.ps1 | iex

$ErrorActionPreference = "Stop"

# Config
$REPO_URL = "https://github.com/DanielPodolsky/ownyourcode.git"
$ZIP_URL = "https://github.com/DanielPodolsky/ownyourcode/archive/refs/heads/main.zip"
$INSTALL_DIR = Join-Path $env:USERPROFILE "ownyourcode"

# Colors
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Header
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║            OwnYourCode Installation                   ║" -ForegroundColor Green
Write-Host "║      AI-Mentored Development for Juniors              ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# ============================================================================
# Check for existing installation
# ============================================================================

if (Test-Path $INSTALL_DIR) {
    Write-Warn "OwnYourCode already installed at $INSTALL_DIR"
    Write-Host ""
    $update = Read-Host "Update existing installation? (y/N)"
    if ($update -eq "y" -or $update -eq "Y") {
        Write-Info "Updating OwnYourCode..."
        $gitDir = Join-Path $INSTALL_DIR ".git"
        if (Test-Path $gitDir) {
            Push-Location $INSTALL_DIR
            git pull origin main
            Pop-Location
            Write-OK "OwnYourCode updated!"
        } else {
            Write-Warn "Not a git repo. Reinstalling..."
            Remove-Item -Recurse -Force $INSTALL_DIR
        }
    } else {
        Write-Info "Keeping existing installation."
        Write-Host ""
        Write-Info "To use OwnYourCode in a project:"
        Write-Host "  cd your-project"
        Write-Host "  ~/ownyourcode/scripts/project-install.ps1"
        Write-Host ""
        exit 0
    }
}

# ============================================================================
# Install OwnYourCode
# ============================================================================

if (-not (Test-Path $INSTALL_DIR)) {
    Write-Info "Installing OwnYourCode to $INSTALL_DIR..."

    # Try git clone first
    $gitExists = Get-Command git -ErrorAction SilentlyContinue
    if ($gitExists) {
        git clone $REPO_URL $INSTALL_DIR
        Write-OK "Cloned via git"
    } else {
        # Fallback to zip download
        Write-Warn "git not found, downloading zip..."
        $zipPath = Join-Path $env:TEMP "ownyourcode.zip"
        $extractPath = Join-Path $env:TEMP "ownyourcode-extract"

        Invoke-WebRequest -Uri $ZIP_URL -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        $extractedDir = Join-Path $extractPath "ownyourcode-main"
        Move-Item -Path $extractedDir -Destination $INSTALL_DIR

        Remove-Item $zipPath -Force
        Remove-Item $extractPath -Recurse -Force
        Write-OK "Downloaded and extracted"
    }
}

# ============================================================================
# Create global learning structure (v2.1 - Global Learning)
# ============================================================================

Write-Info "Creating global learning registry..."

$learningDir = Join-Path $INSTALL_DIR "learning"
$patternsDir = Join-Path $learningDir "patterns"
$failuresDir = Join-Path $learningDir "failures"
$registryPath = Join-Path $learningDir "LEARNING_REGISTRY.md"

New-Item -ItemType Directory -Force -Path $patternsDir | Out-Null
New-Item -ItemType Directory -Force -Path $failuresDir | Out-Null

if (-not (Test-Path $registryPath)) {
    $nl = [Environment]::NewLine
    $registryLines = @(
        "# Global Learning Registry",
        "",
        "> Automatically updated by ``/retrospective``. Query with ``/advise``.",
        "> This file tracks your growth as an engineer across ALL projects.",
        "> Location: ~/ownyourcode/learning/ (global, not project-specific)",
        "",
        "---",
        "",
        "## Patterns (Reusable Solutions)",
        "",
        "Successful patterns you have discovered and can reuse:",
        "",
        "| Date | Domain | Pattern | Project | Location |",
        "|------|--------|---------|---------|----------|",
        "| | | *No patterns recorded yet* | | |",
        "",
        "---",
        "",
        "## Failures (Anti-Patterns)",
        "",
        "Mistakes you have made and learned from (the most valuable learnings):",
        "",
        "| Date | Domain | Issue | Project | Location |",
        "|------|--------|-------|---------|----------|",
        "| | | *No failures documented yet* | | |",
        "",
        "---",
        "",
        "## Competency Progression",
        "",
        "Track your growth over time:",
        "",
        "| Week | Level | Evidence |",
        "|------|-------|----------|",
        "| Start | (learning) | Beginning OwnYourCode journey |",
        "",
        "---",
        "",
        "## Detailed Entries",
        "",
        "*Entries will be added here chronologically as you complete ``/retrospective`` sessions.*"
    )
    Set-Content -Path $registryPath -Value ($registryLines -join $nl)
    Write-OK "Global learning registry created at ~/ownyourcode/learning/"
} else {
    Write-OK "Global learning registry already exists"
}

# ============================================================================
# Complete
# ============================================================================

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          Installation Complete!                       ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-OK "OwnYourCode installed to ~/ownyourcode/"
Write-Host ""

Write-Info "Next steps:"
Write-Host ""
Write-Host "  1. Go to your project:"
Write-Host "     cd your-project"
Write-Host ""
Write-Host "  2. Install OwnYourCode into that project:"
Write-Host "     ~/ownyourcode/scripts/project-install.ps1"
Write-Host ""
Write-Host "  3. Open Claude Code and run:"
Write-Host "     /own:init"
Write-Host ""

Write-Info "Remember: OwnYourCode makes AI your MENTOR, not your coder."
Write-Info "You write the code. You build the skills. You own your career."
Write-Host ""
