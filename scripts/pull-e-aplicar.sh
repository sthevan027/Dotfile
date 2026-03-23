#!/bin/bash
# Puxa as últimas alterações do GitHub e reaplica a configuração
# Rode: ./scripts/pull-e-aplicar.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo ">>> Puxando alterações do GitHub..."
git pull origin main 2>/dev/null || git pull 2>/dev/null || echo "  (não é um repositório git ou sem remote)"

echo ""
echo ">>> Reaplicando configuração..."
./scripts/restaurar-config.sh

echo ""
echo "✓ Atualizado!"
echo ""
echo "Para aplicar tudo de novo (temas, apps, etc):"
echo "  ./scripts/setup-novo-pc.sh"
echo ""
