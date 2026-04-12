---
name: task-review
description: Reviews a completed task for code quality, spec adherence, and test coverage. Use after a task has been implemented via run-task. Don't use for full code review, QA, or implementation.
---

# Task Review

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`) and the task number.
2. Verify the following files exist:
   - `tasks/prd-[feature]/N_task.md` (the completed task)
   - `tasks/prd-[feature]/techspec.md`
3. For each missing file, warn the user:
   "[WARNING] File not found: <path>."
   - Task file: "The task file is needed to validate what was implemented."
   - TechSpec: "Without the TechSpec, the review cannot verify architectural compliance."
4. Ask the user: "Would you like to continue the review without this artifact?" (use the ask user question tool).
5. If the task file itself is missing, recommend aborting.

## Step 1: Analyze Changes

1. Read the completed task file to understand what was implemented.
2. Read the Tech Spec for architectural context.
3. Use `git diff` or `git log` to identify the code changes made for this task.

## Step 2: Review

1. Verify task requirements are met:
   - All subtasks marked as complete
   - Success criteria from the task file are satisfied
2. Check code quality:
   - Follows project conventions (`CLAUDE.md`)
   - No workarounds or hacks
   - Proper error handling and types
3. Verify tests:
   - Tests exist for the implemented functionality
   - Tests cover the scenarios defined in the task
   - All tests pass

## Step 3: Produce Review Artifact

1. Generate a review report covering:
   - **Summary**: Pass / Needs Changes
   - **Compliance**: Task requirements met?
   - **Code Quality**: Issues or suggestions
   - **Tests**: Coverage and quality
   - **Required Actions**: Required fixes (if any)
2. Write the report to `tasks/prd-[feature]/N_task_review.md`.

## Error Handling

- If the task is not marked as complete in `tasks.md`, warn the user before reviewing.
- If tests are failing, list the failures and mark the review as "needs changes."
