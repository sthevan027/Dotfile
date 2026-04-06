#!/usr/bin/env bash
# Instala Oh My Zsh, Powerlevel10k, plugins e copia ~/.zshrc e ~/.p10k.zsh.
# Uso: na raiz do repositório: ./scripts/aplicar-shell.sh
# Requer: git, curl. Tenta instalar zsh (e opcionalmente jq, neofetch) via apt, brew, dnf ou pacman.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SHELL_DIR="$REPO_ROOT/shell"

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

have() { command -v "$1" >/dev/null 2>&1; }

die() {
  echo "Erro: $*" >&2
  exit 1
}

[[ -f "$SHELL_DIR/.zshrc" && -f "$SHELL_DIR/.p10k.zsh" ]] || die "Arquivos em shell/ não encontrados (esperado $SHELL_DIR/.zshrc e .p10k.zsh)."

echo "=============================================="
echo "  Shell — zsh + Oh My Zsh + Powerlevel10k"
echo "=============================================="
echo ""

if ! have zsh; then
  echo ">>> zsh não encontrado; tentando instalar..."
  if have apt-get; then
    sudo apt-get update -qq
    sudo apt-get install -y zsh
  elif have brew; then
    brew install zsh
  elif have dnf; then
    sudo dnf install -y zsh
  elif have pacman; then
    sudo pacman -Sy --needed --noconfirm zsh
  else
    die "Instale zsh manualmente e rode este script de novo."
  fi
fi

if ! have git || ! have curl; then
  echo ">>> Instalando git e curl..."
  if have apt-get; then
    sudo apt-get install -y git curl
  elif have brew; then
    have git || brew install git
    have curl || brew install curl
  elif have dnf; then
    sudo dnf install -y git curl
  elif have pacman; then
    sudo pacman -Sy --needed --noconfirm git curl
  else
    die "Precisa de git e curl no PATH."
  fi
fi

# Opcionais (neofetch/jq usados pelo .zshrc)
if have apt-get; then
  ! have jq && sudo apt-get install -y jq 2>/dev/null || true
  ! have neofetch && sudo apt-get install -y neofetch 2>/dev/null || true
elif have dnf; then
  ! have jq && sudo dnf install -y jq 2>/dev/null || true
  ! have neofetch && sudo dnf install -y neofetch 2>/dev/null || true
elif have brew; then
  have jq || brew install jq 2>/dev/null || true
  have neofetch || brew install neofetch 2>/dev/null || true
fi

clone_or_update() {
  local url="$1" dest="$2"
  if [[ -d "$dest/.git" ]]; then
    echo ">>> Atualizando $(basename "$dest")..."
    git -C "$dest" pull --ff-only 2>/dev/null || true
  else
    rm -rf "$dest"
    echo ">>> Clonando $(basename "$dest")..."
    git clone --depth=1 "$url" "$dest"
  fi
}

if [[ ! -d "$ZSH" ]]; then
  echo ">>> Instalando Oh My Zsh (sem alterar o shell padrão agora)..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo ">>> Oh My Zsh já existe em $ZSH"
fi

mkdir -p "$ZSH_CUSTOM/themes" "$ZSH_CUSTOM/plugins"

clone_or_update "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"
clone_or_update "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

backup_if_exists() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  local bak="${f}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$f" "$bak"
  echo "  (backup: $bak)"
}

echo ""
echo ">>> Copiando ~/.zshrc e ~/.p10k.zsh a partir do repositório..."
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.p10k.zsh"
cp "$SHELL_DIR/.zshrc" "$HOME/.zshrc"
cp "$SHELL_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

echo ""
echo "=============================================="
echo "  Concluído"
echo "=============================================="
echo ""
echo "  Abra um novo terminal ou rode:  exec zsh"
echo ""
if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  ZSH_PATH="$(command -v zsh || true)"
  if [[ -n "$ZSH_PATH" ]]; then
    echo "  Para deixar zsh como shell padrão:"
    echo "    chsh -s $ZSH_PATH"
    echo ""
  fi
fi
echo "  Fonte recomendada para ícones do p10k: MesloLGS (veja README do powerlevel10k)."
echo ""
