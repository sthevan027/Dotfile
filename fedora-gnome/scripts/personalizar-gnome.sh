#!/usr/bin/env bash
# Personalizações GNOME no Fedora: cantos quentes, fontes, cursor,
# extensão "nome no canto", e opcionalmente Dash to Panel.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
EXT_UUID="user-corner-label@dotfile.local"
EXT_SRC="$REPO_ROOT/extensions/$EXT_UUID"
EXT_DST="$HOME/.local/share/gnome-shell/extensions/$EXT_UUID"
SCHEMA_DIR="$EXT_DST/schemas"

CORNER_LABEL="${CORNER_LABEL:-$USER}"

INSTALAR_DTP=false
BARRA_INFERIOR_JANELAS=false
for arg in "$@"; do
  case "$arg" in
    --instalar-dash-to-panel) INSTALAR_DTP=true ;;
    --barra-inferior-janelas) BARRA_INFERIOR_JANELAS=true ;;
    -h|--help)
      echo "Uso: $0 [--instalar-dash-to-panel] [--barra-inferior-janelas]"
      echo "  --instalar-dash-to-panel   Tenta baixar Dash to Panel (EGO)."
      echo "  --barra-inferior-janelas   Ativa a extensão oficial «Window list» (lista em baixo)."
      exit 0
      ;;
  esac
done

fontes_de_code() {
  python3 - <<'PY'
import json, os
paths = [
    os.path.expanduser("~/.config/Code/User/settings.json"),
    os.path.expanduser("~/.var/app/com.visualstudio.code/config/Code/User/settings.json"),
]
fam, size = "JetBrains Mono", "14"
for p in paths:
    if not os.path.isfile(p):
        continue
    try:
        with open(p, encoding="utf-8") as f:
            d = json.load(f)
        fam = d.get("editor.fontFamily", fam).strip().strip("'\"")
        if "editor.fontSize" in d:
            size = str(int(float(d["editor.fontSize"])))
        break
    except (OSError, json.JSONDecodeError, TypeError, ValueError):
        pass
print(f"{fam} {size}")
PY
}

echo ">>> Cantos quentes: ativar"
gsettings set org.gnome.desktop.interface enable-hot-corners true

MONO="$(fontes_de_code)"
echo ">>> Fontes: mono como no VS Code → $MONO ; interface Adwaita Sans 11"
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 11'
gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name "$MONO"

echo ">>> Cursor"
if [[ -d "$HOME/.local/share/icons/Vision-Black" ]] || [[ -d "$HOME/.local/share/icons/Vision-black" ]]; then
  echo "    Vision-Black encontrado — mantendo (alinhado com gnome-complete / restaurar-config)."
  bash "$SCRIPT_DIR/restaurar-config.sh" 2>/dev/null || true
else
  echo "    Vision-Black não encontrado — instalando Bibata (pacote Fedora) como alternativa."
  if ! rpm -q bibata-cursor-theme &>/dev/null && ! rpm -q bibata-cursor-themes &>/dev/null; then
    sudo dnf install -y bibata-cursor-theme 2>/dev/null || sudo dnf install -y bibata-cursor-themes 2>/dev/null || true
  fi
  if [[ -d /usr/share/icons/Bibata-Modern-Classic ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
  elif [[ -d /usr/share/icons/Bibata-Modern-Ice ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
  fi
  gsettings set org.gnome.desktop.interface cursor-size 24
  echo "    Para usar Vision-Black: bash fedora-gnome/scripts/gnome-complete.sh"
fi

echo ">>> Extensão «$EXT_UUID» (nome/ícone no canto esquerdo da barra)"
mkdir -p "$HOME/.local/share/gnome-shell/extensions"
rm -rf "$EXT_DST"
cp -a "$EXT_SRC" "$EXT_DST"
glib-compile-schemas "$SCHEMA_DIR"

GSET=(gsettings --schemadir "$SCHEMA_DIR")
"${GSET[@]}" set "org.gnome.shell.extensions.user-corner-label" display-text "$CORNER_LABEL"
"${GSET[@]}" set "org.gnome.shell.extensions.user-corner-label" show-icon true
"${GSET[@]}" set "org.gnome.shell.extensions.user-corner-label" show-text true

if command -v gnome-extensions &>/dev/null; then
  gnome-extensions enable "$EXT_UUID" 2>/dev/null || true
fi

if $BARRA_INFERIOR_JANELAS; then
  echo ">>> Window list (barra inferior com janelas do workspace atual)"
  gsettings set org.gnome.shell.extensions.window-list display-all-workspaces false
  command -v gnome-extensions &>/dev/null && gnome-extensions enable "window-list@gnome-shell-extensions.gcampax.github.com" 2>/dev/null || true
fi

install_dash_to_panel() {
  command -v curl &>/dev/null || { echo "curl não encontrado."; return 1; }
  local major zip rel
  major=$(gnome-shell --version 2>/dev/null | sed -E 's/.* ([0-9]+)\..*/\1/') || true
  [[ -z "${major:-}" ]] && major=49
  echo "    Procurando pacote compatível com GNOME Shell $major..."
  rel=$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=dash-to-panel@jderose9.github.com&shell_version=${major}" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin).get("download_url") or "")') || true
  if [[ -z "$rel" ]]; then
    echo "    Não há build para Shell $major. Abra: https://extensions.gnome.org/extension/1160/dash-to-panel/"
    return 1
  fi
  zip="$(mktemp --suffix=.zip)"
  curl -fsSL "https://extensions.gnome.org${rel}" -o "$zip"
  gnome-extensions install --force "$zip"
  rm -f "$zip"
  gnome-extensions enable "dash-to-panel@jderose9.github.com"
  echo "    ✓ Dash to Panel instalado."
}

if $INSTALAR_DTP; then
  echo ">>> Dash to Panel (apps na barra superior)"
  command -v gnome-extensions &>/dev/null && install_dash_to_panel || true
else
  echo ""
  echo "Para ícones/nomes das janelas na barra superior, rode:"
  echo "  $0 --instalar-dash-to-panel"
fi

echo ""
echo "✓ Feito. Se a extensão nova não aparecer, faça logout ou Alt+F2 → r → Enter."
echo "  Só ícone:  gsettings --schemadir \"$SCHEMA_DIR\" set org.gnome.shell.extensions.user-corner-label show-text false"
echo "  Só texto:  gsettings --schemadir \"$SCHEMA_DIR\" set org.gnome.shell.extensions.user-corner-label show-icon false"
