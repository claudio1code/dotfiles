# --- CONFIGURAÇÃO BÁSICA ---
export PATH="$HOME/.local/bin:$HOME/.local/bin/scripts:$PATH"

# ZINIT (Gerenciador de Plugins)
source ~/.local/share/zinit/zinit.git/zinit.zsh
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Zoxide (CD Inteligente)
eval "$(zoxide init zsh)"

# --- ALIASES ---
alias cat='bat --paging=never'
alias ls='eza --icons'
alias l='eza -l --icons'
alias la='eza -la --icons'
alias ç='clear'
alias guia='bat ~/.guia.md'
alias vim='nvim'
alias vi='nvim'
alias vimguia='bat ~/vim_cheatsheet.md'
alias norm='norminette'

# Francinette (Ajuste o caminho se necessário)
alias francinette=~/francinette/tester.sh
alias paco=~/francinette/tester.sh

# --- ESTILO DO PROMPT (Dracula + Git) ---
autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst

# Configuração do Git
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%F{#bd93f9}%b%f%F{#50fa7b}%u%f%F{#8be9fd}%a%f%F{#ff5555}%m%f'
precmd() { vcs_info }

# Prompt (Com quebra de linha)
PS1=$'%B%F{#ff79c6}╭─%F{#50fa7b}%n@%m %F{#bd93f9}%2~%F{#ff79c6}]%f%b ${vcs_info_msg_0_}%B%(?..[%F{#ff5555}%?%f])%b\n%F{#50fa7b}╰─➤%f '
export RPROMPT='%F{#8be9fd}%*%f'

# --- HISTÓRICO ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory hist_ignore_dups hist_ignore_space

# --- FERRAMENTAS EXTRAS ---
# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM (Node)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# --- INTELIGÊNCIA ARTIFICIAL ---
# Carrega segredos (Crie um arquivo .env para colocar suas chaves!)
[ -f ~/.env ] && source ~/.env

export AIDER_MODEL="gemini/gemini-2.0-flash-001"

# Aliases Mods
alias gpro='mods --api google --model gemini-2.0-flash-001 --no-cache'
alias gflash='mods --api google --model gemini-1.5-flash-latest --no-cache'
alias gemini-ui='mods --api google --model gemini-2.0-flash-001 --no-cache'

# Função gcommit (Commits Automáticos)
gcommit() {
    if git diff --cached --quiet; then
        echo "⚠️  Nada estagiado para commit."
        return 1
    fi
    echo "🤖 Lendo alterações..."
    DIFF_CONTENT=$(git diff --cached)
    PROMPT="INSTRUÇÃO: Aja apenas como um formatador de texto.
    TAREFA: Escreva uma mensagem de commit (Conventional Commits) baseada APENAS no texto abaixo.
    REGRAS: Retorne APENAS a string da mensagem final.
    TEXTO DE ENTRADA (DIFF): $DIFF_CONTENT"
    
    echo "🤖 Gerando sugestão..."
    SUGESTAO=$(gemini-ui "$PROMPT")
    
    echo -e "\n----------------------------------------"
    echo -e "Sugestão: \033[1;32m$SUGESTAO\033[0m"
    echo -e "----------------------------------------\n"
    
    echo -n "Usar essa mensagem? [y/N] "
    read resp
    if [[ "$resp" =~ ^[Yy]$ ]]; then
        git commit -m "$SUGESTAO"
    else
        echo "Cancelado."
    fi
}

# Keybindings (Ctrl+Setas)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
