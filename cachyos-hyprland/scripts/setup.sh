#!/bin/bash
# Setup completo para CachyOS + Hyprland
# Na raiz do repositório rode: bash cachyos-hyprland/scripts/setup.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_SCRIPT="$SCRIPT_DIR/../../shell/aplicar-shell.sh"

echo "=============================================="
echo "  Setup — CachyOS + Hyprland"
echo "=============================================="
echo ""

echo ">>> 1. Atualizando sistema..."
sudo pacman -Syu --noconfirm
echo ""

echo ">>> 2. Instalando apps (lista meus-apps.txt)..."
"$SCRIPT_DIR/apps.sh" instalar
echo ""

echo ">>> 3. Aplicando aparência + cursor + GTK + ícones..."
"$SCRIPT_DIR/hypr-complete.sh"
echo ""

echo ">>> 4. Aplicando shell (zsh + p10k)..."
"$SHELL_SCRIPT"
echo ""

echo "=============================================="
echo "  ✅ Setup concluído!"
echo "=============================================="
echo ""
echo "  Inicie o Hyprland: exec Hyprland"
echo "  Atalhos principais:"
echo "    Super+Enter ou Super+T → Terminal (kitty)"
echo "    Super+Space            → Lançador de apps (rofi)"
echo "    Super+1..9             → Trocar workspace"
echo "    Super+C                → Fechar janela"
echo "    Shift+Alt+S            → Screenshot"
echo ""
