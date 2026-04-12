---
name: executar-bugfix
description: Fixes all bugs listed in a bugs.md file with root-cause analysis and regression tests. Use after QA has identified bugs that need fixing. Don't use for new features, code review, or QA testing.
---

# Correção de Bugs

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`).
2. Verify that `tasks/prd-[feature]/bugs.md` exists.
3. If missing, warn the user:
   "[AVISO] Arquivo bugs.md não encontrado em tasks/prd-[feature]/. Execute o QA primeiro (`executar-qa`) ou crie o arquivo manualmente."
4. Ask the user: "Deseja continuar sem o arquivo de bugs?" (use the ask user question tool).
5. If the user chooses to abort, suggest: "Execute `executar-qa` para identificar os bugs."
6. Also check for PRD and TechSpec (optional but useful for context):
   - `tasks/prd-[feature]/prd.md`
   - `tasks/prd-[feature]/techspec.md`
7. If missing, note that context may be limited but proceed.

## Step 1: Analyze Bugs

1. Read `bugs.md` fully.
2. Read the PRD and Tech Spec for context on expected behavior.
3. Read `CLAUDE.md` for project conventions.
4. For each bug, analyze the root cause — do NOT apply superficial fixes.

## Step 2: Plan Fixes

1. Order bugs by dependency (if fixing one bug impacts another).
2. For each bug, identify:
   - Root cause
   - Files to modify
   - Regression test strategy

## Step 3: Implement Fixes

1. For EACH bug:
   a. Fix the root cause (no workarounds).
   b. Create a regression test that reproduces the original problem and validates the fix.
2. Begin implementation immediately after planning — do not wait for approval.

## Step 4: Verify

1. Run all project checks (lint, typecheck, build, test).
2. Verify ALL regression tests pass.
3. Verify ALL previously passing tests still pass.
4. Update `bugs.md` marking each bug as fixed.

## Step 5: Complete

1. The task is NOT complete until ALL bugs are fixed and ALL tests pass at 100%.
2. Report the results to the user.

## Error Handling

- If a bug cannot be reproduced, document the reproduction attempt and ask the user for more details.
- If fixing one bug introduces a new one, fix both before marking complete.
- If a bug requires architectural changes beyond the scope, document it and ask the user for guidance.
