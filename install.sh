#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

echo -e "${BLUE}🚀 Iniciando Instalação do Dotfiles do Claudio...${NC}"

# 1. Configurar Homebrew (Sem Sudo/Root)
echo -e "${BLUE}🍺 Verificando Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    if [ -d "$HOME/.brew" ]; then
        echo -e "  ⚠️  Pasta ~/.brew existe. Adicionando ao PATH..."
        export PATH="$HOME/.brew/bin:$PATH"
    else
        echo -e "  📦 Instalando Homebrew localmente (~/.brew)..."
        git clone https://github.com/Homebrew/brew ~/.brew
        export PATH="$HOME/.brew/bin:$PATH"
        echo -e "  🔄 Atualizando Homebrew..."
        brew update --force --quiet
    fi
else
    echo -e "  ✅ Homebrew já instalado."
fi

# Garante que o brew esteja acessível para o resto do script
eval "$($HOME/.brew/bin/brew shellenv)"

# 2. Instalação de Ferramentas via Homebrew (Mais estável que curl)
echo -e "${BLUE}--- Instalando Ferramentas Modernas ---${NC}"
brew install eza bat zoxide fzf mods

# 3. Instalação do ZINIT
echo -e "${BLUE}--- Configurando ZSH e Zinit ---${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    echo -e "⚡ Clonando Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
else
    echo -e "  ✅ Zinit já instalado."
fi

# Linkando arquivos
echo -e "🔗 Criando symlinks..."
ln -sf "$REPO_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$REPO_DIR/vim_cheatsheet.md" "$HOME/.vim_cheatsheet.md"

# Criando script de update
mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/update.sh" "$HOME/.local/bin/update_dotfiles"
chmod +x "$REPO_DIR/update.sh"

# 4. Configuração Vim
echo -e "${BLUE}--- Configurando Vim ---${NC}"
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
# Instala plugins (silenciosamente)
vim -es -u "$HOME/.vimrc" -i NONE -c "PlugInstall" -c "qa"

# 5. Guia
cp "$REPO_DIR/guia.md" "$HOME/.guia.md"

echo -e "\n${GREEN}🎉 Instalação Concluída!${NC}"
echo -e "⚠️  Reinicie seu terminal ou rode: ${BLUE}source ~/.zshrc${NC}"
