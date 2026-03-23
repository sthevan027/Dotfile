#!/bin/bash
# Restaura a configuração salva (config-snapshot.md)
# Rode: ./scripts/restaurar-config.sh

echo "Restaurando configuração Zorin..."

gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
gsettings set org.gnome.desktop.interface cursor-theme "Vision-Black"
gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"

echo "✓ Configuração restaurada!"
echo "  (Se algum tema não existir, rode ./scripts/zorin-complete.sh antes)"
