#!/usr/bin/env bash
# Configura atalhos de teclado GNOME para workspaces, fechar janelas e abrir apps.
# Uso: ./scripts/gnome-shortcuts.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Erro: '$1' não encontrado. Instale-o para executar este script." >&2
    exit 1
  }
}

require gsettings

# Workspaces Super+1..9
for i in {1..9}; do
  key="switch-to-workspace-${i}"
  gsettings set org.gnome.desktop.wm.keybindings "$key" "['<Super>${i}']"
  gsettings set org.gnome.shell.keybindings "switch-to-application-${i}" "[]"
done

# Fechar janela com Super+c
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>c']"

# Ativar indicador visual de workspaces com números
if gnome-extensions info WorkNavigator@opalaayan-git >/dev/null 2>&1; then
  gnome-extensions enable WorkNavigator@opalaayan-git >/dev/null 2>&1 || true
  if gsettings writable org.gnome.shell.extensions.worknavigator panel-position >/dev/null 2>&1; then
    gsettings set org.gnome.shell.extensions.worknavigator panel-position "'left'"
    gsettings set org.gnome.shell.extensions.worknavigator show-background true
    gsettings set org.gnome.shell.extensions.worknavigator show-plus-button false
  fi
fi

# Printscreen com Shift+Alt+s
if gsettings writable org.gnome.settings-daemon.plugins.media-keys screenshot >/dev/null 2>&1; then
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot "['<Shift><Alt>s']"
fi

# Custom shortcuts para abrir apps
CUSTOM_BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
CUSTOM_PATHS=(
  "${CUSTOM_BASE}/custom0/"
  "${CUSTOM_BASE}/custom1/"
  "${CUSTOM_BASE}/custom2/"
  "${CUSTOM_BASE}/custom3/"
)

# Definir lista de custom keybindings
custom_list="["
for p in "${CUSTOM_PATHS[@]}"; do
  custom_list+="'$p', "
done
custom_list="${custom_list%, } ]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_list"

set_custom() {
  local path="$1"
  local name="$2"
  local command="$3"
  local binding="$4"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" name "$name"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" command "$command"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" binding "$binding"
}

set_custom "${CUSTOM_PATHS[0]}" "Terminal ZSH" "gnome-terminal -- zsh" "<Super>t"
set_custom "${CUSTOM_PATHS[1]}" "Warp" "warp" "<Super>w"
set_custom "${CUSTOM_PATHS[2]}" "Zed" "zed" "<Super>z"
set_custom "${CUSTOM_PATHS[3]}" "Firefox" "firefox" "<Super>m"

cat <<'EOF'
✓ Atalhos GNOME configurados:
  - Super+1..9 → mudar workspace
  - Super+c   → fechar janela ativa
  - Shift+Super+s → printscreen
  - Super+t   → abrir terminal
  - Super+w   → abrir Warp
  - Super+z   → abrir Zed
  - Super+m   → abrir Firefox
EOF
