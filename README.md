# dotfiles
Terminal custumizado e com ferramentas de produção

# 🚀 Ultimate Terminal Setup (Dotfiles)

![License](https://img.shields.io/github/license/claudio1code/dotfiles?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-Zsh-blue?style=flat-square&logo=zsh)
![Environment](https://img.shields.io/badge/Environment-42%20SP%20%7C%20Linux%20%7C%20WSL-success?style=flat-square)

# 🚀 Ultimate Terminal Setup (Dotfiles)

![License](https://img.shields.io/github/license/claudio1code/dotfiles?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-Zsh-blue?style=flat-square&logo=zsh)
![Environment](https://img.shields.io/badge/Environment-42%20SP%20%7C%20Linux%20%7C%20WSL-success?style=flat-square)

Configuração de terminal otimizada para estudantes da **42**, usuários de **Linux** e **WSL**.

Este setup transforma um terminal padrão num ambiente de desenvolvimento moderno, rápido e com **IA integrada**, projetado especificamente para funcionar sem permissões de administrador (`sudo`) e sem estourar cotas de disco.

---

---

## ⚡ Instalação Rápida

Abra o seu terminal e rode este comando único. O script detectará o seu ambiente e instalará tudo localmente na sua pasta de usuário.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/claudio1code/dotfiles/main/install.sh)"
```

---

## 🔄 Como Atualizar

Para atualizar sua configuração com as últimas mudanças do repositório:

```bash
bash ~/dotfiles/update.sh
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

## ⚙️ Configuração do Vim

Se você quer apenas a configuração do Vim, sem o resto do ambiente, pode usar este comando:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/claudio1code/dotfiles/main/install_vim.sh)"
```

### Pós-Instalação (Configuração Inicial)

Após a instalação terminar, siga estes 3 passos rápidos:

**1. Carregue o novo terminal:**
```bash
source ~/.zshrc
```

**2. Ative a IA (Login):** Na primeira vez que usar, o Gemini precisa conectar na sua conta Google. Rode o comando abaixo e siga as instruções no navegador:
```bash
gemini
```

**3. Instale os Plugins do Vim:** Abra o Vim e digite o comando de instalação:
```vim
:PlugInstall
```

---

## ✨ Principais Funcionalidades

### 🤖 Inteligência Artificial Nativa (Gemini CLI)
O terminal vem equipado com a CLI oficial do Google Gemini (`@google/gemini-cli`).
- **Chat Interativo:** Discuta código, lógica e arquitetura sem sair do terminal.
- **Agente de Arquivos:** A IA pode ler, analisar e (se solicitado) editar os seus ficheiros.
- **Comando:** `gemini`

### ⚡ Navegação & Ferramentas Modernas
Substituímos os comandos antigos por versões modernas e rápidas:
- **`z` (Zoxide):** Um `cd` inteligente. Pule para pastas profundas digitando apenas parte do nome (ex: `z push`).
- **`ls` (Eza):** Listagem de ficheiros com ícones, cores e indicadores de Git.
- **`cat` (Bat):** Visualizador de ficheiros com syntax highlighting e numeração de linhas.
- **`ctrl+r` (FZF):** Busca fuzzy no histórico de comandos.
- **`ctrl+t` (FZF):** Busca fuzzy de ficheiros instantânea.

### 🎨 Visual & Shell
- **Oh My Posh:** Tema `kushal` configurado para mostrar status do Git, versão do Node/C/Go e tempo de execução.
- **Zinit:** Gerenciador de plugins ultra-rápido.
- **Fontes:** Instalação automática da *Meslo Nerd Font* para suporte a ícones.

### 🛠️ Editor (Vim "Turbinado")
O Vim já vem configurado como uma IDE leve:
- **Plugins:** NERDTree, Airline, Dracula Theme, MuComplete.
- **Atalhos:** `Ctrl+n` para abrir a árvore de ficheiros.

---

## 📂 Estrutura do Projeto

- **`install.sh`:** O cérebro da operação. Instala binários (Eza, Bat, Zoxide) em `~/.local/bin`, configura NVM/Node e a CLI do Gemini. Não usa Homebrew (para evitar problemas de dependência na 42).
- **`.zshrc`:** Configuração do Shell, aliases, carregamento do NVM e plugins Zinit.
- **`.vimrc`:** Configuração do editor e lista de plugins.
- **`.poshthemes/`:** Temas do Oh My Posh.
- **`guia.md`:** Um "cheat sheet" rápido instalado na sua home. Acesse digitando `guia`.

---

## ⚠️ Compatibilidade

Este kit foi desenhado especificamente para:

- **42 School (Goinfre/Home):** Instala tudo em modo utilizador (user space), respeitando cotas e sem exigir root.
- **Linux (Ubuntu/Debian/Arch):** Funciona em qualquer distro x86_64.
- **WSL (Windows Subsystem for Linux):** Funciona perfeitamente.

**Nota:** Atualmente o script baixa binários pré-compilados para Linux. Para usar em macOS, é necessário adaptar a função de download.

## 📜 Licença

MIT License © 2025 Claudio
