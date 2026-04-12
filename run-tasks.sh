#!/bin/bash
set -euo pipefail

# =============================================================================
# run-tasks.sh — Executa todas as tasks de uma pasta PRD via Claude CLI
# Uso: ./run-tasks.sh tasks/prd-nome-da-feature [opções]
# =============================================================================

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Defaults
SKIP_COMPLETED=true
STOP_ON_ERROR=true
MAX_TURNS=50
DANGEROUS_MODE=false
PRD_DIR=""

# Contadores
TOTAL=0
EXECUTED=0
SKIPPED=0
FAILED=0

usage() {
  cat <<EOF
Uso: ./run-tasks.sh <pasta-prd> [opções]

Executa todas as tasks de uma pasta PRD sequencialmente via Claude CLI.

Argumentos:
  <pasta-prd>                    Caminho da pasta PRD (ex: tasks/prd-nome-da-feature)

Opções:
  --no-skip-completed            Executa mesmo tasks já marcadas como [x]
  --no-stop-on-error             Continua execução mesmo se uma task falhar
  --max-turns <N>                Limite de turnos do Claude CLI (default: 50)
  --dangerously-skip-permissions Pula prompts de permissão do Claude CLI
  -h, --help                     Mostra esta mensagem

Exemplos:
  ./run-tasks.sh tasks/prd-nome-da-feature
  ./run-tasks.sh tasks/prd-nome-da-feature --no-skip-completed --max-turns 80
  ./run-tasks.sh tasks/prd-nome-da-feature --dangerously-skip-permissions
EOF
  exit 0
}

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[SKIP]${NC} $1"; }
log_error()   { echo -e "${RED}[ERRO]${NC} $1"; }

# --- Parse de argumentos ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-skip-completed)
      SKIP_COMPLETED=false
      shift
      ;;
    --no-stop-on-error)
      STOP_ON_ERROR=false
      shift
      ;;
    --max-turns)
      MAX_TURNS="$2"
      shift 2
      ;;
    --dangerously-skip-permissions)
      DANGEROUS_MODE=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    -*)
      log_error "Flag desconhecida: $1"
      usage
      ;;
    *)
      if [[ -z "$PRD_DIR" ]]; then
        PRD_DIR="$1"
      else
        log_error "Argumento extra inesperado: $1"
        usage
      fi
      shift
      ;;
  esac
done

# --- Validação ---
if [[ -z "$PRD_DIR" ]]; then
  log_error "Pasta PRD não informada."
  usage
fi

PRD_DIR="${PRD_DIR%/}"

if [[ ! -d "$PRD_DIR" ]]; then
  log_error "Pasta não encontrada: $PRD_DIR"
  exit 1
fi

for required_file in tasks.md prd.md techspec.md; do
  if [[ ! -f "$PRD_DIR/$required_file" ]]; then
    log_error "Arquivo obrigatório não encontrado: $PRD_DIR/$required_file"
    exit 1
  fi
done

# --- Verificar que claude CLI está disponível ---
if ! command -v claude &> /dev/null; then
  log_error "Claude CLI não encontrado. Instale com: npm install -g @anthropic-ai/claude-code"
  exit 1
fi

# --- Descobrir tasks ---
TASK_FILES=()
for f in "$PRD_DIR"/*_task.md; do
  [[ -f "$f" ]] || continue
  basename_f=$(basename "$f")
  # Excluir arquivos de review (*_task_review.md)
  if [[ "$basename_f" =~ ^[0-9]+_task\.md$ ]]; then
    TASK_FILES+=("$f")
  fi
done

if [[ ${#TASK_FILES[@]} -eq 0 ]]; then
  log_error "Nenhuma task encontrada em $PRD_DIR (padrão: N_task.md)"
  exit 1
fi

# Ordenar numericamente
IFS=$'\n' TASK_FILES=($(for f in "${TASK_FILES[@]}"; do echo "$f"; done | sort -t/ -k2 -V))
unset IFS

TOTAL=${#TASK_FILES[@]}
log_info "Encontradas $TOTAL task(s) em $PRD_DIR"
echo ""

# --- Função para verificar se task está completa ---
is_task_completed() {
  local task_num="$1"
  grep -qE "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*${task_num}\.0" "$PRD_DIR/tasks.md" 2>/dev/null
}

# --- Loop principal ---
for task_file in "${TASK_FILES[@]}"; do
  basename_f=$(basename "$task_file")
  task_num="${basename_f%%_task.md}"

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log_info "Task $task_num — $task_file"

  # Check se já completa
  if [[ "$SKIP_COMPLETED" == true ]] && is_task_completed "$task_num"; then
    log_warn "Task $task_num já completa — pulando"
    SKIPPED=$((SKIPPED + 1))
    echo ""
    continue
  fi

  # Montar prompt
  PROMPT=$(cat <<PROMPT_EOF
Você é um assistente IA responsável por implementar as tarefas de forma correta.

Ative e siga a skill executar-task para conduzir todo o processo de implementação. A skill contém o procedimento completo de configuração, análise, planejamento, implementação e revisão.

Identifique e carregue as skills necessárias para que a tarefa seja executada com base nas tecnologias utilizadas.

VOCÊ DEVE iniciar a implementação logo após o planejamento.

Utilize o Context7 MCP para analisar a documentação da linguagem, frameworks e bibliotecas envolvidas na implementação.

Após completar a tarefa, marque como completa em tasks.md.

SEMPRE EXECUTE O task-reviewer no final.

Implemente a tarefa ${task_num} do PRD localizado em ${PRD_DIR}.
- Task file: ${PRD_DIR}/${task_num}_task.md
- PRD: ${PRD_DIR}/prd.md
- Tech Spec: ${PRD_DIR}/techspec.md
- Tasks: ${PRD_DIR}/tasks.md
PROMPT_EOF
)

  # Montar comando claude
  CLAUDE_CMD=(
    claude
    -p "$PROMPT"
    --allowedTools "Bash,Edit,Read,Write,Glob,Grep,Agent,Skill"
    --max-turns "$MAX_TURNS"
    --output-format stream-json
    --verbose
  )

  if [[ "$DANGEROUS_MODE" == true ]]; then
    CLAUDE_CMD+=(--dangerously-skip-permissions)
  fi

  log_info "Executando claude para task $task_num..."
  echo ""

  # Executar
  set +e
  "${CLAUDE_CMD[@]}"
  exit_code=$?
  set -e

  if [[ $exit_code -eq 0 ]]; then
    log_success "Task $task_num concluída com sucesso"
    EXECUTED=$((EXECUTED + 1))
  else
    log_error "Task $task_num falhou (exit code: $exit_code)"
    FAILED=$((FAILED + 1))

    if [[ "$STOP_ON_ERROR" == true ]]; then
      log_error "Interrompendo execução (use --no-stop-on-error para continuar)"
      break
    fi
  fi

  echo ""
done

# --- Resumo ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}RESUMO${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  Total:     $TOTAL"
echo -e "  Executadas: ${GREEN}$EXECUTED${NC}"
echo -e "  Puladas:    ${YELLOW}$SKIPPED${NC}"
echo -e "  Falhas:     ${RED}$FAILED${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ $FAILED -gt 0 ]]; then
  exit 1
fi
