# Claudio's Dotfiles 🚀

Configuração rápida e portátil para **Linux**, **WSL** e **42 School** (sem necessidade de root/sudo).

## 📥 Instalação Passo a Passo

Abra o terminal e rode:

```bash
# 1. Clone o repositório
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles

# 2. Entre na pasta e instale
cd ~/dotfiles
bash install.sh
```

## ⚙️ Configuração Inicial

Após o script terminar:

1. **Recarregue as configurações:**
   ```bash
   source ~/.zshrc
   ```

2. **Configure a Fonte (Visual):**
   Para os ícones aparecerem, mude a fonte do seu terminal (VSCode, iTerm, Alacritty) para **MesloLGS NF**.

3. **Login na IA (Opcional):**
   Se for usar o Gemini, faça login na primeira vez:
   ```bash
   gemini login
   ```

## 📖 Comandos Rápidos

| Comando | O que faz |
| :--- | :--- |
| `update_dotfiles` | **Atualiza** todo o ambiente (git pull + install) |
| `z <nome>` | Navegação inteligente (ex: `z proj`) |
| `ls` | Listar arquivos com ícones |
| `cat <arq>` | Ler arquivo com cores |
| `guia` | Ver todos os atalhos |
| `gemini` | Chat rápido com IA |

### Vim
| Atalho | Ação |
| :--- | :--- |
| `Ctrl + n` | Abrir/Fechar barra lateral |
| `:PlugInstall` | Instalar plugins (se faltar algo) |