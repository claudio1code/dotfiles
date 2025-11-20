# dotfiles
Terminal custumizado e com ferramentas de produção

# 🚀 Ultimate Terminal Setup (Dotfiles)

![License](https://img.shields.io/github/license/claudio1code/dotfiles?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-Zsh-blue?style=flat-square&logo=zsh)
![Environment](https://img.shields.io/badge/Environment-42%20SP%20%7C%20Linux%20%7C%20WSL-success?style=flat-square)

Configuração completa e automatizada para transformar o terminal em um ambiente de desenvolvimento moderno, rápido e produtivo.

Este setup foi desenhado para funcionar tanto em **ambientes pessoais** (Linux/WSL) quanto no **ambiente da 42** (gerenciando permissões e quota no `goinfre`).

## ⚡ Instalação Rápida

Abra seu terminal e rode este comando. O script fará todo o resto.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/claudio1code/dotfiles/main/install.sh)"
```

## 🔄 Como Atualizar

Para atualizar sua configuração com as últimas mudanças do repositório, rode o seguinte comando no seu terminal:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/claudio1code/dotfiles/main/update.sh)"
```

---

## O que está incluso?

Este setup irá clonar o repositório para `~/.dotfiles` e configurar as seguintes ferramentas:

- **Homebrew:** Gerenciador de pacotes para macOS e Linux.
- **Ferramentas Modernas:** `eza`, `bat`, `zoxide`, `fzf`, `oh-my-posh`.
- **Ambiente Node.js:** Instala `nvm` e a CLI do Gemini.
- **Fontes:** Baixa e instala a `Meslo Nerd Font` para ícones no terminal.
- **Zsh com Zinit:** Um ambiente de shell rápido com autocompletar e syntax highlighting.
- **Configuração do Vim:** Transforma o Vim em um editor de código mais amigável e poderoso com plugins essenciais.
- **Guia de Atalhos:** Um guia rápido (`guia`) com os principais atalhos e comandos.

---
## ⚙️ Configuração do Vim

Se você quer apenas a configuração do Vim, sem o resto do ambiente, pode usar este comando:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/claudio1code/dotfiles/main/install_vim.sh)"
```

Isso irá:
- Clonar o repositório (se ainda não existir).
- Instalar o `vim-plug` (gerenciador de plugins).
- Criar o link simbólico para o seu `.vimrc`.

**Importante:** Após a instalação, abra o Vim e execute o comando `:PlugInstall` para instalar os plugins.
