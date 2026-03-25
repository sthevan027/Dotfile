# Meu setup Zorin

Cursor Windows 11 black (Vision-Black), botões estilo macOS, ícones WhiteSur, Zorin Taskbar, shell zsh + Powerlevel10k.

| Situação | Comando |
|----------|---------|
| **PC novo (Zorin)** | `./scripts/setup-novo-pc.sh` |
| **Só terminal (qualquer Linux/macOS)** | `./scripts/aplicar-shell.sh` |
| **Só tema / barra / cursor** | `./scripts/zorin-complete.sh` |
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
│   ├── setup-novo-pc.sh      # apt upgrade + apps + Zorin + gsettings + shell
│   ├── zorin-complete.sh     # Taskbar + Vision cursor + WhiteSur GTK + ícones
│   ├── restaurar-config.sh   # Só gsettings/dconf (rápido)
│   ├── aplicar-shell.sh      # zsh em qualquer máquina
│   ├── apps.sh               # capturar | instalar (meus-apps.txt)
│   └── pull-e-aplicar.sh     # git pull + restaurar-config [--shell]
├── meus-apps.txt
├── config-snapshot.md        # Resumo do visual atual
├── CHECKLIST.md              # Antes de formatar / depois do install
└── README.md
```

---

## GitHub

```bash
git add .
git commit -m "Atualiza dotfiles"
git push -u origin main
```
