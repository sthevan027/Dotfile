#!/usr/bin/env bash
# Reaplica tema, ícones, cursor e botões (gsettings + dconf + GTK + ambiente).
# Rode após instalar temas ou quando algo não "grudar".

set -euo pipefail

echo "Restaurando aparência (WhiteSur + Vision-Black + botões à direita)..."

CURSOR_DIR="${HOME}/.local/share/icons"
CURSOR_NAME="Vision-Black"
[[ -d "${CURSOR_DIR}/Vision-black" ]] && CURSOR_NAME="Vision-black"

fix_vision_index_theme() {
  local f="${CURSOR_DIR}/${CURSOR_NAME}/index.theme"
  [[ -f "$f" ]] || return 0
  sed -i 's/^Inherits=.*/Inherits=hicolor/' "$f" 2>/dev/null || true
}

if [[ -d "${CURSOR_DIR}/${CURSOR_NAME}" ]]; then
  fix_vision_index_theme
  mkdir -p "${HOME}/.icons"
  ln -sfn "${CURSOR_DIR}/${CURSOR_NAME}" "${HOME}/.icons/${CURSOR_NAME}"
fi

# --- GTK / GNOME ---
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME"
gsettings set org.gnome.desktop.interface cursor-size 24

dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/cursor-theme "'${CURSOR_NAME}'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/cursor-size "uint32 24" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/button-layout "':minimize,maximize,close'" 2>/dev/null || true

# --- GTK3/GTK4 via arquivo (apps que não leem só o gsettings) ---
mkdir -p "${HOME}/.config/gtk-3.0" "${HOME}/.config/gtk-4.0" "${HOME}/.config/environment.d"

cat > "${HOME}/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=WhiteSur-Dark
gtk-icon-theme-name=WhiteSur
gtk-cursor-theme-name=${CURSOR_NAME}
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

cat > "${HOME}/.config/gtk-4.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=WhiteSur-Dark
gtk-icon-theme-name=WhiteSur
gtk-cursor-theme-name=${CURSOR_NAME}
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

# --- Electron / VS Code / Cursor: leem XCURSOR_* no arranque da sessão ---
cat > "${HOME}/.config/environment.d/90-dotfile-cursor.conf" <<EOF
XCURSOR_THEME=${CURSOR_NAME}
XCURSOR_SIZE=24
EOF

echo "✓ Feito."
if [[ ! -d "${CURSOR_DIR}/${CURSOR_NAME}" ]]; then
  echo "  ⚠ Cursor ${CURSOR_NAME} não encontrado — rode: bash fedora-gnome/scripts/gnome-complete.sh"
else
  echo "  → Faça LOGOUT e login para o ponteiro mudar em apps Electron."
fi
echo "  → Apps Libadwaita ignoram WhiteSur nas janelas; mantêm escuro via color-scheme."
