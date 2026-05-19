#!/bin/bash
# Setup completo para PC novo com Fedora + GNOME
# Na raiz do repositório rode: bash fedora-gnome/scripts/setup.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_SCRIPT="$SCRIPT_DIR/../../shell/aplicar-shell.sh"

echo "=============================================="
echo "  Setup — Fedora + GNOME"
echo "=============================================="
echo ""

echo ">>> 1. Atualizando sistema..."
sudo dnf update -y
echo ""

echo ">>> 2. Instalando apps (lista meus-apps.txt)..."
"$SCRIPT_DIR/apps.sh" instalar
echo ""

echo ">>> 3. Aplicando aparência GNOME (cursor, tema, ícones, extensões)..."
"$SCRIPT_DIR/gnome-complete.sh"
echo ""

echo ">>> 4. Restaurando configurações gsettings..."
"$SCRIPT_DIR/restaurar-config.sh"
echo ""

echo ">>> 5. Aplicando shell (zsh + p10k)..."
"$SHELL_SCRIPT"
echo ""

echo "=============================================="
echo "  ✅ Setup concluído!"
echo "=============================================="
echo ""
echo "  Faça logout e login para aplicar tudo."
echo "  Atalhos de teclado: bash fedora-gnome/scripts/gnome-shortcuts.sh"
echo "  Personalização extra: bash fedora-gnome/scripts/personalizar-gnome.sh"
echo ""
