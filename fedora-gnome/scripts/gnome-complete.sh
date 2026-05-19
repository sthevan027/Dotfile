#!/bin/bash
# GNOME (Fedora): extensões + cursor + botões à direita + tema GTK/ícones
# Rode: bash fedora-gnome/scripts/gnome-complete.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=============================================="
echo "  GNOME: Barra + Cursor + botões à direita + ícones"
echo "=============================================="
echo ""

# --- 1. APLICATIVOS ABERTOS NA BARRA ---
echo ">>> 1. Gerenciador de extensões GNOME"
echo ""

if gnome-extensions list 2>/dev/null | grep -qi zorin-taskbar; then
    echo "    Zorin Taskbar já instalado. Ativando..."
    gnome-extensions enable zorin-taskbar@zorinos.com 2>/dev/null || true
    echo "    ✓ Taskbar ativada!"
elif [ -d "/usr/share/gnome-shell/extensions/zorin-taskbar@zorinos.com" ]; then
    echo "    Zorin Taskbar encontrada. Ativando..."
    gnome-extensions enable zorin-taskbar@zorinos.com 2>/dev/null || true
    echo "    ✓ Taskbar ativada!"
else
    echo "    Instalando Extension Manager (Fedora)..."
    # No Fedora o pacote chama gnome-extensions-app (ou extension-manager via COPR)
    sudo dnf install -y gnome-extensions-app 2>/dev/null \
      || sudo dnf install -y extension-manager 2>/dev/null \
      || true

    echo ""
    echo "    Para adicionar APLICATIVOS ABERTOS na barra:"
    echo "    1. Abra 'Extension Manager' (gerenciador de extensões)"
    echo "    2. Vá em 'Navegar' e pesquise 'Zorin Taskbar' ou 'Dash to Panel'"
    echo "    3. Clique em Instalar"
    echo ""
fi
echo ""

# --- 2. CURSOR WINDOWS 11 BLACK ---
echo ">>> 2. Cursor Windows 11 Black (estilo Aero)"
echo ""

CURSOR_DIR="$HOME/.local/share/icons"
mkdir -p "$CURSOR_DIR"

if [ -d "$CURSOR_DIR/Vision-Black" ] || [ -d "$CURSOR_DIR/Vision-black" ]; then
    echo "    Vision-Black já instalado."
else
    echo "    Baixando Vision Cursor (Windows 11 style black)..."
    TMP_CURSOR=$(mktemp -d)
    if command -v curl &>/dev/null; then
        curl -sL "https://github.com/zDyant/Vision-Cursor/releases/download/v1.0/Vision-Black-Linux.tar.gz" -o "$TMP_CURSOR/vision.tar.gz"
    elif command -v wget &>/dev/null; then
        wget -q "https://github.com/zDyant/Vision-Cursor/releases/download/v1.0/Vision-Black-Linux.tar.gz" -O "$TMP_CURSOR/vision.tar.gz"
    else
        echo "    curl ou wget não encontrado. Instale: sudo dnf install wget"
        echo "    Ou baixe manualmente: https://github.com/zDyant/Vision-Cursor/releases"
        echo "    Extraia Vision-Black para ~/.local/share/icons/"
        rm -rf "$TMP_CURSOR"
        exit 1
    fi
    tar -xzf "$TMP_CURSOR/vision.tar.gz" -C "$CURSOR_DIR"
    rm -rf "$TMP_CURSOR"
    # Corrige Inherits= que pode quebrar alguns leitores de tema
    for _vb in "$CURSOR_DIR/Vision-Black" "$CURSOR_DIR/Vision-black"; do
        [[ -f "$_vb/index.theme" ]] && sed -i 's/^Inherits=.*/Inherits=hicolor/' "$_vb/index.theme" 2>/dev/null || true
    done
    echo "    ✓ Cursor instalado!"
fi

CURSOR_NAME="Vision-Black"
[ -d "$CURSOR_DIR/Vision-black" ] && CURSOR_NAME="Vision-black"
mkdir -p "$HOME/.icons"
ln -sfn "$CURSOR_DIR/$CURSOR_NAME" "$HOME/.icons/$CURSOR_NAME"
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME"
gsettings set org.gnome.desktop.interface cursor-size 24
dconf write /org/gnome/desktop/interface/cursor-theme "'$CURSOR_NAME'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/cursor-size "uint32 24" 2>/dev/null || true
mkdir -p "$HOME/.config/environment.d"
cat > "$HOME/.config/environment.d/90-dotfile-cursor.conf" <<EOF
XCURSOR_THEME=$CURSOR_NAME
XCURSOR_SIZE=24
EOF
echo "    ✓ Cursor Windows 11 Black aplicado!"
echo "    (Logout/login para Electron/VS Code usarem o mesmo ponteiro.)"
echo ""

# --- 3. BOTÕES À DIREITA ---
echo ">>> 3. Botões da janela à direita (minimizar, maximizar, fechar)"
echo ""

THEME_DIRS="/usr/share/themes $HOME/.themes $HOME/.local/share/themes"
WS_INSTALLED=""
for d in $THEME_DIRS; do
    [ -d "$d/WhiteSur-Dark" ] && WS_INSTALLED="yes" && break
done

if [ -z "$WS_INSTALLED" ]; then
    echo "    Instalando WhiteSur (tema GTK)..."
    if command -v git &>/dev/null; then
        TMP_DIR=$(mktemp -d)
        git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$TMP_DIR/WhiteSur-gtk-theme"
        "$TMP_DIR/WhiteSur-gtk-theme/install.sh" -c Dark
        rm -rf "$TMP_DIR"
        echo "    ✓ WhiteSur instalado!"
    else
        echo "    ✗ git não encontrado. Instale: sudo dnf install git"
    fi
else
    echo "    WhiteSur já instalado."
fi

gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/button-layout "':minimize,maximize,close'" 2>/dev/null || true
echo "    ✓ Botões à direita aplicados!"
echo ""

# --- 4. ÍCONES ESTILO MACOS ---
echo ">>> 4. Ícones estilo macOS (WhiteSur)"
echo ""

ICON_DIRS="/usr/share/icons $HOME/.icons $HOME/.local/share/icons"
WS_ICONS=""
for d in $ICON_DIRS; do
    [ -d "$d/WhiteSur" ] && WS_ICONS="yes" && break
done

if [ -z "$WS_ICONS" ]; then
    echo "    Instalando WhiteSur Icon Theme..."
    if command -v git &>/dev/null; then
        TMP_DIR=$(mktemp -d)
        git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git "$TMP_DIR/WhiteSur-icon-theme"
        "$TMP_DIR/WhiteSur-icon-theme/install.sh"
        rm -rf "$TMP_DIR"
        echo "    ✓ Ícones instalados!"
    else
        echo "    ✗ git não encontrado. Instale: sudo dnf install git"
    fi
else
    echo "    WhiteSur Icon Theme já instalado."
fi

gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur'" 2>/dev/null || true
echo "    ✓ Ícones macOS aplicados!"
echo ""

echo "=============================================="
echo "  ✅ Pronto!"
echo "=============================================="
echo ""
echo "  • Extension Manager → pesquise 'Zorin Taskbar' ou 'Dash to Panel'"
echo "  • Se tema/botões não mudarem: bash fedora-gnome/scripts/restaurar-config.sh"
echo "  • Logout/login se o cursor não atualizar em apps Electron"
echo ""
