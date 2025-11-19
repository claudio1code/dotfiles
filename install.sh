#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando o Setup do Kit Claudio...${NC}"

# --- 1. CLONE DOTFILES REPOSITORY ---
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${BLUE}Clonando o repositório de dotfiles...${NC}"
    git clone https://github.com/claudio1code/dotfiles.git "$DOTFILES_DIR"
else
    echo -e "${GREEN}✅ Repositório de dotfiles já existe.${NC}"
fi

cd "$DOTFILES_DIR"

# --- 2. DETECÇÃO DE AMBIENTE (42 vs CASA) ---
if [ -d "$HOME/goinfre" ]; then
    echo -e "${GREEN}🏫 Ambiente 42 detectado! Usando goinfre para economizar quota.${NC}"
    BREW_DIR="$HOME/goinfre/.brew"
else
    echo -e "${GREEN}🏠 Ambiente Pessoal detectado. Instalando na home.${NC}"
    BREW_DIR="$HOME/.brew"
fi

# --- 3. INSTALAÇÃO DO HOMEBREW ---
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

# --- 4. FERRAMENTAS MODERNAS (RUST SUITE) ---
echo -e "${BLUE}📦 Instalando ferramentas (eza, bat, zoxide, fzf, oh-my-posh)...${NC}"
brew install eza bat zoxide fzf oh-my-posh

# Instala atalhos do FZF automaticamente
echo -e "${BLUE}🔍 Configurando FZF...${NC}"
"$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish > /dev/null 2>&1

# --- 5. NODE.JS & IA (NVM + GEMINI) ---
echo -e "${BLUE}🤖 Configurando Node.js e Gemini AI...${NC}"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Instala Node LTS e Gemini
nvm install --lts
nvm use --lts
if ! command -v gemini &> /dev/null; then
    npm install -g @google/gemini-cli
fi

# --- 6. ZSH & ZINIT ---
echo -e "${BLUE}⚡ Instalando Zinit (Gerenciador de Plugins)...${NC}"
if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
    mkdir -p "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit/zinit.git"
fi

# --- 7. FONTS (NERD FONT) ---
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

# --- 8. SYMLINKING DOTFILES ---
echo -e "${BLUE}🔗 Criando symlinks para os dotfiles...${NC}"

# .zshrc
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# oh-my-posh theme
mkdir -p ~/.poshthemes
ln -sf "$DOTFILES_DIR/.poshthemes/kushal.omp.json" "$HOME/.poshthemes/kushal.omp.json"

# .vimrc
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"

# guia.md
ln -sf "$DOTFILES_DIR/guia.md" "$HOME/.guia.md"


# --- 9. CRIANDO SCRIPT DE UPDATE ---
echo -e "${BLUE}📝 Criando script de update...${NC}"
cat << 'EOF' > "$DOTFILES_DIR/update.sh"
#!/bin/bash
set -e

# Get the directory of the script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "$DOTFILES_DIR"

echo "Pulling latest changes from GitHub..."
git pull

echo "Applying updates..."
sh install.sh

echo "Update complete!"
EOF
chmod +x "$DOTFILES_DIR/update.sh"

echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA!${NC}"
echo -e "Reinicie o terminal ou digite: ${BLUE}source ~/.zshrc${NC}"
echo -e "Para atualizar, rode: ${BLUE}sh ~/.dotfiles/update.sh${NC}"
echo -e "Para ver seus atalhos, digite: ${BLUE}guia${NC}"