#!/usr/bin/env bash
# CachyOS + Hyprland: cursor Vision-Black + tema WhiteSur-Dark + ícones WhiteSur
# Linka os configs de hypr/, waybar/, rofi/, dunst/ e hyprlock/ para ~/.config/
# Rode: bash cachyos-hyprland/scripts/hypr-complete.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_SRC="$REPO_ROOT/config"

echo "=============================================="
echo "  Hyprland: Cursor + GTK + Ícones + Configs"
echo "=============================================="
echo ""

# --- 1. CURSOR VISION-BLACK ---
echo ">>> 1. Cursor Windows 11 Black"
echo ""

CURSOR_DIR="$HOME/.local/share/icons"
mkdir -p "$CURSOR_DIR"

if [ -d "$CURSOR_DIR/Vision-Black" ] || [ -d "$CURSOR_DIR/Vision-black" ]; then
    echo "    Vision-Black já instalado."
else
    echo "    Baixando Vision Cursor..."
    TMP_CURSOR=$(mktemp -d)
    if command -v curl &>/dev/null; then
        curl -sL "https://github.com/zDyant/Vision-Cursor/releases/download/v1.0/Vision-Black-Linux.tar.gz" -o "$TMP_CURSOR/vision.tar.gz"
    else
        wget -q "https://github.com/zDyant/Vision-Cursor/releases/download/v1.0/Vision-Black-Linux.tar.gz" -O "$TMP_CURSOR/vision.tar.gz"
    fi
    tar -xzf "$TMP_CURSOR/vision.tar.gz" -C "$CURSOR_DIR"
    rm -rf "$TMP_CURSOR"
    for _vb in "$CURSOR_DIR/Vision-Black" "$CURSOR_DIR/Vision-black"; do
        [[ -f "$_vb/index.theme" ]] && sed -i 's/^Inherits=.*/Inherits=hicolor/' "$_vb/index.theme" 2>/dev/null || true
    done
    echo "    ✓ Cursor instalado!"
fi

CURSOR_NAME="Vision-Black"
[ -d "$CURSOR_DIR/Vision-black" ] && CURSOR_NAME="Vision-black"
mkdir -p "$HOME/.icons"
ln -sfn "$CURSOR_DIR/$CURSOR_NAME" "$HOME/.icons/$CURSOR_NAME"
echo "    ✓ Cursor: $CURSOR_NAME"
echo ""

# --- 2. TEMA GTK WHITESUR-DARK ---
echo ">>> 2. Tema GTK WhiteSur-Dark"
echo ""

THEME_DIRS="/usr/share/themes $HOME/.themes $HOME/.local/share/themes"
WS_INSTALLED=""
for d in $THEME_DIRS; do
    [ -d "$d/WhiteSur-Dark" ] && WS_INSTALLED="yes" && break
done

if [ -z "$WS_INSTALLED" ]; then
    echo "    Instalando WhiteSur GTK..."
    TMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$TMP_DIR/WhiteSur-gtk-theme"
    "$TMP_DIR/WhiteSur-gtk-theme/install.sh" -c Dark
    rm -rf "$TMP_DIR"
    echo "    ✓ WhiteSur-Dark instalado!"
else
    echo "    WhiteSur-Dark já instalado."
fi

# --- 3. ÍCONES WHITESUR ---
echo ""
echo ">>> 3. Ícones WhiteSur"
echo ""

ICON_DIRS="/usr/share/icons $HOME/.icons $HOME/.local/share/icons"
WS_ICONS=""
for d in $ICON_DIRS; do
    [ -d "$d/WhiteSur" ] && WS_ICONS="yes" && break
done

if [ -z "$WS_ICONS" ]; then
    echo "    Instalando WhiteSur Icon Theme..."
    TMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git "$TMP_DIR/WhiteSur-icon-theme"
    "$TMP_DIR/WhiteSur-icon-theme/install.sh"
    rm -rf "$TMP_DIR"
    echo "    ✓ Ícones instalados!"
else
    echo "    WhiteSur Icon Theme já instalado."
fi

# --- 4. GTK via arquivo (apps GTK no Wayland) ---
echo ""
echo ">>> 4. Configurando GTK3/GTK4 e variáveis de ambiente"
echo ""

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/environment.d"

cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=WhiteSur-Dark
gtk-icon-theme-name=WhiteSur
gtk-cursor-theme-name=$CURSOR_NAME
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

cat > "$HOME/.config/gtk-4.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=WhiteSur-Dark
gtk-icon-theme-name=WhiteSur
gtk-cursor-theme-name=$CURSOR_NAME
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

# Vars de sessão (Electron, X11-on-Wayland)
cat > "$HOME/.config/environment.d/90-dotfile-cursor.conf" <<EOF
XCURSOR_THEME=$CURSOR_NAME
XCURSOR_SIZE=24
GTK_THEME=WhiteSur-Dark
EOF

# gsettings funciona mesmo no Hyprland se o schema GNOME estiver instalado
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"   2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"       2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size 24              2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"  2>/dev/null || true
fi

echo "    ✓ GTK configurado!"
echo ""

# --- 5. LINKAR CONFIGS DO REPOSITÓRIO → ~/.config/ ---
echo ">>> 5. Linkando configs (hypr, waybar, rofi, dunst, hyprlock)"
echo ""

link_config() {
    local src="$CONFIG_SRC/$1"
    local dst="$HOME/.config/$1"
    [ -d "$src" ] || { echo "    (sem $1 no repo)"; return; }
    # Backup se existir e não for link
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
        echo "    (backup: ${dst}.bak.*)"
    fi
    ln -sfn "$src" "$dst"
    echo "    ✓ ~/.config/$1 → $src"
}

link_config hypr
link_config kitty
link_config waybar
link_config rofi
link_config dunst
link_config hyprlock

echo ""
echo "=============================================="
echo "  ✅ Pronto!"
echo "=============================================="
echo ""
echo "  Inicie o Hyprland: exec Hyprland"
echo "  Layout do teclado: edite cachyos-hyprland/config/hypr/hyprland.conf → kb_layout"
echo "  Wallpaper: edite cachyos-hyprland/config/hypr/hyprpaper.conf"
echo ""
