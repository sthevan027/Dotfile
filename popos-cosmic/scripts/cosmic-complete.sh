#!/usr/bin/env bash
# Pop!_OS COSMIC DE: cursor + ícones + GTK compat + tema escuro
# O COSMIC tem DE próprio (não é GNOME) — gsettings/dconf não controlam a aparência nativa.
# Este script configura o que é possível via arquivos e variáveis de ambiente.
# Rode: bash popos-cosmic/scripts/cosmic-complete.sh

set -e

echo "=============================================="
echo "  COSMIC DE: Cursor + Ícones + GTK + Escuro"
echo "=============================================="
echo ""

# --- 1. CURSOR WINDOWS 11 BLACK ---
echo ">>> 1. Cursor Windows 11 Black (estilo Aero)"
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
        echo "    curl ou wget não encontrado. Instale: sudo apt install wget"
        rm -rf "$TMP_CURSOR"
        exit 1
    fi
    tar -xzf "$TMP_CURSOR/vision.tar.gz" -C "$CURSOR_DIR"
    rm -rf "$TMP_CURSOR"
    for _vb in "$CURSOR_DIR/Vision-Black" "$CURSOR_DIR/Vision-black"; do
        [[ -f "$_vb/index.theme" ]] && sed -i 's/^Inherits=.*/Inherits=hicolor/' "$_vb/index.theme" 2>/dev/null || true
    done
    echo "    ✓ Cursor instalado em $CURSOR_DIR"
fi

CURSOR_NAME="Vision-Black"
[ -d "$CURSOR_DIR/Vision-black" ] && CURSOR_NAME="Vision-black"

# Symlink legado (alguns apps procuram aqui)
mkdir -p "$HOME/.icons"
ln -sfn "$CURSOR_DIR/$CURSOR_NAME" "$HOME/.icons/$CURSOR_NAME"

# Variáveis de sessão — lidas pelo COSMIC, Wayland e apps Electron/X11
mkdir -p "$HOME/.config/environment.d"
cat > "$HOME/.config/environment.d/90-dotfile-cursor.conf" <<EOF
XCURSOR_THEME=$CURSOR_NAME
XCURSOR_SIZE=24
EOF

# GTK3/GTK4 via arquivo (apps GTK que rodam sobre o COSMIC)
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-cursor-theme-name=$CURSOR_NAME
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF
cat > "$HOME/.config/gtk-4.0/settings.ini" <<EOF
[Settings]
gtk-cursor-theme-name=$CURSOR_NAME
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

echo "    ✓ Cursor $CURSOR_NAME configurado via env + GTK!"
echo "    → Faça LOGOUT e login para o cursor atualizar em todos os apps."
echo ""
echo "    Para aplicar no COSMIC nativo:"
echo "    Configurações → Área de Trabalho → Aparência → Cursor"
echo ""

# --- 2. ÍCONES WHITESUR (úteis para apps GTK) ---
echo ">>> 2. Ícones WhiteSur (estilo macOS, para apps GTK)"
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
        # Adicionar ao GTK settings
        sed -i '/^\[Settings\]/a gtk-icon-theme-name=WhiteSur' "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
        sed -i '/^\[Settings\]/a gtk-icon-theme-name=WhiteSur' "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || true
        echo "    ✓ WhiteSur Icon Theme instalado!"
    else
        echo "    git não encontrado. Instale: sudo apt install git"
    fi
else
    echo "    WhiteSur Icon Theme já instalado."
fi
echo ""

# --- 3. TEMA ESCURO (XDG color-scheme, lido por apps GTK/Qt) ---
echo ">>> 3. Tema escuro (XDG color-scheme)"
echo ""

# XDG color-scheme via dconf (funciona em algumas versões do COSMIC com GTK compat layer)
dconf write /org/freedesktop/appearance/color-scheme "'prefer-dark'" 2>/dev/null || true
echo "    ✓ color-scheme prefer-dark configurado (apps GTK/Qt respeitam automaticamente)."
echo ""
echo "    Para o tema escuro no COSMIC nativo:"
echo "    Configurações → Área de Trabalho → Aparência → Estilo → Escuro"
echo ""

echo "=============================================="
echo "  ✅ Pronto!"
echo "=============================================="
echo ""
echo "  O que este script configurou automaticamente:"
echo "  • Cursor Vision-Black via XCURSOR_THEME + GTK settings"
echo "  • Ícones WhiteSur para apps GTK"
echo "  • color-scheme prefer-dark"
echo ""
echo "  O que configurar manualmente no COSMIC Settings:"
echo "  • Tema de cores (Configurações → Área de Trabalho → Aparência)"
echo "  • Cursor nativo COSMIC (Aparência → Cursor)"
echo "  • Painel e dock (Configurações → Área de Trabalho → Painel)"
echo ""
