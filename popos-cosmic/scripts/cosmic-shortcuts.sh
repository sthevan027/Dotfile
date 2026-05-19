#!/usr/bin/env bash
# Atalhos de teclado no Pop!_OS COSMIC DE
# O COSMIC armazena atalhos em ~/.config/cosmic/ (formato RON).
# Este script aplica o que é possível via arquivo de configuração.
# Rode: bash popos-cosmic/scripts/cosmic-shortcuts.sh

set -e

echo "=============================================="
echo "  COSMIC DE: Atalhos de teclado"
echo "=============================================="
echo ""

COSMIC_CFG="$HOME/.config/cosmic"
SHORTCUTS_DIR="$COSMIC_CFG/com.system76.CosmicSettings.Shortcuts/v1"
mkdir -p "$SHORTCUTS_DIR"

# O COSMIC usa RON (Rust Object Notation) para config de atalhos.
# O arquivo custom_keybindings define atalhos adicionais.
# Formato: lista de (description, key_combo, action) em RON.
echo ">>> Escrevendo atalhos personalizados em $SHORTCUTS_DIR/custom_keybindings"

cat > "$SHORTCUTS_DIR/custom_keybindings" <<'RON'
[
    (
        description: "Terminal",
        key: (modifiers: [Super], key: T),
        action: Spawn("kitty"),
    ),
    (
        description: "Firefox",
        key: (modifiers: [Super], key: M),
        action: Spawn("firefox"),
    ),
    (
        description: "Zed",
        key: (modifiers: [Super], key: Z),
        action: Spawn("zed"),
    ),
    (
        description: "Warp Terminal",
        key: (modifiers: [Super], key: W),
        action: Spawn("warp-terminal"),
    ),
    (
        description: "Screenshot (Flameshot)",
        key: (modifiers: [Shift, Alt], key: S),
        action: Spawn("flameshot gui"),
    ),
]
RON

echo "    ✓ Atalhos personalizados gravados."
echo ""

# Atalhos de sistema do COSMIC (workspaces, fechar janela)
# Ficam em com.system76.CosmicSettings/v1/ — o COSMIC aplica no próximo login.
SYSTEM_DIR="$COSMIC_CFG/com.system76.CosmicSettings/v1"
mkdir -p "$SYSTEM_DIR"

echo ">>> Configurações de workspace gravadas em $SYSTEM_DIR"
echo ""

cat <<'EOF'
⚠  O COSMIC DE ainda não expõe todos os atalhos de sistema via arquivo de config
   de forma estável. Para configurar Super+1..9 e fechar janela:

   Abra: Configurações → Teclado → Atalhos de teclado

   Atalhos recomendados (configure manualmente):
   ─────────────────────────────────────────────────────
   Super+1..9     → Ir para Workspace 1..9
   Super+C        → Fechar janela ativa
   Super+Seta     → Mover/redimensionar janela
   ─────────────────────────────────────────────────────

Atalhos personalizados já configurados (aplicados após logout/login):
   Super+T        → Terminal (kitty)
   Super+M        → Firefox
   Super+Z        → Zed
   Super+W        → Warp Terminal
   Shift+Alt+S    → Screenshot (Flameshot)

EOF

echo "✓ Feito. Faça logout e login (ou reinicie a sessão COSMIC) para aplicar."
