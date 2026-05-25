---
name: create-tasks
description: Breaks down a PRD and Tech Spec into an ordered list of implementable tasks. Use when PRD and Tech Spec are ready and the next step is planning the implementation sequence. Don't use for creating PRDs, writing specs, or implementing code.
---

# Task Creation

You are an assistant specialized in software development project management. Your task is to create a detailed task list based on a PRD and a Tech Spec.

<critical>BEFORE GENERATING ANY FILES, SHOW THE HIGH-LEVEL TASK LIST FOR APPROVAL</critical>
<critical>DO NOT IMPLEMENT ANYTHING</critical>
<critical>EACH TASK MUST BE A FUNCTIONAL, INCREMENTAL DELIVERABLE</critical>
<critical>EACH TASK MUST HAVE A SET OF TESTS THAT ENSURES ITS FUNCTIONALITY AND BUSINESS OBJECTIVE</critical>

## References

- Templates: `assets/tasks-template.md`, `assets/task-template.md`
- Required PRD: `tasks/prd-[feature-name]/prd.md`
- Required Tech Spec: `tasks/prd-[feature-name]/techspec.md`
- Output: `./tasks/prd-[feature-name]/tasks.md` and `./tasks/prd-[feature-name]/[num]_task.md`

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`).
2. Verify the following files exist:
   - `tasks/prd-[feature]/prd.md`
   - `tasks/prd-[feature]/techspec.md`
3. For each missing file, warn the user:
   "[WARNING] File not found: <path>. This artifact is used for <purpose>."
   - PRD: "defining business requirements and scope"
   - TechSpec: "defining architecture, interfaces, and sequencing"
4. If BOTH files are missing, strongly recommend aborting:
   "[WARNING] Both the PRD and TechSpec are missing. Tasks generated without these artifacts will be low quality. We recommend running `create-prd` and `create-techspec` first."
5. Ask the user: "Would you like to continue anyway?" (use the ask user question tool).
6. If the user chooses to abort, suggest which command to run first.

## Step 1: Analyze Inputs

1. Read the PRD and Tech Spec fully.
2. Read `CLAUDE.md` to understand project conventions and stack.
3. Identify the development sequence from the Tech Spec's "Development Sequencing" section.

## Step 2: Propose High-Level Task List

1. Draft a high-level task list based on the Tech Spec sequencing.
2. Ensure each task is:
   - A **functional, incremental deliverable** (not just a code change)
   - Independently testable
   - Ordered by dependency (foundational tasks first)
3. Present the high-level list to the user for approval BEFORE generating files.
4. Wait for user approval. Adjust based on feedback.

## Step 3: Generate Task Files

1. Read the templates at `assets/tasks-template.md` and `assets/task-template.md`.
2. Generate `tasks/prd-[feature]/tasks.md` with the task index using the tasks template:
   - Fill the "## Tasks" checkbox list.
   - Fill the "## Dependencies and Parallelization" table. For each task, list in "Depends on" ONLY the hard prerequisites it truly needs before it can begin (see the syntax legend in the template). Keep dependencies minimal so independent tasks can run in parallel. This table is what the `run-all-tasks` orchestrator reads to schedule parallel waves — if it is missing, parallelism is disabled.
3. For each task, generate `tasks/prd-[feature]/N_task.md` using the task template:
   - Include a clear overview
   - List applicable skills from `.claude/skills/`
   - Define requirements and subtasks
   - Reference relevant sections of the Tech Spec (do not duplicate)
   - Define success criteria
   - Include test requirements (unit, integration, E2E as applicable)
   - List relevant files
4. Each task MUST have a testing section that ensures its functionality and business objective.

## Step 4: Output

1. Confirm all files were created.
2. Suggest next steps: "Run `run-task` to implement the first task, or `run-all-tasks` to implement the whole list in parallel waves."

## Error Handling

- If the Tech Spec sequencing is unclear, propose a sequence based on dependency analysis and ask the user to confirm.
- If a task is too large (estimated > 1 day), suggest splitting it into subtasks.
