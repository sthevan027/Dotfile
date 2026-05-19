#!/usr/bin/env bash
# Configura atalhos de teclado GNOME para workspaces, fechar janelas e abrir apps.
# Uso: bash fedora-gnome/scripts/gnome-shortcuts.sh

set -e

command -v gsettings >/dev/null 2>&1 || {
  echo "Erro: 'gsettings' não encontrado. Este script requer GNOME." >&2
  exit 1
}

# Super+1..9 → trocar workspace
for i in {1..9}; do
  gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-${i}" "['<Super>${i}']"
  gsettings set org.gnome.shell.keybindings "switch-to-application-${i}" "[]"
done

# Fechar janela com Super+c
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>c']"

# Indicador visual de workspaces (WorkNavigator, se instalado)
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

custom_list="["
for p in "${CUSTOM_PATHS[@]}"; do
  custom_list+="'$p', "
done
custom_list="${custom_list%, } ]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_list"

set_custom() {
  local path="$1" name="$2" command="$3" binding="$4"
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
  Super+1..9    → mudar workspace
  Super+c       → fechar janela ativa
  Shift+Alt+s   → printscreen
  Super+t       → terminal (zsh)
  Super+w       → Warp
  Super+z       → Zed
  Super+m       → Firefox
EOF
