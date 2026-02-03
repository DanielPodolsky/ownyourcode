#!/bin/bash

# OwnYourCode Project Uninstallation Script
# Cleanly removes OwnYourCode from a project

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
PROJECT_DIR=$(pwd)
MANIFEST="$PROJECT_DIR/.claude/ownyourcode-manifest.json"

# Detect CLAUDE.md location from manifest (or fallback to legacy locations)
if [ -f "$MANIFEST" ]; then
    # Read from manifest
    CLAUDE_MD_REL=$(grep -o '"claude_md_location": *"[^"]*"' "$MANIFEST" 2>/dev/null | cut -d'"' -f4)

    # Check if backup_path is null (fresh install) or a path (merged install)
    if grep -q '"backup_path": *null' "$MANIFEST" 2>/dev/null; then
        FRESH_INSTALL=true
        BACKUP=""
    else
        FRESH_INSTALL=false
        BACKUP_REL=$(grep -o '"backup_path": *"[^"]*"' "$MANIFEST" 2>/dev/null | cut -d'"' -f4)
    fi

    # Convert relative to absolute
    if [ "$CLAUDE_MD_REL" = "./CLAUDE.md" ]; then
        CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
        [ "$FRESH_INSTALL" = false ] && BACKUP="$PROJECT_DIR/CLAUDE.md.pre-ownyourcode"
    else
        CLAUDE_MD="$PROJECT_DIR/.claude/CLAUDE.md"
        [ "$FRESH_INSTALL" = false ] && BACKUP="$PROJECT_DIR/.claude/CLAUDE.md.pre-ownyourcode"
    fi
    HAS_MANIFEST=true
else
    # Legacy fallback - check both locations
    if [ -f "$PROJECT_DIR/CLAUDE.md" ] && grep -q "OWNYOURCODE:" "$PROJECT_DIR/CLAUDE.md" 2>/dev/null; then
        CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
        BACKUP="$PROJECT_DIR/CLAUDE.md.pre-ownyourcode"
    else
        CLAUDE_MD="$PROJECT_DIR/.claude/CLAUDE.md"
        BACKUP="$PROJECT_DIR/.claude/CLAUDE.md.pre-ownyourcode"
    fi
    HAS_MANIFEST=false
    FRESH_INSTALL=false  # Can't determine, use safe fallback
fi

# Helpers
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Header
echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║            OwnYourCode Uninstallation                  ║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# STEP 0: Check if OwnYourCode is installed
# ============================================================================

if [ ! -d "$PROJECT_DIR/ownyourcode" ] && [ ! -d "$PROJECT_DIR/.claude/commands/own" ]; then
    warn "OwnYourCode does not appear to be installed in this project."
    exit 0
fi

# ============================================================================
# STEP 1: Confirm
# ============================================================================

info "This will remove OwnYourCode from: $PROJECT_DIR"
echo ""
echo "  Will remove:"
echo "    - ownyourcode/ folder"
echo "    - .claude/commands/own/"
echo "    - .claude/skills/ (OwnYourCode skills only)"
echo "    - OwnYourCode section from CLAUDE.md"
if [ "$HAS_MANIFEST" = true ]; then
    echo "    - .claude/ownyourcode-manifest.json"
fi
echo ""

read -p "Continue? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    info "Cancelled."
    exit 0
fi

echo ""

# ============================================================================
# STEP 2: Handle CLAUDE.md
# ============================================================================

info "Handling CLAUDE.md..."

if [ -f "$CLAUDE_MD" ]; then
    if [ "$HAS_MANIFEST" = true ] && [ "$FRESH_INSTALL" = true ]; then
        # Fresh install - we created it, delete entirely
        rm "$CLAUDE_MD"
        success "Removed CLAUDE.md (was created by OwnYourCode)"
    elif [ -f "$BACKUP" ]; then
        # Merged install with backup - restore original
        cp "$BACKUP" "$CLAUDE_MD"
        rm "$BACKUP"
        success "Restored original CLAUDE.md from backup"
    elif grep -q "OWNYOURCODE:" "$CLAUDE_MD" 2>/dev/null; then
        # Legacy fallback - remove OwnYourCode section using markers
        sed '/# ═.*OWNYOURCODE/,/# ═.*END OWNYOURCODE/d' "$CLAUDE_MD" > "$CLAUDE_MD.tmp"

        # Remove trailing blank lines
        sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CLAUDE_MD.tmp" > "$CLAUDE_MD"
        rm "$CLAUDE_MD.tmp"

        # Check if CLAUDE.md is now empty (only whitespace)
        if [ ! -s "$CLAUDE_MD" ] || [ -z "$(grep -v '^[[:space:]]*$' "$CLAUDE_MD")" ]; then
            rm "$CLAUDE_MD"
            success "Removed CLAUDE.md (was only OwnYourCode content)"
        else
            success "Removed OwnYourCode section from CLAUDE.md"
        fi
    else
        info "No OwnYourCode section found in CLAUDE.md"
    fi
else
    info "No CLAUDE.md found"
fi

# ============================================================================
# STEP 3: Remove commands
# ============================================================================

info "Removing commands..."

if [ -d "$PROJECT_DIR/.claude/commands/own" ]; then
    rm -rf "$PROJECT_DIR/.claude/commands/own"
    success "Removed .claude/commands/own/"
else
    info "No commands folder found"
fi

# Clean up empty commands directory
if [ -d "$PROJECT_DIR/.claude/commands" ] && [ -z "$(ls -A "$PROJECT_DIR/.claude/commands")" ]; then
    rmdir "$PROJECT_DIR/.claude/commands"
    info "Removed empty .claude/commands/"
fi

# ============================================================================
# STEP 4: Remove OwnYourCode skills (preserve user skills)
# ============================================================================

info "Removing OwnYourCode skills..."

# Known OwnYourCode skill folders (these are ours, safe to remove)
OYC_SKILL_FOLDERS="fundamentals gates career learned"

if [ -d "$PROJECT_DIR/.claude/skills" ]; then
    for folder in $OYC_SKILL_FOLDERS; do
        if [ -d "$PROJECT_DIR/.claude/skills/$folder" ]; then
            rm -rf "$PROJECT_DIR/.claude/skills/$folder"
        fi
    done
    success "Removed OwnYourCode skills (user skills preserved)"

    # Clean up empty skills directory
    if [ -z "$(ls -A "$PROJECT_DIR/.claude/skills")" ]; then
        rmdir "$PROJECT_DIR/.claude/skills"
        info "Removed empty .claude/skills/"
    else
        info "Preserved user skills in .claude/skills/"
    fi
else
    info "No skills folder found"
fi

# ============================================================================
# STEP 5: Remove manifest
# ============================================================================

if [ -f "$MANIFEST" ]; then
    rm "$MANIFEST"
    success "Removed manifest"
fi

# Clean up empty .claude directory
if [ -d "$PROJECT_DIR/.claude" ] && [ -z "$(ls -A "$PROJECT_DIR/.claude")" ]; then
    rmdir "$PROJECT_DIR/.claude"
    info "Removed empty .claude/"
fi

# ============================================================================
# STEP 6: Remove ownyourcode folder
# ============================================================================

info "Removing ownyourcode folder..."

if [ -d "$PROJECT_DIR/ownyourcode" ]; then
    # Ask about specs if they exist
    if [ -d "$PROJECT_DIR/ownyourcode/specs" ] && [ "$(ls -A "$PROJECT_DIR/ownyourcode/specs/active" 2>/dev/null)" ]; then
        warn "You have active specs in ownyourcode/specs/active/"
        read -p "Delete them too? (y/N): " delete_specs
        if [ "$delete_specs" != "y" ] && [ "$delete_specs" != "Y" ]; then
            # Move specs to project root before deletion
            mv "$PROJECT_DIR/ownyourcode/specs" "$PROJECT_DIR/ownyourcode-specs-backup"
            success "Backed up specs to ownyourcode-specs-backup/"
        fi
    fi

    rm -rf "$PROJECT_DIR/ownyourcode"
    success "Removed ownyourcode/"
else
    info "No ownyourcode folder found"
fi

# ============================================================================
# COMPLETE
# ============================================================================

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Uninstallation Complete!                     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

success "OwnYourCode has been removed from this project."
echo ""

info "To reinstall later:"
echo "  ~/ownyourcode/scripts/project-install.sh"
echo ""
