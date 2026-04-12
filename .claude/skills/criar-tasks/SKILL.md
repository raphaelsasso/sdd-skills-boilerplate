---
name: criar-tasks
description: Breaks down a PRD and Tech Spec into an ordered list of implementable tasks. Use when PRD and Tech Spec are ready and the next step is planning the implementation sequence. Don't use for creating PRDs, writing specs, or implementing code.
---

# Criação de Tasks

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`).
2. Verify the following files exist:
   - `tasks/prd-[feature]/prd.md`
   - `tasks/prd-[feature]/techspec.md`
3. For each missing file, warn the user:
   "[AVISO] Arquivo não encontrado: <path>. Este artefato é utilizado para <purpose>."
   - PRD: "definir os requisitos de negócio e escopo"
   - TechSpec: "definir a arquitetura, interfaces e sequenciamento"
4. If BOTH files are missing, strongly recommend aborting:
   "[AVISO] Tanto o PRD quanto a TechSpec estão ausentes. As tasks geradas sem esses artefatos terão baixa qualidade. Recomendamos executar `cria-prd` e `cria-techspec` primeiro."
5. Ask the user: "Deseja continuar mesmo assim?" (use the ask user question tool).
6. If the user chooses to abort, suggest which command to run first.

## Step 1: Analyze Inputs

1. Read the PRD and Tech Spec fully.
2. Read `CLAUDE.md` to understand project conventions and stack.
3. Identify the development sequence from the Tech Spec's "Sequenciamento de Desenvolvimento" section.

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
2. Generate `tasks/prd-[feature]/tasks.md` with the task index using the tasks template.
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
2. Suggest: "Execute `executar-task` para implementar a primeira tarefa."

## Error Handling

- If the Tech Spec sequencing is unclear, propose a sequence based on dependency analysis and ask the user to confirm.
- If a task is too large (estimated > 1 day), suggest splitting it into subtasks.
