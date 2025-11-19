# dotfiles
Terminal custumizado e com ferramentas de produção

# 🚀 Ultimate Terminal Setup (Dotfiles)

![License](https://img.shields.io/github/license/claudio1code/dotfiles?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-Zsh-blue?style=flat-square&logo=zsh)
![Environment](https://img.shields.io/badge/Environment-42%20SP%20%7C%20Linux%20%7C%20WSL-success?style=flat-square)

Configuração completa e automatizada para transformar o terminal em um ambiente de desenvolvimento moderno, rápido e produtivo.

Este setup foi desenhado para funcionar tanto em **ambientes pessoais** (Linux/WSL) quanto no **ambiente da 42** (gerenciando permissões e quota no `goinfre`).

## ⚡ Instalação Rápida do Terminal

Abra seu terminal e rode este comando. O script fará todo o resto.

```bash
sh -c "$(curl -fsSL [https://raw.githubusercontent.com/claudio1code/dotfiles/main/install.sh](https://raw.githubusercontent.com/claudio1code/dotfiles/main/install.sh))"
```

### O que o `install.sh` faz?

Este script automatiza a instalação e configuração de um ambiente de terminal Zsh completo. Ele irá:

- **Instalar o Homebrew:** Gerenciador de pacotes para macOS e Linux.
- **Instalar Ferramentas Modernas:** `eza`, `bat`, `zoxide`, `fzf`, `oh-my-posh`.
- **Configurar o Ambiente Node.js:** Instala `nvm` e a CLI do Gemini.
- **Instalar Fontes:** Baixa e instala a `Meslo Nerd Font` para ícones no terminal.
- **Gerar o `.zshrc`:** Cria um arquivo de configuração `.zshrc` que ativa todas as ferramentas e plugins.

---

---

## 🔄 Atualizando a Configuração

Para receber as últimas atualizações deste repositório, siga os passos abaixo:

1.  **Navegue até o diretório local dos dotfiles:**
    ```bash
    cd <caminho_para_seu_repositorio_dotfiles>
    ```
2.  **Puxe as últimas alterações do GitHub:**
    ```bash
    git pull
    ```
3.  **Execute o script de instalação novamente para aplicar as mudanças:**
    ```bash
    sh install.sh
    ```

---

## ⚙️ Configuração do Vim

Esta configuração (`.vimrc`) transforma o Vim padrão em um editor de código mais amigável e poderoso.

### Instalação Rápida do Vim

Use este comando para baixar o arquivo `.vimrc` para sua pasta de usuário:

```bash
curl -o ~/.vimrc https://raw.githubusercontent.com/claudio1code/dotfiles/main/.vimrc
```

**Importante:** Após baixar o `.vimrc`, abra o Vim e execute o comando `:PlugInstall` para instalar os plugins.

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
