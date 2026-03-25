#!/bin/bash
# Zorin: Aplicativos na barra + Cursor Windows 11 Black + Botões macOS
# Rode: ./scripts/zorin-complete.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=============================================="
echo "  Zorin: Barra + Cursor + Botões + Ícones Mac"
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
    sudo apt install -y extension-manager 2>/dev/null || sudo apt install -y gnome-shell-extension-manager 2>/dev/null || sudo apt install -y chrome-gnome-shell 2>/dev/null || true
    
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
    else
        echo "    wget ou curl não encontrado. Instale: sudo apt install wget"
        echo "    Ou baixe manualmente: https://github.com/zDyant/Vision-Cursor/releases"
        echo "    Extraia Vision-Black para ~/.local/share/icons/"
        exit 1
    fi
fi

# Aplicar cursor (nome pode ser Vision-Black ou Vision-black)
CURSOR_NAME="Vision-Black"
[ -d "$CURSOR_DIR/Vision-black" ] && CURSOR_NAME="Vision-black"
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME"
gsettings set org.gnome.desktop.interface cursor-size 24
echo "    ✓ Cursor Windows 11 Black aplicado!"
echo ""
echo "    (Versão Twipeep do DeviantArt: baixe em"
echo "     https://www.deviantart.com/twipeep/art/Windows-11-cursor-black-version-572437583"
echo "     Extraia em ~/.local/share/icons/ e aplique nas configurações)"
echo ""

# --- 3. BOTÕES ESTILO MACOS ---
echo ">>> 3. Botões estilo macOS (vermelho, amarelo, verde)"
echo ""

THEME_DIRS="/usr/share/themes $HOME/.themes $HOME/.local/share/themes"
WS_INSTALLED=""
for d in $THEME_DIRS; do
    [ -d "$d/WhiteSur-Dark" ] && WS_INSTALLED="yes" && break
done

if [ -z "$WS_INSTALLED" ]; then
    echo "    Instalando WhiteSur (tema com botões Mac)..."
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
    echo "    WhiteSur já instalado."
fi

# Botões à esquerda (estilo Mac)
gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"

# Aplicar tema GTK e janelas
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"

# Zorin pode usar schema próprio — forçar via dconf
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'" 2>/dev/null || true

echo "    ✓ Botões macOS aplicados via gsettings!"
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
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    if command -v git &>/dev/null; then
        git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
        cd WhiteSur-icon-theme
        ./install.sh
        cd "$SCRIPT_DIR/.."
        rm -rf "$TMP_DIR"
        echo "    ✓ Ícones instalados!"
    else
        echo "    git não encontrado. Instale: sudo apt install git"
        cd "$SCRIPT_DIR/.."
        rm -rf "$TMP_DIR"
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
