#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

echo -e "${BLUE}🚀 Iniciando Instalação Otimizada...${NC}"

# 1. Instalar Homebrew (Se não existir)
echo -e "${BLUE}🍺 Verificando Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    if [ -d "$HOME/.brew" ]; then
        echo -e "  ⚠️  Pasta ~/.brew existe. Configurando..."
    else
        echo -e "  📦 Instalando Homebrew localmente (~/.brew)..."
        git clone https://github.com/Homebrew/brew ~/.brew
        echo -e "  🔄 Atualizando Homebrew..."
        "$HOME/.brew/bin/brew" update --force --quiet
    fi
    # Adiciona ao PATH temporariamente para este script rodar
    eval "$($HOME/.brew/bin/brew shellenv)"
else
    echo -e "  ✅ Homebrew já instalado."
fi

# 2. Instalar Ferramentas via Brew (CORRIGE O ERRO DO GZIP/CURL)
echo -e "${BLUE}--- Instalando Ferramentas (zoxide, eza, bat, fzf) ---${NC}"
brew install zoxide eza bat fzf mods

# 3. ZINIT
echo -e "${BLUE}--- Configurando Zinit ---${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 4. Links Simbólicos (Aqui está o pulo do gato!)
echo -e "🔗 Criando symlinks..."
# Ao linkar o zshrc novo, a configuração inteligente já vai junto
ln -sf "$REPO_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$REPO_DIR/vim_cheatsheet.md" "$HOME/.vim_cheatsheet.md"

# Scripts
mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/update.sh" "$HOME/.local/bin/update_dotfiles"
chmod +x "$REPO_DIR/update.sh"

# 5. Vim Setup
echo -e "${BLUE}--- Configurando Vim ---${NC}"
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null
vim -es -u "$HOME/.vimrc" -i NONE -c "PlugInstall" -c "qa"

echo -e "\n${GREEN}🎉 Instalação Concluída!${NC}"
echo -e "Como seu .zshrc agora é inteligente, basta rodar: ${BLUE}zsh${NC}"
