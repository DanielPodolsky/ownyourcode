---
name: done
description: Complete a task with 6 Gates verification, code review, and career value extraction
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash
---

# /own:done

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Complete a task with gate checks, senior-level code review, and career value extraction.

## Overview

This command is run when the user finishes a task or feature. It performs:
1. **Gate Checks** — 6 Mentorship Gates verification
2. **Code Review** — FAANG-level feedback on their code
3. **Task Completion** — Update the dashboard (task done, DoD, phase status)
4. **Interview Story** — Extract STAR format story (if career_focus allows)
5. **Resume Bullet** — Draft action-impact bullet (if career_focus allows)

**Profile-Aware Behavior:**
- Check `.claude/ownyourcode-manifest.json` for `profile.settings.career_focus`
- If `career_focus = "full-extraction"` → Run all phases including 5 and 6
- If `career_focus = "tips-only"` → Skip Phases 5 and 6
- If `career_focus = "none"` → Skip Phases 5 and 6, hide CAREER VALUE in summary

---

## Execution Flow

### Phase 1: Identify Completed Work

```
Question: "What did you just finish?"

Options:
1. A task from my active spec
   Description: Completing planned work

2. A bug fix
   Description: Fixed something that was broken

3. A feature (not specced)
   Description: Built something new

4. A refactor
   Description: Improved existing code
```

If from active spec, read the dashboard to understand context:
- Read `ownyourcode/dashboard/dashboard-data.js` (`window.PROJECT`)
- Find the active phase (first with `status !== "complete"`) and the relevant
  task in its `tasks[]` (match by `text`/`detail`, note its `id`)
- Note what they were building and why (the phase `spec` / `design`)

---

### Phase 2: Gather Changes

Review what code was written:

```bash
# Recent commits
git log --oneline -5

# Files changed
git diff --name-only HEAD~1

# Or if uncommitted
git status
```

Ask them to point to the key files:

> "Which files contain the main implementation?"

Read those files to understand what they built.

---

### Phase 2.5: Gate Checks (THE 6 GATES)

Before code review, run through the 6 Mentorship Gates. These ensure quality and understanding.

> "Before we review the code, let's run through the 6 Gates."

#### Gate 1: Ownership (CAN BLOCK)
*Reference: `.claude/skills/gates/ownership/SKILL.md`*

> "Walk me through what this code does, step by step."

**Questions:**
1. "Why did you choose this approach? What alternatives did you consider?"
2. "If the requirements changed to [X], what would you modify?"

**Outcomes:**
- **PASS**: Junior demonstrates clear understanding
- **BLOCKED**: Junior cannot explain → "Let's pause. Review the code and come back when you can explain it."

#### Gate 2: Security (WARNINGS)
*Reference: `.claude/skills/gates/security/SKILL.md`*

> "Where does user input enter this feature?"
> "How is that input validated?"

**Check for:**
- Input validation present
- Authorization checks
- No hardcoded secrets
- No SQL/XSS vulnerabilities

**Outcomes:**
- **PASS**: No issues found
- **WARNING**: Issues found → Note them for code review

#### Gate 3: Error Handling (WARNINGS)
*Reference: `.claude/skills/gates/error/SKILL.md`*

> "What happens if [main operation] fails?"
> "What does the user see when an error occurs?"

**Check for:**
- No empty catch blocks
- User-friendly error messages
- Loading states cleared on error
- Errors logged for debugging

**Outcomes:**
- **PASS**: Error handling appropriate
- **WARNING**: Issues found → Note them for code review

#### Gate 4: Performance (WARNINGS)
*Reference: `.claude/skills/gates/performance/SKILL.md`*

> "What happens when there are 10,000 items?"
> "How many database queries does this make?"

**Check for:**
- No N+1 queries
- Pagination for lists
- No unnecessary re-renders
- Cleanup of intervals/subscriptions

**Outcomes:**
- **PASS**: No obvious issues
- **WARNING**: Issues found → Note them for code review

#### Gate 5: Fundamentals (SUGGESTIONS)
*Reference: `.claude/skills/gates/fundamentals/SKILL.md`*

> "Would a new developer understand this code?"

**Check for:**
- Descriptive naming
- Reasonable function size
- No magic numbers
- Appropriate abstractions

**Outcomes:**
- **PASS**: Code quality is solid
- **SUGGESTIONS**: Polish items → Note for consideration

#### Gate 6: Testing (WARNINGS)
*Reference: `.claude/skills/gates/testing/SKILL.md`*

> "What tests prove this feature works?"

**Questions:**
1. "What tests did you write for this feature?"
2. "What edge cases do your tests cover?"
3. "If I broke [specific part], which test would catch it?"

**Check for:**
- At least one test exists
- Happy path is covered
- At least one edge case considered
- Tests actually run (not skipped)

**Outcomes:**
- **PASS**: Tests exist and cover critical paths
- **WARNING**: No tests or weak coverage → Encourage but don't block

**Note:** This gate issues WARNINGS only. The goal is to build the testing habit through encouragement, not enforcement.

#### Gate Summary

```
┌─────────────────────────────────────────┐
│           GATE CHECK RESULTS            │
├─────────────────────────────────────────┤
│ 1. Ownership:    ✅ PASS / 🛑 BLOCKED   │
│ 2. Security:     ✅ PASS / ⚠️ WARNING   │
│ 3. Error:        ✅ PASS / ⚠️ WARNING   │
│ 4. Performance:  ✅ PASS / ⚠️ WARNING   │
│ 5. Fundamentals: ✅ PASS / 💡 SUGGEST   │
│ 6. Testing:      ✅ PASS / ⚠️ WARNING   │
└─────────────────────────────────────────┘
```

**If BLOCKED on Gate 1:** Stop here. The junior must understand their code before proceeding.

**If WARNINGS exist:** Note them and incorporate into code review. The junior should address them.

**If only SUGGESTIONS:** Proceed to code review. These are polish, not blockers.

---

### Phase 3: Code Review (FAANG Level)

Perform a thorough code review. Be honest but constructive.

**Incorporate any gate warnings into the review.**

#### Review Categories

**Correctness**
- Does it work?
- Are edge cases handled?
- What happens with invalid input?

**Security**
- Any injection vulnerabilities?
- Secrets exposed?
- Input validation?

**Performance**
- Unnecessary re-renders?
- Expensive operations optimized?
- Memory leaks?

**Readability**
- Clear naming?
- No magic numbers?
- Reasonable function size?

**Maintainability**
- Easy to change?
- Well-structured?
- DRY but not over-abstracted?

#### Review Format

Use severity levels:

```markdown
## Code Review

### Blockers (Must Fix)

**Issue:** [Description]
`path/file.ts:42`

[Explanation of the issue]

**Why it matters:** [Impact]

**Question for you:** [What would you change? - don't give the answer]

---

### Warnings (Should Consider)

**Issue:** [Description]
`path/file.ts:88`

[Explanation]

**Consider:** [Improvement direction]

---

### Suggestions (Nice to Have)

**Idea:** [Improvement]

[Why this would be better]
```

**Important:** For blockers and warnings, ask them what they would change rather than giving the fix.

---

### Phase 4: Update the Dashboard

All state lives in `ownyourcode/dashboard/dashboard-data.js` (`window.PROJECT`). This phase
makes three small, exact-string mutations — never regenerate the whole file, and
never touch `dashboard.html`. See `DASHBOARD_CONTRACT.md` §4.3 + §6.

#### 4a. Flip the completed task

Find the task by its unique `id` in the active phase's `tasks[]` and flip its
`done`:

```
Before:  { id: "2.3", group: "Implementation", text: "...", detail: "...", done: false }
After:   { id: "2.3", group: "Implementation", text: "...", detail: "...", done: true }
```

Use the `Edit` tool anchored on `"id": "2.3"` so the replacement is unique. If
the user finished several tasks, repeat per `id`.

#### 4b. Propagate Definition of Done (agent judgment — be conservative)

For each `window.PROJECT.dod` item the completed work *materially advances*, flip
its `done: false → true`. This is a judgment call, not a deterministic mapping —
only flip a DoD item when the work clearly satisfies it. When unsure, leave it
`false` (the user can flip it themselves). Never flip a DoD item on speculation.

#### 4c. Complete the phase when all its tasks are done

After 4a, check the active phase's `tasks[]`. If EVERY task now has `done: true`,
advance the phase:

```
Before:  status: "specced"
After:   status: "complete"
```

Then confirm to the junior:
```
🎉 Phase [n] — [name] complete! All [N] tasks done.
```

(There is no folder to archive in v2.5 — the phase simply becomes `complete` and
the dashboard renders it as done.)

#### 4d. Validate (mandatory)

```bash
node --check ownyourcode/dashboard/dashboard-data.js && echo "VALID" || echo "INVALID"
```

If `INVALID`, fix the syntax and re-run until valid — never leave a broken data
file. Then tell the user to **refresh the dashboard** to see the updated ring,
kanban, and Definition-of-Done tracker.

---

### Phase 5: Interview Story (STAR Method)

**⚠️ Profile Check:** Read `.claude/ownyourcode-manifest.json` → `profile.settings.career_focus`
- If `"tips-only"` or `"none"` → **SKIP THIS PHASE**
- If `"full-extraction"` or not set → Continue below

*Reference: `.claude/skills/career/star-stories/SKILL.md`*

**Explain STAR first:**

> "Let's extract an interview story from this work using the STAR method:
>
> **S - Situation:** What was the context? What problem existed?
> **T - Task:** What were YOU specifically responsible for?
> **A - Action:** What did YOU do? (Be specific about YOUR work)
> **R - Result:** What was the outcome? (Quantify if possible)
>
> When interviewers ask 'Tell me about a time you...', this is what they want."

Guide them through:

> "Walk me through your STAR story for this work:
>
> What was the **Situation**? What problem or challenge existed?"

[Wait for response]

> "What was your **Task**? What were you specifically responsible for?"

[Wait for response]

> "What **Action** did you take? Be specific about what YOU did."

[Wait for response]

> "What was the **Result**? What outcome did your work produce?"

Save the story to `ownyourcode/career/stories/[date]-[feature].md`

---

### Phase 6: Resume Bullet

**⚠️ Profile Check:** Read `.claude/ownyourcode-manifest.json` → `profile.settings.career_focus`
- If `"tips-only"` or `"none"` → **SKIP THIS PHASE**
- If `"full-extraction"` or not set → Continue below

*Reference: `.claude/skills/career/resume-bullets/SKILL.md`*

Draft a resume bullet point:

> "Let's create a resume bullet point. The format is:
>
> **Action Verb + What You Did + Impact**
>
> Examples:
> - Bad: 'Built a login form'
> - Good: 'Engineered JWT authentication with refresh rotation, reducing session vulnerability surface'
>
> - Bad: 'Fixed bugs in the app'
> - Good: 'Identified and resolved race condition in form submission, preventing duplicate API calls'"

Ask:

```
Question: "What's the most impressive aspect of what you just built?"

Options:
1. The technical complexity
   Description: Solved a hard problem

2. The problem I solved
   Description: Fixed something important

3. The user impact
   Description: Made things better for users

4. The performance gain
   Description: Made things faster/more efficient
```

Help them craft a compelling bullet based on their choice.

---

### Phase 7: Commit Pitch Check

If they haven't committed yet:

> "Great work! Before we wrap up, let's commit this properly.
>
> Remember: Every commit is a pitch to a recruiter.
>
> What would be a good commit message for this work?
> Format: type(scope): description"

Reject vague commits:
```
Rejected:
- "fix bug"
- "wip"
- "update"
- "changes"

Accepted:
- "feat(auth): implement JWT refresh token rotation"
- "fix(form): resolve race condition in submission"
```

---

### Phase 8: Retrospective Prompt

After completing all phases:

> "This was solid work. To lock in what you learned, run `/own:retro` to:
> - Document what worked well
> - Note any challenges you overcame
> - Update your learning registry
>
> Would you like to run that now?"

---

### Phase 9: Summary

**Profile-Aware Summary:**
- Check `profile.settings.career_focus` from manifest
- If `"none"` → Hide CAREER VALUE section entirely
- If `"tips-only"` → Hide CAREER VALUE section
- If `"full-extraction"` or not set → Show full summary below

```
┌─────────────────────────────────────────┐
│           TASK COMPLETED!               │
├─────────────────────────────────────────┤
│ Feature: [Name]                         │
│                                         │
│ GATE RESULTS                            │
│ ─────────────                           │
│ Ownership:    ✅ PASS                   │
│ Security:     ⚠️ 1 warning (addressed)  │
│ Error:        ✅ PASS                   │
│ Performance:  ✅ PASS                   │
│ Fundamentals: 💡 2 suggestions          │
│ Testing:      ✅ PASS                   │
│                                         │
│ CODE REVIEW                             │
│ ─────────────                           │
│ Blockers:    0                          │
│ Warnings:    2 (addressed)              │
│ Suggestions: 3                          │
│                                         │
│ CAREER VALUE  ← (hide if career_focus   │
│ ─────────────    is "none" or "tips")   │
│ Interview Story: ✅ Saved               │
│ Resume Bullet:   ✅ Drafted             │
│                                         │
│ Commit: [Their commit message]          │
└─────────────────────────────────────────┘

Next steps:
- Run /own:retro to document learnings
- Run /own:status to see roadmap progress
- Run /own:feature to start next feature
```

---

## Important Notes

1. **Gates are mandatory** — Don't skip them, especially Ownership and Testing
2. **Be honest in reviews** — Sugar-coating doesn't help them grow
3. **But be encouraging** — They finished something, celebrate that
4. **Don't give fixes** — Ask what they would change instead
5. **STAR is powerful** — Help them tell their story well
6. **Resume bullets matter** — These can make or break a job search
7. **Prompt /own:retro** — Learning flywheel captures growth
