#!/bin/bash
# GNOME (qualquer distro): barra/extensões + cursor + botões à direita + tema GTK/ícones
# Rode: ./scripts/gnome-complete.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=============================================="
echo "  GNOME: Barra + Cursor + botões à direita + ícones"
echo "=============================================="
echo ""

# --- 1. APLICATIVOS ABERTOS NA BARRA (Zorin Taskbar) ---
echo ">>> 1. Aplicativos abertos na barra superior"
echo ""

# Verificar se Zorin Taskbar já está instalado
if gnome-extensions list 2>/dev/null | grep -qi zorin-taskbar; then
    echo "    Zorin Taskbar já instalado. Ativando..."
    gnome-extensions enable zorin-taskbar@zorinos.com 2>/dev/null || gnome-extensions enable $(gnome-extensions list | grep -i taskbar) 2>/dev/null || true
    echo "    ✓ Taskbar ativada!"
elif [ -d "/usr/share/gnome-shell/extensions/zorin-taskbar@zorinos.com" ]; then
    echo "    Zorin Taskbar encontrada. Ativando..."
    gnome-extensions enable zorin-taskbar@zorinos.com 2>/dev/null || true
    echo "    ✓ Taskbar ativada!"
else
    echo "    Instalando Extension Manager..."
    if command -v apt &>/dev/null; then
      sudo apt install -y extension-manager 2>/dev/null || sudo apt install -y gnome-shell-extension-manager 2>/dev/null || sudo apt install -y chrome-gnome-shell 2>/dev/null || true
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y extension-manager 2>/dev/null || sudo dnf install -y gnome-shell-extensions 2>/dev/null || true
    fi
    
    echo ""
    echo "    Para adicionar os APLICATIVOS ABERTOS na barra:"
    echo "    1. Abra 'Extension Manager' (gerenciador de extensões)"
    echo "    2. Vá em 'Navegar' e pesquise 'Zorin Taskbar'"
    echo "    3. Clique em Instalar"
    echo ""
    echo "    Ou acesse: https://extensions.gnome.org/extension/2003/zorin-taskbar/"
    echo ""
fi
echo ""

# --- 2. CURSOR WINDOWS 11 BLACK ---
echo ">>> 2. Cursor Windows 11 Black (estilo Aero)"
echo ""

CURSOR_DIR="$HOME/.local/share/icons"
mkdir -p "$CURSOR_DIR"

# Vision Cursor - estilo Windows 11, versão preta (similar ao Twipeep)
if [ -d "$CURSOR_DIR/Vision-Black" ] || [ -d "$CURSOR_DIR/vision-black" ]; then
    echo "    Vision-Black já instalado."
else
    echo "    Baixando Vision Cursor (Windows 11 style black)..."
    CURL_OR_WGET=""
    command -v wget &>/dev/null && CURL_OR_WGET="wget"
    command -v curl &>/dev/null && CURL_OR_WGET="curl"
    
    if [ -n "$CURL_OR_WGET" ]; then
        TMP_CURSOR=$(mktemp -d)
        if [ "$CURL_OR_WGET" = "wget" ]; then
            wget -q "https://github.com/zDyant/Vision-Cursor/releases/download/v1.0/Vision-Black-Linux.tar.gz" -O "$TMP_CURSOR/vision.tar.gz"
        else
            curl -sL "https://github.com/zDyant/Vision-Cursor/releases/download/v1.0/Vision-Black-Linux.tar.gz" -o "$TMP_CURSOR/vision.tar.gz"
        fi
        tar -xzf "$TMP_CURSOR/vision.tar.gz" -C "$CURSOR_DIR"
        rm -rf "$TMP_CURSOR"
        echo "    ✓ Cursor instalado!"
        # Inherits com aspas no index.theme atrapalha alguns leitores de tema
        for _vb in "$CURSOR_DIR/Vision-Black" "$CURSOR_DIR/Vision-black"; do
            [[ -f "$_vb/index.theme" ]] && sed -i 's/^Inherits=.*/Inherits=hicolor/' "$_vb/index.theme" 2>/dev/null || true
        done
    else
        echo "    wget ou curl não encontrado. Instale:"
        if command -v apt &>/dev/null; then
            echo "      sudo apt install wget"
        elif command -v dnf &>/dev/null; then
            echo "      sudo dnf install wget"
        fi
        echo "    Ou baixe manualmente: https://github.com/zDyant/Vision-Cursor/releases"
        echo "    Extraia Vision-Black para ~/.local/share/icons/"
        exit 1
    fi
fi

# Aplicar cursor (nome pode ser Vision-Black ou Vision-black)
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
echo "    (Logout/login para Electron/Cursor usarem o mesmo ponteiro.)"
echo ""
echo "    (Versão Twipeep do DeviantArt: baixe em"
echo "     https://www.deviantart.com/twipeep/art/Windows-11-cursor-black-version-572437583"
echo "     Extraia em ~/.local/share/icons/ e aplique nas configurações)"
echo ""

# --- 3. BOTÕES À DIREITA (PADRÃO WINDOWS) ---
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
        cd "$TMP_DIR"
        git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
        cd WhiteSur-gtk-theme
        # -c Dark = variante escura; instala em /usr (precisa sudo)
        ./install.sh -c Dark
        cd "$SCRIPT_DIR/.."
        rm -rf "$TMP_DIR"
        echo "    ✓ WhiteSur instalado!"
    else
        echo "    ✗ git não encontrado. Instale com:"
        if command -v apt &>/dev/null; then
            echo "      sudo apt install git"
        elif command -v dnf &>/dev/null; then
            echo "      sudo dnf install git"
        fi
    fi
else
    echo "    WhiteSur já instalado."
fi

# Botões à direita (ordem: minimizar, maximizar, fechar)
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Aplicar tema GTK e janelas
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"

# Zorin pode usar schema próprio — forçar via dconf
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/button-layout "':minimize,maximize,close'" 2>/dev/null || true

echo "    ✓ Botões à direita aplicados via gsettings!"
echo ""
echo "    Se NÃO aparecer, aplique manualmente:"
echo "    1. Abra 'Aparência' (ou Configurações > Aparência)"
echo "    2. Em 'Estilo das janelas' ou 'Window style', escolha 'WhiteSur-Dark'"
echo "    3. Ou use: gnome-tweaks > Aparência > Temas"
echo ""

# --- 4. ÍCONES ESTILO MACOS ---
echo ">>> 4. Ícones estilo macOS (squircle)"
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
        cd "$TMP_DIR"
        git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
        cd WhiteSur-icon-theme
        ./install.sh
        cd "$SCRIPT_DIR/.."
        rm -rf "$TMP_DIR"
        echo "    ✓ Ícones instalados!"
    else
        echo "    ✗ git não encontrado. Instale com:"
        if command -v apt &>/dev/null; then
            echo "      sudo apt install git"
        elif command -v dnf &>/dev/null; then
            echo "      sudo dnf install git"
        fi
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
echo "  • Taskbar: Extension Manager → Zorin Taskbar, se ainda não tiver"
echo "  • Se tema/botões não mudarem: ./scripts/restaurar-config.sh"
echo "  • Logout/login se o cursor ou GTK não atualizarem"
echo ""
