#!/bin/bash
# Setup completo para PC novo com GNOME (Ubuntu, Fedora Workstation, Zorin, etc.)
# Clone do repositório e rode: ./scripts/setup-novo-pc.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=============================================="
echo "  Setup — PC novo (GNOME)"
echo "=============================================="
echo ""

# 1. Atualizar sistema
echo ">>> 1. Atualizando sistema..."
if command -v apt &>/dev/null; then
  sudo apt update && sudo apt upgrade -y
elif command -v dnf &>/dev/null; then
  sudo dnf update -y
else
  echo "⚠ Não foi detectado apt ou dnf. Atualize manualmente."
fi
echo ""

# 2. Instalar apps
echo ">>> 2. Instalando apps (lista meus-apps.txt)..."
./scripts/apps.sh instalar
echo ""

# 3. Aparência GNOME (cursor, botões, ícones, extensões de barra quando aplicável)
echo ">>> 3. Aplicando aparência (cursor, botões à direita, ícones)..."
./scripts/gnome-complete.sh
echo ""

# 4. Restaurar gsettings
echo ">>> 4. Restaurando configurações..."
./scripts/restaurar-config.sh
echo ""

# 5. Shell (zsh + Powerlevel10k)
echo ">>> 5. Aplicando shell (zsh + p10k)..."
./scripts/aplicar-shell.sh
echo ""

echo "=============================================="
echo "  ✅ Setup concluído!"
echo "=============================================="
echo ""
echo "  Faça logout e login para aplicar tudo."
echo "  Barra com apps abertos: no Zorin use Zorin Taskbar; em outras distros, Extension Manager (ex.: Dash to Panel)."
echo "  Atalhos extras: ./scripts/gnome-shortcuts.sh"
echo ""
