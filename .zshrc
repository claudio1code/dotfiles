# --- HOMEBREW ---
# Detecta onde o brew está instalado (42 vs Casa)
if [ -d "$HOME/goinfre/.brew" ]; then
    eval "$($HOME/goinfre/.brew/bin/brew shellenv)"
elif [ -d "$HOME/.brew" ]; then
    eval "$($HOME/.brew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$( /home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- ZSH HISTORY ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory hist_ignore_dups

# --- ZINIT ---
source ~/.local/share/zinit/zinit.git/zinit.zsh
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# --- FERRAMENTAS ---
eval "$(zoxide init zsh)"

# Aliases
alias cat='bat --paging=never'
alias ls='eza --icons'
alias l='eza -l --icons'
alias la='eza -la --icons'
alias guia='bat ~/.guia.md'

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM (Node)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- OH MY POSH ---
eval "$(oh-my-posh init zsh --config ~/.poshthemes/kushal.omp.json)"
