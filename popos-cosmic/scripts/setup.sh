#!/bin/bash
# Setup completo para PC novo com Pop!_OS + COSMIC DE
# Na raiz do repositório rode: bash popos-cosmic/scripts/setup.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_SCRIPT="$SCRIPT_DIR/../../shell/aplicar-shell.sh"

echo "=============================================="
echo "  Setup — Pop!_OS + COSMIC DE"
echo "=============================================="
echo ""

echo ">>> 1. Atualizando sistema..."
sudo apt update && sudo apt upgrade -y
echo ""

echo ">>> 2. Instalando apps (lista meus-apps.txt)..."
"$SCRIPT_DIR/apps.sh" instalar
echo ""

echo ">>> 3. Aplicando aparência COSMIC (cursor, GTK compat, ícones)..."
"$SCRIPT_DIR/cosmic-complete.sh"
echo ""

echo ">>> 4. Aplicando shell (zsh + p10k)..."
"$SHELL_SCRIPT"
echo ""

echo "=============================================="
echo "  ✅ Setup concluído!"
echo "=============================================="
echo ""
echo "  Faça logout e login para aplicar tudo."
echo "  Atalhos de teclado: bash popos-cosmic/scripts/cosmic-shortcuts.sh"
echo ""
echo "  Aparência do COSMIC DE (tema, cor de destaque, barra):"
echo "  Abra: Configurações → Área de Trabalho → Aparência"
echo ""
