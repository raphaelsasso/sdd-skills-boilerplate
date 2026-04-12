---
name: executar-qa
description: Performs Quality Assurance on implemented features including E2E testing, accessibility checks, and requirements verification. Use after implementation and code review are done. Don't use for code review, implementation, or bug fixing.
---

# Quality Assurance

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`).
2. Verify the following files exist:
   - `tasks/prd-[feature]/prd.md`
   - `tasks/prd-[feature]/techspec.md`
   - `tasks/prd-[feature]/tasks.md`
3. For each missing file, warn the user:
   "[AVISO] Arquivo não encontrado: <path>. O QA precisa desses artefatos para validar os requisitos."
4. Ask the user: "Deseja continuar o QA sem este artefato?" (use the ask user question tool).
5. If the user chooses to abort, suggest which command to run first.

## Step 1: Requirements Checklist

1. Read the PRD and extract every functional requirement.
2. Create a checklist of all requirements to verify.
3. Read the Tech Spec for API contracts and expected behavior.

## Step 2: Execute Tests

1. Run all existing unit tests and verify they pass.
2. Run E2E tests if available.
3. Manually verify critical user flows described in the PRD:
   - Happy path scenarios
   - Error states and edge cases
   - Empty states
   - Loading states

## Step 3: Accessibility Check

1. Verify WCAG 2.2 compliance:
   - Keyboard navigation
   - Screen reader compatibility
   - Color contrast
   - Focus management
2. Document any accessibility issues found.

## Step 4: Document Results

1. For each requirement in the checklist, mark as PASS or FAIL.
2. For each bug found, document:
   - Description of the issue
   - Steps to reproduce
   - Expected vs actual behavior
   - Severity (critical / major / minor)
   - Screenshots or evidence when possible
3. Write the QA report to `tasks/prd-[feature]/qa-report.md`.
4. If bugs were found, write them to `tasks/prd-[feature]/bugs.md`.
5. If bugs exist, suggest: "Execute `executar-bugfix` para corrigir os bugs encontrados."

## Error Handling

- If the application cannot be started, document the startup failure as a critical bug.
- If E2E tests are not configured, note this in the report and perform manual verification instead.
