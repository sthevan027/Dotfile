#!/usr/bin/env bash
# Reaplica tema, ícones, cursor e botões (gsettings + dconf + GTK + ambiente).
# Rode após instalar temas ou quando algo não “grudar” (especialmente Cursor/Electron).

set -euo pipefail

echo "Restaurando aparência (WhiteSur + Vision-Black + botões à direita)..."

CURSOR_DIR="${HOME}/.local/share/icons"
CURSOR_NAME="Vision-Black"
[[ -d "${CURSOR_DIR}/Vision-black" ]] && CURSOR_NAME="Vision-black"

# Corrige index.theme do Vision (Inherits com aspas quebra alguns leitores)
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

# --- GTK / GNOME (janelas nativas, Nautilus, etc.) ---
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

# --- GTK3/GTK4 em ficheiro (ajuda apps que não leem só o gsettings) ---
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

# --- Electron / Cursor / VS Code: leem XCURSOR_* no arranque da sessão ---
cat > "${HOME}/.config/environment.d/90-dotfile-cursor.conf" <<EOF
XCURSOR_THEME=${CURSOR_NAME}
XCURSOR_SIZE=24
EOF

echo "✓ Feito."
if [[ ! -d "${CURSOR_DIR}/${CURSOR_NAME}" ]]; then
  echo "  ⚠ Pasta ${CURSOR_DIR}/${CURSOR_NAME} não existe — corre: ./scripts/gnome-complete.sh (secção do cursor)"
else
  echo "  → Faz LOGOUT e login (ou reinicia) para o ponteiro mudar dentro do Cursor e outras apps Electron."
fi
echo "  → Cursor/VS Code usam interface própria: o tema GTK não pinta a barra do editor; o ponteiro deve alinhar após re-login."
echo "  → Apps Libadwaita podem ignorar WhiteSur nas janelas; mantêm escuro com color-scheme."
