# Checklist — Antes de formatar o PC

## O que salvar ANTES de formatar

### 1. Dotfiles no GitHub ✓
```bash
cd ~/Documents/Projeto/dotfiles
git init
git add .
git commit -m "Setup Zorin completo"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/dotfiles.git
git push -u origin main
```

### 2. Backup manual (copie para pendrive/nuvem)
- [ ] **Senhas/credenciais** — exporte do gerenciador de senhas
- [ ] **Chaves SSH** — `~/.ssh/` (se usar git/GitHub)
- [ ] **Bookmarks do navegador** — Firefox sincroniza; ou exporte
- [ ] **Projetos/código** — push no GitHub/GitLab antes

### 3. Não precisa salvar (já está nos dotfiles)
- ✓ Tema, cursor, ícones, botões
- ✓ Lista de apps
- ✓ Scripts de instalação

---

## Depois de instalar o Zorin no PC novo

```bash
# 1. Clone os dotfiles
git clone https://github.com/SEU_USUARIO/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Rode o setup completo
./scripts/setup-novo-pc.sh

# 3. Logout e login
```

## Atualizar depois (puxar alterações)

```bash
cd ~/dotfiles
./scripts/pull-e-aplicar.sh
```

Puxa do GitHub e reaplica a config automaticamente.

---

## O que pode faltar (configure depois)

| Item | Como resolver |
|------|---------------|
| **SSH/Git** | `ssh-keygen` e adicione a chave no GitHub |
| **Zorin Taskbar** | Extension Manager → instalar Zorin Taskbar |
| **Wallpaper** | Coloque em `~/.config/wallpaper.png` |
| **Contas** | Login no Discord, VS Code, Firefox, etc. |
