# --- CONFIGURAÇÃO INTELIGENTE DO HOMEBREW ---
# Verifica se existe instalação local (42/Sem Root)
if [ -d "$HOME/.brew/bin" ]; then
    export PATH="$HOME/.brew/bin:$PATH"
    eval "$($HOME/.brew/bin/brew shellenv)"
# Verifica instalação padrão do Linux
elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Verifica macOS (Apple Silicon)
elif [ -d "/opt/homebrew/bin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- CONFIGURAÇÃO BÁSICA ---
export PATH="$HOME/.local/bin:$HOME/.local/bin/scripts:$PATH"

# NVM (Node)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

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
PS1=$'%B%F{#50fa7b}╭─%n@%m %F{#ff5555}[%F{#bd93f9}%2~%F{#ff5555}]%f%b ${vcs_info_msg_0_}%B%(?..[%F{#ff5555}%?%f])%b\n%F{#50fa7b}╰─➤%f '
export RPROMPT='%F{#8be9fd}%*%f'

# --- HISTÓRICO ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory hist_ignore_dups hist_ignore_space

# --- FERRAMENTAS EXTRAS ---
# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- INTELIGÊNCIA ARTIFICIAL (Gemini CLI Oficial) ---

# Carrega variáveis sensíveis (API KEY)
[ -f ~/.env ] && source ~/.env
# --- Gemini CLI (robusto para 42 / NVM) ---
unalias gemini 2>/dev/null

gemini() {
  nvm use 20 >/dev/null 2>&1

  # garante que o binário do node ativo está no PATH
  export PATH="$NVM_BIN:$PATH"

  command gemini "$@"
}


# --- gcommit: Commits Automáticos com Gemini ---
gcommit() {
    # Verifica se há algo estagiado
    if git diff --cached --quiet; then
        echo "⚠️  Nada estagiado para commit."
        return 1
    fi

    echo "🤖 Lendo alterações..."
    DIFF_CONTENT="$(git diff --cached)"

    PROMPT=$(cat <<'EOF'
Você é um gerador de mensagens de commit.

Regras:
- Use o padrão Conventional Commits
- Seja claro e conciso
- Retorne APENAS a mensagem final
- Não use markdown
- Não explique nada
- Commita só em português

Diff:
EOF
)
    PROMPT="$PROMPT
$DIFF_CONTENT"

    echo "🤖 Gerando sugestão com Gemini..."
    SUGESTAO="$(printf "%s" "$PROMPT" | gemini)"

    if [ -z "$SUGESTAO" ]; then
        echo "❌ Falha ao gerar mensagem"
        return 1
    fi

    echo
    echo "Sugestão:"
    echo "----------------------------------------"
    echo "$SUGESTAO"
    echo "----------------------------------------"
    echo

    echo -n "Usar essa mensagem? [y/N] "
    read resp
    if [[ "$resp" =~ ^[Yy]$ ]]; then
        git commit -m "$SUGESTAO"
    else
        echo "Cancelado."
    fi
}
