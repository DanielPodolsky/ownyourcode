# OwnYourCode Project Installation Script (Windows)
# AI-Mentored Development for Juniors
# Version 2.2.4

$ErrorActionPreference = "Stop"

# Paths
$BASE_DIR = Join-Path $env:USERPROFILE "ownyourcode"
$PROJECT_DIR = Get-Location
$PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR

# Colors
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Header
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║            OwnYourCode Installation v2.2.4                ║" -ForegroundColor Green
Write-Host "║       AI-Mentored Spec-Driven Development Engine          ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Check base exists
if (-not (Test-Path $BASE_DIR)) {
    Write-Err "OwnYourCode base not found at $BASE_DIR. Run the base installer first."
}

Write-Info "Installing OwnYourCode into: $PROJECT_DIR"
Write-Host ""

# ============================================================================
# STEP 1: Handle existing installation
# ============================================================================

$ownyourcodeDir = Join-Path $PROJECT_DIR "ownyourcode"
if (Test-Path $ownyourcodeDir) {
    Write-Warn "OwnYourCode already installed in this project."
    $confirm = Read-Host "Reinstall? [y/N]"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Info "Cancelled."
        exit 0
    }
    Write-Host ""
}

# ============================================================================
# STEP 2: Create directory structure
# ============================================================================

Write-Info "Creating directories..."

$directories = @(
    "ownyourcode/product",
    "ownyourcode/specs/active",
    "ownyourcode/specs/completed",
    "ownyourcode/career/stories",
    "ownyourcode/guides",
    ".claude/commands/own",
    ".claude/skills/fundamentals/frontend",
    ".claude/skills/fundamentals/backend",
    ".claude/skills/fundamentals/security",
    ".claude/skills/fundamentals/performance",
    ".claude/skills/fundamentals/error-handling",
    ".claude/skills/fundamentals/engineering",
    ".claude/skills/fundamentals/database",
    ".claude/skills/fundamentals/testing",
    ".claude/skills/fundamentals/seo",
    ".claude/skills/fundamentals/accessibility",
    ".claude/skills/fundamentals/documentation",
    ".claude/skills/fundamentals/debugging",
    ".claude/skills/fundamentals/resistance",
    ".claude/skills/gates/ownership",
    ".claude/skills/gates/security",
    ".claude/skills/gates/error",
    ".claude/skills/gates/performance",
    ".claude/skills/gates/fundamentals",
    ".claude/skills/gates/testing",
    ".claude/skills/career/star-stories",
    ".claude/skills/career/resume-bullets",
    ".claude/skills/learned"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $PROJECT_DIR $dir
    New-Item -ItemType Directory -Force -Path $fullPath | Out-Null
}

Write-OK "Directories created"

# ============================================================================
# STEP 3: Handle CLAUDE.md (Smart Merge)
# ============================================================================

# Check BOTH locations - prefer root per Claude Code best practices
$ROOT_CLAUDE_MD = Join-Path $PROJECT_DIR "CLAUDE.md"
$DOTCLAUDE_MD = Join-Path $PROJECT_DIR ".claude/CLAUDE.md"
$TEMPLATE = Join-Path $BASE_DIR "core/CLAUDE.md.template"

Write-Info "Configuring CLAUDE.md..."

# Detect existing CLAUDE.md location
if (Test-Path $ROOT_CLAUDE_MD) {
    $CLAUDE_MD = $ROOT_CLAUDE_MD
    $CLAUDE_MD_REL = "./CLAUDE.md"
    Write-Info "Found existing CLAUDE.md at project root"
} elseif (Test-Path $DOTCLAUDE_MD) {
    $CLAUDE_MD = $DOTCLAUDE_MD
    $CLAUDE_MD_REL = "./.claude/CLAUDE.md"
    Write-Info "Found existing CLAUDE.md in .claude folder"
} else {
    # No existing - create at root (best practice)
    $CLAUDE_MD = $ROOT_CLAUDE_MD
    $CLAUDE_MD_REL = "./CLAUDE.md"
}

$BACKUP_PATH = $null

if (Test-Path $CLAUDE_MD) {
    $content = Get-Content $CLAUDE_MD -Raw

    if ($content -match "OWNYOURCODE:") {
        Write-Warn "OwnYourCode section already exists in CLAUDE.md"
        $replace = Read-Host "Replace existing OwnYourCode section? [y/N]"

        if (($replace -eq "y" -or $replace -eq "Y") -and (Test-Path $TEMPLATE)) {
            # Remove existing section and append fresh
            $cleaned = $content -replace "# ═.*OWNYOURCODE[\s\S]*?# ═.*END OWNYOURCODE[^\n]*", ""
            $templateContent = Get-Content $TEMPLATE -Raw
            Set-Content -Path $CLAUDE_MD -Value ($cleaned.Trim() + "`n`n" + $templateContent)
            Write-OK "OwnYourCode section replaced"
        } else {
            Write-Info "Keeping existing OwnYourCode section"
        }
    } else {
        # Existing CLAUDE.md without OwnYourCode - merge
        Write-Info "Merging OwnYourCode section..."

        # Backup (next to the file)
        $BACKUP_PATH = "$CLAUDE_MD.pre-ownyourcode"
        Copy-Item $CLAUDE_MD $BACKUP_PATH
        Write-OK "Backed up to $(Split-Path -Leaf $BACKUP_PATH)"

        # Append template
        if (Test-Path $TEMPLATE) {
            $templateContent = Get-Content $TEMPLATE -Raw
            Add-Content -Path $CLAUDE_MD -Value ("`n`n" + $templateContent)
            Write-OK "OwnYourCode section merged into CLAUDE.md"
        }
    }
} else {
    # No existing CLAUDE.md - create at root (best practice)
    if (Test-Path $TEMPLATE) {
        Copy-Item $TEMPLATE $CLAUDE_MD
        Write-OK "Created CLAUDE.md at project root"
    }
}

# ============================================================================
# STEP 4: Copy commands
# ============================================================================

Write-Info "Installing commands..."

$srcCommands = Join-Path $BASE_DIR ".claude/commands/own"
$destCommands = Join-Path $PROJECT_DIR ".claude/commands/own"

if (Test-Path $srcCommands) {
    $files = Get-ChildItem -Path $srcCommands -Filter "*.md"
    foreach ($file in $files) {
        Copy-Item $file.FullName -Destination $destCommands -Force
    }
    $cmdCount = $files.Count
    Write-OK "Commands installed: $cmdCount"
} else {
    Write-Warn "Commands directory not found"
}

# ============================================================================
# STEP 5: Copy skills
# ============================================================================

Write-Info "Installing skills..."

# Fundamentals
$fundamentals = @(
    "frontend", "backend", "security", "performance", "error-handling",
    "engineering", "database", "testing", "seo", "accessibility",
    "documentation", "debugging", "resistance"
)

$fundamentalCount = 0
foreach ($skill in $fundamentals) {
    $src = Join-Path $BASE_DIR ".claude/skills/fundamentals/$skill/SKILL.md"
    $dest = Join-Path $PROJECT_DIR ".claude/skills/fundamentals/$skill/SKILL.md"
    if (Test-Path $src) {
        Copy-Item $src $dest -Force
        $fundamentalCount++
    }
}
Write-OK "Fundamental skills installed: $fundamentalCount"

# Gates
$gates = @("ownership", "security", "error", "performance", "fundamentals", "testing")
$gateCount = 0
foreach ($gate in $gates) {
    $src = Join-Path $BASE_DIR ".claude/skills/gates/$gate/SKILL.md"
    $dest = Join-Path $PROJECT_DIR ".claude/skills/gates/$gate/SKILL.md"
    if (Test-Path $src) {
        Copy-Item $src $dest -Force
        $gateCount++
    }
}
Write-OK "Gate skills installed: $gateCount"

# Career
$careerSkills = @("star-stories", "resume-bullets")
foreach ($skill in $careerSkills) {
    $src = Join-Path $BASE_DIR ".claude/skills/career/$skill/SKILL.md"
    $dest = Join-Path $PROJECT_DIR ".claude/skills/career/$skill/SKILL.md"
    if (Test-Path $src) {
        Copy-Item $src $dest -Force
    }
}
Write-OK "Career extraction skills installed"

# Create .gitkeep for learned
$gitkeepPath = Join-Path $PROJECT_DIR ".claude/skills/learned/.gitkeep"
Set-Content -Path $gitkeepPath -Value "# Auto-generated skills go here - from /own:retro"

# ============================================================================
# STEP 6: Learning Registry Note
# ============================================================================

Write-Info "Learning Registry..."

$learningDir = Join-Path $BASE_DIR "learning"
if (Test-Path $learningDir) {
    Write-OK "Using global registry at ~/ownyourcode/learning/"
} else {
    Write-Warn "Global learning registry not found. Run base-install.ps1 to create it."
}

# ============================================================================
# STEP 7: Copy guides
# ============================================================================

Write-Info "Copying guides..."

$srcGuides = Join-Path $BASE_DIR "guides"
$destGuides = Join-Path $PROJECT_DIR "ownyourcode/guides"

if (Test-Path $srcGuides) {
    $files = Get-ChildItem -Path $srcGuides -Filter "*.md" -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        Copy-Item $file.FullName -Destination $destGuides -Force
    }
    Write-OK "Guides copied"
} else {
    Write-Info "No guides to copy"
}

# ============================================================================
# STEP 8: Create product templates
# ============================================================================

Write-Info "Creating product templates..."

$productDir = Join-Path $PROJECT_DIR "ownyourcode/product"

$nl = [Environment]::NewLine
$missionLines = @(
    "# Project Mission",
    "",
    "> Run ``/own:init`` to define your project vision.",
    "",
    "## The Problem",
    "",
    "<!-- What problem are you solving? Describe the PROBLEM, not features. -->",
    "",
    "## Who Is This For?",
    "",
    "<!-- Who will use this? -->",
    "",
    "## Definition of Done",
    "",
    "<!-- When is this project DONE? What must work? -->"
)
Set-Content -Path (Join-Path $productDir "mission.md") -Value ($missionLines -join $nl)

$stackLines = @(
    "# Technology Stack",
    "",
    "> Run ``/own:init`` to auto-detect and document your stack.",
    "",
    "## Frontend",
    "",
    "<!-- Technologies detected or chosen -->",
    "",
    "## Backend",
    "",
    "<!-- Technologies detected or chosen -->",
    "",
    "## Why These Choices?",
    "",
    "<!-- Document your reasoning -->"
)
Set-Content -Path (Join-Path $productDir "stack.md") -Value ($stackLines -join $nl)

$roadmapLines = @(
    "# Project Roadmap",
    "",
    "> Run ``/own:init`` to create your development roadmap.",
    "",
    "## Phase 1: Foundation",
    "",
    "- [ ] Project setup",
    "- [ ] Core structure",
    "",
    "## Phase 2: Core Features",
    "",
    "- [ ] Feature 1",
    "- [ ] Feature 2",
    "",
    "## Phase 3: Polish and Deploy",
    "",
    "- [ ] Testing",
    "- [ ] Deployment"
)
Set-Content -Path (Join-Path $productDir "roadmap.md") -Value ($roadmapLines -join $nl)

Write-OK "Product templates created"

# ============================================================================
# STEP 9: Update .gitignore
# ============================================================================

$gitignorePath = Join-Path $PROJECT_DIR ".gitignore"
if (Test-Path $gitignorePath) {
    $gitignore = Get-Content $gitignorePath -Raw
    if ($gitignore -notmatch "ownyourcode/career/") {
        Add-Content -Path $gitignorePath -Value "`n# OwnYourCode - personal career tracking`nownyourcode/career/"
        Write-OK "Updated .gitignore"
    }
}

# ============================================================================
# STEP 10: Generate manifest (for clean uninstall)
# ============================================================================

Write-Info "Generating manifest..."

$MANIFEST = Join-Path $PROJECT_DIR ".claude/ownyourcode-manifest.json"

# Format backup path for JSON
if ($BACKUP_PATH) {
    $BACKUP_REL = "$CLAUDE_MD_REL.pre-ownyourcode"
    $backupJson = "`"$BACKUP_REL`""
} else {
    $backupJson = "null"
}

$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$manifestContent = @"
{
  "version": "2.2.4",
  "installed_at": "$timestamp",
  "claude_md_location": "$CLAUDE_MD_REL",
  "backup_path": $backupJson,
  "skills": [
    "fundamentals/frontend",
    "fundamentals/backend",
    "fundamentals/security",
    "fundamentals/performance",
    "fundamentals/error-handling",
    "fundamentals/engineering",
    "fundamentals/database",
    "fundamentals/testing",
    "fundamentals/seo",
    "fundamentals/accessibility",
    "fundamentals/documentation",
    "fundamentals/debugging",
    "fundamentals/resistance",
    "gates/ownership",
    "gates/security",
    "gates/error",
    "gates/performance",
    "gates/fundamentals",
    "gates/testing",
    "career/star-stories",
    "career/resume-bullets",
    "learned"
  ],
  "commands": [
    "own/advise.md",
    "own/docs.md",
    "own/done.md",
    "own/feature.md",
    "own/guide.md",
    "own/init.md",
    "own/retro.md",
    "own/status.md",
    "own/stuck.md",
    "own/test.md"
  ]
}
"@

Set-Content -Path $MANIFEST -Value $manifestContent
Write-OK "Manifest created at .claude/ownyourcode-manifest.json"

# ============================================================================
# COMPLETE
# ============================================================================

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          Installation Complete! v2.2.4                    ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-OK "OwnYourCode v2.2.4 installed successfully!"
Write-Host ""

Write-Info "What was created:"
Write-Host ""
Write-Host "  📄 $CLAUDE_MD_REL           — THE STRICTNESS [mentor behavior]"
Write-Host ""
Write-Host "  📁 ownyourcode/              — Your project docs [commit this]"
Write-Host "     ├── product/             — Mission, stack, roadmap"
Write-Host "     ├── specs/               — Feature specifications"
Write-Host "     ├── career/              — Interview stories & bullets"
Write-Host "     └── guides/              — Setup guides"
Write-Host ""
Write-Host "  📁 .claude/                 — Claude Code configuration"
Write-Host "     ├── commands/            — Slash commands"
Write-Host "     └── skills/              — Auto-invoked mentorship skills"
Write-Host "         ├── fundamentals/    — Core review skills"
Write-Host "         ├── gates/           — Mentorship gates"
Write-Host "         ├── career/          — STAR & resume extraction"
Write-Host "         └── learned/         — Auto-generated from /own:retro"
Write-Host ""
Write-Host "  📁 ~/ownyourcode/learning/  — GLOBAL Learning Flywheel"
Write-Host "     ├── LEARNING_REGISTRY.md — Your growth tracker [all projects]"
Write-Host "     ├── patterns/            — Reusable solutions"
Write-Host "     └── failures/            — Documented anti-patterns"
Write-Host ""

Write-Info "Next steps:"
Write-Host "  1. Open Claude Code in this project"
Write-Host "  2. Run: /own:init"
Write-Host ""
Write-Info "The workflow:"
Write-Host "  /own:feature  ->  Plan a new feature [creates spec, design, tasks]"
Write-Host "  /own:advise   ->  Get relevant learnings before starting a task"
Write-Host "  /own:guide    ->  Get implementation help as you code"
Write-Host "  /own:done     ->  Pass 6 Gates, code review, extract STAR story"
Write-Host "  /own:retro    ->  Capture what you learned"
Write-Host ""

Write-Info "MCP Setup [recommended]:"
Write-Host "  Context7:  claude mcp add context7 --transport http https://mcp.context7.com/mcp"
Write-Host "  OctoCode:  https://octocode.ai/#installation"
Write-Host ""

Write-Info "To remove OwnYourCode later:"
Write-Host "  irm https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/project-uninstall.ps1 | iex"
Write-Host ""
