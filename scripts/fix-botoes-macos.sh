#!/bin/bash
# Força aplicação dos botões estilo macOS no Zorin
# Rode se os botões não aparecerem após zorin-complete.sh

echo "Aplicando botões estilo macOS..."

# 1. Botões à esquerda (fechar, minimizar, maximizar)
gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"

# 2. Tema WhiteSur
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"

# 3. dconf (backup para Zorin)
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'" 2>/dev/null
dconf write /org/gnome/desktop/wm/preferences/theme "'WhiteSur-Dark'" 2>/dev/null
dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'" 2>/dev/null

echo ""
echo "✓ Aplicado!"
echo ""
echo "Se ainda não mudar:"
echo "  1. Abra 'Aparência' (menu do sistema)"
echo "  2. Em 'Estilo das janelas', escolha 'WhiteSur-Dark'"
echo ""
echo "  Ou instale gnome-tweaks e mude em Aparência > Temas:"
echo "    sudo apt install gnome-tweaks"
echo ""
