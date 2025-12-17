# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gnzh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# FZF Base Directory
export FZF_BASE=/home/linuxbrew/.linuxbrew/opt/fzf
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z fzf)

source $ZSH/oh-my-zsh.sh

# --- User configuration ---

# Carrega o Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Custom PATH
export PATH="$HOME/.local/bin:$PATH"

# --- Zsh History Configuration ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space
# --- End Zsh History Configuration ---

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

# Custom Aliases
# alias cat='bat --paging=never'
alias ls='eza --icons'
alias ç='clear'
alias la='eza -la --icons'
# Atalho para abrir o guia pessoal
alias guia='bat ~/.guia.md'

# --- Gemini CLI Alias ---
# Abre o Gemini em uma nova aba do terminal no diretório atual
alias gemini='/home/claudio/.local/bin/start_gemini.sh'

# Gemini CLI aliases
alias gflash='gemini -m gemini-1.5-flash-latest'
alias gpro='gemini -m gemini-1.5-pro-latest'
