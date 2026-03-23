# 🎨 GTK — Cursor Aero e Botões Estilo macOS

Instruções para aplicar o cursor Aero e os botões de janela (fechar, minimizar, maximizar) no estilo macOS.

**No Zorin (sem mudar o sistema):**

Script completo (aplicativos na barra + cursor Win11 + botões Mac):
```bash
./scripts/zorin-complete.sh
```

Ou só cursor + botões Mac: `./scripts/zorin-aero-macos.sh`

---

## 🖱️ Cursor Aero

O cursor Aero é o estilo clássico do Windows Vista/7 — suave e com sombra.

### Ubuntu / Debian / Zorin

```bash
# Instalar pacote de cursores (inclui variantes tipo Aero)
sudo apt install dmz-cursor-theme

# Ou para tema mais parecido com Aero:
sudo apt install comixcursors
```

### Alternativa: Manual (tema Aero-like)

1. Baixe um tema de cursor no [Gnome Look](https://www.gnome-look.org/browse/cat/107/)
2. Extraia em `~/.local/share/icons/` ou `~/.icons/`
3. O nome da pasta será o nome do tema

### Configurar o cursor

**Opção 1 — Via dconf (recomendado):**

```bash
# Listar temas disponíveis
ls /usr/share/icons/ | grep -i cursor
ls ~/.local/share/icons/ | grep -i cursor

# Aplicar (ex: dmz-white ou ComixCursors)
gsettings set org.gnome.desktop.interface cursor-theme "dmz-white"
gsettings set org.gnome.desktop.interface cursor-size 24
```

**Opção 2 — Via arquivo:**

Crie ou edite `~/.config/gtk-3.0/settings.ini`:

```ini
[Settings]
gtk-cursor-theme-name = dmz-white
gtk-cursor-theme-size = 24
gtk-cursor-blink-time = 1200
```

Para X11, adicione em `~/.Xresources`:

```
Xcursor.theme: dmz-white
Xcursor.size: 24
```

Depois execute: `xrdb ~/.Xresources`

**Reinicie o X (logout/login) para aplicar.**

---

## 🔘 Botões Estilo macOS

Os botões (fechar, minimizar, maximizar) no estilo macOS ficam à **esquerda** e têm cores:
- **Vermelho** — fechar
- **Amarelo** — minimizar  
- **Verde** — maximizar

### Tema GTK recomendado: WhiteSur ou McMojave

```bash
# Clone o WhiteSur (tema macOS-like para GTK)
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh -c Dark -c Light

# Aplicar
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark"
```

**McMojave (alternativa):**

```bash
git clone https://github.com/vinceliuice/McMojave-kde.git
# Ou use o pacote do seu distro, se disponível
```

### Aplicar tema manualmente

```bash
# GTK
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"

# Ícones (opcional)
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"

# Cursor (junto com Aero ou similar)
gsettings set org.gnome.desktop.interface cursor-theme "dmz-white"
```

---

## 📋 Resumo — Comandos rápidos

```bash
# Cursor
gsettings set org.gnome.desktop.interface cursor-theme "dmz-white"
gsettings set org.gnome.desktop.interface cursor-size 24

# Tema macOS (após instalar WhiteSur)
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
```

---

**Nota:** No i3, as janelas tiling geralmente não mostram barra de título com botões. Os temas acima afetam aplicativos com decorações de janela (GTK, Electron, etc.) e janelas flutuantes.
