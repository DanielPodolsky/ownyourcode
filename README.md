<h1 align="center">
  <img width="600" alt="OwnYourCode" src="https://github.com/user-attachments/assets/e3919357-88be-4f5e-af3a-aa3ac440bd98" />
</h1>

<p align="center">
  <strong>AI-Mentored Development</strong><br>
  <em>AI guides, you build. You own the result.</em>
</p>

<p align="center">
  <sub>v2.2.5 · MIT License</sub>
</p>

---

## The Problem

AI coding tools optimize for **shipping**. You get code fast, but you don't understand it. You can't debug it. You can't defend it in an interview. You can't build on it without asking AI again.

**OwnYourCode flips this.** AI becomes your mentor, not your coder. It guides, questions, and reviews — but you write the code.

**The result:** Code you understand. Code you can extend. Code that's actually yours.

---

## Who This Is For

| Profile | What You Get |
|---------|--------------|
| **Junior Developer** | Deep learning. Forced design thinking. Build the senior mindset early. |
| **Career Switcher** | Translate your domain expertise. Learn to code without crutches. |
| **Interview Prep** | STAR stories extracted from real work. Resume bullets that aren't BS. |
| **Experienced Dev** | Skip the hand-holding. Get quality checks and velocity. |

*Profiles adapt the experience. The core stays the same: you write, AI guides.*

---

## Quick Start

**macOS / Linux**

```bash
curl -sSL https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/base-install.sh | bash
cd your-project && ~/ownyourcode/scripts/project-install.sh
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/base-install.ps1 | iex
cd your-project
irm https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/project-install.ps1 | iex
```

**Initialize**

```
/own:init
```

---

## How It Works

### The 4 Protocols

| Protocol | Rule |
|----------|------|
| **Active Typist** | You write all code. AI provides patterns (max 8 lines), guidance, and reviews. |
| **Socratic Teaching** | AI asks questions instead of giving answers. |
| **Evidence-Based** | AI verifies with official docs before answering. |
| **Systematic Debugging** | READ → ISOLATE → DOCS → FIX. |

### The 6 Gates

Before completing any task, your code passes through quality checkpoints: Ownership, Security, Error Handling, Performance, Readability, Testing.

Gate 1 can block completion. If you can't explain your code, you don't understand it.

### The Flywheel

Learnings compound across projects. Patterns that worked. Mistakes you won't repeat. Career value extracted from every task.

---

## Commands

| Command | Purpose |
|---------|---------|
| `/own:init` | Set your profile, stack, and goals |
| `/own:feature` | Plan with spec-driven development |
| `/own:guide` | Get implementation guidance |
| `/own:stuck` | Debug systematically |
| `/own:done` | Complete with gates + code review |
| `/own:retro` | Capture learnings |

---

## MCP Setup (Optional)

MCPs provide real-time documentation and code examples.

```bash
# Context7 — Official documentation lookup
claude mcp add context7 --transport http https://mcp.context7.com/mcp

# Octocode — GitHub code search
# https://octocode.ai/#installation
```

Without MCPs, OwnYourCode still works but can't verify against latest docs.

---

## Philosophy

> "Won't this slow me down?"

Yes. That's the point.

Building with someone else's code means you can't build the next thing alone. Building yourself takes longer — but now you can build anything.

[Full Philosophy →](guides/philosophy.md)

---

<p align="center">
  <sub>MIT License</sub>
</p>
