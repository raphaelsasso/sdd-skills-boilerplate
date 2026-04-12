---
name: executar-task
description: Implements a single task from the task list, including code, tests, and checks. Use when tasks have been created and the next step is writing code. Don't use for creating PRDs, specs, task lists, or code review.
---

# Execução de Task

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`) and the task number.
2. Verify the following files exist:
   - `tasks/prd-[feature]/prd.md`
   - `tasks/prd-[feature]/techspec.md`
   - `tasks/prd-[feature]/tasks.md`
   - `tasks/prd-[feature]/N_task.md` (the specific task file)
3. For each missing file, warn the user:
   "[AVISO] Arquivo não encontrado: <path>."
   - PRD: "Sem o PRD, os requisitos de negócio podem não ser atendidos."
   - TechSpec: "Sem a TechSpec, a arquitetura e interfaces podem ficar inconsistentes."
   - tasks.md: "Sem o índice de tasks, o progresso não pode ser rastreado."
   - N_task.md: "O arquivo da task não existe. Verifique o número da task."
4. Ask the user: "Deseja continuar sem este artefato?" (use the ask user question tool).
5. If the task file itself is missing, strongly recommend aborting.

## Step 1: Analyze Task

1. Read the specific task file (`N_task.md`) fully.
2. Read the PRD and Tech Spec to understand the broader context.
3. Read `CLAUDE.md` to understand project conventions, stack, and commands.
4. Identify required technology skills from the task's skills section and the project stack.

## Step 2: Plan Implementation

1. Analyze the subtasks listed in the task file.
2. Identify files to create or modify.
3. Plan the implementation order (dependencies first).
4. Identify test scenarios from the task's testing section.

## Step 3: Implement

1. Implement each subtask in order.
2. Follow the project conventions defined in `CLAUDE.md`.
3. Write tests alongside the implementation (unit, integration, E2E as specified in the task).
4. Do NOT apply workarounds — resolve root causes.

## Step 4: Verify

1. Run all project checks as defined in `CLAUDE.md`:
   - Lint
   - Type check
   - Build
   - Tests (unit + integration)
2. Fix any failures before proceeding.
3. Verify all success criteria from the task file are met.

## Step 5: Complete

1. Mark the task as complete in `tasks/prd-[feature]/tasks.md` (change `[ ]` to `[x]`).
2. Trigger the `task-review` skill to review the completed task.

## Error Handling

- If a subtask requires a dependency that doesn't exist yet, check if it belongs to a prior task and warn the user.
- If tests fail after implementation, debug and fix before marking complete.
- If the task scope exceeds what's described, implement only what's specified and note deviations.
