#!/usr/bin/env bash
# git pull + reaplica gsettings (e opcionalmente o shell).
# Uso: ./scripts/pull-e-aplicar.sh [--shell]

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

WITH_SHELL=false
for a in "$@"; do
  [[ "$a" == "--shell" ]] && WITH_SHELL=true
done

echo ">>> git pull..."
git pull origin main 2>/dev/null || git pull 2>/dev/null || echo "  (sem remote ou não é git)"

echo ""
echo ">>> Aparência (gsettings)..."
./scripts/restaurar-config.sh

if $WITH_SHELL; then
  echo ""
  echo ">>> Shell..."
  ./scripts/aplicar-shell.sh
fi

echo ""
echo "✓ Sincronizado."
$WITH_SHELL || echo "  Shell: ./scripts/pull-e-aplicar.sh --shell  ou  ./scripts/aplicar-shell.sh"
echo ""
