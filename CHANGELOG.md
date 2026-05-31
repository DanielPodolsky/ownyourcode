# Changelog

All notable changes to OwnYourCode will be documented in this file.

---

## [Unreleased]

## [2.5.0] - 2026-05-30

### The "Dashboard SDD" Release

OwnYourCode's spec-driven development workflow moves from a folder of Markdown
files to a single, live, app-like dashboard you open in your browser.

### Added

#### Dashboard SDD — Spec-Driven Development becomes a live dashboard

Spec-Driven Development no longer produces a folder of Markdown files. Your whole
project — mission, stack, roadmap, and every phase's spec / design / tasks — now
lives in a single **dashboard** you open in your browser. Two files replace all
the per-page documents:

- `ownyourcode/dashboard/dashboard.html` — a stable view shell (layout + styling + render
  logic) that you never hand-edit for content.
- `ownyourcode/dashboard/dashboard-data.js` — `window.PROJECT`, the single source of truth
  every `/own:*` command reads and writes.

The shell loads its data via `<script src>` (which works under the `file://`
protocol where `fetch()` is CORS-blocked), so the dashboard is a **double-click
artifact — no local server**, while still loading web fonts from the network.

- **`DASHBOARD_CONTRACT.md`** (ships into every project): the schema authority
  for `window.PROJECT` — field semantics, per-command mutation rules, the phase
  lifecycle (`roadmap-only → specced → complete`), and the safety invariants
  (`node --check` after every write; exact-string `Edit` by unique task `id`;
  the shell is never edited for content).
- **The whole workflow is dashboard-native:**
  - `/own:init` fills `dashboard-data.js` from the (unchanged) Q&A flow.
  - `/own:feature` detects the next `roadmap-only` phase and writes its `spec`,
    `design`, and `tasks` into the phase object, advancing it to `specced`.
  - `/own:done` flips a task's `done` by unique `id`, propagates satisfied
    Definition-of-Done items, and completes a phase when all its tasks are done.
  - `/own:status` reads `window.PROJECT` for all progress (read-only).
  - `/own:guide` reads the active phase's tasks from the dashboard.
  Every mutating command validates with `node --check` and uses exact-string
  `Edit` (never a full-file rewrite).
- **The dashboard itself** renders the entire project as an app-like cockpit:
  header + sidebar + per-phase **Spec / Design / Tasks** tabs, a hand-rolled SVG
  architecture diagram (no library — redraws from data), and a kanban board with
  a live progress ring. Stack rows carry source attribution
  (`package.json` / `mcp:DATE` / `verify:URL` / `manual`); component breakdowns
  include `new`/`modified` badges and file paths.
- **Default theme — "Terminal-Futurism":** a 1:1 capture of
  [ownyourcode.dev](https://www.ownyourcode.dev)'s design system — dark
  near-black surfaces, a terminal-green accent with glow, `Outfit` + `JetBrains
  Mono`, and a signature "ghost numeral" motif. Dark-native; motion gated by
  `prefers-reduced-motion`. Ships inline in `dashboard.html` (self-styled).
- **`/own:theme` is the styling engine:** detects `frontend-design` via the
  session skill list (not the unreliable filesystem cache), reads a design brief
  (`.theme/theme-prompt.md`), and regenerates **only** the dashboard's inline
  `<style>` + font `<link>` — backup-first, with a post-write integrity check
  that auto-restores if the render contract is damaged. Never touches your data.
- **Install seeds the dashboard:** `project-install.sh` / `.ps1` provision
  `dashboard.html` + `dashboard-data.js` + `DASHBOARD_CONTRACT.md` + the theme
  brief, and retire the old `product/` placeholders. Fallback-first: a missing
  source template warns and skips rather than seeding a broken project.
- **Regression suite** (`tests/`, dev-only — never shipped to user projects):
  install + headless render + static command-contract layers (run via
  `bash tests/run.sh`), plus a manual fresh-install walkthrough.

> Supersedes an earlier per-page HTML approach (explored after the 2.3.0 release,
> never tagged) — that work was folded into this single-dashboard model. Existing
> Markdown projects are unaffected until re-initialized.

#### Repository Infrastructure
- **Claude PR Review Gate:** Every PR targeting `main` is now automatically reviewed by Claude against the OwnYourCode standards (P/S/T/X/D rule set across Philosophy, Structure, Tooling, Security, and Documentation), the 4 Protocols, and the universal-audience product mission. The reviewer's system prompt lives in `.github/CLAUDE_REVIEWER.md` and is isolated from the workflow YAML for fast iteration. Reviewer enforces an explicit `VERDICT:` contract (`APPROVE` / `REQUEST_CHANGES` / `COMMENT`) so branch protection can gate merges on the verdict.
- **`@claude` Tag Responder:** Any write-access user can now mention `@claude` in a PR/issue comment, an inline review comment, or a formal PR review to summon Claude for in-thread Q&A with full context (latest PR diff, full comment thread, PR/issue description). Complementary to the auto-review gate — different concern, different workflow file (`.github/workflows/claude-tag.yml`), no system prompt (uses the action's default conversational tag mode). Tool surface is read-and-comment only (no `Edit`/`Write`/shell-wildcards) and the trigger is gated by the action's built-in write-access check.

## [2.3.0] - 2026-02-10

### The "Profiles" Release

OwnYourCode now adapts its pedagogy based on who you are. The 6 Gates, code reviews, and quality standards remain the same—but HOW we teach changes based on your profile.

### Added

#### Profile System
- **4 Developer Profiles:** Junior, Career Switcher, Interview Prep, Experienced
- **Profile Selection:** Part of `/own:init` flow—choose your profile before project setup
- **Profile Templates:** `profiles/*.md` define behavior for each profile type

#### Profile Settings
- **Career Focus:** `full-extraction` (STAR stories + resume bullets), `tips-only` (insights during teaching), `none` (pure learning)
- **Design Involvement:** Collaborative spec creation vs. AI generates / developer reviews
- **Analogies:** Optional domain-specific analogies (e.g., "explain like cooking", "use Star Wars references")
- **Background:** For juniors—brand new vs. has coded before

#### Junior Profile Enhancements
- **Mandatory Design Involvement:** Juniors MUST participate in creating mission.md, stack.md, roadmap.md, spec.md, design.md, tasks.md
- **Collaborative Thinking Flow:** AI asks concrete technology questions, junior thinks through trade-offs
- **Momentum-Driven Socratic Questioning:** Questions build up to create productive struggle
- **MCP-Grounded Guidance:** Context7 + Octocode inform questions with current best practices

#### Experienced Profile
- **Efficiency Mode:** Skip fundamentals, peer-level collaboration
- **Workflow Preferences:** Pair programming, async review, or minimal intervention
- **Adapted Gates:** Ownership gate focuses on "right approach?" not "can you explain?"

### Changed

#### Manifest Structure
- Added `profile` section with `type`, `configured_at`, and `settings`
- Settings include: `background`, `career_focus`, `design_involvement`, `analogies`, `previous_field`, `target_companies`, `timeline`, `focus_areas`, `workflow_preference`

#### CLAUDE.md.template
- Added profile injection points for dynamic behavior
- Role phrasing adapts per profile
- Career extraction section now profile-aware

#### Commands Updated
- `/own:init`: Profile selection added at beginning (Phase -1)
- `/own:done`: Phases 5-6 (career extraction) conditional on `career_focus` setting
- `/own:feature`: Collaborative vs. standard spec generation based on profile
- `/own:status`: Career Stats section hidden when `career_focus=none`

### Philosophy

> "OwnYourCode teaches everyone the same WHAT (6 Gates, quality standards, code reviews).
> The Profiles system changes HOW we teach based on who you are."

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
