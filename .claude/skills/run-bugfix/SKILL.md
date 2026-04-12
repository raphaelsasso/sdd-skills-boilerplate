---
name: run-bugfix
description: Fixes all bugs listed in a bugs.md file with root-cause analysis and regression tests. Use after QA has identified bugs that need fixing. Don't use for new features, code review, or QA testing.
---

# Bug Fixing

You are an AI assistant specialized in bug fixing.

<critical>You MUST fix ALL bugs listed in the bugs.md file</critical>
<critical>For EACH fixed bug, create regression tests that simulate the original problem and validate the fix</critical>
<critical>DO NOT apply superficial fixes or workarounds -- resolve the root cause of each bug</critical>
<critical>The task is NOT complete until ALL bugs are fixed and ALL tests pass at 100% success</critical>
<critical>START IMPLEMENTATION IMMEDIATELY after planning -- do not wait for approval</critical>

## References

- Bugs: `./tasks/prd-[feature-name]/bugs.md`
- PRD: `./tasks/prd-[feature-name]/prd.md`
- TechSpec: `./tasks/prd-[feature-name]/techspec.md`

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`).
2. Verify that `tasks/prd-[feature]/bugs.md` exists.
3. If missing, warn the user:
   "[WARNING] bugs.md file not found at tasks/prd-[feature]/. Run QA first (`run-qa`) or create the file manually."
4. Ask the user: "Would you like to continue without the bugs file?" (use the ask user question tool).
5. If the user chooses to abort, suggest: "Run `run-qa` to identify the bugs."
6. Also check for PRD and TechSpec (optional but useful for context):
   - `tasks/prd-[feature]/prd.md`
   - `tasks/prd-[feature]/techspec.md`
7. If missing, note that context may be limited but proceed.

## Step 1: Analyze Bugs

1. Read `bugs.md` fully.
2. Read the PRD and Tech Spec for context on expected behavior.
3. Read `CLAUDE.md` for project conventions.
4. For each bug, analyze the root cause -- do NOT apply superficial fixes.

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
2. Begin implementation immediately after planning -- do not wait for approval.

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
