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

Esta configuração (`.vimrc`) transforma o Vim padrão em um editor de código mais amigável e poderoso.

**Importante:** Após a instalação, abra o Vim e execute o comando `:PlugInstall` para instalar os plugins.

### O que o `.vimrc` faz?

- **Adiciona Plugins Essenciais** com o `vim-plug`:
  - `NERDTree`: Uma árvore de arquivos lateral (atalho: `Ctrl + n`).
  - `vim-airline`: Uma barra de status moderna e informativa.
  - `dracula/vim`: Um tema de cores agradável e popular.
  - `vim-mucomplete`: Um sistema de autocompletar leve.
- **Melhora a Experiência de Edição:** Ativa números de linha, syntax highlighting, auto-indentação, `Tab` com 4 espaços e "undo" persistente.
- **Facilita a Navegação:** Melhora buscas e habilita o uso do mouse.

### Guia de Atalhos Essenciais do Vim

- **Modos:** `i` (Inserção), `v` (Visual), `<ESC>` (Normal).
- **Navegação:** `h`, `j`, `k`, `l`, `w` (palavra), `b` (palavra anterior), `gg` (início do arq), `G` (fim do arq).
- **Edição:** `x` (apagar), `dd` (apagar linha), `yy` (copiar linha), `p` (colar), `u` (desfazer).
- **Comandos:** `:w` (salvar), `:q` (sair), `:wq` (salvar e sair), `:q!` (sair sem salvar).
- **Splits:** `:vsplit arquivo` (vertical), `:split arquivo` (horizontal), `<C-w> + hjkl` (navegar).
- **Busca:** `/palavra`.
- **Substituição:** `:%s/antigo/novo/g`.
