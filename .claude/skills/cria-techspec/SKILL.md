---
name: cria-techspec
description: Generates a Technical Specification from an existing PRD. Use when a PRD is ready and the next step is to define architecture, APIs, data models, and implementation strategy. Don't use for requirements gathering, task breakdown, or implementation.
---

# Criação de Tech Spec

## Step 0: Verify Dependencies

1. Identify the target feature folder (`tasks/prd-[feature]/`).
2. Verify that `tasks/prd-[feature]/prd.md` exists.
3. If the PRD is missing, warn the user:
   "[AVISO] PRD não encontrado em tasks/prd-[feature]/prd.md. A Tech Spec pode ficar incompleta sem o PRD como base."
4. Ask the user: "Deseja continuar sem o PRD?" (use the ask user question tool).
5. If the user chooses to abort, suggest: "Execute `cria-prd` primeiro para criar o PRD."
6. If the user chooses to continue, proceed to Step 1 noting that output quality may be reduced.

## Step 1: Gather Context

1. Read the PRD fully (`tasks/prd-[feature]/prd.md`).
2. Read `CLAUDE.md` to understand the project stack, conventions, and structure.
3. Explore the current codebase to understand existing architecture, patterns, and integration points.
4. Use web search (at least 3 searches) to research relevant technical patterns, API documentation, and best practices.

## Step 2: Clarification Questions

1. Based on the PRD and codebase analysis, identify technical ambiguities.
2. Ask the user clarification questions using the ask user question tool. Focus on:
   - Architectural preferences (monolith vs microservices, specific patterns)
   - Database and storage choices
   - External service integrations
   - Performance and scalability requirements
   - Testing strategy preferences
3. Do NOT proceed to Tech Spec generation without clarification answers.

## Step 3: Generate Tech Spec

1. Read the Tech Spec template at `assets/techspec-template.md`.
2. Generate the Tech Spec following the template structure:
   - **Resumo Executivo**: Solution overview in 1-2 paragraphs
   - **Arquitetura do Sistema**: Components, relationships, data flow
   - **Design de Implementação**: Interfaces, data models, API endpoints
   - **Pontos de Integração**: External services and auth requirements
   - **Abordagem de Testes**: Unit, integration, E2E strategy
   - **Sequenciamento de Desenvolvimento**: Build order and dependencies
   - **Considerações Técnicas**: Key decisions, trade-offs, risks
   - **Arquivos relevantes e dependentes**: List files that will be created or modified
3. List applicable skills from `.claude/skills/` in the "Conformidade com Skills Padrões" section.

## Step 4: Output

1. Write the Tech Spec to `tasks/prd-[feature]/techspec.md`.
2. Confirm completion and suggest: "Execute `criar-tasks` para quebrar a implementação em tarefas."

## Error Handling

- If the PRD has gaps that prevent technical decisions, list them and ask the user to update the PRD first.
- If multiple architectural approaches are viable, present trade-offs and ask the user to choose before proceeding.
