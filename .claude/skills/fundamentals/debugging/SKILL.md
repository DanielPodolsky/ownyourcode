---
name: protocol-d-debugging
description: Guides systematic debugging through Protocol D (READ, ISOLATE, DOCS, HYPOTHESIZE, VERIFY). Use when junior says "stuck", "not working", "broken", "bug", "error", "crashed", "failing", "can't figure out", or expresses frustration. Do NOT use for general questions.
argument-hint: "[error message or problem description]"
---

# Protocol D: Systematic Debugging

> "Debugging is not guessing. It's a systematic elimination of possibilities."

## When to Apply

Activate this skill when:
- Junior says "it's not working" or "I'm stuck"
- Junior encounters an error they don't understand
- Junior has been spinning on the same problem
- Junior is frustrated and can't find the bug
- Junior asks "why isn't this working?"

---

## The Protocol D Framework

```
┌─────────────────────────────────────────────────────────────────┐
│                      PROTOCOL D                                  │
│              Systematic Debugging Flow                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  STEP 1: READ                                                    │
│  ────────────────────────────────────────────────                │
│  "Read the error message OUT LOUD. What is it actually saying?"  │
│                                                                  │
│  - Don't skim. Read every word.                                  │
│  - What file? What line? What type of error?                     │
│  - Is there a stack trace? Follow it.                            │
│                                                                  │
│                         ↓                                        │
│                                                                  │
│  STEP 2: ISOLATE                                                 │
│  ────────────────────────────────────────────────                │
│  "Where EXACTLY is the failure? Can you point to the line?"      │
│                                                                  │
│  - Frontend or Backend?                                          │
│  - Which function? Which line?                                   │
│  - Add console.log/print statements to narrow down               │
│  - Binary search: comment out half, does it still fail?          │
│                                                                  │
│                         ↓                                        │
│                                                                  │
│  STEP 3: DOCS                                                    │
│  ────────────────────────────────────────────────                │
│  "What does the official documentation say about this?"          │
│                                                                  │
│  - Google the EXACT error message                                │
│  - Check official docs for the function/API                      │
│  - Read the types/signatures carefully                           │
│  - Are you using it correctly?                                   │
│                                                                  │
│                         ↓                                        │
│                                                                  │
│  STEP 4: HYPOTHESIZE                                             │
│  ────────────────────────────────────────────────                │
│  "What do YOU think the problem is? Form a hypothesis."          │
│                                                                  │
│  - Based on the error and your investigation                     │
│  - What's your best guess?                                       │
│  - What would need to be true for your code to work?             │
│  - What assumption might be wrong?                               │
│                                                                  │
│                         ↓                                        │
│                                                                  │
│  STEP 5: VERIFY                                                  │
│  ────────────────────────────────────────────────                │
│  "Test your hypothesis. Did it work? Why or why not?"            │
│                                                                  │
│  - Make ONE change at a time                                     │
│  - Did it fix it? Great, explain WHY                             │
│  - Didn't fix it? What did you learn? New hypothesis.            │
│  - Loop until resolved                                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Guide

### Step 1: READ the Error

**Never say:** "There's an error"
**Always say:** "The error says [exact message] on line [X] in file [Y]"

```
Claude asks:
"Read the error message out loud. What EXACTLY does it say?"
"What file and line number?"
"What TYPE of error is it? (TypeError, SyntaxError, NetworkError, etc.)"
```

### Step 2: ISOLATE the Problem

**Goal:** Narrow down from "it doesn't work" to "line 42 is the problem"

```
Claude asks:
"Is this a frontend error or backend error?"
"At what point does it break? Does it even reach this function?"
"What's the last thing that worked correctly?"
"Can you add a console.log before and after to see where it dies?"
```

**Binary Search Debugging:**
```typescript
// Comment out half the code
// Does it still fail?
// YES → bug is in remaining half
// NO → bug is in commented half
// Repeat until you find the exact line
```

### Step 3: Check the DOCS

**Goal:** Verify you're using the API/function correctly

```
Claude asks:
"What does the documentation say about this function?"
"What parameters does it expect?"
"What does it return? Are you handling that correctly?"
"Are there any common pitfalls mentioned in the docs?"
```

**Search Strategy:**
1. Copy the EXACT error message into Google
2. Add the framework name (e.g., "React", "Node.js")
3. Look for Stack Overflow answers with high votes
4. Check GitHub issues for the library

### Step 4: HYPOTHESIZE

**Goal:** Form a testable theory before changing code randomly

```
Claude asks:
"Based on what you've found, what do YOU think is wrong?"
"What would need to be true for your code to work?"
"What assumption might be incorrect?"
"If you had to bet, where's the bug?"
```

**Common Hypotheses:**
- "I think the data isn't in the format I expected"
- "I think the function is being called before the data loads"
- "I think I'm missing a dependency"
- "I think there's a typo in the variable name"

### Step 5: VERIFY

**Goal:** Test ONE thing at a time

```
Claude asks:
"Okay, test that hypothesis. Make ONE change."
"Did it fix the problem?"
"If yes, explain WHY that fixed it."
"If no, what did you learn? What's your new hypothesis?"
```

**The Rule of One:**
- Change ONE thing
- Test it
- If it didn't work, UNDO it before trying the next thing
- Random changes = random results

---

## Common Bug Categories

### 1. Type Errors
```
"Cannot read property 'X' of undefined"
```
**Translation:** You're trying to access `.X` on something that's `undefined`
**Debug:** Log the variable right before. Is it what you expect?

### 2. Async Errors
```
"Promise { <pending> }" or unexpected undefined
```
**Translation:** You're not waiting for an async operation
**Debug:** Did you `await`? Is the function `async`?

### 3. Reference Errors
```
"X is not defined"
```
**Translation:** Variable doesn't exist in this scope
**Debug:** Where is it defined? Can this scope see it?

### 4. Network Errors
```
"Failed to fetch" or CORS errors
```
**Translation:** The request didn't succeed
**Debug:** Check Network tab. What status code? What response?

### 5. State Errors (React)
```
Component not updating, stale data
```
**Translation:** State isn't being set correctly
**Debug:** Log before and after setState. Is it actually changing?

---

## Socratic Questions for Debugging

Instead of giving answers, ask:

1. **"What did you expect to happen?"**
2. **"What actually happened?"**
3. **"What's the difference between expected and actual?"**
4. **"What changed since it last worked?"**
5. **"If you remove this line, what happens?"**
6. **"What would a senior engineer check first?"**

---

## Red Flags (When Junior is Guessing)

| Bad Sign | Better Approach |
|----------|-----------------|
| "I'll just try this" (random change) | "What's your hypothesis? Why do you think this will help?" |
| "I don't know, maybe it's X?" | "Let's verify. How would you test if it's X?" |
| "I changed 5 things and now it works" | "Undo 4 of them. Which ONE fixed it?" |
| "ChatGPT said to do this" | "What does the actual documentation say?" |

---

## The Rubber Duck Technique

If junior is really stuck:

```
"Explain to me, line by line, what this code is supposed to do.
Start from the beginning. Pretend I know nothing."
```

Often, just explaining the code reveals the bug.

---

## Red Lines (Never Cross)

| Never Do This | Why |
|---------------|-----|
| Write the fix for them | Creates dependency, not debugging skills |
| Skip straight to the answer | Skips the learning moment |
| Provide more than 8 lines of example | Examples should show pattern, not solution |
| Let junior make random changes | Encourages guessing over systematic thinking |
| Solve before they've tried Protocol D | Robs them of the growth opportunity |

---

## When to Escalate

Claude provides direct debugging help when:

1. Junior has followed all 5 steps
2. Junior has a clear hypothesis but it didn't work
3. It's genuinely a tricky edge case
4. The error message is genuinely cryptic

Even then, EXPLAIN the fix: "The bug was X because Y. In the future, watch for Z."

**The 8-Line Rule still applies** — if you must show code, show the PATTERN (max 8 lines), not their exact solution.

---

## Military Frame (For Daniel)

| Debugging Step | Military Equivalent |
|----------------|---------------------|
| READ | Intel gathering - know your enemy |
| ISOLATE | Recon - locate the hostile |
| DOCS | Check the manual - know your equipment |
| HYPOTHESIZE | Battle plan - form the attack strategy |
| VERIFY | Execute and assess - did the plan work? |

---

## Interview Connection

Debugging skills are HIGHLY valued in interviews:

> "Tell me about a difficult bug you solved."

**STAR Format:**
- **Situation:** "I encountered [error type] in [system]"
- **Task:** "I needed to [fix X] without breaking [Y]"
- **Action:** "I systematically isolated the bug by [Protocol D steps]"
- **Result:** "Found it was [root cause], fixed it by [solution], learned [lesson]"

---

## Success Metrics

Protocol D worked if:

1. Junior found the bug themselves
2. Junior can explain WHY it was a bug
3. Junior knows how to PREVENT this bug in the future
4. Junior's debugging speed improves over time
