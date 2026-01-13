#!/bin/bash
set -e

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd )"
INTER_DIR="$REPO_DIR/configurations/intermediate"
BIN_DIR="$HOME/.local/bin"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

echo -e "${BLUE}🚀 Iniciando Instalação Intermediária (Otimizada para Espaço)...${NC}"

# --- FUNÇÕES DE INSTALAÇÃO MANUAL (SEM BREW/SUDO) ---
install_zoxide() {
    if ! command -v zoxide &> /dev/null; then
        echo -e "  📦 Baixando Zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    else
        echo -e "  ✅ Zoxide já instalado."
    fi
}

install_fzf() {
    if [ ! -d "$HOME/.fzf" ]; then
        echo -e "  📦 Baixando FZF..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --bin --no-update-rc --completion --key-bindings
        ln -sf "$HOME/.fzf/bin/fzf" "$BIN_DIR/fzf"
    else
        echo -e "  ✅ FZF já instalado."
    fi
}

install_eza() {
    if ! command -v eza &> /dev/null; then
        echo -e "  📦 Baixando Eza (ls moderno)..."
        EZA_URL="https://github.com/eza-community/eza/releases/download/v0.18.6/eza_x86_64-unknown-linux-gnu.tar.gz"
        curl -sL "$EZA_URL" | tar xz -C "$BIN_DIR"
        chmod +x "$BIN_DIR/eza"
    else
        echo -e "  ✅ Eza já instalado."
    fi
}

install_bat() {
    if ! command -v bat &> /dev/null; then
        echo -e "  📦 Baixando Bat (cat moderno)..."
        BAT_VER="v0.24.0"
        BAT_URL="https://github.com/sharkdp/bat/releases/download/$BAT_VER/bat-$BAT_VER-x86_64-unknown-linux-gnu.tar.gz"
        curl -sL "$BAT_URL" | tar xz -C /tmp
        mv "/tmp/bat-$BAT_VER-x86_64-unknown-linux-gnu/bat" "$BIN_DIR/bat"
        rm -rf "/tmp/bat-$BAT_VER-x86_64-unknown-linux-gnu"
    else
        echo -e "  ✅ Bat já instalado."
    fi
}

# --- FLUXO PRINCIPAL ---

# 1. Zinit
if [ ! -d "$ZINIT_HOME" ]; then
    echo -e "${BLUE}--- Instalando Zinit ---${NC}"
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 2. Fontes
echo -e "${BLUE}--- Verificando Fontes ---${NC}"
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    echo "  ⬇️  Baixando MesloLGS NF..."
    mkdir -p "$FONT_DIR"
    curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    curl -sL -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    curl -sL -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    curl -sL -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    if command -v fc-cache &> /dev/null; then fc-cache -f "$FONT_DIR"; fi
fi

# 3. Instalação de Ferramentas
echo -e "${BLUE}--- Instalando Ferramentas (Modo Econômico) ---${NC}"
install_zoxide
install_fzf
install_eza
install_bat

# 4. Links Simbólicos
echo -e "${BLUE}--- Configurando Dotfiles ---${NC}"
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "  💾 Preservando seu .zshrc antigo em .zshrc_local"
    mv "$HOME/.zshrc" "$HOME/.zshrc_local"
fi
ln -sf "$INTER_DIR/zshrc" "$HOME/.zshrc"

echo -e "\n${GREEN}🎉 Instalação Intermediária Concluída!${NC}"
echo -e "Reinicie o terminal ou rode: ${BLUE}source ~/.zshrc${NC}"