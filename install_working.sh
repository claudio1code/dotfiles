#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -e "${BLUE}🔧 Instalação Funcional - Setup que Realmente Funciona${NC}"
echo -e "${YELLOW}Configuração prática para Bash e Zsh${NC}"

# Criar estrutura básica
echo -e "${BLUE}📁 Criando estrutura...${NC}"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/fonts"
mkdir -p "$HOME/.vim/autoload"

# Configuração BASH (funciona imediatamente)
echo -e "${BLUE}🔧 Configurando Bash...${NC}"
cat > "$HOME/.bashrc_custom" << 'EOF'
# Configuração Custom Bash
export PATH="$HOME/.local/bin:$PATH"

# Histórico melhorado
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
HISTCONTROL=ignoreboth

# Cores
export LS_COLORS='di=34:fi=0:ln=35:pi=33:so=33:ex=31:bd=34;46:cd=34;43:or=33;01:*.tar=31:*.tgz=31:*.zip=31:*.gz=31:*.bz2=31:*.deb=31:*.rpm=31:*.jpg=35:*.png=35:*.gif=35:*.bmp=35:*.tif=35:'

# Aliases úteis
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ç='clear'
alias c='clear'
alias h='history'
alias j='jobs -l'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Funções
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Exports
export EDITOR='vim'
export PAGER='less'
export LESS='-R'

# Prompt customizado
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

EOF

# Configuração ZSH (quando mudar)
echo -e "${BLUE}🔧 Configurando Zsh...${NC}"
cat > "$HOME/.zshrc" << 'EOF'
# Configuração Zsh Funcional
export PATH="$HOME/.local/bin:$PATH"

# Histórico
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Autocompleção
autoload -U compinit
compinit

# Prompt simples e funcional
autoload -U colors
colors
PROMPT='%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ '

# Aliases
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ç='clear'
alias c='clear'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Funções
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Exports
export EDITOR='vim'
export PAGER='less'
export LESS='-R'

EOF

# Configuração Vim
echo -e "${BLUE}🔧 Configurando Vim...${NC}"
cat > "$HOME/.vimrc" << 'EOF'
" Configuração Vim Funcional
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
set backspace=indent,eol,start
set mouse=a

" Cores
syntax on
set background=dark
if has("gui_running")
    colorscheme default
else
    colorscheme default
endif

" Mapeamentos
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>s :split<CR>
nnoremap <leader>v :vsplit<CR>

" Busca
set ignorecase
set smartcase
set gdefault

" Status line
set statusline=%f         " caminho do arquivo
set statusline+=%m        " modificado
set statusline+=%r        " somente leitura
set statusline+=%h        " help
set statusline+=%w        " preview
set statusline+=%=        " separador
set statusline+=%y        " tipo de arquivo
set statusline+=\ %l/%L   " linha
set statusline+=\ %c      " coluna
set statusline+=\ %P      " percentual

EOF

# Vim-plug
echo -e "${BLUE}🔌 Instalando Vim-plug...${NC}"
curl -sL -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || echo "⚠️  Vim-plug falhou (opcional)"

# Scripts úteis
echo -e "${BLUE}📜 Criando scripts...${NC}"

# Update
cat > "$HOME/.local/bin/update_dotfiles" << 'EOF'
#!/bin/bash
cd ~/dotfiles
git pull 2>/dev/null || echo "⚠️  Sem conexão ou sem mudanças"
echo "✅ Dotfiles verificados!"
EOF
chmod +x "$HOME/.local/bin/update_dotfiles"

# Limpeza
cat > "$HOME/.local/bin/clean_cache" << 'EOF'
#!/bin/bash
echo "🧹 Limpando cache..."
rm -rf ~/.cache/* 2>/dev/null || true
rm -rf ~/.local/share/Trash/* 2>/dev/null || true
echo "✅ Cache limpo!"
EOF
chmod +x "$HOME/.local/bin/clean_cache"

# Info sistema
cat > "$HOME/.local/bin/sysinfo" << 'EOF'
#!/bin/bash
echo "🖥️  Info do Sistema:"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
echo "Memória: $(free -h | grep Mem)"
echo "Disco: $(df -h ~ | tail -1)"
echo "Shell: $SHELL"
EOF
chmod +x "$HOME/.local/bin/sysinfo"

# Adicionar ao bashrc atual
echo -e "${BLUE}🔧 Integrando com Bash atual...${NC}"
if ! grep -q ".bashrc_custom" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Custom dotfiles" >> "$HOME/.bashrc"
    echo "source ~/.bashrc_custom" >> "$HOME/.bashrc"
fi

# Mudar shell para Zsh (opcional)
echo -e "${BLUE}🔄 Configurando shell...${NC}"
if command -v zsh &> /dev/null; then
    echo "✅ Zsh encontrado"
    echo "Para mudar para Zsh permanentemente, execute:"
    echo "  chsh -s \$(which zsh)"
    echo "Depois abra novo terminal"
else
    echo "⚠️  Zsh não encontrado. Instale com:"
    echo "  sudo apt install zsh"
fi

echo -e "\n${GREEN}✅ Instalação Funcional Concluída!${NC}"
echo -e "${YELLOW}📝 O que foi configurado:${NC}"
echo -e "✅ Bash customizado (funciona AGORA)"
echo -e "✅ Zsh configurado (quando mudar)"
echo -e "✅ Vim funcional"
echo -e "✅ Scripts úteis"
echo -e "✅ Cores e aliases"

echo -e "\n${YELLOW}🚀 Para testar AGORA (no Bash):${NC}"
echo -e "1. Recarregue: ${BLUE}source ~/.bashrc${NC}"
echo -e "2. Teste: ${BLUE}la${NC} (listar arquivos colorido)"
echo -e "3. Teste: ${BLUE}mkcd teste${NC} (criar e entrar na pasta)"
echo -e "4. Teste: ${BLUE}sysinfo${NC} (info do sistema)"
echo -e "5. Teste: ${BLUE}clean_cache${NC} (limpar cache)"

echo -e "\n${YELLOW}🔧 Para mudar para Zsh (opcional):${NC}"
echo -e "1. Execute: ${BLUE}chsh -s \$(which zsh)${NC}"
echo -e "2. Feche e abra terminal"
echo -e "3. Aproveite o Zsh configurado!"

echo -e "\n${GREEN}🎉 Funciona offline, rápido e prático!${NC}"
