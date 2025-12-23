<h5 align="center">
  <img width="717" height="114" alt="ascii-art-text (3)" src="https://github.com/user-attachments/assets/81bf37f6-d06a-4576-be3e-579e6bd30cd9" />
</h5>

<p align="center">
  <strong>AI-Mentored Development for Juniors</strong><br>
  <em>Ship code AND build skills. Not one or the other.</em>
</p>

<p align="center">
  <!-- TODO: Add badges after pushing to GitHub -->
  <a href="#-installation"><img src="https://img.shields.io/badge/install-curl%20%7C%20bash-brightgreen?style=for-the-badge" alt="Install"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue?style=for-the-badge" alt="License"></a>
  <a href="#-commands"><img src="https://img.shields.io/badge/commands-6-orange?style=for-the-badge" alt="Commands"></a>
</p>

<p align="center">
  <a href="#-the-problem">The Problem</a> •
  <a href="#-how-mentorspec-works">How It Works</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-commands">Commands</a> •
  <a href="#-faq">FAQ</a>
</p>

---

## 🧠 The Problem

Most AI coding tools create **dependency**, not **skill**.

```
┌─────────────────────────────────────────────────────────────────────┐
│                     THE AI BRAIN ROT CYCLE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   Junior asks AI ──▶ AI writes code ──▶ Junior copies it           │
│         ▲                                      │                    │
│         │                                      ▼                    │
│         └────────── Next problem ◀── "It works!" (no understanding)│
│                                                                     │
│   RESULT: Junior needs AI MORE over time, not less                  │
│   INTERVIEW: "Explain this code you wrote" → 😰                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**MentorSpec breaks the cycle.**

```
┌─────────────────────────────────────────────────────────────────────┐
│                    THE MENTORSPEC WAY                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   Junior asks AI ──▶ AI asks questions ──▶ Junior THINKS           │
│         ▲                                      │                    │
│         │                                      ▼                    │
│         └────── Real understanding ◀── Junior writes code          │
│                                                                     │
│   RESULT: Junior needs AI LESS over time                            │
│   INTERVIEW: "Explain this code" → "I built it because..." ✅       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## ⚡ Installation

### Step 1: Install MentorSpec

```bash
curl -sSL https://raw.githubusercontent.com/DanielPodolsky/mentor-spec/main/scripts/base-install.sh | bash
```

### Step 2: Add to Your Project

```bash
cd your-project
~/mentor-spec/scripts/project-install.sh
```

### Step 3: Initialize

Open Claude Code in your project:

```
/mentor-spec:init
```

**That's it.** Claude is now your mentor, not your coder.

---

## 🎯 Commands

| Command | What Happens |
|---------|--------------|
| `/mentor-spec:init` | Define your mission, stack, and roadmap |
| `/mentor-spec:feature` | Plan a feature with spec-driven development |
| `/mentor-spec:guide` | Get guidance (patterns, not solutions) |
| `/mentor-spec:stuck` | Debug with Protocol D (systematic debugging) |
| `/mentor-spec:done` | Code review + extract STAR interview story |
| `/mentor-spec:status` | See your progress |

---

## 🔥 What Changes

<table>
<tr>
<th width="50%">Typical AI Workflow</th>
<th width="50%">MentorSpec Workflow</th>
</tr>
<tr>
<td>

```
You: "Build me a login form"

AI: [Plans it]
AI: [Codes it for you]

You: Review → Ship

You shipped.
But did you grow?
```

</td>
<td>

```
You: "Build me a login form"

AI: [Plans it, designs it,
     breaks it into tasks]

AI: "Now let's build this together.
     What fields does it need?
     Write the form structure..."

You: [Types every line] → Ship

You shipped AND you grew.
```

</td>
</tr>
</table>

---

## 🔄 How MentorSpec Works

MentorSpec is a **spec-driven development** system with two phases:

```
┌─────────────────────────────────────────────────────────────────────┐
│                     PHASE 1: AI-LED SPECIFICATION                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   • AI helps define your mission, stack, and roadmap                │
│   • AI breaks features into specs, designs, and tasks               │
│   • You learn to THINK about problems before coding                 │
│                                                                     │
│   This part is similar to other spec-driven tools.                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 PHASE 2: MENTORED IMPLEMENTATION                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   • AI guides, questions, and teaches                               │
│   • YOU write the actual code                                       │
│   • AI never touches your production code                           │
│                                                                     │
│   This is where juniors build real skills. ← THE DIFFERENCE         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📜 Philosophy

### The Anti-Brain-Rot Rules

```
┌──────────────────────────────────────────────────────────────┐
│  1. AI NEVER writes production code                          │
│     └─▶ MAX 8 lines of example patterns                      │
│                                                              │
│  2. Documentation is SACRED                                  │
│     └─▶ "What do the docs say?" before every answer          │
│                                                              │
│  3. Never give answers DIRECTLY                              │
│     └─▶ "What have you tried?" first                         │
│                                                              │
│  4. Force UNDERSTANDING                                      │
│     └─▶ "Explain back to me what you're implementing"        │
│                                                              │
│  5. Embrace the STRUGGLE                                     │
│     └─▶ Confusion is the sweat of learning                   │
└──────────────────────────────────────────────────────────────┘
```

### Protocol D (When Stuck)

When you're stuck, MentorSpec doesn't solve it for you. It guides you:

```
╔══════════════════════════════════════════════════════════════╗
║                      PROTOCOL D                              ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  1. READ      "Read the error out loud. What is it saying?"  ║
║       │                                                      ║
║       ▼                                                      ║
║  2. ISOLATE   "Where exactly is the failure?"                ║
║       │                                                      ║
║       ▼                                                      ║
║  3. DOCS      "What does the documentation say?"             ║
║       │                                                      ║
║       ▼                                                      ║
║  4. HYPOTHESIZE "What do you think the fix is?"              ║
║       │                                                      ║
║       ▼                                                      ║
║  5. VERIFY    "Try it. Did it work? Why?"                    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

This is how seniors debug. Now it's how YOU debug.
```

### Career Value Extraction

Every completed task produces:

- **STAR Interview Story** — Situation, Task, Action, Result
- **Resume Bullet** — "Engineered X, resulting in Y"

Build your portfolio while building your project.

---

## 📁 What Gets Created

```
your-project/
├── .claude/
│   ├── CLAUDE.md                    # THE STRICTNESS (mentor rules)
│   └── commands/mentor-spec/        # Slash commands
│
└── mentorspec/
    ├── product/
    │   ├── mission.md               # What problem you're solving
    │   ├── stack.md                 # Your tech decisions
    │   └── roadmap.md               # Development phases
    ├── specs/
    │   ├── active/                  # Features in progress
    │   └── completed/               # Done features
    └── career/
        └── stories/                 # Your interview stories
```

---

## 🗑️ Uninstall

**From a project:**
```bash
~/mentor-spec/scripts/project-uninstall.sh
```

**Remove MentorSpec completely:**
```bash
rm -rf ~/mentor-spec
```

---

## 🎯 Who Is This For?

- **Juniors learning to code** — Build real skills, not AI dependency
- **Job seekers** — Create a portfolio you can defend in interviews
- **Self-taught devs** — Get the mentorship bootcamps charge $20k for
- **Anyone** who wants to need AI LESS over time

---

## ❓ FAQ

### "Won't this slow me down?"

Yes. That's the point.

Building a house fast with someone else's hands means you can't build the next one alone.

Building it yourself, with guidance, takes longer. But now you can build anything.

### "What if I just want the AI to code it?"

Then MentorSpec will feel frustrating.

It's designed to feel a bit uncomfortable — like a workout. Growth requires resistance.

If you want AI to just write code, use a different tool. No judgment.

### "Is this only for complete beginners?"

No. MentorSpec is for anyone who wants to **grow**, not just ship.

If you're already senior and just want to ship fast, MentorSpec isn't for you. That's okay.

But if you're a junior who wants skills that last — welcome.

---

## 🧪 The Ultimate Test

> *"If you took away the AI tomorrow, could you still code?"*

**Without MentorSpec:** Probably not.

**With MentorSpec:** **Yes.** Because you wrote every line. You understood every decision. You built real skills.

---

<p align="center">
  <strong>Stop letting AI rot your brain.</strong><br>
  <em>Start building skills that last.</em>
</p>

<p align="center">
  <a href="#-installation">Get Started →</a>
</p>

---

<p align="center">
  <sub>MIT License • Built for juniors who want to become seniors</sub>
</p>
