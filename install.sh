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

# 6. Instalação de Fontes (MesloLGS NF)
echo -e "${BLUE}--- Baixando Fontes (MesloLGS NF) ---${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Baixa as 4 variações da fonte
curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl -sL -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
curl -sL -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
curl -sL -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

# Atualiza cache de fontes (se o comando existir)
if command -v fc-cache &> /dev/null; then
    echo "🔄 Atualizando cache de fontes..."
    fc-cache -f "$FONT_DIR"
fi

echo -e "\n${GREEN}🎉 Instalação Concluída!${NC}"
echo -e "Como seu .zshrc agora é inteligente, basta rodar: ${BLUE}zsh${NC}"
