#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LOCAL_BIN="$HOME/.local/bin"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

echo -e "${BLUE}🚀 Iniciando Instalação do Dotfiles do Claudio...${NC}"

# 1. Garante pastas locais
mkdir -p "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

# 2. Instalação de Binários (Eza, Bat, Zoxide, FZF)
install_tool() {
    local name=$1
    local url=$2
    local bin_name=$3
    
    if ! command -v "$name" &> /dev/null; then
        echo -e "📦 Instalando ${YELLOW}$name${NC}..."
        TEMP_DIR=$(mktemp -d)
        curl -sL "$url" | tar -xz -C "$TEMP_DIR"
        # Tenta achar o binário e mover
        find "$TEMP_DIR" -name "$bin_name" -type f -exec mv {} "$LOCAL_BIN/$name" \;
        chmod +x "$LOCAL_BIN/$name"
        rm -rf "$TEMP_DIR"
        echo -e "  ✅ $name instalado."
    else
        echo -e "  Running: $name já instalado."
    fi
}

echo -e "${BLUE}--- Ferramentas Modernas ---${NC}"
install_tool "eza" "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" "eza"
install_tool "bat" "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" "bat"
install_tool "zoxide" "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-x86_64-unknown-linux-musl.tar.gz" "zoxide"

# FZF Installation
if [ ! -f "$HOME/.fzf/bin/fzf" ]; then
    echo -e "📦 Instalando FZF..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish --bin > /dev/null
    ln -sf "$HOME/.fzf/bin/fzf" "$LOCAL_BIN/fzf"
fi

# 3. Instalação do ZINIT (Critical for new .zshrc)
echo -e "${BLUE}--- Configurando ZSH e Zinit ---${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    echo -e "⚡ Clonando Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
else
    echo -e "  ✅ Zinit já instalado."
fi

# Linkando arquivos de configuração
echo -e "🔗 Criando symlinks..."
ln -sf "$REPO_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$REPO_DIR/vim_cheatsheet.md" "$HOME/.vim_cheatsheet.md"

# Criando alias para atualização
ln -sf "$REPO_DIR/update.sh" "$LOCAL_BIN/update_dotfiles"
chmod +x "$REPO_DIR/update.sh"

# 4. Configuração Vim
echo -e "${BLUE}--- Configurando Vim ---${NC}"
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
# Instala plugins silenciosamente
vim -es -u "$HOME/.vimrc" -i NONE -c "PlugInstall" -c "qa"

# 5. Guia
cp "$REPO_DIR/guia.md" "$HOME/.guia.md"

echo -e "\n${GREEN}🎉 Instalação Concluída!${NC}"
echo -e "⚠️  Nota: O 'mods' e 'aider' devem ser instalados via pip/brew conforme o README."
echo -e "Reinicie seu terminal com: ${BLUE}source ~/.zshrc${NC}"
