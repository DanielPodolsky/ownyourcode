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

AI coding tools optimize for **shipping**. The risk: code that works but isn't truly yours. Hard to debug without context. Hard to extend without asking again. Hard to defend when it matters.

**OwnYourCode flips this.** AI becomes your mentor, not your coder. It guides, questions, and reviews — but you write the code.

**The result:** Code you understand. Code you can extend. Code that's actually yours.

---

## Who This Is For

> **Coming Soon:** Profile selection during `/own:init`. Currently in development.

| Profile             | Design Thinking | Career Extraction | Unique Feature                                          |
| ------------------- | --------------- | ----------------- | ------------------------------------------------------- |
| **Junior**          | **Required**    | On request        | Builds senior mindset through forced design involvement |
| **Career Switcher** | On request      | On request        | Analogies from your previous field to bridge concepts   |
| **Interview Prep**  | On request      | **Required**      | STAR stories and resume bullets from every task         |
| **Experienced**     | On request      | On request        | Streamlined workflow, skip explanations you don't need  |

_Profiles adapt the experience. The core stays the same: you write, AI guides._

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

| Protocol                 | Rule                                                                           |
| ------------------------ | ------------------------------------------------------------------------------ |
| **Active Typist**        | You write all code. AI provides patterns (max 8 lines), guidance, and reviews. |
| **Socratic Teaching**    | AI asks questions instead of giving answers.                                   |
| **Evidence-Based**       | AI verifies with official docs before answering.                               |
| **Systematic Debugging** | READ → ISOLATE → DOCS → FIX.                                                   |

### The 6 Gates

Before completing any task, your code passes through 6 quality checkpoints:

<div align="center">

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'lineColor': '#aaa'}}}%%
flowchart TB
    Start((" ")) -->|/own:done| Code(["YOUR CODE"])
    Code --> G1["1. Ownership<br/>Walk me through this code"]
    G1 --> G2["2. Security<br/>Is user input validated?"]
    G2 --> G3["3. Errors<br/>What if this operation fails?"]
    G3 --> G4["4. Performance<br/>What happens at<br/>10,000 items?"]
    G4 --> G5["5. Readability<br/>Would a new dev<br/>understand?"]
    G5 --> G6["6. Testing<br/>What tests prove it works?"]
    G6 --> Done(["COMPLETE"])
    Done -.->|Next Feature| Start

    style Start fill:#aaa,stroke:#aaa
    style Code fill:#2d2d2d,color:#fff
    style G1 fill:#8b3a3a,color:#fff
    style G2 fill:#2d2d2d,color:#fff
    style G3 fill:#2d2d2d,color:#fff
    style G4 fill:#2d2d2d,color:#fff
    style G5 fill:#2d2d2d,color:#fff
    style G6 fill:#2d2d2d,color:#fff
    style Done fill:#2d5a3d,color:#fff
```

</div>

> **Gate 1 blocks completion.** Can't explain your code? Don't ship it.

### The Flywheel

Learnings compound across projects. Patterns that worked. Mistakes you won't repeat. Career value extracted from every task.

---

## Commands

| Command        | Purpose                            |
| -------------- | ---------------------------------- |
| `/own:init`    | Set your profile, stack, and goals |
| `/own:feature` | Plan with spec-driven development  |
| `/own:guide`   | Get implementation guidance        |
| `/own:stuck`   | Debug systematically               |
| `/own:done`    | Complete with gates + code review  |
| `/own:retro`   | Capture learnings                  |

---

## MCP Setup (Recommended)

MCPs provide real-time documentation and production code examples.

```bash
# Context7 — Official documentation lookup
claude mcp add context7 --transport http https://mcp.context7.com/mcp

# Octocode — GitHub code search
https://octocode.ai/#installation
```

Without MCPs, OwnYourCode operates at reduced capability — guidance relies on AI's training data rather than verified, up-to-date documentation.

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
