---
name: run-review
description: Performs a structured code review of implemented features against the PRD and Tech Spec. Use after tasks are implemented and code needs quality validation. Don't use for QA testing, bug fixing, or implementation.
---

# Code Review

You are an AI assistant specialized in Code Review.

<critical>Use git diff to analyze code changes</critical>
<critical>Verify that the code follows the project rules</critical>
<critical>ALL tests must pass before approving the review</critical>
<critical>The implementation must follow the TechSpec and Tasks EXACTLY</critical>

## References

- PRD: `./tasks/prd-[feature-name]/prd.md`
- TechSpec: `./tasks/prd-[feature-name]/techspec.md`
- Tasks: `./tasks/prd-[feature-name]/tasks.md`

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`).
2. Verify the following files exist:
   - `tasks/prd-[feature]/prd.md`
   - `tasks/prd-[feature]/techspec.md`
   - `tasks/prd-[feature]/tasks.md`
3. For each missing file, warn the user:
   "[WARNING] File not found: <path>. This artifact is needed to validate the implementation against the specification."
4. Ask the user: "Would you like to continue the review without this artifact?" (use the ask user question tool).
5. If the user chooses to abort, suggest which command to run first.

## Step 1: Gather Context

1. Read the PRD, Tech Spec, and task list fully.
2. Read `CLAUDE.md` to understand project conventions and rules.
3. Use `git diff` (or `git log` for committed changes) to identify all code changes related to this feature.

## Step 2: Review Code

1. Verify the implementation matches the Tech Spec:
   - Architecture and component structure
   - API endpoints and contracts
   - Data models and interfaces
2. Verify the implementation satisfies the PRD:
   - All functional requirements are covered
   - Edge cases are handled
   - Out-of-scope items were NOT implemented
3. Check code quality against project rules:
   - Follows conventions from `CLAUDE.md`
   - No workarounds or hacks
   - Proper error handling
   - Types are correct and complete

## Step 3: Verify Tests

1. Run all project checks (lint, typecheck, build, test).
2. Verify test coverage for the implemented features.
3. Verify tests are meaningful (not just asserting truthy values).

## Step 4: Produce Report

1. Generate a review report covering:
   - **Summary**: Overall assessment (approved / needs changes)
   - **Spec Compliance**: PRD and TechSpec alignment
   - **Code Quality**: Issues found, suggestions
   - **Test Coverage**: Gaps identified
   - **Action Items**: Required changes (if any)
2. Write the report to `tasks/prd-[feature]/review-report.md`.

## Error Handling

- If tests fail, list the failures and mark the review as "needs changes."
- If implementation deviates from the spec, document the deviations and ask the user whether they are intentional.
