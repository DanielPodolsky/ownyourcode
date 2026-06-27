# Changelog

## 2.7.0

- Reworked the Junior profile from "hand-type every line" to **predict-before-reveal**: on each implementation task the junior commits a prediction (approach, data structure, control flow, edge cases) *before* the AI writes the code, then the AI grades the prediction against a rubric and names the specific gap — ownership shifts from typing the code to being able to evaluate it
- The predict-before-reveal loop runs inline as a new `/own:feature` **Phase 6** (Junior profile only) so the gate can't be skipped; only judgment-carrying Implementation tasks gate, while Setup and Verification tasks flow
- Added a per-dimension **Prediction Scorecard** to the global learning registry that logs MATCH/PARTIAL/MISS over time, turning "is the junior's judgment improving?" into a measurable curve
- Added **adaptive fading**: the prediction gate relaxes per-dimension as the junior proves the skill (4 consecutive matches retires a dimension to a spot-check), with a deterministic staleness re-check so a faded-but-rusty dimension re-engages on its own — the gym never decays into a rubber-stamp tax
- The Junior `OWN` step now requires a self-explanation (why the actual approach is better and where the prediction broke), feeding `/own:done` Gate 1 with real ownership evidence
- Added `docs/research/junior-profile-predict-before-reveal-validation.md` — the redesign validated against learning-science literature and real-world industry practice, with prioritized refinements
- `/own:guide` is no longer the primary implementation path for juniors; it remains available for ad-hoc help (README and command docs updated to match)

## 2.6.0

- Added a boot sequence — a terminal window types your live project status (phases, task counts) on load; any key skips it, `prefers-reduced-motion` bypasses it, `#noboot` disables it
- Added a command palette (`⌘K`/`Ctrl+K` with platform-aware label, or `/`) for jumping between views; digits `1–9` jump directly and `[` `]` cycle
- Added a tmux-style status bar with live segments: version, project, active phase, task totals, DoD percent, and a ticking clock
- Added a mission track to the Overview — the roadmap as a timeline with complete, active (pulsing), and roadmap-only nodes; clicking a node navigates to its phase
- Added per-phase task-burn progress bars to the Overview, derived from the same task data the kanban renders
- Added micro-interactions: pointer-tracking tile glow, count-up stats, kanban column progress bars, a segmented Definition-of-Done bar, marching-ants diagram connectors, and aurora/radar-sweep atmosphere
- Fixed the architecture diagram stretching to fill wide tiles and text overflowing its boxes — layout is now content-aware (label gutter and node boxes size to their text via JetBrains Mono's fixed metrics), with clipped text preserved as a hover tooltip
- Fixed Windows PowerShell 5.1 failing to parse the installers when run from disk — all `.ps1` scripts are now pure ASCII (the same convention Chocolatey and Scoop installers use)
- Expanded the render test from 35 to 48 assertions and added drift guards: every shipped command must be documented in `CLAUDE.md.template`, and every `.ps1` must stay pure ASCII
- The PR review gate now runs one full review when a PR opens and cheap incremental reviews (previous comments + newly pushed commits only) on each push, with turn caps and a one-comment praise cap
- Existing projects upgrade by replacing `dashboard.html` only — the `window.PROJECT` contract is unchanged and `dashboard-data.js` is untouched

## 2.5.0

- Spec-Driven Development now lives in a single browser dashboard instead of a folder of Markdown files: `dashboard.html` (stable view shell, never hand-edited for content) plus `dashboard-data.js` (`window.PROJECT`, the single source of truth every `/own:*` command reads and writes)
- The dashboard is a double-click `file://` artifact — data loads via `<script src>`, no local server needed
- Added `DASHBOARD_CONTRACT.md`, shipped into every project: the schema authority for `window.PROJECT`, per-command mutation rules, the phase lifecycle, and safety invariants
- Made the whole workflow dashboard-native: `/own:init` fills the data file, `/own:feature` specs the next roadmap phase, `/own:done` completes tasks by unique id and propagates Definition-of-Done items, `/own:status` and `/own:guide` read it
- Added the "Terminal-Futurism" default theme — a 1:1 capture of ownyourcode.dev's design system: dark near-black surfaces, terminal-green accent with glow, Outfit + JetBrains Mono, and the signature ghost-numeral motif
- `/own:theme` regenerates only the dashboard's inline `<style>` and font links from a design brief — backup-first, with a post-write integrity check that auto-restores if the render contract is damaged
- Installers now seed the dashboard files and retire the old `product/` placeholders, warning and skipping instead of seeding a broken project when templates are missing
- Added a dev-only regression suite (`bash tests/run.sh`): install, headless render, and static command-contract layers
- Every PR to `main` is now auto-reviewed by Claude against the OwnYourCode standards (`.github/CLAUDE_REVIEWER.md`) with an explicit verdict contract for branch protection
- Mentioning `@claude` in a PR or issue comment now summons in-thread Q&A with full PR context

## 2.3.0

- Added 4 developer profiles (Junior, Career Switcher, Interview Prep, Experienced) — the gates and quality standards stay the same, how we teach adapts to who you are
- Added profile selection to `/own:init`, with settings for career focus, design involvement, analogies, and coding background
- Juniors now get mandatory design involvement and momentum-driven Socratic questioning grounded in MCP research
- Experienced developers get efficiency mode, workflow preferences, and an ownership gate that asks "right approach?" instead of "can you explain?"
- The manifest gained a `profile` section; `CLAUDE.md.template`, `/own:done`, `/own:feature`, and `/own:status` are now profile-aware

## 2.2.5

- Fixed `/own:init` using outdated internal knowledge for package versions — versions are now fetched in real time via MCP
- Fixed `/own:init` creating duplicate `ownyourcode/` directories when run from a project subdirectory

## 2.2.4

- Fixed CLAUDE.md duplication when re-running the installer
- Fixed uninstall leaving OwnYourCode files behind

## 2.2.3

- Stack recommendations now show verified versions with source attribution: read from `package.json`, verified via MCP, or flagged "verify at URL"

## 2.2.2

- Added `.claude/agents/` to `.gitignore` for personal agent files

## 2.2.1

- Fixed the interactive prompt not appearing when installing via `curl ... | bash` — input now reads from `/dev/tty`

## 2.2.0

- Redesigned the README as a focused landing page: "The 4 Protocols" surfaced as visible methodology, universal ownership positioning, new tagline "AI guides, you build. You own the result."
- Unified all commands under the `/own:` prefix
- Improved skill descriptions so skills auto-trigger more reliably
- Fixed Windows installation: PowerShell string escaping, here-string compatibility, and `irm`-based project install

## 2.1.0

- Learnings now persist globally across all projects at `~/ownyourcode/learning/` — patterns and failures compound across your entire engineering journey
- `/init` now detects and teaches package managers (npm, pnpm, bun, yarn)
- Package versions are always verified via Context7 + OctoCode before being recommended
- Skills now apply silently during `/feature` and `/done` — the junior receives quality guidance without seeing skill names
- Completed specs auto-archive to `completed/` and task tracking updates in real time

## 2.0.0

- Added the 6 Mentorship Gates — mandatory quality checkpoints before completing any task: Ownership (can block), Security, Error Handling, Performance, Fundamentals, Testing
- Added the Learning Flywheel: `/advise` for pre-work intelligence, `/retrospective` for capturing learnings, and a persistent learning registry with patterns and failures
- Added 4 fundamental skills (Testing, SEO, Accessibility, Documentation) and 2 commands (`/own:test`, `/own:docs`)
- Added the Resistance Protocol — enforced pushback when juniors try to shortcut ("just write the code for me" gets redirected to learning)
- Every completed task now produces STAR interview stories and resume bullets

## 1.0.0

- Initial release: 8 slash commands, 7 fundamental skills, 5 mentorship gates, Anti-Brain-Rot rules, Protocol D debugging, and STAR story extraction
