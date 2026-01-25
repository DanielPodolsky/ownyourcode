<h1 align="center">
  <img width="986" height="256" alt="ascii-art-text" src="https://github.com/user-attachments/assets/e3919357-88be-4f5e-af3a-aa3ac440bd98" />

</h1>

<p align="center">
  <strong>AI-Mentored Development for Juniors</strong><br>
  <em>Less dependency, more ownership.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-2.1-blueviolet?style=for-the-badge" alt="Version 2.1">
  <a href="#quick-start"><img src="https://img.shields.io/badge/install-curl%20%7C%20bash-brightgreen?style=for-the-badge" alt="Install"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/commands-10-orange?style=flat-square" alt="10 Commands">
  <img src="https://img.shields.io/badge/skills-11-green?style=flat-square" alt="11 Skills">
  <img src="https://img.shields.io/badge/gates-6-red?style=flat-square" alt="6 Gates">
</p>

---

## What is OwnYourCode?

AI coding tools optimize for **shipping**, not **learning**. Junior asks AI → AI writes code → Junior copy-pastes → "It works!" → No understanding gained → Dependency grows.

OwnYourCode flips this. The AI becomes your **mentor**, not your coder. It guides, questions, and reviews — but **you** write every line.

**The result:** Skills that last. Code you can defend in an interview. Independence, not dependency.

> See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## Quick Start

### macOS / Linux

**Step 1: Install OwnYourCode**

```bash
curl -sSL https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/base-install.sh | bash
```

**Step 2: Add to Your Project**

```bash
cd your-project
~/ownyourcode/scripts/project-install.sh
```

### Windows (PowerShell)

**Step 1: Install OwnYourCode**

```powershell
irm https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/base-install.ps1 | iex
```

**Step 2: Add to Your Project**

```powershell
cd your-project
irm https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/project-install.ps1 | iex
```

### Then Initialize

Open Claude Code in your project and run:

```
/own:init
```

That's it. Claude is now your mentor, not your coder.

---

## How It Works

OwnYourCode operates in two phases:

1. **AI-Led Specification** — AI helps you think, plan, and break down features into tasks. You review and approve.

2. **Mentored Implementation** — AI provides patterns (max 8 lines of example code), asks guiding questions, and reviews via 6 Gates. **You write all production code.**

**The core rules:**
- AI never writes production code for you
- Documentation is checked before every technical answer
- You must explain your code to complete a task
- Confusion is expected — growth requires struggle

---

## The 6 Gates

Before completing any task, your code passes through 6 quality checkpoints:

| Gate | Focus | Question Asked |
|------|-------|----------------|
| 1. Ownership | Understanding | "Walk me through what this code does, line by line." |
| 2. Security | OWASP Top 10 | "Where does user input enter? How is it validated?" |
| 3. Error Handling | Resilience | "What happens if the network fails? What does the user see?" |
| 4. Performance | Scalability | "What happens with 10,000 items? How many DB queries?" |
| 5. Fundamentals | Readability | "Would a new developer understand this code?" |
| 6. Testing | Quality | "What tests prove this feature works?" |

**Gate 1 (Ownership) can block completion.** If you can't explain your code, you don't understand it.

---

## The Learning Flywheel

Your learnings compound over time. Unlike normal AI chats that forget everything, OwnYourCode remembers.

**The cycle:**
- `/own:feature` — Plan a new feature (creates spec, design, tasks)
- `/own:advise` — Get relevant learnings before starting a task
- `/own:guide` — Get implementation help as you code
- `/own:done` — Pass 6 Gates, code review, extract STAR story
- `/own:retro` — Capture what you learned

**What persists:**
- **Patterns** — Solutions that worked
- **Failures** — Mistakes you won't repeat
- **STAR Stories** — Interview-ready accomplishments
- **Resume Bullets** — Career value from every task

Each cycle makes the next one smarter. Your failures become warnings. Your patterns become shortcuts.

---

## Commands

| Command | Purpose |
|---------|---------|
| `/own:init` | Define your mission, stack, and roadmap |
| `/own:feature` | Plan a feature with spec-driven development |
| `/own:advise` | Pre-work intelligence from your learning history |
| `/own:guide` | Get implementation guidance (patterns, not code) |
| `/own:test` | Guide through writing tests (you write, AI guides) |
| `/own:docs` | Guide through writing documentation |
| `/own:stuck` | Debug with Protocol D |
| `/own:done` | Complete with 6 Gates + code review + career extraction |
| `/own:retro` | Capture learnings for the flywheel |
| `/own:status` | Check progress + learning stats |

---

## Protocol D (Debugging)

When you're stuck, OwnYourCode guides you through systematic debugging:

1. **READ** — "Read the error out loud. What is it saying?"
2. **ISOLATE** — "Where exactly is the failure?"
3. **DOCS** — "What does the documentation say?"
4. **HYPOTHESIZE** — "What do YOU think the fix is?"
5. **VERIFY** — "Try it. Did it work? Why?"

This is how seniors debug. Now it's how you debug.

---

## MCP Setup (Recommended)

OwnYourCode uses MCPs for enhanced mentorship:

**Context7 — Documentation Lookup**
```bash
claude mcp add context7 --transport http https://mcp.context7.com/mcp
```

**Octocode — GitHub Code Search**
```bash
https://octocode.ai/#installation
```

| MCP | Purpose |
|-----|---------|
| Context7 | "According to the React 19 docs..." — Official documentation |
| Octocode | "Here's how Vercel implements this..." — Production patterns |

Without MCPs, OwnYourCode still works but operates at reduced effectiveness.

---

## Architecture

```
your-project/
├── .claude/
│   ├── CLAUDE.md                     ← Mentor rules
│   ├── commands/ownyourcode/         ← 10 slash commands
│   └── skills/
│       ├── fundamentals/             ← 11 core skills
│       ├── gates/                    ← 6 mentorship gates
│       ├── career/                   ← STAR + resume extraction
│       └── learned/                  ← Project-specific skills
│
├── ownyourcode/
│   ├── product/                      ← Mission, stack, roadmap
│   ├── specs/
│   │   ├── active/                   ← Work in progress
│   │   └── completed/                ← Archived specs
│   └── career/                       ← Your interview stories
│
~/ownyourcode/                        ← GLOBAL (persists across projects)
└── learning/
    ├── LEARNING_REGISTRY.md          ← Growth tracker
    ├── patterns/                     ← Reusable solutions
    └── failures/                     ← Lessons learned
```

---

## Philosophy

**"Won't this slow me down?"**

Yes. That's the point. Building with someone else's hands means you can't build the next one alone. Building yourself, with guidance, takes longer — but now you can build anything.

---

<p align="center">
  <em>Less dependency, more ownership.</em>
</p>

<p align="center">
  <a href="#quick-start">Get Started</a>
</p>

---

<p align="center">
  <sub>MIT License</sub>
</p>
