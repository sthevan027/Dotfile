#!/bin/bash
# Zorin: Cursor Aero Black + Botões estilo macOS
# Rode no terminal: ./scripts/zorin-aero-macos.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=========================================="
echo "  Zorin: Aero Black + Botões macOS"
echo "=========================================="
echo ""

# --- 1. CURSOR AERO BLACK ---
echo ">>> 1. Cursor Aero Black"
echo ""

# dmz-black é o cursor escuro mais próximo do Aero Black (nos repositórios)
if apt list --installed 2>/dev/null | grep -q dmz-cursor-theme; then
    echo "    dmz-cursor-theme já instalado."
else
    echo "    Instalando dmz-cursor-theme..."
    sudo apt install -y dmz-cursor-theme
fi

echo "    Aplicando cursor DMZ-Black (estilo Aero)..."
gsettings set org.gnome.desktop.interface cursor-theme "DMZ-Black"
gsettings set org.gnome.desktop.interface cursor-size 24
echo "    ✓ Cursor aplicado!"
echo ""

# --- 2. BOTÕES ESTILO MACOS ---
echo ">>> 2. Botões estilo macOS (vermelho, amarelo, verde)"
echo ""

# Verificar se WhiteSur está instalado
if [ -d "/usr/share/themes/WhiteSur-Dark" ] || [ -d "$HOME/.themes/WhiteSur-Dark" ] || [ -d "$HOME/.local/share/themes/WhiteSur-Dark" ]; then
    echo "    WhiteSur já instalado."
else
    echo "    WhiteSur NÃO encontrado. Instalando..."
    echo ""
    
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    
    if command -v git &>/dev/null; then
        git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
        cd WhiteSur-gtk-theme
        ./install.sh -c Dark
        cd "$SCRIPT_DIR/.."
        rm -rf "$TMP_DIR"
    else
        echo "    ERRO: git não encontrado. Instale com: sudo apt install git"
        cd "$SCRIPT_DIR/.."
        rm -rf "$TMP_DIR"
        exit 1
    fi
fi

echo "    Aplicando tema WhiteSur (botões à esquerda, estilo Mac)..."
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"
echo "    ✓ Botões macOS aplicados!"
echo ""

echo "=========================================="
echo "  ✅ Pronto!"
echo "=========================================="
echo ""
echo "  As mudanças já estão ativas."
echo "  Se o cursor não mudar, faça logout e login."
echo ""
