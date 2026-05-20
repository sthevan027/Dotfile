#!/usr/bin/env bash
# Apps CachyOS/Niri: capturar instalados → meus-apps.txt | instalar a partir do arquivo
# Uso: bash cachyos-niri/scripts/apps.sh capturar | instalar

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APPS_FILE="$REPO_ROOT/meus-apps.txt"

have() { command -v "$1" >/dev/null 2>&1; }

cmd="${1:-}"

aur_helper() {
  if have paru; then echo "paru"
  elif have yay; then echo "yay"
  else echo ""; fi
}

capturar() {
  echo "Capturando apps instalados..."
  {
    echo "# Apps instalados — $(date '+%Y-%m-%d')"
    echo "# Edite e rode: bash cachyos-niri/scripts/apps.sh instalar"
    echo ""
    echo "=== PACMAN ==="
    pacman -Qqe 2>/dev/null | sort
    echo ""
    echo "=== FLATPAK ==="
    flatpak list --app --columns=application 2>/dev/null | tail -n +1
  } > "$APPS_FILE"
  echo "✓ Salvo em: $APPS_FILE"
}

instalar() {
  [ ! -f "$APPS_FILE" ] && echo "Arquivo $APPS_FILE não encontrado. Rode: bash cachyos-niri/scripts/apps.sh capturar" && exit 1

  AUR="$(aur_helper)"
  echo "Instalando apps de $APPS_FILE..."
  echo ""

  pacman_pkgs=$(awk '/^=== PACMAN ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
  if [ -n "$pacman_pkgs" ]; then
    echo ">>> Pacman/AUR..."
    if [ -n "$AUR" ]; then
      echo "$pacman_pkgs" | xargs "$AUR" -S --noconfirm 2>/dev/null || true
    else
      echo "$pacman_pkgs" | xargs sudo pacman -S --noconfirm --needed 2>/dev/null || true
      echo "  ⚠ Nenhum helper AUR encontrado (paru/yay). Pacotes AUR precisam ser instalados manualmente."
    fi
  fi

  flatpak_ids=$(awk '/^=== FLATPAK ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
  if [ -n "$flatpak_ids" ] && have flatpak; then
    echo ""
    echo ">>> Flatpak..."
    for id in $flatpak_ids; do
      flatpak install -y flathub "$id" 2>/dev/null || flatpak install -y "$id" 2>/dev/null || echo "  (pulando $id)"
    done
  fi

  echo ""
  echo "✓ Concluído!"
}

case "$cmd" in
  capturar) capturar ;;
  instalar) instalar ;;
  *)
    echo "Uso: $0 capturar | instalar"
    exit 1
    ;;
esac
