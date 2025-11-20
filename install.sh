#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando o Setup do Kit Claudio...${NC}"

# --- 1. DETECÇÃO DE AMBIENTE (42 vs CASA) ---
if [ -d "$HOME/goinfre" ]; then
    echo -e "${GREEN}🏫 Ambiente 42 detectado! Usando goinfre para economizar quota.${NC}"
    BREW_DIR="$HOME/goinfre/.brew"
else
    echo -e "${GREEN}🏠 Ambiente Pessoal detectado. Instalando na home.${NC}"
    BREW_DIR="$HOME/.brew"
fi

# --- 2. INSTALAÇÃO DO HOMEBREW ---
if [ ! -d "$BREW_DIR" ]; then
    echo -e "${BLUE}🍺 Instalando Homebrew em $BREW_DIR...${NC}"
    git clone --depth=1 https://github.com/Homebrew/brew "$BREW_DIR"
    
    # Adiciona ao PATH temporariamente para este script usar
    eval "$("$BREW_DIR/bin/brew" shellenv)"
    brew update --force --quiet
else
    echo -e "${GREEN}✅ Homebrew já instalado.${NC}"
    eval "$("$BREW_DIR/bin/brew" shellenv)"
fi

# --- 3. FERRAMENTAS MODERNAS (INSTALAÇÃO MANUAL SEM BREW) ---
echo -e "${BLUE}📦 Instalando ferramentas (eza, bat, zoxide, oh-my-posh)...${NC}"

# Define o diretório de binários locais e o adiciona ao PATH
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Função para checar se a ferramenta já foi adicionada ao PATH do script atual
path_contains() {
    case ":$PATH:" in
        *":$1:"*) return 0 ;;
        *) return 1 ;;
    esac
}

# Adiciona ao PATH do script atual para garantir que os comandos sejam encontrados
if ! path_contains "$LOCAL_BIN"; then
    export PATH="$LOCAL_BIN:$PATH"
fi

# Eza (substituto do ls)
if ! command -v eza &> /dev/null; then
    echo "  -> Instalando eza..."
    TEMP_DIR=$(mktemp -d)
    wget -qO "$TEMP_DIR/eza.tar.gz" https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
    tar -xf "$TEMP_DIR/eza.tar.gz" -C "$LOCAL_BIN"
    rm -r "$TEMP_DIR"
else
    echo "  -> eza já está instalado."
fi

# Bat (substituto do cat)
if ! command -v bat &> /dev/null; then
    echo "  -> Instalando bat..."
    TEMP_DIR=$(mktemp -d)
    wget -qO "$TEMP_DIR/bat.tar.gz" https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
    tar xf "$TEMP_DIR/bat.tar.gz" --strip-components=1 -C "$LOCAL_BIN" bat-v0.24.0-x86_64-unknown-linux-gnu/bat
    rm -r "$TEMP_DIR"
else
    echo "  -> bat já está instalado."
fi

# Zoxide (cd inteligente)
if ! command -v zoxide &> /dev/null; then
    echo "  -> Instalando zoxide..."
    TEMP_DIR=$(mktemp -d)
    wget -qO "$TEMP_DIR/zoxide.tar.gz" https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-0.9.4-x86_64-unknown-linux-musl.tar.gz
    tar -xf "$TEMP_DIR/zoxide.tar.gz" -C "$LOCAL_BIN" zoxide
    rm -r "$TEMP_DIR"
else
    echo "  -> zoxide já está instalado."
fi

# Oh-my-posh (tema do prompt)
if ! command -v oh-my-posh &> /dev/null; then
    echo "  -> Instalando oh-my-posh..."
    # A flag -d aponta o diretório de instalação
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$LOCAL_BIN"
else
    echo "  -> oh-my-posh já está instalado."
fi

# Git e FZF
echo -e "${BLUE}📦 Verificando dependências restantes (git, fzf)...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}  -> Git não encontrado. Instale-o com o gerenciador de pacotes do seu sistema (ex: sudo apt install git) e rode o script novamente.${NC}"
    exit 1
fi
if ! command -v fzf &> /dev/null; then
    echo "  -> Tentando instalar FZF com brew..."
    if command -v brew &> /dev/null; then
        brew install fzf
        "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish > /dev/null 2>&1
    else
        echo -e "${RED}  -> Brew não está funcional. Pulei a instalação do FZF. Considere instalar manualmente.${NC}"
    fi
else
    echo "  -> fzf já está instalado."
fi

# --- 4. NODE.JS & IA (NVM + GEMINI) ---
echo -e "${BLUE}🤖 Configurando Node.js e Gemini AI...${NC}"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Instala Node LTS e Gemini
nvm install --lts
nvm use --lts
if ! command -v gemini &> /dev/null; then
    npm install -g @google/gemini-cli
fi

# --- 5. ZSH & ZINIT ---
echo -e "${BLUE}⚡ Instalando Zinit (Gerenciador de Plugins)...${NC}"
if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
    mkdir -p "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit/zinit.git"
fi

# --- FONTS (NERD FONT) ---
echo -e "${BLUE}🅰️  Instalando fontes Meslo Nerd Font...${NC}"

# Define o diretório de fontes local (funciona na 42 e Linux pessoal)
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Baixa as fontes se elas não existirem
if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    
    # Atualiza o cache de fontes do Linux
    if command -v fc-cache >/dev/null 2>&1; then
        echo -e "${BLUE}🔄 Atualizando cache de fontes...${NC}"
        fc-cache -f "$FONT_DIR"
    fi
    echo -e "${GREEN}✅ Fontes instaladas! Lembre-se de configurar seu terminal para usar 'MesloLGS NF'.${NC}"
else
    echo -e "${GREEN}✅ Fontes já instaladas.${NC}"
fi

# --- 6. TEMA E CONFIGURAÇÃO ---
echo -e "${BLUE}🎨 Baixando tema Kushal...${NC}"
mkdir -p ~/.poshthemes
curl -L https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/kushal.omp.json -o ~/.poshthemes/kushal.omp.json

# --- 7. CRIANDO O GUIA DE ATALHOS ---
echo -e "${BLUE}📚 Criando ~/.guia.md...${NC}"
cat << 'EOF' > ~/.guia.md
# 🚀 GUIA DE ATALHOS E FERRAMENTAS (CLÁUDIO)

## 🧠 Zoxide (Navegação Inteligente)
z <nome>      # Vai para uma pasta (ex: z push)
z <nome> <tab> # Mostra opções
z -           # Volta para a pasta anterior
zi            # Lista interativa

## 📂 Eza & Bat (Arquivos)
ls            # Lista com ícones (eza)
ls -T         # Árvore de arquivos
cat <arq>     # Lê com cores (bat)

## 🔍 FZF (Busca Rápida)
Ctrl + T      # Achar ARQUIVOS
Ctrl + R      # Achar COMANDOS (Histórico)

## 🤖 Gemini (IA)
gemini        # Chat
gemini "txt"  # Pergunta rápida
cat x | gemini "..." # Analisar arquivo

## ⌨️ Atalhos Úteis
Ctrl + L      # Limpar tela
Ctrl + A / E  # Início / Fim da linha
EOF

# --- 8. GERANDO O .ZSHRC FINAL ---
echo -e "${BLUE}📝 Gerando novo .zshrc...${NC}"
cp ~/.zshrc ~/.zshrc.backup.$(date +%s) # Backup por segurança

cat << EOF > ~/.zshrc
# --- PATH LOCAL ---
# Adiciona o diretório de binários locais ao início do PATH
export PATH="\$HOME/.local/bin:\$PATH"

# --- HOMEBREW ---
# Detecta onde o brew está instalado (42 vs Casa)
if [ -d "\$HOME/goinfre/.brew" ]; then
    eval "\$(\$HOME/goinfre/.brew/bin/brew shellenv)"
elif [ -d "\$HOME/.brew" ]; then
    eval "\$(\$HOME/.brew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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
eval "\$(zoxide init zsh)"

# Aliases
alias cat='bat --paging=never'
alias ls='eza --icons'
alias l='eza -l --icons'
alias la='eza -la --icons'
alias guia='bat ~/.guia.md'

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM (Node)
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"

# --- OH MY POSH ---
eval "\$(oh-my-posh init zsh --config ~/.poshthemes/kushal.omp.json)"
EOF

echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA!${NC}"
echo -e "Reinicie o terminal ou digite: ${BLUE}source ~/.zshrc${NC}"
echo -e "Para ver seus atalhos, digite: ${BLUE}guia${NC}"
