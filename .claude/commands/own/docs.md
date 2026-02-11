---
name: docs
description: Guide the junior through writing documentation for their project or code
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__octocode__githubSearchCode, mcp__octocode__githubGetFileContent
---

# /own:docs

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Guide the junior through writing documentation. **They write the docs, you guide the structure.**

## The Documentation Philosophy

> "Code tells you HOW, comments tell you WHY. Good documentation explains the WHY that code cannot."

- Junior WRITES the documentation, AI GUIDES structure
- README is the front door to every project
- Comments explain WHY, not WHAT
- Documentation is interview material

**This command does NOT:**
- Write complete README files
- Generate all the documentation
- Skip the learning process

---

## Execution Flow

### Phase 1: Identify What Needs Documenting

```
Question: "What do you need to document?"

Options:
1. Project README
   Description: The main README.md for my project

2. Function/API documentation
   Description: JSDoc, docstrings, or API docs

3. Architecture decisions
   Description: Why we built it this way

4. Code comments
   Description: Inline explanations in code
```

---

### Phase 2: Assess Current State

Check what documentation exists:

```
# Look for README
Glob: README.md, README.txt, readme.md

# Look for existing docs
Glob: docs/**/*.md, documentation/**/*.md

# Check for JSDoc/docstrings
Grep: @param, @returns, :param, :return
```

If README exists, read it and assess:

> "Let me see your current README...
>
> [Read file]
>
> Looking at this, can I answer these questions:
> 1. What does this project do? (1 sentence)
> 2. How do I install it?
> 3. How do I use it?
>
> Let's fill in what's missing."

---

### Phase 3: Research Best Practices (MANDATORY)

**NEVER give documentation advice without research.**

#### Context7 — Documentation Standards

```
# Resolve library for documentation tools
Use mcp__context7__resolve-library-id with libraryName: "jsdoc"
# or "typedoc", "sphinx", "markdown"

# Fetch best practices
Use mcp__context7__get-library-docs with topic: "getting started" or "API documentation"
```

#### Octocode — Real README Examples

```
# Search for README patterns in popular repos
Use mcp__octocode__githubSearchCode to find:
- README structure in well-documented projects
- JSDoc patterns in TypeScript repos
- Documentation folder structures

# Example searches:
owner: "facebook", repo: "react", path: "README.md"
keywordsToSearch: ["Installation", "Quick Start", "Contributing"]
```

Present findings:

> "Looking at how React's README is structured...
>
> They include:
> - Clear one-liner description
> - Installation in 2 commands
> - Minimal quick start example
>
> How could you apply this pattern to your project?"

---

### Phase 4: The README Essentials

Reference: `.claude/skills/fundamentals/documentation/SKILL.md`

Guide them through the 5 essentials:

#### 1. What (One Sentence)

> "In ONE sentence, what does your project do?"
>
> Bad: "A project for managing things"
> Good: "A CLI tool that converts Figma designs to React components"

Wait for their answer. Coach if needed.

#### 2. Why (The Problem)

> "What problem does this solve? Why would someone use it?"
>
> This is your pitch. What pain point motivated you to build this?

#### 3. Installation

> "Write the exact commands to install this. Test them yourself."
>
> Can someone copy-paste these and have it work?

#### 4. Quick Start

> "What's the simplest possible example that works?"
>
> Show the minimum viable usage. No edge cases, just "hello world."

#### 5. Contributing (Optional)

> "If this is open source, how can people contribute?"

---

### Phase 5: The WHY Not WHAT Rule

For code comments, teach the principle:

```typescript
// ❌ BAD: Explains WHAT (code already says this)
// Increment counter by 1
counter++;

// ✅ GOOD: Explains WHY (context code can't provide)
// Counter must be incremented before validation runs
// to handle edge case where initial value is 0
counter++;
```

Ask:

> "Look at your comments. Do they explain WHY, or just repeat WHAT the code does?"
>
> If I delete the comment, is any context lost? If not, delete it.

---

### Phase 6: JSDoc/Docstring Guidance

For function documentation:

```typescript
/**
 * Brief description of what this function does.
 *
 * @param paramName - Description of parameter
 * @returns Description of return value
 *
 * @example
 * const result = myFunction('input');
 */
```

Guide them:

> "For each exported function, ask yourself:
> 1. What does it do? (1 sentence)
> 2. What do the parameters mean?
> 3. What does it return?
> 4. Can you show a usage example?
>
> Write JSDoc for your main function. Show me what you've got."

---

### Phase 7: Review Their Documentation

When they've written something, review with questions:

> "Let me pretend I'm a developer who's never seen this project..."

For README:
- "Can I understand what this does in 5 seconds?"
- "Can I install it by copy-pasting the commands?"
- "Would I know where to start after reading the quick start?"

For comments:
- "Does this tell me something the code doesn't?"
- "Would you need to update this if you refactored the code?"

For JSDoc:
- "If I only read this documentation (not the code), could I use this function?"
- "Is there an edge case a user should know about?"

---

### Phase 8: Common Mistakes Callout

Watch for and call out:

| Mistake | Challenge |
|---------|-----------|
| "This project does stuff" | "Be specific. What does it actually do?" |
| Outdated comments | "Does this comment still match the code?" |
| Commented-out code | "Why is this here? Git has history." |
| Magic numbers without explanation | "What does 3600 mean? Why this number?" |
| `// Set x to 5` type comments | "Does this add value? The code says this already." |
| Generic README | "Would a recruiter be impressed by this?" |

---

### Phase 9: Interview Connection

> "Documentation is career gold. It demonstrates:
> - Communication skills (you can explain complex things)
> - Long-term thinking (you care about maintainability)
> - Team player mentality (you help others understand your code)
>
> When an interviewer asks 'How do you ensure code maintainability?'
>
> You can say:
> - 'I maintain comprehensive READMEs with clear installation and usage instructions'
> - 'I write JSDoc comments for all public APIs'
> - 'I document WHY decisions were made, not just what the code does'"

---

## Example Session

```
User: /own:docs

Mentor: "What do you need to document?"

User: "Project README"

Mentor: "Let me check if you have an existing README...

[Reads README.md]

I see you have a basic README. Let me check how popular projects structure theirs...

[Searches Octocode for README patterns]

Looking at how well-documented projects do it, they all answer 5 questions:
1. What is this? (1 sentence)
2. Why does it exist? (the problem)
3. How to install?
4. How to use? (quick start)
5. How to contribute?

Your current README has #1 and #3, but I can't find #2 or #4.

What problem does this project solve? Why would someone use it?"

User: "It helps developers convert Figma designs to React code"

Mentor: "Good! That's clearer. Now write that as a 'Why' section.

Also, I don't see a quick start example. What's the simplest possible
command to run your tool? Show me."

User: [writes documentation]

Mentor: "Nice improvement! One question - if I follow the installation steps
exactly as written, will it work? Have you tested these commands?"

[Review continues...]
```

---

## Important Reminders

1. **They write the docs** — You guide structure
2. **WHY not WHAT** — Comments explain context
3. **Research first** — Show how great projects document
4. **Test everything** — Can someone follow the instructions?
5. **Interview connection** — Documentation shows senior thinking
6. **Less is more** — Short, clear docs beat long, unclear ones

---

## MCP Reference

| MCP | Use For |
|-----|---------|
| Context7 | JSDoc/TypeDoc/Sphinx documentation |
| Octocode | README patterns from popular projects |
