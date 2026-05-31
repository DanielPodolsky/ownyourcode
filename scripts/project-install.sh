#!/bin/bash

# OwnYourCode Project Installation Script
# AI-Mentored Development for All Developers
# Version 2.5.0 - Dashboard SDD

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
# Use the directory where this script lives (go up one level from scripts/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Helpers
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Header
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            OwnYourCode Installation v2.5.0                 ║${NC}"
echo -e "${GREEN}║    AI-Mentored Development with Profile Support            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check base exists (should always exist since we derive it from script location)
if [ ! -d "$BASE_DIR" ]; then
    error "OwnYourCode base not found at $BASE_DIR. Script location issue."
fi

info "Using OwnYourCode from: $BASE_DIR"

info "Installing OwnYourCode into: $PROJECT_DIR"
echo ""

# ============================================================================
# STEP 1: Handle existing installation
# ============================================================================

if [ -d "$PROJECT_DIR/ownyourcode" ]; then
    warn "OwnYourCode already installed in this project."
    read -p "Reinstall? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        info "Cancelled."
        exit 0
    fi
    echo ""
fi

# ============================================================================
# STEP 2: Create directory structure
# ============================================================================

info "Creating directories..."

# OwnYourCode project directories
# Note: v2.5 drops product/ — mission/stack/roadmap now live in the dashboard.
mkdir -p "$PROJECT_DIR/ownyourcode/specs/active"
mkdir -p "$PROJECT_DIR/ownyourcode/specs/completed"
mkdir -p "$PROJECT_DIR/ownyourcode/career/stories"
mkdir -p "$PROJECT_DIR/ownyourcode/guides"

# Claude Code directories (v2.0 - Skill-Driven)
mkdir -p "$PROJECT_DIR/.claude/commands/own"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/frontend"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/backend"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/security"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/performance"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/error-handling"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/engineering"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/database"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/testing"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/seo"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/accessibility"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/documentation"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/debugging"
mkdir -p "$PROJECT_DIR/.claude/skills/fundamentals/resistance"
mkdir -p "$PROJECT_DIR/.claude/skills/gates/ownership"
mkdir -p "$PROJECT_DIR/.claude/skills/gates/security"
mkdir -p "$PROJECT_DIR/.claude/skills/gates/error"
mkdir -p "$PROJECT_DIR/.claude/skills/gates/performance"
mkdir -p "$PROJECT_DIR/.claude/skills/gates/fundamentals"
mkdir -p "$PROJECT_DIR/.claude/skills/gates/testing"
mkdir -p "$PROJECT_DIR/.claude/skills/career/star-stories"
mkdir -p "$PROJECT_DIR/.claude/skills/career/resume-bullets"
mkdir -p "$PROJECT_DIR/.claude/skills/learned"

# Note: Learning is GLOBAL at ~/ownyourcode/learning/ (not project-local)

success "Directories created"

# ============================================================================
# STEP 3: Handle CLAUDE.md (Smart Merge)
# ============================================================================

# Check BOTH locations - prefer root per Claude Code best practices
ROOT_CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
DOTCLAUDE_MD="$PROJECT_DIR/.claude/CLAUDE.md"
TEMPLATE="$BASE_DIR/core/CLAUDE.md.template"

info "Configuring CLAUDE.md..."

# Detect existing CLAUDE.md location
if [ -f "$ROOT_CLAUDE_MD" ]; then
    CLAUDE_MD="$ROOT_CLAUDE_MD"
    CLAUDE_MD_REL="./CLAUDE.md"
    info "Found existing CLAUDE.md at project root"
elif [ -f "$DOTCLAUDE_MD" ]; then
    CLAUDE_MD="$DOTCLAUDE_MD"
    CLAUDE_MD_REL="./.claude/CLAUDE.md"
    info "Found existing CLAUDE.md in .claude folder"
else
    # No existing - create at root (best practice)
    CLAUDE_MD="$ROOT_CLAUDE_MD"
    CLAUDE_MD_REL="./CLAUDE.md"
fi

if [ -f "$CLAUDE_MD" ]; then
    # Check if OwnYourCode already installed
    if grep -q "OWNYOURCODE:" "$CLAUDE_MD" 2>/dev/null; then
        warn "OwnYourCode section already exists in CLAUDE.md"
        read -p "Replace existing OwnYourCode section? (y/N): " replace
        if [ "$replace" = "y" ] || [ "$replace" = "Y" ]; then
            # Remove existing OwnYourCode section
            sed -i.bak '/# ═.*OWNYOURCODE/,/# ═.*END OWNYOURCODE/d' "$CLAUDE_MD"
            # Append fresh template
            echo "" >> "$CLAUDE_MD"
            cat "$TEMPLATE" >> "$CLAUDE_MD"
            success "OwnYourCode section replaced"
        else
            info "Keeping existing OwnYourCode section"
        fi
    else
        # Existing CLAUDE.md without OwnYourCode - Smart merge
        info "Merging OwnYourCode section..."

        # Backup original (next to the file)
        BACKUP_PATH="${CLAUDE_MD}.pre-ownyourcode"
        cp "$CLAUDE_MD" "$BACKUP_PATH"
        success "Backed up to $(basename "$BACKUP_PATH")"

        # Append OwnYourCode section
        echo "" >> "$CLAUDE_MD"
        echo "" >> "$CLAUDE_MD"
        cat "$TEMPLATE" >> "$CLAUDE_MD"
        success "OwnYourCode section merged into CLAUDE.md"
    fi
else
    # No existing CLAUDE.md - create at root (best practice)
    cp "$TEMPLATE" "$CLAUDE_MD"
    success "Created CLAUDE.md at project root"
fi

# ============================================================================
# STEP 4: Copy commands (v2.0 location)
# ============================================================================

info "Installing commands..."

# Copy commands from .claude/commands/own/
cp "$BASE_DIR/.claude/commands/own/"*.md "$PROJECT_DIR/.claude/commands/own/" 2>/dev/null || true
CMD_COUNT=$(ls "$PROJECT_DIR/.claude/commands/own/"*.md 2>/dev/null | wc -l | tr -d ' ')
success "Commands installed ($CMD_COUNT commands)"

# ============================================================================
# STEP 5: Copy skills (NEW in v2.0)
# ============================================================================

info "Installing skills..."

# Copy fundamentals
if [ -d "$BASE_DIR/.claude/skills/fundamentals" ]; then
    for skill in frontend backend security performance error-handling engineering database testing seo accessibility documentation debugging resistance; do
        if [ -f "$BASE_DIR/.claude/skills/fundamentals/$skill/SKILL.md" ]; then
            cp "$BASE_DIR/.claude/skills/fundamentals/$skill/SKILL.md" \
               "$PROJECT_DIR/.claude/skills/fundamentals/$skill/"
        fi
    done
    success "13 Core Fundamental skills installed"
fi

# Copy gates
if [ -d "$BASE_DIR/.claude/skills/gates" ]; then
    for gate in ownership security error performance fundamentals testing; do
        if [ -f "$BASE_DIR/.claude/skills/gates/$gate/SKILL.md" ]; then
            cp "$BASE_DIR/.claude/skills/gates/$gate/SKILL.md" \
               "$PROJECT_DIR/.claude/skills/gates/$gate/"
        fi
    done
    success "6 Mentorship Gate skills installed"
fi

# Copy career skills
if [ -d "$BASE_DIR/.claude/skills/career" ]; then
    for career in star-stories resume-bullets; do
        if [ -f "$BASE_DIR/.claude/skills/career/$career/SKILL.md" ]; then
            cp "$BASE_DIR/.claude/skills/career/$career/SKILL.md" \
               "$PROJECT_DIR/.claude/skills/career/$career/"
        fi
    done
    success "Career extraction skills installed"
fi

# Create .gitkeep for learned skills
echo "# Auto-generated skills go here (from /own:retro)" > "$PROJECT_DIR/.claude/skills/learned/.gitkeep"

# ============================================================================
# STEP 5.5: Copy profile templates (NEW in v2.3.0)
# ============================================================================

info "Installing profile templates..."

if [ -d "$BASE_DIR/profiles" ]; then
    mkdir -p "$PROJECT_DIR/ownyourcode/profiles"
    cp "$BASE_DIR/profiles/"*.md "$PROJECT_DIR/ownyourcode/profiles/" 2>/dev/null || true
    success "Profile templates installed (default, junior, career-switcher, interview-prep, experienced)"
else
    warn "Profile templates not found at $BASE_DIR/profiles"
fi

# ============================================================================
# STEP 6: Learning Registry Note (v2.1 - Global Learning)
# ============================================================================

info "Learning Registry..."

# Learning is GLOBAL at ~/ownyourcode/learning/ (not project-local)
# This ensures learnings persist across ALL projects
if [ -d "$BASE_DIR/learning" ]; then
    success "Using global registry at ~/ownyourcode/learning/"
else
    warn "Global learning registry not found. Run base-install.sh to create it."
fi

# ============================================================================
# STEP 7: Copy guides
# ============================================================================

info "Copying guides..."

cp "$BASE_DIR/guides/"*.md "$PROJECT_DIR/ownyourcode/guides/" 2>/dev/null || true
success "Guides copied"

# ============================================================================
# STEP 7.5: Seed the dashboard (v2.5 — Dashboard SDD)
# ============================================================================
# v2.5 replaces the per-page product/*.html and specs/**/*.html files with a
# single dashboard: a stable view shell (dashboard.html) + a data file
# (dashboard-data.js) that every /own:* command reads and writes. The schema
# authority is DASHBOARD_CONTRACT.md (shipped into ownyourcode/dashboard/).
# Fallback-first: if the source templates are missing (older base install),
# warn and skip rather than seeding a broken project.

info "Seeding the project dashboard..."

DASH_SRC="$BASE_DIR/core/templates"
if [ -f "$DASH_SRC/dashboard.html.template" ]; then
    # Keep the source templates in-project so /own:init can regenerate the
    # shell if it is ever missing (fallback-first, self-contained project).
    mkdir -p "$PROJECT_DIR/ownyourcode/templates"
    cp "$DASH_SRC/dashboard.html.template"    "$PROJECT_DIR/ownyourcode/templates/"
    cp "$DASH_SRC/dashboard-data.js.template" "$PROJECT_DIR/ownyourcode/templates/"

    # Working files live in their own dashboard/ folder (keeps ownyourcode/ tidy).
    # The shell is used as-is (never templated); the data file starts as the empty
    # scaffold until /own:init fills it from your answers.
    mkdir -p "$PROJECT_DIR/ownyourcode/dashboard"
    cp "$DASH_SRC/dashboard.html.template"    "$PROJECT_DIR/ownyourcode/dashboard/dashboard.html"
    cp "$DASH_SRC/dashboard-data.js.template" "$PROJECT_DIR/ownyourcode/dashboard/dashboard-data.js"

    # The schema contract ships to the project root for command + human reference.
    cp "$DASH_SRC/DASHBOARD_CONTRACT.md" "$PROJECT_DIR/ownyourcode/dashboard/DASHBOARD_CONTRACT.md" 2>/dev/null || true

    # Seed the theme brief that /own:theme reads to restyle the dashboard.
    mkdir -p "$PROJECT_DIR/ownyourcode/.theme/.history"
    cp "$DASH_SRC/theme-prompt.md.template" "$PROJECT_DIR/ownyourcode/.theme/theme-prompt.md" 2>/dev/null || true

    success "Dashboard seeded — open ownyourcode/dashboard/dashboard.html, then run /own:init"
else
    warn "Dashboard templates not found in source repo — skipping dashboard seed."
    warn "Update your OwnYourCode base install to get the v2.5 dashboard."
fi

# ============================================================================
# STEP 9: Update .gitignore
# ============================================================================

if [ -f "$PROJECT_DIR/.gitignore" ]; then
    if ! grep -q "ownyourcode/career/" "$PROJECT_DIR/.gitignore" 2>/dev/null; then
        echo "" >> "$PROJECT_DIR/.gitignore"
        echo "# OwnYourCode - personal career tracking" >> "$PROJECT_DIR/.gitignore"
        echo "ownyourcode/career/" >> "$PROJECT_DIR/.gitignore"
        success "Updated .gitignore"
    fi
fi

# ============================================================================
# STEP 10: Generate manifest (for clean uninstall + profile storage)
# ============================================================================

info "Generating manifest..."

MANIFEST="$PROJECT_DIR/.claude/ownyourcode-manifest.json"
mkdir -p "$PROJECT_DIR/.claude"

# Format backup path for JSON (null if not set, quoted string if set)
if [ -n "$BACKUP_PATH" ]; then
    # Convert absolute path to relative
    BACKUP_REL="${CLAUDE_MD_REL}.pre-ownyourcode"
    BACKUP_JSON="\"$BACKUP_REL\""
else
    BACKUP_JSON="null"
fi

cat > "$MANIFEST" << EOF
{
  "version": "2.5.0",
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "claude_md_location": "$CLAUDE_MD_REL",
  "backup_path": $BACKUP_JSON,
  "profile": {
    "type": null,
    "configured_at": null,
    "settings": {
      "background": null,
      "career_focus": null,
      "design_involvement": null,
      "analogies": {
        "enabled": false,
        "source": null
      },
      "previous_field": null,
      "focus_area": null,
      "position_title": null,
      "target_company": null,
      "teaching_style": null,
      "feedback_style": null,
      "pacing": null,
      "personal_touch": null
    }
  },
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
    "own/profile.md",
    "own/retro.md",
    "own/status.md",
    "own/stuck.md",
    "own/test.md",
    "own/theme.md"
  ]
}
EOF

success "Manifest created at .claude/ownyourcode-manifest.json"

# ============================================================================
# COMPLETE
# ============================================================================

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Installation Complete! v2.5.0                    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

success "OwnYourCode v2.5.0 installed successfully!"
echo ""

info "What was created:"
echo ""
echo "  📄 $CLAUDE_MD_REL           — THE STRICTNESS (mentor behavior)"
echo ""
echo "  📁 ownyourcode/              — Your project docs (commit this)"
echo "     ├── dashboard/           — Your project cockpit"
echo "     │   ├── dashboard.html        — open this in a browser"
echo "     │   ├── dashboard-data.js     — SDD state (the /own:* commands write this)"
echo "     │   └── DASHBOARD_CONTRACT.md — The window.PROJECT schema authority"
echo "     ├── specs/               — Feature specifications"
echo "     ├── career/              — Interview stories & bullets"
echo "     ├── profiles/            — Profile templates (junior, experienced, etc.)"
echo "     └── guides/              — Setup guides"
echo ""
echo "  📁 .claude/                 — Claude Code configuration"
echo "     ├── commands/            — ${CMD_COUNT} slash commands"
echo "     └── skills/              — Auto-invoked mentorship skills"
echo "         ├── fundamentals/    — 13 Core review skills"
echo "         ├── gates/           — 6 Mentorship gates"
echo "         ├── career/          — STAR & resume extraction"
echo "         └── learned/         — Auto-generated from /own:retro"
echo ""
echo "  📁 ~/ownyourcode/learning/  — GLOBAL Learning Flywheel"
echo "     ├── LEARNING_REGISTRY.md — Your growth tracker (all projects)"
echo "     ├── patterns/            — Reusable solutions"
echo "     └── failures/            — Documented anti-patterns"
echo ""

info "Next steps:"
echo "  1. Open Claude Code in this project"
echo "  2. Run: /own:init"
echo ""
echo -e "${YELLOW}  ⚠️  Profile setup is part of /own:init${NC}"
echo "     Choose your profile (Junior, Career Switcher, Interview Prep, Experienced)"
echo "     This customizes HOW OwnYourCode teaches you"
echo ""
info "The workflow:"
echo "  /own:feature  →  Plan a new feature (creates spec, design, tasks)"
echo "  /own:advise   →  Get relevant learnings before starting a task"
echo "  /own:guide    →  Get implementation help as you code"
echo "  /own:done     →  Pass 6 Gates, code review, extract STAR story"
echo "  /own:retro    →  Capture what you learned"
echo ""

info "MCP Setup (recommended):"
echo "  Context7:  claude mcp add context7 --transport http https://mcp.context7.com/mcp"
echo "  OctoCode:  https://octocode.ai/#installation"
echo ""

info "To remove OwnYourCode later:"
echo "  ~/ownyourcode/scripts/project-uninstall.sh"
echo ""
