#!/bin/bash
# Setup completo para CachyOS + Niri
# Na raiz do repositório rode: bash cachyos-niri/scripts/setup.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_SCRIPT="$SCRIPT_DIR/../../shell/aplicar-shell.sh"

echo "=============================================="
echo "  Setup — CachyOS + Niri"
echo "=============================================="
echo ""

echo ">>> 1. Atualizando sistema..."
sudo pacman -Syu --noconfirm
echo ""

echo ">>> 2. Instalando apps (lista meus-apps.txt)..."
"$SCRIPT_DIR/apps.sh" instalar
echo ""

echo ">>> 3. Aplicando aparência + cursor + GTK + ícones..."
"$SCRIPT_DIR/niri-complete.sh"
echo ""

echo ">>> 4. Aplicando shell (zsh + p10k)..."
"$SHELL_SCRIPT"
echo ""

echo "=============================================="
echo "  ✅ Setup concluído!"
echo "=============================================="
echo ""
echo "  Inicie o Niri: exec niri"
echo ""
echo "  Atalhos principais:"
echo "    Mod+T            → Terminal (kitty)"
echo "    Mod+E            → Gerenciador de arquivos (nemo)"
echo "    Mod+Space        → Lançador de apps (rofi)"
echo "    Mod+1..9         → Trocar workspace"
echo "    Mod+C            → Fechar janela"
echo "    Mod+R            → Ciclar larguras (1/3, 1/2, 2/3, full)"
echo "    Mod+Shift+V      → Toggle floating"
echo "    Shift+Alt+S      → Screenshot de área"
echo "    Mod+Shift+L      → Bloquear tela"
echo ""
echo "  Layout do teclado: edite cachyos-niri/config/niri/config.kdl → kb_layout"
echo ""
