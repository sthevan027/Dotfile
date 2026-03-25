#!/usr/bin/env bash
# Reaplica tema, ícones, cursor e botões (gsettings + dconf, para Zorin pegar tudo).
# Rode após instalar temas ou quando algo não “grudar” na interface.

echo "Restaurando aparência (WhiteSur + Vision-Black + botões Mac)..."

gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
gsettings set org.gnome.desktop.interface cursor-theme "Vision-Black"
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"

dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/theme "'WhiteSur-Dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur'" 2>/dev/null || true
dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'" 2>/dev/null || true

echo "✓ Feito."
echo "  Se algo não mudar: Configurações → Aparência ou gnome-tweaks."
echo "  Sem temas instalados: ./scripts/zorin-complete.sh"
