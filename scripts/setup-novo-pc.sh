#!/bin/bash
# Setup completo para PC novo (Zorin fresh install)
# Clone do GitHub e rode: ./scripts/setup-novo-pc.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=============================================="
echo "  Setup Zorin — PC novo"
echo "=============================================="
echo ""

# 1. Atualizar sistema
echo ">>> 1. Atualizando sistema..."
sudo apt update && sudo apt upgrade -y
echo ""

# 2. Instalar apps
echo ">>> 2. Instalando apps (lista meus-apps.txt)..."
./scripts/apps.sh instalar
echo ""

# 3. Aparência (cursor, botões, ícones, taskbar)
echo ">>> 3. Aplicando aparência (cursor, botões Mac, ícones)..."
./scripts/zorin-complete.sh
echo ""

# 4. Restaurar gsettings
echo ">>> 4. Restaurando configurações..."
./scripts/restaurar-config.sh
echo ""

# 5. Shell (zsh + Powerlevel10k)
echo ">>> 5. Aplicando shell (zsh + p10k)..."
./scripts/aplicar-shell.sh
echo ""

echo "=============================================="
echo "  ✅ Setup concluído!"
echo "=============================================="
echo ""
echo "  Faça logout e login para aplicar tudo."
echo "  Instale Zorin Taskbar pelo Extension Manager se não apareceu."
echo ""
