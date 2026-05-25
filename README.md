# SDD Boilerplate

Boilerplate for **Spec-Driven Development**. Stack-agnostic -- works with any framework, language, or runtime.

## What is SDD?

SDD is a workflow where every feature goes through structured stages before implementation:

```
Prompt -> PRD -> Tech Spec -> Tasks -> Implementation -> Review -> QA
```

Each stage produces a documented artifact in the `tasks/` folder, ensuring traceability and quality.

Each stage includes **safeguards**: if prior artifacts don't exist, the agent warns you and asks whether to continue.

## How to use

### 1. Clone the boilerplate

```bash
git clone <repo-url> my-project
cd my-project
```

### 2. Choose your stack

Open `CLAUDE.md` (and `AGENTS.md`) and fill in the **Stack and recommended skills** table with your project's technologies.

### 3. Scaffold your project

Create the folder structure, install dependencies, and configure tooling according to the chosen stack. Then fill in the **Commands** and **Structure** sections in `CLAUDE.md`.

### 4. Write the feature prompt

Copy `.claude/skills/create-prd/assets/prompt-template.md` to `docs/feature-name.md` and fill in the feature requirements.

### 5. Run the SDD workflow

Use the available skills (via Claude Code or Cursor) to generate each artifact:

| Stage           | Skill               | Output                                    |
| --------------- | ------------------- | ----------------------------------------- |
| PRD             | `create-prd`        | `tasks/prd-[feature]/prd.md`              |
| Tech Spec       | `create-techspec`   | `tasks/prd-[feature]/techspec.md`         |
| Tasks           | `create-tasks`      | `tasks/prd-[feature]/tasks.md` + `N_task.md` |
| Implementation  | `run-task`          | Implemented code + tests                  |
| Implementation (all) | `run-all-tasks` | Whole task list implemented in parallel waves |
| Review          | `run-review`        | Code review report                        |
| QA              | `run-qa`            | QA report                                 |
| Bugfix          | `run-bugfix`        | Fixes + regression tests                  |

### 6. Automation with run-tasks.sh

To run all tasks for a feature automatically via Claude CLI:

```bash
./run-tasks.sh tasks/prd-feature-name
```

Available options:

```bash
./run-tasks.sh tasks/prd-feature --no-skip-completed    # Re-run already completed tasks
./run-tasks.sh tasks/prd-feature --max-turns 80          # Increase turn limit
./run-tasks.sh tasks/prd-feature --no-stop-on-error      # Continue even on failures
```

## Boilerplate structure

```
/
├── CLAUDE.md                  # Agent guide (fill in your stack here)
├── AGENTS.md                  # Synced copy of CLAUDE.md
├── README.md                  # This file
├── run-tasks.sh               # Automated task runner (Claude CLI)
├── docs/                      # Feature prompts go here
├── tasks/                     # Generated SDD artifacts (PRD, techspec, tasks)
└── .claude/
    ├── agents/
    │   ├── task-reviewer.md   # Task review agent
    │   └── task-runner.md     # Implements a single task via run-task (used by run-all-tasks)
    └── skills/                # Self-contained skills with procedures and templates
        ├── create-prd/
        │   ├── SKILL.md
        │   └── assets/
        │       ├── prd-template.md
        │       └── prompt-template.md
        ├── create-techspec/
        │   ├── SKILL.md
        │   └── assets/
        │       └── techspec-template.md
        ├── create-tasks/
        │   ├── SKILL.md
        │   └── assets/
        │       ├── tasks-template.md
        │       └── task-template.md
        ├── run-task/
        │   └── SKILL.md
        ├── run-all-tasks/
        │   ├── SKILL.md
        │   ├── scripts/plan-waves.py
        │   └── references/troubleshooting.md
        ├── run-review/
        │   └── SKILL.md
        ├── run-qa/
        │   └── SKILL.md
        ├── run-bugfix/
        │   └── SKILL.md
        ├── task-review/
        │   └── SKILL.md
        └── skills-best-practices/
            ├── SKILL.md
            └── assets/, references/, scripts/
```

## Available skills

| Skill                    | Purpose                                              | Included templates             |
| ------------------------ | ---------------------------------------------------- | ------------------------------ |
| `create-prd`               | Generate a PRD from a feature prompt                  | `prd-template.md`, `prompt-template.md` |
| `create-techspec`          | Generate a Tech Spec from a PRD                       | `techspec-template.md`         |
| `create-tasks`            | Break PRD + Tech Spec into implementable tasks        | `tasks-template.md`, `task-template.md` |
| `run-task`          | Implement an individual task                          | —                              |
| `run-all-tasks`     | Orchestrate the whole task list in parallel waves (dispatches the `task-runner` agent) | `plan-waves.py` |
| `run-review`        | Code review against PRD and TechSpec                  | —                              |
| `run-qa`            | QA with E2E, accessibility, and requirements checklist| —                              |
| `run-bugfix`        | Fix bugs with root-cause analysis                     | —                              |
| `task-review`            | Review a completed task (used by task-reviewer agent) | —                              |
| `skills-best-practices`  | Guide for creating new skills (agentskills.io)        | `SKILL.template.md`            |

## License

Free to use :)
