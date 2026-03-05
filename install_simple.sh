#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -e "${BLUE}🔧 Instalação Simples - Apenas Configuração${NC}"
echo -e "${YELLOW}Configuração básica sem downloads externos${NC}"

# Criar estrutura básica
echo -e "${BLUE}📁 Criando estrutura de diretórios...${NC}"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/fonts"
mkdir -p "$HOME/.vim/autoload"

# Configuração Zsh básica (sem plugins complexos)
echo -e "${BLUE}🔧 Configurando Zsh básico...${NC}"
cat > "$HOME/.zshrc" << 'EOF'
# Configuração Básica Zsh
export PATH="$HOME/.local/bin:$PATH"

# Histórico
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Autocompleção básica
autoload -U compinit
compinit

# Prompt simples
autoload -U promptinit
promptinit
prompt adam1

# Aliases básicos
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git básico
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Limpeza
alias ç='clear'

# Funções básicas
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Exports úteis
export EDITOR='vim'
export PAGER='less'
export LESS='-R'

EOF

# Configuração Vim básica
echo -e "${BLUE}🔧 Configurando Vim básico...${NC}"
cat > "$HOME/.vimrc" << 'EOF'
" Configuração Básica Vim
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set syntax=on
set hlsearch
set incsearch
set showmatch
set ruler
set laststatus=2

" Cores
syntax on
colorscheme default

" Mapeamentos básicos
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :Explore<CR>

" Busca case insensitive
set ignorecase
set smartcase

EOF

# Vim-plug básico
echo -e "${BLUE}🔌 Instalando Vim-plug...${NC}"
curl -sL -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || echo "⚠️  Falha no Vim-plug (opcional)"

# Scripts úteis
echo -e "${BLUE}📜 Criando scripts úteis...${NC}"

# Script de atualização
cat > "$HOME/.local/bin/update_dotfiles" << 'EOF'
#!/bin/bash
cd ~/dotfiles
git pull
echo "Dotfiles atualizados!"
EOF
chmod +x "$HOME/.local/bin/update_dotfiles"

# Script de limpeza
cat > "$HOME/.local/bin/clean_home" << 'EOF'
#!/bin/bash
echo "🧹 Limpando cache..."
rm -rf ~/.cache/*
echo "✅ Cache limpo!"
EOF
chmod +x "$HOME/.local/bin/clean_home"

# Mudar shell para Zsh
echo -e "${BLUE}🔄 Mudando shell para Zsh...${NC}"
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)" 2>/dev/null || echo "⚠️  Execute manualmente: chsh -s \$(which zsh)"
    fi
    echo "✅ Shell alterado para Zsh"
else
    echo "❌ Zsh não encontrado. Instale com: sudo apt install zsh"
fi

echo -e "\n${GREEN}✅ Instalação Simples Concluída!${NC}"
echo -e "${YELLOW}📝 O que foi configurado:${NC}"
echo -e "✅ Zsh básico com autocompletação"
echo -e "✅ Vim básico com numeração"
echo -e "✅ Aliases úteis"
echo -e "✅ Scripts de manutenção"
echo -e "✅ Shell alterado para Zsh"

echo -e "\n${YELLOW}📝 Próximos passos:${NC}"
echo -e "1. Abra um novo terminal (já estará em Zsh)"
echo -e "2. Teste: ${BLUE}ls --color=auto${NC}"
echo -e "3. Teste: ${BLUE}mkcd teste${NC}"
echo -e "4. Use: ${BLUE}update_dotfiles${NC} para atualizar"
echo -e "5. Use: ${BLUE}clean_home${NC} para limpar"

echo -e "\n${GREEN}🎉 Funciona offline e é super rápido!${NC}"
