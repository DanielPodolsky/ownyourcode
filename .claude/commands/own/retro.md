---
name: retro
description: Post-work command that extracts learnings and updates the learning registry
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, mcp__octocode__githubSearchCode, mcp__octocode__githubGetFileContent
---

# /own:retro

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Extract learnings from completed work and persist them for future reference.

## Overview

This command is run **after** completing work (typically after `/own:done`). It:
1. Reflects on what was learned
2. Documents patterns worth reusing
3. Records failures to avoid
4. Updates the learning registry
5. Generates skill files for significant learnings

> "The junior who documents their failures outgrows the senior who repeats them."

---

## Execution Flow

### Phase 1: What Did You Just Complete?

> "What did you just finish working on?"

If they just ran `/own:done`, reference that context.

Get:
- Feature/task name
- Domain (auth, forms, API, etc.)
- Rough summary

---

### Phase 2: Learning Extraction

Ask these questions to extract learnings:

#### Question 1: The Hard Part
> "What was the hardest part of this work?"

Looking for:
- Technical challenges overcome
- Confusing concepts clarified
- Time-consuming debugging

#### Question 2: The Insight
> "What do you know now that you didn't know before you started?"

Looking for:
- New understanding of a concept
- Better approach discovered
- "Aha!" moments

#### Question 3: The Pattern (if applicable)
> "Did you discover or use a pattern that worked well? Something you'd want to reuse?"

Looking for:
- Code patterns worth extracting
- Approaches that solved problems elegantly
- Techniques to remember

#### Question 4: The Failure (most valuable)
> "Did you make any mistakes or hit any walls? What went wrong before it went right?"

Looking for:
- Bugs that took time to find
- Wrong approaches tried first
- Misunderstandings that caused problems

#### Question 5: The Advice
> "If you could go back and tell yourself one thing before starting this task, what would it be?"

This often captures the most actionable learning.

---

### Phase 3: Categorize Learnings

Based on their answers, categorize:

**Patterns** (reusable solutions):
- Code patterns that worked well
- Approaches worth reusing
- Techniques to remember

**Failures** (anti-patterns):
- Mistakes to avoid
- Wrong approaches
- Time-wasters to skip

**Insights** (general learnings):
- Conceptual understanding
- "Now I get it" moments
- Connections made

---

### Phase 4: Generate Learning Artifacts

**All learnings are stored GLOBALLY at `~/ownyourcode/learning/` to persist across projects.**

#### For Significant Patterns

Create a pattern file at `~/ownyourcode/learning/patterns/[PatternName].md`:

```markdown
---
name: [Pattern Name]
description: [When to use this pattern]
---

# [Pattern Name]

**Learned:** 2026-01-01
**Domain:** [Domain]
**Context:** [Brief context of when this was learned]

## When to Use

[Situations where this pattern applies]

## The Pattern

[Code example or description]

## Why It Works

[Explanation of why this is effective]

## Watch Out For

[Common mistakes or edge cases]

## Related

- [Link to original task if applicable]
```

#### For Significant Failures

Create a failure doc at `~/ownyourcode/learning/failures/[Topic].md`:

```markdown
# FAILURE: [Short Description]

**Date:** 2026-01-01
**Domain:** [Domain]
**Time Lost:** [Rough estimate]

## What Happened

[Description of the failure]

## Root Cause

[Why it happened]

## The Fix

[How it was resolved]

## How to Avoid

[What to do differently next time]

## Red Flags

[Warning signs to watch for]
```

---

### Phase 5: Update Global Learning Registry

Append to `~/ownyourcode/learning/LEARNING_REGISTRY.md`:

```markdown
### 2026-01-01: [Title]

**Domain:** [Domain]
**Type:** Pattern | Failure | Insight
**Summary:** [One-line summary]
**Key Insight:** [The main takeaway]
**Location:** [Path to skill file or failure doc if created]
```

Also update the index tables at the top of the registry.

---

### Phase 6: Competency Check

Based on accumulated learnings, assess growth:

```
┌─────────────────────────────────────────┐
│         COMPETENCY SNAPSHOT             │
├─────────────────────────────────────────┤
│                                         │
│ Total Patterns Documented:  [X]         │
│ Total Failures Documented:  [Y]         │
│ Total Insights Captured:    [Z]         │
│                                         │
│ Domains Explored:                       │
│ • Auth: ████████░░ (8 learnings)       │
│ • Forms: ████░░░░░░ (4 learnings)      │
│ • API: ██░░░░░░░░ (2 learnings)        │
│                                         │
│ Current Level: ⭐⭐⭐ (Intermediate)     │
│                                         │
│ "You're building a solid foundation.    │
│  Keep documenting — this compounds."    │
│                                         │
└─────────────────────────────────────────┘
```

---

### Phase 7: Summary

```
┌─────────────────────────────────────────┐
│       RETROSPECTIVE COMPLETE            │
├─────────────────────────────────────────┤
│                                         │
│ Task: [Feature Name]                    │
│ Domain: [Domain]                        │
│                                         │
│ LEARNINGS CAPTURED                      │
│ ─────────────────                       │
│ ✅ Pattern: [Name] → saved to skills    │
│ ⚠️ Failure: [Name] → documented         │
│ 💡 Insight: "[Key insight]"             │
│                                         │
│ GLOBAL REGISTRY UPDATED                 │
│ ─────────────────                       │
│ ~/ownyourcode/learning/LEARNING_REGISTRY│
│                                         │
│ NEXT TIME                               │
│ ─────────────────                       │
│ Run /own:advise before your next task   │
│ to surface these learnings.             │
│                                         │
└─────────────────────────────────────────┘

What's next?
- /own:status — see your progress
- /own:feature — start new feature
- /own:advise — prepare for next task
```

---

## Important Notes

1. **Failures are gold** — Document them shamelessly, they're the best teachers
2. **Be specific** — Vague learnings aren't useful later
3. **One pattern at a time** — Don't force it; quality over quantity
4. **Registry is GLOBAL** — Learnings persist across ALL your projects at `~/ownyourcode/learning/`
5. **Registry compounds** — Every entry makes /own:advise smarter
6. **Review periodically** — Skim your registry monthly

---

## Learning Flywheel

```
                    ┌────────────────┐
                    │  /own:advise   │
                    │    (query)     │
                    └───────┬────────┘
                            │
                            ▼
              ┌────────────────────────┐
              │        WORK            │
              │  (build, debug, learn) │
              └────────────┬───────────┘
                            │
                            ▼
                    ┌────────────────┐
                    │   /own:done    │
                    │   (complete)   │
                    └───────┬────────┘
                            │
                            ▼
              ┌────────────────────────┐
              │      /own:retro        │
              │  (extract learnings)   │
              └────────────┬───────────┘
                            │
                            ▼
              ┌────────────────────────┐
              │   GLOBAL REGISTRY      │
              │ ~/ownyourcode/learning │
              └────────────┬───────────┘
                            │
                            └──────────────┐
                                           │
                    ┌────────────────┐     │
                    │  /own:advise   │◄────┘
                    │    (query)     │
                    └────────────────┘
```

The more you use this loop, the smarter the system becomes.

---

## Competency Levels

| Level | Learnings | Characteristics |
|-------|-----------|-----------------|
| ⭐ Beginner | 0-5 | Just starting, building foundation |
| ⭐⭐ Developing | 6-15 | Patterns emerging, fewer repeated mistakes |
| ⭐⭐⭐ Intermediate | 16-30 | Solid playbook, can advise others |
| ⭐⭐⭐⭐ Advanced | 31-50 | Deep knowledge, rarely stuck |
| ⭐⭐⭐⭐⭐ Expert | 50+ | Teaching others, anticipates problems |

Your goal: **⭐⭐⭐⭐⭐ in 30 days.**

Every /own:retro moves you forward.
