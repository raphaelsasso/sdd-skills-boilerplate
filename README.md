# SDD Boilerplate

Boilerplate para desenvolvimento orientado por especificação (**Spec-Driven Development**). Agnóstico de stack -- funciona com qualquer framework, linguagem ou runtime.

## O que é SDD?

SDD é um fluxo de trabalho onde toda feature passa por etapas estruturadas antes da implementação:

```
Prompt -> PRD -> Tech Spec -> Tasks -> Implementação -> Review -> QA
```

Cada etapa produz um artefato documentado na pasta `tasks/`, garantindo rastreabilidade e qualidade.

Cada etapa possui **safeguards**: se os artefatos anteriores não existirem, o agente avisa e pergunta se deseja continuar.

## Como usar

### 1. Clone o boilerplate

```bash
git clone <repo-url> meu-projeto
cd meu-projeto
```

### 2. Escolha sua stack

Abra `CLAUDE.md` (e `AGENTS.md`) e preencha a tabela **Stack e skills recomendadas** com as tecnologias do seu projeto.

### 3. Scaffolde seu projeto

Crie a estrutura de pastas, instale dependências e configure o tooling conforme a stack escolhida. Depois, preencha as seções de **Comandos** e **Estrutura** em `CLAUDE.md`.

### 4. Escreva o prompt da feature

Copie `.claude/skills/cria-prd/assets/prompt-template.md` para `docs/nome-da-feature.md` e preencha com os requisitos da funcionalidade.

### 5. Execute o fluxo SDD

Use os comandos disponíveis (via Claude Code ou Cursor) para gerar cada artefato:

| Etapa           | Comando             | Saída                                     |
| --------------- | ------------------- | ----------------------------------------- |
| PRD             | `cria-prd`          | `tasks/prd-[feature]/prd.md`              |
| Tech Spec       | `cria-techspec`     | `tasks/prd-[feature]/techspec.md`         |
| Tasks           | `criar-tasks`       | `tasks/prd-[feature]/tasks.md` + `N_task.md` |
| Implementação   | `executar-task`     | Código implementado + testes              |
| Review          | `executar-review`   | Relatório de code review                  |
| QA              | `executar-qa`       | Relatório de QA                           |
| Bugfix          | `executar-bugfix`   | Correções + testes de regressão           |

### 6. Automação com run-tasks.sh

Para executar todas as tasks de uma feature automaticamente via Claude CLI:

```bash
./run-tasks.sh tasks/prd-nome-da-feature
```

Opções disponíveis:

```bash
./run-tasks.sh tasks/prd-feature --no-skip-completed    # Re-executa tasks já completas
./run-tasks.sh tasks/prd-feature --max-turns 80          # Aumenta o limite de turnos
./run-tasks.sh tasks/prd-feature --no-stop-on-error      # Continua mesmo com falhas
```

## Estrutura do boilerplate

```
/
├── CLAUDE.md                  # Guia para agentes (preencher stack aqui)
├── AGENTS.md                  # Cópia sincronizada do CLAUDE.md
├── README.md                  # Este arquivo
├── run-tasks.sh               # Runner automatizado de tasks (Claude CLI)
├── docs/                      # Prompts de features vão aqui
├── tasks/                     # Artefatos SDD gerados (PRD, techspec, tasks)
└── .claude/
    ├── agents/
    │   └── task-reviewer.md   # Agente de revisão de tasks
    ├── commands/              # Comandos do fluxo SDD (thin launchers)
    │   ├── cria-prd.md
    │   ├── cria-techspec.md
    │   ├── criar-tasks.md
    │   ├── executar-task.md
    │   ├── executar-review.md
    │   ├── executar-qa.md
    │   └── executar-bugfix.md
    └── skills/                # Skills self-contained com procedimentos e templates
        ├── cria-prd/
        │   ├── SKILL.md
        │   └── assets/
        │       ├── prd-template.md
        │       └── prompt-template.md
        ├── cria-techspec/
        │   ├── SKILL.md
        │   └── assets/
        │       └── techspec-template.md
        ├── criar-tasks/
        │   ├── SKILL.md
        │   └── assets/
        │       ├── tasks-template.md
        │       └── task-template.md
        ├── executar-task/
        │   └── SKILL.md
        ├── executar-review/
        │   └── SKILL.md
        ├── executar-qa/
        │   └── SKILL.md
        ├── executar-bugfix/
        │   └── SKILL.md
        ├── task-review/
        │   └── SKILL.md
        └── skills-best-practices/
            ├── SKILL.md
            └── assets/, references/, scripts/
```

## Skills disponíveis

| Skill                    | Uso                                                  | Templates incluídos            |
| ------------------------ | ---------------------------------------------------- | ------------------------------ |
| `cria-prd`               | Gera PRD a partir de um prompt de feature             | `prd-template.md`, `prompt-template.md` |
| `cria-techspec`          | Gera Tech Spec a partir de um PRD                     | `techspec-template.md`         |
| `criar-tasks`            | Quebra PRD + Tech Spec em tarefas implementáveis      | `tasks-template.md`, `task-template.md` |
| `executar-task`          | Implementa uma tarefa individual                      | —                              |
| `executar-review`        | Code review contra PRD e TechSpec                     | —                              |
| `executar-qa`            | QA com E2E, acessibilidade e checklist de requisitos  | —                              |
| `executar-bugfix`        | Corrige bugs com análise de causa raiz                | —                              |
| `task-review`            | Revisa uma task concluída (usado pelo task-reviewer)  | —                              |
| `skills-best-practices`  | Guia para criar novas skills (agentskills.io)         | `SKILL.template.md`            |

## Licença

Projeto privado.
