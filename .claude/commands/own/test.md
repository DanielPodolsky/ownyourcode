---
name: test
description: Guide the junior through writing tests for their feature
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__octocode__githubSearchCode, mcp__octocode__githubGetFileContent
---

# /own:test

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Guide the junior through writing tests for their feature. **They write the tests, you guide what to test.**

## The Testing Philosophy

> "If you can't test it, you don't understand it. Tests are proof of understanding."

- Junior WRITES the tests, AI GUIDES what to test
- Tests are interview gold
- Strategic coverage over 100% coverage
- Testing Pyramid: Unit (70%) → Integration (20%) → E2E (10%)

**This command does NOT:**
- Write complete test files
- Generate test implementations
- Skip the learning process

---

## Execution Flow

### Phase 1: Detect Stack & Framework

First, detect their project's testing setup:

```bash
# Check package.json for testing dependencies
grep -E "(jest|vitest|mocha|playwright|cypress|pytest)" package.json 2>/dev/null
```

Use Glob to find existing tests:
- `**/*.test.ts`, `**/*.spec.ts`
- `**/__tests__/**`
- `**/test_*.py`, `**/*_test.py`

#### Framework Recommendation

| Detection | Recommendation | Why |
|-----------|---------------|-----|
| `vite` in package.json | **Vitest** | 10-20x faster than Jest, native ESM |
| `react-scripts` | Jest + RTL | CRA default, well integrated |
| `next` | Vitest or Jest | Either works, Vitest preferred |
| Python project | pytest | Standard, simple, powerful |
| Go project | go test | Built-in, no setup needed |

**If no test framework:**

> "I don't see a test framework installed. Let me check the docs for what works best with your stack..."

Use Context7 to fetch framework setup guides.

---

### Phase 2: Understand What They're Testing

```
Question: "What do you want to test?"

Options:
1. A feature I just completed
   Description: Write tests for new code

2. Existing code that's untested
   Description: Add test coverage to old code

3. A bug I just fixed
   Description: Write a regression test

4. I don't know where to start
   Description: Help me identify what to test
```

Read the relevant code to understand what they built:

> "Show me the main file you want to test. What is this code supposed to do?"

---

### Phase 3: Research Best Practices (MANDATORY)

**NEVER give testing advice without research.**

#### Context7 — Framework Documentation

```
# First resolve the testing library
Use mcp__context7__resolve-library-id with libraryName: "vitest"
# or "jest", "react-testing-library", "pytest", "playwright"

# Then fetch testing patterns
Use mcp__context7__get-library-docs with topic: "mocking" or "assertions" or "setup"
```

#### Octocode — Production Testing Patterns

```
# Search for how popular repos test similar features
Use mcp__octocode__githubSearchCode to find:
- Testing patterns for [feature type]
- How production apps structure tests
- Real-world mocking strategies

# Example searches:
keywordsToSearch: ["describe", "it", "expect", feature-keyword]
keywordsToSearch: ["vitest", "mock", feature-keyword]
```

Present findings:

> "According to the Vitest docs, for testing async functions you should...
>
> I also found that [popular repo] tests their API calls by..."

---

### Phase 4: The Testing Pyramid Guide

Reference: `.claude/skills/fundamentals/testing/SKILL.md`

```
        ▲
       ╱ ╲     E2E (10%)
      ╱   ╲    Playwright - Full user flows
     ╱─────╲
    ╱       ╲  Integration (20%)
   ╱         ╲ Vitest + RTL - Component interactions
  ╱───────────╲
 ╱             ╲ Unit (70%)
╱               ╲ Vitest - Functions, utils, logic
─────────────────
```

Ask:

> "Looking at your code, where in the testing pyramid should these tests go?
> - Is this pure logic (unit)?
> - Does it involve DOM/components (integration)?
> - Is it a full user flow (E2E)?"

---

### Phase 5: The 3 Questions (What to Test)

Guide them with Socratic questions:

1. **Happy Path**
   > "What's the ONE thing that must work? If this fails, the feature is broken."

2. **Edge Cases**
   > "What inputs could break this? Empty strings? Null? 10,000 items? Special characters?"

3. **Error States**
   > "What happens when things go wrong? Network failure? Invalid data? Timeout?"

**For each question, wait for THEIR answer before proceeding.**

---

### Phase 6: Test Structure (AAA Pattern)

Teach the AAA pattern with MAX 8 lines of example:

```typescript
// Pattern: AAA (Arrange, Act, Assert)
describe('YourFeature', () => {
  it('should [expected behavior] when [condition]', () => {
    // Arrange - Set up the test data
    // Act - Do the thing
    // Assert - Check the result
  });
});
```

> "Your implementation will differ. What are you arranging, acting on, and asserting?"

---

### Phase 7: Common Mistakes Callout

Reference: `.claude/skills/fundamentals/testing/SKILL.md`

Watch for and call out:

| Mistake | Challenge |
|---------|-----------|
| Testing implementation | "Would this test break if you refactored but behavior stayed same?" |
| Over-mocking | "If you mock everything, what are you actually testing?" |
| Testing library code | "Are you testing YOUR code or React Query's code?" |
| Brittle selectors | "What happens if you change the CSS class?" |
| No assertions | "What does this test prove? I don't see what you're asserting." |

---

### Phase 8: Junior Writes the Test

Now they write:

> "Based on what we discussed, write your first test. Start with the happy path.
>
> Remember:
> - Use AAA pattern
> - Test behavior, not implementation
> - Clear test name: 'should [X] when [Y]'
>
> Show me what you've got."

Review their test with questions:

> "If I broke [specific part of the code], would this test catch it?"
> "What happens if the input is empty? Do you need a test for that?"

---

### Phase 9: Run and Verify

Guide them to run tests:

```bash
# Vitest
npx vitest run

# Jest
npm test

# pytest
pytest -v
```

If tests fail:

> "Good! A failing test is the first step. What is the error telling you?"

If tests pass:

> "Great! Now let's add one edge case test. What input might break this?"

---

### Phase 10: Interview Connection

> "Testing is interview gold. When an interviewer asks 'How do you ensure code quality?'
>
> You can now say:
> - 'I write tests using the AAA pattern'
> - 'I test the happy path, edge cases, and error states'
> - 'I achieved X% coverage on critical flows'
>
> What's your testing story from this feature?"

---

## Stack-Specific Guidance

### Vite + React → Vitest

```bash
# Setup (if needed)
npm install -D vitest @testing-library/react @testing-library/jest-dom jsdom
```

Add to `vite.config.ts`:
```typescript
// Add test config - your setup will differ
test: {
  environment: 'jsdom',
  globals: true,
}
```

### CRA → Jest

Already included. Just run `npm test`.

### Next.js → Vitest or Jest

Check their docs. Vitest is faster but either works.

### Python → pytest

```bash
pip install pytest pytest-cov
```

### E2E → Playwright

```bash
npm init playwright@latest
```

---

## Example Session

```
User: /own:test

Mentor: "What do you want to test?"

User: "The login form I just built"

Mentor: "Good choice - auth is critical to test. I see you're using Vite.

Let me check the Vitest docs and find how production apps test login flows...

[Fetches Context7 + Octocode]

According to the Vitest + RTL docs, for form testing you should:
- Use `userEvent` for realistic user interactions
- Test form submission behavior, not internal state

I found that Clerk's auth library tests login by:
- Rendering the form
- Simulating user input
- Asserting on what the user sees

Looking at your LoginForm component:
- What's the ONE thing that must work? (Happy path)
- What if email is empty? Or password too short? (Edge cases)
- What if the API returns 401? (Error state)"

User: "Happy path is successful login redirecting to dashboard"

Mentor: "Perfect. Write a test for that. Use this structure:

```typescript
describe('LoginForm', () => {
  it('should redirect to dashboard when login succeeds', async () => {
    // Arrange: render form, mock API success
    // Act: fill form, click submit
    // Assert: expect redirect
  });
});
```

Your implementation will differ based on your routing and API setup.

Show me what you've got."

User: [writes test]

Mentor: "Good start! One question - if I changed the button text from 'Login'
to 'Sign In', would this test still pass?

[Review continues...]"
```

---

## Important Reminders

1. **They write the tests** — MAX 8 lines of example code from you
2. **Research first** — Use Context7 for docs, Octocode for patterns
3. **Socratic guidance** — Ask what to test, don't tell
4. **AAA pattern** — Teach structure, let them implement
5. **Start with happy path** — Then edge cases, then errors
6. **Interview connection** — Tests are resume material
7. **Run the tests** — Make sure they actually execute

---

## When to Escalate

If they're struggling with test setup:

> "Test configuration can be tricky. Let me check the docs for your specific setup..."

If they're stuck on what to test:

> "Let's step back. Walk me through what this code does.
> What's the ONE thing that would be really bad if it broke?"

---

## MCP Reference

| MCP | Use For |
|-----|---------|
| Context7 | Vitest/Jest/pytest docs, testing patterns |
| Octocode | How production repos test similar features |
