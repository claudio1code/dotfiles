
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
alias ç='clear'
alias la='eza -la --icons'
# Atalho para abrir o guia pessoal
alias guia='bat ~/.guia.md'

# --- FZF (Busca Rápida) ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- INÍCIO DO ESTILO ---
autoload -U colors && colors
autoload -Uz vcs_info

# Configuração visual do Git (branch e ícones)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%F{#bd93f9}%b%f%F{#50fa7b}%u%f%F{#8be9fd}%a%f%F{#ff5555}%m%f'

# 1. Permite que variáveis (como a do Git) funcionem dentro do prompt
setopt prompt_subst

# 2. Configurações do Git
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%F{#bd93f9}%b%f%F{#50fa7b}%u%f%F{#8be9fd}%a%f%F{#ff5555}%m%f'

# Função necessária para atualizar o git a cada comando
precmd() { vcs_info }

# Relógio do lado direito (cor azul claro)
export RPROMPT='%F{#8be9fd}%*%f'

# O Prompt Principal (Usuário, Host, Pasta e Cores estilo Dracula)
PS1=$'%B%F{#ff79c6}[%F{#50fa7b}%n@%m %F{#bd93f9}%2~%F{#ff79c6}]%f%b ${vcs_info_msg_0_}%B%(?..[%F{#ff5555}%?%f])%b\n%F{#50fa&b}»»%f '
# --- FIM DO ESTILO ---

 # Path to your Oh My Zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="gnzh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# FZF Base Directory
export FZF_BASE=/home/linuxbrew/.linuxbrew/opt/fzf
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z fzf)

#source $ZSH/oh-my-zsh.sh

# --- Zsh History Configuration ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
#
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# --- Configuração do GEMINI (Mods) ---
#export AIDER_MODEL="gemini/gemini-2.0-flash"
#export GOOGLE_API_KEY=<SUA_CHAVE_API>
# Chave de Busca (Serper)

# ALIASES (Corrigidos para modelos aceitos pelo Mods)

# 1. gpro: Vamos usar o 2.0 Flash (é o mais moderno da lista que ele aceita)
alias gpro='mods --api google --model gemini-2.0-flash-001 --no-cache'

# 2. gflash: Vamos usar o 1.5 Flash (super leve e estável)
alias gflash='mods --api google --model gemini-1.5-flash-latest --no-cache'

# 3. gemini-ui: O comando padrão
alias gemini-ui='mods --api google --model gemini-2.0-flash-001 --no-cache'


alias norm='norminette'
# Configuração do Aider (Para usar Gemini)
export AIDER_MODEL="gemini/gemini-2.0-flash-001"

# NVM (Node) - Corrigido
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Navegação palavra por palavra com Ctrl + Setas
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
alias vim='nvim'
alias vi='nvim'
alias vimguia='bat ~/guia_vim.md'


gcommit() {
    # 1. Verifica se tem algo no stage
    if git diff --cached --quiet; then
        echo "⚠️  Nada estagiado para commit."
        return 1
    fi

    echo "🤖 Lendo alterações..."
    
    # 2. Salva o diff em uma variável
    DIFF_CONTENT=$(git diff --cached)

    # 3. Monta um prompt que PROÍBE o uso de ferramentas
    # O truque é dizer "Este é o conteúdo do arquivo" em vez de "Rode esse comando"
    PROMPT="INSTRUÇÃO: Aja apenas como um formatador de texto. NÃO tente executar comandos. NÃO use ferramentas.
    
    TAREFA: Escreva uma mensagem de commit (Conventional Commits) baseada APENAS no texto abaixo.
    
    REGRAS:
    - Formato: <tipo>: <descrição breve>
    - Se for Norminette/Espaços: use 'style: norminette'
    - Retorne APENAS a string da mensagem final.

    TEXTO DE ENTRADA (DIFF):
    $DIFF_CONTENT"

    echo "🤖 Gerando sugestão..."

    # 4. Envia para o Gemini
    # Aspas duplas são cruciais para passar as quebras de linha corretamente
    SUGESTAO=$(gemini "$PROMPT")

    echo "\n----------------------------------------"
    echo "Sugestão: \033[1;32m$SUGESTAO\033[0m"
    echo "----------------------------------------\n"

    # 5. Pergunta se quer usar
    echo -n "Usar essa mensagem? [y/N] "
    read resp
    if [[ "$resp" =~ ^[Yy]$ ]]; then
        git commit -m "$SUGESTAO"
    else
        echo "Cancelado."
    fi
}
