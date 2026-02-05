# Changelog

All notable changes to OwnYourCode will be documented in this file.

---

## [2.2.5] - 2026-02-05

### Fixed

**Version Fetching in /own:init**
- Added `mcp__octocode__packageSearch` to allowed-tools for real-time npm version fetching
- Added explicit version fetching protocol with package names table and workflow example
- Prevents Claude from using outdated internal knowledge for version numbers

**Directory Location in /own:init**
- Added "CRITICAL: You Are UPDATING, Not Creating" section
- Clarifies that `ownyourcode/` already exists from installation (sibling to CLAUDE.md)
- Prevents creating duplicate `ownyourcode/` directories when running from project subdirectories

---

## [2.2.4] - 2026-02-03

### Fixed

**Installation Scripts**
- Prevent CLAUDE.md duplication when re-running install
- Ensure clean uninstall removes all OwnYourCode files properly

---

## [2.2.3] - 2026-01-31

### Fixed

**Version Accuracy in /own:init**
- Stack recommendations now show verified versions with source attribution
- Existing projects: versions read directly from package.json (source of truth)
- New projects: versions verified via MCP, or show "Verify at [docs URL]" if unavailable
- Added Source column to stack.md template (package.json / MCP verified / Verify at URL)
- Added Version Freshness section to remind users when to re-verify
- Prevents outdated version numbers (e.g., "React 18+") from appearing in generated docs

---

## [2.2.2] - 2026-01-30

### Changed

**Repository Configuration**
- Added `.claude/agents/` to .gitignore for personal agent files

---

## [2.2.1] - 2026-01-30

### Fixed

- **Piped Installation Prompt**: Fixed interactive prompt not appearing when running `curl ... | bash`. Now reads from `/dev/tty` instead of stdin.

---

## [2.2.0] - 2026-01-30

### The "Ownership & Polish" Release

Focused on clarity, consistency, and Windows compatibility. The README now sells the methodology, commands are unified, and Windows users can install without issues.

### Changed

#### README Transformation
- Redesigned as a focused landing page (239 → 148 lines)
- Surfaced "The 4 Protocols" as visible methodology
- Removed badge wall and visual clutter
- Changed positioning from "for Juniors" to universal ownership message
- New tagline: "AI guides, you build. You own the result."

#### Command Naming Unification
- All commands now consistently use `/own:` prefix
- Improved command descriptions for clearer purpose
- Better onboarding flow in `/own:init`

#### Skill Auto-Invocation
- Optimized skill descriptions for improved pattern matching
- Skills now trigger more reliably based on file context

### Fixed

#### Windows Installation
- Fixed PowerShell string escaping (parentheses → brackets)
- Fixed here-string compatibility issues
- Used `irm` for project-install to bypass git encoding problems
- Windows users can now install without manual intervention

---

## [2.1.0] - 2026-01-06

### The "Global Learning + Silent Skills" Release

Quality improvements based on real-world testing. Learnings now persist across projects, skills apply silently, and research is always verified.

### Added

#### Global Learning Registry
- Learning persists across ALL projects at `~/ownyourcode/learning/`
- Patterns and failures compound across your entire engineering journey
- `/advise` queries global registry + MCP research
- `/retrospective` writes to global registry

#### Package Manager Education
- `/init` now detects and teaches about npm, pnpm, bun, and yarn
- Fresh projects ask which package manager to use
- Existing projects detect from lock files and provide education

#### Version Intelligence
- Always verify latest package versions via Context7 + OctoCode before recommending
- Document versions in `stack.md`
- Warn about outdated dependencies

#### Silent Skill Activation
- Skills shape specs during `/feature` planning
- Skills shape code review during `/done`
- Junior never sees skill names — just receives quality guidance naturally

#### Dual MCP Research Protocol
- BOTH Context7 AND OctoCode are mandatory for any technical research
- "According to the React 19 docs [Context7]... Looking at production [OctoCode]..."

### Changed

- Spec archival now automatic — completed specs move to `completed/` after `/done`
- Task tracking now real-time — tasks marked complete during work, not just at end
- Learning paths changed from project-local to global (`~/ownyourcode/learning/`)
- Install scripts updated for v2.1 features

### Technical

- `base-install.sh` creates global learning structure
- `project-install.sh` no longer creates local learning directories
- CLAUDE.md.template has 5 new mandatory rules
- feature.md has internal skill mapping (Phase 2.5)
- init.md has package manager detection and version verification

---

## [2.0.0] - 2026-01-02

### The "Learning Flywheel" Release

Major overhaul transforming OwnYourCode from a strict mentor into a complete learning system that compounds growth over time.

### Added

#### 6 Mentorship Gates
Mandatory quality checkpoints before completing any task:
- **Gate 1: Ownership** (CAN BLOCK) - Must explain your own code
- **Gate 2: Security** (Warnings) - OWASP Top 10 checks
- **Gate 3: Error Handling** (Warnings) - Graceful failure verification
- **Gate 4: Performance** (Warnings) - O(n²), N+1 query detection
- **Gate 5: Fundamentals** (Suggestions) - Code quality polish
- **Gate 6: Testing** (Warnings) - Encourages testing habit

#### Learning Flywheel
Your learnings compound across sessions:
- `/advise` command - Pre-work intelligence from past learnings
- `/retrospective` command - Capture learnings after each task
- `learning/LEARNING_REGISTRY.md` - Persistent growth tracker
- `learning/patterns/` - Reusable solutions discovered
- `learning/failures/` - Mistakes learned from

#### 4 New Fundamental Skills
- **Testing** - Testing pyramid, Vitest/Jest guidance, AAA pattern
- **SEO** - Meta tags, semantic HTML, Open Graph
- **Accessibility** - WCAG basics, keyboard navigation, ARIA
- **Documentation** - WHY not WHAT, README structure, JSDoc

#### 2 New Commands
- `/own:test` - Guide through writing tests (junior writes, AI guides)
- `/own:docs` - Guide through writing documentation

#### Resistance Protocol
Enforced pushback when juniors try to shortcut:
- "Just write the code for me" → Redirected to learning
- "This is taking too long" → Refocused on growth
- "I don't need to explain it" → Required explanation

#### Career Extraction
Every completed task produces:
- STAR interview stories (Situation, Task, Action, Result)
- Resume bullets (Action Verb + What + Impact)

### Changed

- Commands now total 10 (was 8)
- Fundamental skills now total 11 (was 7)
- Gates now total 6 (was 5)
- `/done` command now includes Testing Gate
- README completely rewritten for v2.0

### Technical

- Skills architecture with auto-invocation based on file patterns
- Updated install scripts for new skill structure

### MCP Integration

Required for full functionality:
- **Context7** — Official documentation lookup and citation
- **Octocode** — GitHub code search for production patterns

---

## [1.0.0] - 2025-12-XX

### Initial Release

The original OwnYourCode with:
- 8 slash commands
- 7 fundamental skills
- 5 mentorship gates
- Anti-Brain-Rot Rules
- Protocol D debugging
- STAR story extraction

---

## Philosophy

> "If you took away the AI tomorrow, could this junior still code?"
>
> OwnYourCode makes the answer: **YES**.

The goal is not to ship code. The goal is to build the engineer.
