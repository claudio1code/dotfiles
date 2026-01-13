#!/bin/bash
set -e

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd )"
AI_DIR="$REPO_DIR/configurations/ai"
BIN_DIR="$HOME/.local/bin"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

echo -e "${BLUE}🧠 Iniciando Instalação AI (Completa + Node.js)...${NC}"

# 1. Reutiliza funções de instalação (Zoxide, FZF, Eza, Bat)
# (Copiando lógica para garantir independência)
install_binaries() {
    # Zoxide
    if ! command -v zoxide &> /dev/null; then
        echo "  📦 Baixando Zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
    # FZF
    if [ ! -d "$HOME/.fzf" ]; then
        echo "  📦 Baixando FZF..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --bin --no-update-rc --completion --key-bindings
        ln -sf "$HOME/.fzf/bin/fzf" "$BIN_DIR/fzf"
    fi
    # Eza
    if ! command -v eza &> /dev/null; then
        echo "  📦 Baixando Eza..."
        EZA_URL="https://github.com/eza-community/eza/releases/download/v0.18.6/eza_x86_64-unknown-linux-gnu.tar.gz"
        curl -sL "$EZA_URL" | tar xz -C "$BIN_DIR"
        chmod +x "$BIN_DIR/eza"
    fi
    # Bat
    if ! command -v bat &> /dev/null; then
        echo "  📦 Baixando Bat..."
        BAT_VER="v0.24.0"
        BAT_URL="https://github.com/sharkdp/bat/releases/download/$BAT_VER/bat-$BAT_VER-x86_64-unknown-linux-gnu.tar.gz"
        curl -sL "$BAT_URL" | tar xz -C /tmp
        mv "/tmp/bat-$BAT_VER-x86_64-unknown-linux-gnu/bat" "$BIN_DIR/bat"
    fi
}

echo -e "${BLUE}--- Ferramentas Básicas ---${NC}"
install_binaries

# 2. Zinit e Fontes
if [ ! -d "$ZINIT_HOME" ]; then
    echo -e "${BLUE}--- Instalando Zinit ---${NC}"
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

echo -e "${BLUE}--- Baixando Fontes ---${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    if command -v fc-cache &> /dev/null; then fc-cache -f "$FONT_DIR"; fi
fi

# 3. NVM & Node.js (Sem Sudo, na Home)
echo -e "${BLUE}--- Configurando NVM e Node.js ---${NC}"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "  📦 Instalando NVM em $HOME/.nvm (Persistente)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
    echo "  ✅ NVM já instalado."
fi

# Carrega NVM para instalar Node
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v node &> /dev/null; then
    echo "  📦 Instalando Node.js (LTS)..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
else
    echo "  ✅ Node.js detectado: $(node -v)"
fi

# 4. Gemini CLI
echo -e "${BLUE}--- Instalando Gemini CLI ---${NC}"
if ! command -v gemini &> /dev/null; then
    echo "  🤖 Instalando 'gemini-chat-cli' via NPM..."
    npm install -g gemini-chat-cli
else
    echo "  ✅ Gemini CLI já instalado."
fi

# 5. Dotfiles Link
echo -e "${BLUE}--- Configurando ZSH ---${NC}"
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "  💾 Preservando .zshrc antigo em .zshrc_local"
    mv "$HOME/.zshrc" "$HOME/.zshrc_local"
fi
ln -sf "$AI_DIR/zshrc" "$HOME/.zshrc"

# Aviso sobre API Key
echo -e "\n${GREEN}🎉 Configuração AI Concluída!${NC}"
if [ ! -f "$HOME/.env" ]; then
    echo "⚠️  IMPORTANTE: Crie um arquivo ~/.env com sua chave:"
    echo "   export GEMINI_API_KEY='sua_chave_aqui'"
fi
echo -e "Reinicie o terminal ou rode: ${BLUE}source ~/.zshrc${NC}"
