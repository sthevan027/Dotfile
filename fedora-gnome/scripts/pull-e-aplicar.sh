#!/usr/bin/env bash
# git pull + reaplica gsettings (e opcionalmente o shell).
# Uso: bash fedora-gnome/scripts/pull-e-aplicar.sh [--shell]

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_SCRIPT="$SCRIPT_DIR/../../shell/aplicar-shell.sh"

WITH_SHELL=false
for a in "$@"; do
  [[ "$a" == "--shell" ]] && WITH_SHELL=true
done

echo ">>> git pull..."
git pull 2>/dev/null || echo "  (sem remote configurado ou não é repositório git)"

echo ""
echo ">>> Aparência (gsettings)..."
"$SCRIPT_DIR/restaurar-config.sh"

if $WITH_SHELL; then
  echo ""
  echo ">>> Shell..."
  "$SHELL_SCRIPT"
fi

echo ""
echo "✓ Sincronizado."
$WITH_SHELL || echo "  Shell: bash fedora-gnome/scripts/pull-e-aplicar.sh --shell  ou  bash shell/aplicar-shell.sh"
echo ""
