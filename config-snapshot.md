# Snapshot da configuração — Zorin

Salvo em: 23/03/2026

## Setup atual

| Item | Valor |
|------|-------|
| **Tema GTK** | WhiteSur-Dark |
| **Tema janelas** | WhiteSur-Dark |
| **Ícones** | WhiteSur |
| **Cursor** | Vision-Black (Windows 11 black) |
| **Botões** | close,minimize,maximize: (à esquerda, estilo Mac) |
| **Barra** | Zorin Taskbar |

## Aplicar em sistema novo

```bash
cd dotfiles
./scripts/zorin-complete.sh
```

## Scripts

| Script | Função |
|--------|--------|
| `zorin-complete.sh` | Setup completo |
| `restaurar-config.sh` | Aplicar config salva (após instalar temas) |
| `zorin-aero-macos.sh` | Cursor + botões Mac |
| `icones-macos.sh` | Só ícones WhiteSur |
| `fix-botoes-macos.sh` | Corrigir botões |

## Extensões GNOME

- **Zorin Taskbar** — apps abertos na barra

## Dependências

- WhiteSur GTK theme
- WhiteSur Icon theme
- Vision Cursor (ou DMZ-Black)
- Extension Manager (para Zorin Taskbar)
