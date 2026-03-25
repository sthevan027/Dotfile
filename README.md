# 🖥️ Meu Setup Zorin

Configuração atual do meu Linux (Zorin OS): cursor Windows 11 black, botões estilo macOS, ícones, aplicativos na barra.

**PC novo?** Clone e rode: `./scripts/setup-novo-pc.sh`

**Terminal (zsh + p10k) em qualquer máquina:** `./scripts/aplicar-shell.sh`

---

## ✨ O que está ativo

| Item | Status |
|------|--------|
| **Cursor** | Windows 11 Black (Vision / Aero) |
| **Botões de janela** | Estilo macOS (vermelho, amarelo, verde à esquerda) |
| **Ícones** | WhiteSur — estilo macOS (squircle) |
| **Barra superior** | Zorin Taskbar — apps abertos visíveis |
| **Shell** | zsh, Oh My Zsh, Powerlevel10k (ver `shell/`) |

---

## 🖲️ Terminal (zsh)

Configuração versionada em `shell/.zshrc` e `shell/.p10k.zsh`. O script instala Oh My Zsh, o tema Powerlevel10k e os plugins `zsh-autosuggestions` e `zsh-syntax-highlighting`, depois copia os arquivos para o seu home (com backup `.bak.*` se já existirem).

```bash
cd dotfiles
./scripts/aplicar-shell.sh
exec zsh
```

Em máquina nova sem zsh como padrão: `chsh -s "$(command -v zsh)"` (faça logout/login depois).

---

## 🚀 Aplicar (instalação limpa)

```bash
cd dotfiles
./scripts/zorin-complete.sh
```

Se os botões Mac não aparecerem:
```bash
./scripts/fix-botoes-macos.sh
```

---

## 📁 Estrutura

```
dotfiles/
├── shell/
│   ├── .zshrc                 # zsh (fonte para ~/ .zshrc)
│   └── .p10k.zsh              # Powerlevel10k
├── scripts/
│   ├── aplicar-shell.sh       # zsh + OMZ + p10k + plugins (qualquer máquina)
│   ├── zorin-complete.sh      # Tudo: taskbar + cursor + botões Mac
│   ├── zorin-aero-macos.sh    # Só cursor + botões Mac
│   ├── fix-botoes-macos.sh    # Corrigir botões se não aplicar
│   └── icones-macos.sh        # Só ícones estilo macOS
├── meus-apps.txt              # Lista de apps (edite e rode instalar-apps.sh)
├── scripts/capturar-apps.sh   # Captura apps instalados
├── scripts/instalar-apps.sh   # Instala apps da lista
├── gtk/README.md              # Detalhes cursor e WhiteSur
└── README.md
```

---

## 📸 Configuração salva

- `config-snapshot.md` — estado atual (desktop Zorin)
- `shell/` — terminal zsh + p10k
- `CHECKLIST.md` — o que fazer antes de formatar + setup no PC novo

## 🔄 Atualizar (puxar do GitHub)

```bash
./scripts/pull-e-aplicar.sh
```

Puxa as alterações e reaplica a configuração.

---

## 🚀 Subir no GitHub (antes de formatar)

```bash
git init
git add .
git commit -m "Setup Zorin"
git remote add origin https://github.com/SEU_USER/dotfiles.git
git branch -M main
git push -u origin main
```

---

## 🗄️ Arquivo i3 (não uso)

As pastas `i3/`, `polybar/`, `picom/` ficam em `archive/` — configuração do rice i3 caso queira voltar no futuro.
