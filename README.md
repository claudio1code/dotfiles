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
sh -c "$(curl -fsSL [https://raw.githubusercontent.com/claudio1code/dotfiles/main/install.sh](https://raw.githubusercontent.com/claudio1code/dotfiles/main/install.sh))"
```

### O que o `install.sh` faz?

Este script automatiza a instalação e configuração de um ambiente de terminal Zsh completo. Ele irá:

- **Instalar o Homebrew:** Gerenciador de pacotes para macOS e Linux.
- **Instalar Ferramentas Modernas:**
  - `eza`: Um substituto moderno para o `ls` com ícones e cores.
  - `bat`: Um substituto para o `cat` com syntax highlighting.
  - `zoxide`: Um navegador de diretórios inteligente que aprende seus hábitos.
  - `fzf`: Uma ferramenta de busca "fuzzy" para arquivos e histórico de comandos.
  - `oh-my-posh`: Um motor de temas para o prompt do terminal.
- **Configurar o Ambiente Node.js:** Instala o `nvm` para gerenciar versões do Node.js e instala a CLI do Gemini.
- **Instalar Fontes:** Baixa e instala a `Meslo Nerd Font`, necessária para os ícones do prompt.
- **Gerar o `.zshrc`:** Cria um arquivo de configuração `.zshrc` que ativa todas as ferramentas, plugins (como auto-sugestões e syntax highlighting) e aliases.

---

## Configuração do Vim

Para uma configuração detalhada e separada do Vim, incluindo um guia de atalhos, veja nosso guia completo:

[➡️ **Guia de Configuração do Vim**](./VIM_SETUP.md)