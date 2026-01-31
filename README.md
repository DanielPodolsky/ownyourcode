<h1 align="center">
  <img width="600" alt="OwnYourCode" src="https://github.com/user-attachments/assets/e3919357-88be-4f5e-af3a-aa3ac440bd98" />
</h1>

<p align="center">
  <strong>AI-Mentored Development</strong><br>
  <em>AI guides, you build. You own the result.</em>
</p>

<p align="center">
  <sub>v2.2.3 · MIT License</sub>
</p>

---

## The Problem

AI coding tools optimize for **shipping**, not **learning**.

Junior asks AI → AI writes code → Junior copy-pastes → "It works!" → No understanding → Dependency grows.

**OwnYourCode flips this.** The AI becomes your mentor, not your coder. It guides, questions, and reviews — but you write every line.

**The result:** Code you understand. Code you can defend in an interview. Code you can debug at 3 AM without AI.

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

## The 4 Protocols

These are non-negotiable.

| Protocol                    | Rule                                                                           | Why                                                                           |
| --------------------------- | ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| **A. Active Typist**        | You write all code. AI provides patterns (max 8 lines), guidance, and reviews. | Muscle memory builds engineers. Copying builds nothing.                       |
| **B. Socratic Teaching**    | AI asks questions instead of giving answers.                                   | Understanding > memorizing. If you know the WHY, you can solve any variation. |
| **C. Evidence-Based**       | AI verifies with official docs before answering.                               | Technology changes fast. Seniors verify. Juniors guess.                       |
| **D. Systematic Debugging** | READ → ISOLATE → DOCS → FIX. AI guides the process, not the answer.            | This is how seniors debug. Build the habit now.                               |

---

## The 6 Gates

Before completing any task, your code passes through 6 quality checkpoints:

| Gate              | Focus         | Question Asked                                               |
| ----------------- | ------------- | ------------------------------------------------------------ |
| 1. Ownership      | Understanding | "Walk me through what this code does, line by line."         |
| 2. Security       | OWASP Top 10  | "Where does user input enter? How is it validated?"          |
| 3. Error Handling | Resilience    | "What happens if the network fails? What does the user see?" |
| 4. Performance    | Scalability   | "What happens with 10,000 items? How many DB queries?"       |
| 5. Fundamentals   | Readability   | "Would a new developer understand this code?"                |
| 6. Testing        | Quality       | "What tests prove this feature works?"                       |

**Gate 1 can block completion.** If you can't explain your code, you don't understand it.

---

## The Learning Flywheel

Your learnings compound. OwnYourCode captures patterns, failures, and career stories — then resurfaces them when relevant.

```
/own:feature → /own:advise → /own:guide → /own:done → /own:retro
     ↑                                                      |
     └──────────────────────────────────────────────────────┘
```

**What persists across projects:**

- **Patterns** — Solutions that worked
- **Failures** — Mistakes you won't repeat
- **STAR Stories** — Interview-ready accomplishments
- **Resume Bullets** — Career value from every task

Each cycle makes the next one smarter.

---

## Commands

| Command        | Purpose                                                 |
| -------------- | ------------------------------------------------------- |
| `/own:init`    | Define your mission, stack, and roadmap                 |
| `/own:feature` | Plan a feature with spec-driven development             |
| `/own:advise`  | Pre-work intelligence from your learning history        |
| `/own:guide`   | Get implementation guidance (patterns, not code)        |
| `/own:test`    | Guide through writing tests                             |
| `/own:docs`    | Guide through writing documentation                     |
| `/own:stuck`   | Debug with Protocol D                                   |
| `/own:done`    | Complete with 6 Gates + code review + career extraction |
| `/own:retro`   | Capture learnings for the flywheel                      |
| `/own:status`  | Check progress + learning stats                         |

---

## MCP Setup (Optional)

MCPs enhance mentorship with real-time documentation and production code examples.

```bash
# Context7 — Official documentation lookup
claude mcp add context7 --transport http https://mcp.context7.com/mcp

# Octocode — GitHub code search
# https://octocode.ai/#installation
```

Without MCPs, OwnYourCode still works but can't verify against latest docs.

---

## Philosophy

**"Won't this slow me down?"**

Yes. That's the point.

Building with someone else's hands means you can't build the next one alone. Building yourself, with guidance, takes longer — but now you can build anything.

---

<p align="center">
  <sub>MIT License · <a href="guides/philosophy.md">Full Philosophy</a></sub>
</p>
