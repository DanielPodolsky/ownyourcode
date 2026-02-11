---
name: advise
description: Pre-work command that queries past learnings and leverages MCPs before starting a new task
allowed-tools: Read, Glob, Grep, AskUserQuestion, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__octocode__githubSearchCode, mcp__octocode__githubGetFileContent, mcp__octocode__githubViewRepoStructure, mcp__octocode__githubSearchRepositories
---

# /own:advise

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Query past learnings and leverage research tools before starting a new task.

## Overview

This command is run **before** starting new work. It:
1. Understands what you're about to work on
2. Queries your learning registry for relevant patterns/failures
3. Uses MCPs to research best practices and implementations
4. Surfaces past insights to prevent repeating mistakes
5. Ensures you have a plan before coding

> "Those who don't learn from history are doomed to rewrite it with bugs."

---

## Execution Flow

### Phase 1: What Are You About to Work On?

```
Question: "What are you about to work on?"

Options:
1. A new feature from my spec
   Description: Starting planned work

2. A bug fix
   Description: Something is broken

3. An improvement/refactor
   Description: Making existing code better

4. Something new (not specced)
   Description: Unplanned work
```

Follow-up:
- "In a few words, what's the domain? (e.g., auth, forms, API, database, UI)"
- "What libraries or frameworks are you using?"

---

### Phase 2: Query Global Learning Registry

Read the **global** learning registry at `~/ownyourcode/learning/LEARNING_REGISTRY.md` and search for:
- Patterns matching the domain
- Failures matching the domain
- Recent learnings that might apply

Also check `~/ownyourcode/learning/patterns/` for any documented patterns in the domain.

**Important:** Learning is GLOBAL, not project-specific. This ensures learnings persist across all your projects.

---

### Phase 3: Surface Relevant Learnings

If past learnings found:

```
┌─────────────────────────────────────────┐
│         RELEVANT PAST LEARNINGS         │
├─────────────────────────────────────────┤
│                                         │
│ 📚 PATTERNS YOU'VE USED                │
│ ─────────────────────────               │
│ • [Pattern Name] (2026-01-15)          │
│   "[Summary of what worked]"            │
│   Location: ~/ownyourcode/learning/...  │
│                                         │
│ ⚠️ FAILURES TO AVOID                   │
│ ─────────────────────────               │
│ • [Issue Name] (2026-01-01)            │
│   "[What went wrong and why]"           │
│   Location: ~/ownyourcode/learning/...  │
│                                         │
│ 💡 INSIGHTS                             │
│ ─────────────────────────               │
│ • "[Key insight from past work]"        │
│                                         │
└─────────────────────────────────────────┘
```

If no learnings found:

```
No specific learnings found for [domain] yet.

This will be one of your first deep dives into this area.
As you work, pay attention to:
- Patterns that work well
- Mistakes to avoid
- Insights worth remembering

Run /own:retro when you're done to capture learnings.
```

---

### Phase 4: MCP-Powered Research

**Use ALL available MCPs to gather intelligence before coding:**

#### Context7 - Official Documentation
For any libraries/frameworks mentioned:
1. Resolve the library ID
2. Fetch latest documentation
3. Surface: Recent API changes, best practices, common pitfalls

> "Let me check Context7 for the latest [library] documentation..."

#### Octocode - GitHub Best Practices
Search GitHub for real-world implementations:
1. Search popular repositories for the pattern/feature
2. Find production-quality implementations
3. Surface: How top projects implement this, common patterns, tested approaches

Example queries:
- "How does [popular repo] implement [feature]?"
- "What's the standard pattern for [X] in [framework]?"
- "How do production apps handle [edge case]?"

> "Let me check Octocode for how production apps implement this..."

Use these Octocode tools:
- `githubSearchCode` - Find implementations across repos
- `githubGetFileContent` - Read specific implementations
- `githubSearchRepositories` - Find authoritative repos for reference

#### When to Use Each MCP

| Situation | Primary MCP | Secondary |
|-----------|-------------|-----------|
| Learning a library API | Context7 | Octocode (examples) |
| Implementing a feature | Octocode | Context7 (docs) |
| Best practices question | Octocode | - |
| Debugging library issue | Context7 | Octocode (issues) |
| Architecture decisions | Octocode | - |

---

### Phase 5: Research Summary

Present findings in a structured way:

```
┌─────────────────────────────────────────┐
│           RESEARCH FINDINGS             │
├─────────────────────────────────────────┤
│                                         │
│ 📖 DOCUMENTATION (Context7)             │
│ ─────────────────────────               │
│ • [Library] v[X.Y.Z]                   │
│ • Key API: [relevant methods]           │
│ • Note: "[Important caveat]"            │
│                                         │
│ 🔍 PRODUCTION EXAMPLES (Octocode)       │
│ ─────────────────────────               │
│ • [Repo Name] implements this as:       │
│   "[Brief description of approach]"     │
│ • Common pattern: [Pattern observed]    │
│                                         │
│ ⚡ RECOMMENDATIONS                       │
│ ─────────────────────────               │
│ • Follow [repo]'s approach for [X]      │
│ • Avoid [anti-pattern seen in search]   │
│ • Consider [suggestion from research]   │
│                                         │
└─────────────────────────────────────────┘
```

---

### Phase 6: Preparation Checklist

Before you start coding, confirm:

```
Question: "Before diving in, let's check preparation:"

Options (multi-select):
1. I've reviewed the documentation findings
   Description: Understand the APIs I'll use

2. I've looked at the production examples
   Description: Know how real apps implement this

3. I have a mental model of the approach
   Description: I know roughly what I'm going to build

4. I've identified potential edge cases
   Description: I know what could go wrong

5. I'm ready to start
   Description: Let's go!
```

If they haven't done preparation:

> "Hold on. Let's not repeat past mistakes. Before coding:
>
> 1. **Docs**: Did you see [key point from Context7]?
> 2. **Examples**: [Popular repo] does it this way - thoughts?
> 3. **Edge cases**: What's one thing that could go wrong?"

---

### Phase 7: Plan Verification

> "Great. Before you start, tell me:
>
> 1. What's the first thing you'll create/modify?
> 2. How will you know it's working?
> 3. What's the riskiest part?"

This forces thinking before typing.

---

### Phase 8: Launch Confirmation

```
┌─────────────────────────────────────────┐
│           READY TO START                │
├─────────────────────────────────────────┤
│                                         │
│ Task: [Description]                     │
│ Domain: [Domain]                        │
│                                         │
│ Intelligence Gathered:                  │
│ ─────────────────────                   │
│ 📚 Past Learnings: [X] relevant items   │
│ 📖 Context7: [Library] docs reviewed    │
│ 🔍 Octocode: [X] implementations found  │
│                                         │
│ Key Takeaways:                          │
│ • [Most important doc point]            │
│ • [Best practice from Octocode]         │
│ • [Your past learning to apply]         │
│                                         │
│ Your Plan:                              │
│ 1. [First step]                         │
│ 2. [Verification approach]              │
│ 3. [Risk awareness]                     │
│                                         │
│ ✅ You're prepared. Go build!           │
│                                         │
│ When stuck: /own:stuck          │
│ Need guidance: /own:guide       │
│ When done: /own:done            │
└─────────────────────────────────────────┘
```

---

## Important Notes

1. **Don't skip this** — 5 minutes of prep saves hours of debugging
2. **Learning registry is gold** — It grows with every /own:retro
3. **MCPs are your research team** — Use them liberally
4. **Plan first** — Seniors think before they code
5. **Context7 for docs, Octocode for patterns** — Each MCP has its strength

---

## Why This Matters

| Without /own:advise | With /own:advise |
|-----------------|--------------|
| Repeat past mistakes | Learn from history |
| Jump into code blind | Start with a plan |
| Guess at best practices | See how pros do it |
| Miss API changes | Know latest documentation |
| Hope for the best | Prepare for edge cases |

---

## MCP Reference

### Context7
- Best for: Official documentation, API references, library guides
- Commands: `resolve-library-id`, `get-library-docs`

### Octocode
- Best for: Real implementations, production patterns, best practices
- Commands: `githubSearchCode`, `githubGetFileContent`, `githubSearchRepositories`

---

## Learning Flywheel Connection

```
/own:advise → Work → /own:done → /own:retro
    ↑                          │
    └──── Global Registry  ←───┘
          ~/ownyourcode/learning/
           + MCP Research
```

Every /own:retro adds to your global registry.
Every /own:advise queries that growing knowledge base PLUS live research.
Over time, you build a personal playbook that persists across ALL your projects.
