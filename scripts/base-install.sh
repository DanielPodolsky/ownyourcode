#!/bin/bash

# OwnYourCode Base Installation Script
# AI-Mentored Development for All Developers
# Version 2.3.0 - Profiles Support
#
# Usage: curl -sSL https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/base-install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Config
REPO_URL="https://github.com/DanielPodolsky/ownyourcode.git"
INSTALL_DIR="$HOME/ownyourcode"

# Helpers
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Header
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         OwnYourCode Installation v2.3.0               ║${NC}"
echo -e "${GREEN}║   AI-Mentored Development with Profile Support        ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# Check for existing installation
# ============================================================================

if [ -d "$INSTALL_DIR" ]; then
    warn "OwnYourCode already installed at $INSTALL_DIR"
    echo ""
    read -p "Update existing installation? (y/N): " update < /dev/tty
    if [ "$update" = "y" ] || [ "$update" = "Y" ]; then
        info "Updating OwnYourCode..."
        cd "$INSTALL_DIR"
        if [ -d ".git" ]; then
            git pull origin main
            success "OwnYourCode updated!"
        else
            warn "Not a git repo. Reinstalling..."
            cd ..
            rm -rf "$INSTALL_DIR"
        fi
    else
        info "Keeping existing installation."
        echo ""
        info "To use OwnYourCode in a project:"
        echo "  cd your-project"
        echo "  ~/ownyourcode/scripts/project-install.sh"
        echo ""
        exit 0
    fi
fi

# ============================================================================
# Install OwnYourCode
# ============================================================================

if [ ! -d "$INSTALL_DIR" ]; then
    info "Installing OwnYourCode to $INSTALL_DIR..."

    # Try git clone first
    if command -v git &> /dev/null; then
        git clone "$REPO_URL" "$INSTALL_DIR"
        success "Cloned via git"
    else
        # Fallback to curl + unzip
        warn "git not found, downloading zip..."
        ZIP_URL="https://github.com/DanielPodolsky/ownyourcode/archive/refs/heads/main.zip"
        curl -sSL "$ZIP_URL" -o /tmp/ownyourcode.zip
        unzip -q /tmp/ownyourcode.zip -d /tmp
        mv /tmp/ownyourcode-main "$INSTALL_DIR"
        rm /tmp/ownyourcode.zip
        success "Downloaded and extracted"
    fi
fi

# ============================================================================
# Make scripts executable
# ============================================================================

info "Setting permissions..."
chmod +x "$INSTALL_DIR/scripts/"*.sh
success "Scripts are executable"

# ============================================================================
# Create global learning structure (v2.1 - Global Learning)
# ============================================================================

info "Creating global learning registry..."
mkdir -p "$INSTALL_DIR/learning/patterns"
mkdir -p "$INSTALL_DIR/learning/failures"

if [ ! -f "$INSTALL_DIR/learning/LEARNING_REGISTRY.md" ]; then
    cat > "$INSTALL_DIR/learning/LEARNING_REGISTRY.md" << 'EOF'
# Global Learning Registry

> Automatically updated by `/own:retro`. Query with `/own:advise`.
> This file tracks your growth as an engineer across ALL projects.
> Location: ~/ownyourcode/learning/ (global, not project-specific)

---

## Patterns (Reusable Solutions)

Successful patterns you've discovered and can reuse:

| Date | Domain | Pattern | Project | Location |
|------|--------|---------|---------|----------|
| | | *No patterns recorded yet* | | |

---

## Failures (Anti-Patterns)

Mistakes you've made and learned from (the most valuable learnings):

| Date | Domain | Issue | Project | Location |
|------|--------|-------|---------|----------|
| | | *No failures documented yet* | | |

---

## Competency Progression

Track your growth over time:

| Week | Level | Evidence |
|------|-------|----------|
| Start | ⭐ (learning) | Beginning OwnYourCode journey |

---

## Detailed Entries

*Entries will be added here chronologically as you complete `/own:retro` sessions.*
EOF
    success "Global learning registry created at ~/ownyourcode/learning/"
else
    success "Global learning registry already exists"
fi

# ============================================================================
# Complete
# ============================================================================

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Installation Complete!                       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

success "OwnYourCode installed to ~/ownyourcode/"
echo ""

info "Next steps:"
echo ""
echo "  1. Go to your project:"
echo "     cd your-project"
echo ""
echo "  2. Install OwnYourCode into that project:"
echo "     ~/ownyourcode/scripts/project-install.sh"
echo ""
echo "  3. Open Claude Code and run:"
echo "     /own:init"
echo ""

info "Remember: OwnYourCode makes AI your MENTOR, not your coder."
info "You write the code. You build the skills. You own your career."
echo ""
