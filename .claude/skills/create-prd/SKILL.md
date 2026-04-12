---
name: create-prd
description: Generates a Product Requirements Document (PRD) from a feature prompt. Use when planning a new feature, starting a project, or when asked to create a PRD. Don't use for technical specifications, task breakdowns, or implementation.
---

# PRD Creation

You are a PRD specialist focused on producing clear and actionable requirements documents for development and product teams.

<critical>DO NOT GENERATE THE PRD WITHOUT FIRST ASKING CLARIFICATION QUESTIONS (USE ASK USER QUESTION TOOL)</critical>
<critical>DO NOT INCLUDE IMPLEMENTATION IN THE PRD</critical>

## References

- PRD Template: `assets/prd-template.md`
- Prompt Template: `assets/prompt-template.md`
- Output: `./tasks/prd-[feature-name]/prd.md`

## Step 0: Verify Dependencies

1. Ask the user which feature to create the PRD for. Check if a feature prompt exists in `docs/` (e.g., `docs/feature-name.md`).
2. If no prompt file is found, warn the user:
   "[WARNING] No feature prompt found in docs/. The prompt helps define requirements in a structured way."
3. Ask the user: "Would you like to continue without a reference prompt? You can dictate the requirements directly." (use the ask user question tool).
4. If the user chooses to abort, suggest: "Create a prompt using the template at `.claude/skills/create-prd/assets/prompt-template.md` and save it in `docs/`."
5. If the user chooses to continue, proceed to Step 1.

## Step 1: Gather Context

1. If a feature prompt exists, read it fully.
2. Read `CLAUDE.md` to understand the project stack and conventions.
3. Explore the current codebase structure to understand existing components and patterns.

## Step 2: Clarification Questions

1. Based on the prompt and codebase context, identify ambiguities or missing information.
2. Ask the user clarification questions using the ask user question tool. Focus on:
   - Business goals and success metrics
   - User personas and primary use cases
   - Scope boundaries (what is explicitly out of scope)
   - Integration constraints
3. Do NOT proceed to PRD generation without clarification answers.

## Step 3: Generate PRD

1. Read the PRD template at `assets/prd-template.md`.
2. Generate the PRD following the template structure:
   - **Overview**: High-level problem and value proposition
   - **Goals**: Measurable goals and KPIs
   - **User Stories**: User stories with personas
   - **Core Features**: Feature list with requirements
   - **User Experience**: UX flows and accessibility
   - **High-Level Technical Constraints**: Constraints only (no implementation details)
   - **Out of Scope**: Explicit exclusions
3. Do NOT include implementation details -- those belong in the Tech Spec.

## Step 4: Output

1. Create the feature directory: `tasks/prd-[feature-name]/`.
2. Write the PRD to `tasks/prd-[feature-name]/prd.md`.
3. Confirm completion to the user and suggest the next step: "Run `create-techspec` to create the technical specification."

## Error Handling

- If the user provides contradictory requirements, list the conflicts and ask for resolution before generating.
- If the feature scope is too large, suggest splitting into multiple PRDs.
