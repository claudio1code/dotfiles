# --- HOMEBREW (Configuração da 42 - goinfre) ---
# eval "$($HOME/goinfre/.brew/bin/brew shellenv)"

# --- ZINIT (Gerenciador de Plugins) ---
source ~/.local/share/zinit/zinit.git/zinit.zsh

# Plugins essenciais
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Adiciona o diretório local de binários ao PATH
export PATH="$PATH:$HOME/.local/bin"

# --- CONFIGURAÇÃO DAS FERRAMENTAS MODERNAS ---

# 1. Zoxide (CD Inteligente)
eval "$(zoxide init zsh)"

# 2. Aliases (Apelidos - Atualizado para EZA)
alias cat='bat --paging=never'
alias ls='eza --icons'
alias l='eza -l --icons'
alias la='eza -la --icons'
# Atalho para abrir o guia pessoal
alias guia='bat ~/.guia.md'

# --- FZF (Busca Rápida) ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- OH MY POSH (Tema Kushal) ---
# Baixa o tema automaticamente se ele não existir
if [ ! -f ~/.poshthemes/kushal.omp.json ]; then
    mkdir -p ~/.poshthemes
    curl -L https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/kushal.omp.json -o ~/.poshthemes/kushal.omp.json
fi

# Carrega o prompt
eval "$(oh-my-posh init zsh --config ~/.poshthemes/kushal.omp.json)"

# --- OH MY POSH (Mantenha essa linha onde ela já estava) ---
eval "$(oh-my-posh init zsh --config ~/.poshthemes/kushal.omp.json)"

# --- Configuração do GEMINI (Mods) ---
# ALIASES (Corrigidos para modelos aceitos pelo Mods)

# 1. gpro: Vamos usar o 2.0 Flash (é o mais moderno da lista que ele aceita)
alias gpro='mods --api google --model gemini-2.0-flash-001 --no-cache'

# 2. gflash: Vamos usar o 1.5 Flash (super leve e estável)
alias gflash='mods --api google --model gemini-1.5-flash-latest --no-cache'

# 3. gemini-ui: O comando padrão
alias gemini-ui='mods --api google --model gemini-2.0-flash-001 --no-cache'

# Configuração do Aider (Para usar Gemini)
export AIDER_MODEL="gemini/gemini-2.0-flash-001"

# NVM (Node) - Corrigido

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Navegação palavra por palavra com Ctrl + Setas
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
