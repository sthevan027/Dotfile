#!/usr/bin/env bash
# git pull + reaplica configs Hyprland (e opcionalmente o shell).
# Uso: bash cachyos-hyprland/scripts/pull-e-aplicar.sh [--shell]

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
echo ">>> Reaplicando aparência + configs..."
"$SCRIPT_DIR/hypr-complete.sh"

if $WITH_SHELL; then
  echo ""
  echo ">>> Shell..."
  "$SHELL_SCRIPT"
fi

echo ""
echo "✓ Sincronizado. Reinicie o Hyprland (Super+M → sair) para aplicar tudo."
$WITH_SHELL || echo "  Shell: bash cachyos-hyprland/scripts/pull-e-aplicar.sh --shell"
echo ""
