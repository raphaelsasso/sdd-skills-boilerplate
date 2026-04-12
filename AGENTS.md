# CLAUDE.md

Guide for AI agents when working with this repository's code.

This project follows the **SDD (Spec-Driven Development)** workflow.

---

## Project Setup

### Step 1: Choose Your Stack

Before starting development, fill in the table below with the technologies chosen for the project. This table is the primary reference for AI agents to know which stack to use.

### Stack and recommended skills

| Area              | Technology | Suggested skill |
| ----------------- | ---------- | --------------- |
| Frontend          |            |                 |
| UI / Design       |            |                 |
| Backend           |            |                 |
| Database          |            |                 |
| Testing           |            |                 |
| Package Manager   |            |                 |
| Design / UX       |            |                 |
| PRD               | —          | `create-prd`      |
| Tech Spec         | —          | `create-techspec` |
| Tasks             | —          | `create-tasks`   |
| Implementation    | —          | `run-task`  |
| Code Review       | —          | `run-review`, `task-review` |
| QA                | —          | `run-qa`   |
| Bugfix            | —          | `run-bugfix` |

### Step 2: Define the project structure

After choosing the stack, create the folder structure and configuration files for your project. Then document the structure in the "Project structure" section below.

---

### Priorities

- **Always check skills** before implementing — tasks without relevant skills may be invalidated
- **Run checks** before completing: lint, typecheck, build, test (according to the chosen stack)
- **Do not use workarounds** — prefer root-cause fixes
- **Use the package manager defined in the stack** to add dependencies (never manually edit dependency files without verifying the version)

### Project commands

<!-- Fill in your project commands after scaffolding -->

```bash
# Example:
# dev           — Start development environment
# build         — Production build
# typecheck     — Type checking
# lint          — Linting
# test          — Unit tests
# test:e2e      — E2E tests
```

### Project structure

<!-- Fill in your project structure after scaffolding -->

```
/
├── ...
```

### Code rules

1. **Functional components** — no class components
2. **Typed props** — type directly in the function
3. **Handle states** — loading, error, and empty
4. **kebab-case** for file names (e.g., `my-component.tsx`)
5. **Composition** — prefer composition over many boolean props

### Testing

<!-- Fill in your project's testing strategy -->

- **Unit tests**: [framework and configuration]
- **E2E**: [framework and configuration]

### Git

- **Do not run** `git restore`, `git reset`, `git clean` or destructive commands **without explicit user permission**

### Anti-patterns

1. Skipping skill activation
2. Activating only one skill when code touches multiple domains
3. Forgetting to verify before marking a task as complete
4. Running destructive git commands without user permission
5. Avoid using workarounds
