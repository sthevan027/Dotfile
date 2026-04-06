# Dotfiles — GNOME + shell

Cursor Windows 11 black (Vision-Black), botões da janela à direita, ícones WhiteSur, extensão de barra (Zorin Taskbar no Zorin; em outras distros use Extension Manager), shell zsh + Powerlevel10k.

| Situação | Comando |
|----------|---------|
| **PC novo (GNOME)** | `./scripts/setup-novo-pc.sh` |
| **Só terminal (qualquer Linux/macOS)** | `./scripts/aplicar-shell.sh` |
| **Só tema / barra / cursor** | `./scripts/gnome-complete.sh` |
| **Atalhos (workspaces Super+1..9, etc.)** | `./scripts/gnome-shortcuts.sh` |
| **Reaplicar cores/tema sem reinstalar nada** | `./scripts/restaurar-config.sh` |
| **Puxar do Git e reaplicar** | `./scripts/pull-e-aplicar.sh` (use `--shell` para zsh também) |
| **Lista de apps** | `./scripts/apps.sh capturar` → editar `meus-apps.txt` → `./scripts/apps.sh instalar` |

---

## Terminal (zsh)

Arquivos em `shell/.zshrc` e `shell/.p10k.zsh`. O script instala Oh My Zsh, Powerlevel10k e plugins, copia para o home (com backup `.bak.*`).

```bash
cd dotfiles
./scripts/aplicar-shell.sh
exec zsh
```

Shell padrão: `chsh -s "$(command -v zsh)"` (logout/login).

---

## Estrutura

```
dotfiles/
├── shell/                    # .zshrc + .p10k.zsh (fonte)
├── scripts/
│   ├── setup-novo-pc.sh      # atualiza sistema + apps + GNOME + gsettings + shell
│   ├── gnome-complete.sh     # extensões de barra + cursor + WhiteSur GTK + ícones
│   ├── gnome-shortcuts.sh    # atalhos gsettings (workspaces, apps)
│   ├── restaurar-config.sh   # só gsettings/dconf (rápido)
│   ├── aplicar-shell.sh      # zsh em qualquer máquina
│   ├── apps.sh               # capturar | instalar (meus-apps.txt)
│   └── pull-e-aplicar.sh     # git pull + restaurar-config [--shell]
├── meus-apps.txt
└── README.md
```

---

## GitHub

```bash
git add .
git commit -m "Atualiza dotfiles"
git push -u origin main
```
