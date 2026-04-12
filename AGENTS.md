# CLAUDE.md

Guia para agentes de IA ao trabalhar com o código deste repositório.

Este projeto segue o fluxo **SDD (Spec-Driven Development)**.

---

## Setup do Projeto

### Passo 1: Escolha a Stack

Antes de iniciar o desenvolvimento, preencha a tabela abaixo com as tecnologias escolhidas para o projeto. Essa tabela é a referência principal para agentes de IA saberem qual stack utilizar.

### Stack e skills recomendadas

| Área              | Tecnologia | Skill sugerida |
| ----------------- | ---------- | -------------- |
| Frontend          |            |                |
| UI / Design       |            |                |
| Backend           |            |                |
| Database          |            |                |
| Testes            |            |                |
| Package Manager   |            |                |
| Design / UX       |            |                |
| PRD               | —          | `cria-prd`     |
| Tech Spec         | —          | `cria-techspec`|
| Tasks             | —          | `criar-tasks`  |
| Implementação     | —          | `executar-task` |
| Code Review       | —          | `executar-review`, `task-review` |
| QA                | —          | `executar-qa`  |
| Bugfix            | —          | `executar-bugfix` |

### Passo 2: Defina a estrutura do projeto

Após escolher a stack, crie a estrutura de pastas e arquivos de configuração do seu projeto. Depois, documente a estrutura na seção "Estrutura do projeto" abaixo.

---

### Prioridades

- **Sempre verifique as skills** antes de implementar — tarefas sem skills relevantes podem ser invalidadas
- **Execute os checks** antes de concluir: lint, typecheck, build, test (conforme a stack escolhida)
- **Não use workarounds** — prefira correções de causa raiz
- **Use o package manager definido na stack** para adicionar dependências (nunca edite arquivos de dependência manualmente sem conferir a versão)

### Comandos do projeto

<!-- Preencha com os comandos do seu projeto após scaffolding -->

```bash
# Exemplo:
# dev           — Inicia o ambiente de desenvolvimento
# build         — Build de produção
# typecheck     — Verificação de tipos
# lint          — Linting
# test          — Testes unitários
# test:e2e      — Testes E2E
```

### Estrutura do projeto

<!-- Preencha com a estrutura do seu projeto após scaffolding -->

```
/
├── ...
```

### Regras de código

1. **Componentes funcionais** — sem class components
2. **Props tipadas** — tipar diretamente na função
3. **Tratar estados** — loading, error e empty
4. **kebab-case** para nomes de arquivos (ex: `meu-componente.tsx`)
5. **Composição** — preferir composição a muitas props booleanas

### Testes

<!-- Preencha com a estratégia de testes do seu projeto -->

- **Unit tests**: [framework e configuração]
- **E2E**: [framework e configuração]

### Git

- **Não execute** `git restore`, `git reset`, `git clean` ou comandos destrutivos **sem permissão explícita do usuário**

### Anti-padrões

1. Pular ativação de skill
2. Ativar apenas uma skill quando o código toca vários domínios
3. Esquecer verificação antes de marcar tarefa concluída
4. Executar comandos git destrutivos sem permissão do usuário
5. Evite fazer workarounds
