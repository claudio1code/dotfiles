#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

echo -e "${BLUE}🏠 Instalação Personal - Setup Completo com Sudo${NC}"
echo -e "${YELLOW}Cenário: Computador pessoal com permissão sudo, instalação completa${NC}"

# 1. Verificar sudo
echo -e "${BLUE}--- Verificando Permissões ---${NC}"
if ! sudo -n true 2>/dev/null; then
    echo "🔐 Será solicitada senha sudo para instalação de pacotes do sistema..."
fi

# 2. Instalar dependências do sistema
echo -e "${BLUE}--- Instalando Pacotes do Sistema ---${NC}"
sudo apt update
sudo apt install -y zsh curl git build-essential python3 python3-pip nodejs npm neovim

# 3. Instalar Homebrew no sistema
echo -e "${BLUE}--- Instalando Homebrew (Sistema) ---${NC}"
if ! command -v brew &> /dev/null; then
    if [ ! -d "/home/linuxbrew/.linuxbrew" ]; then
        echo "📦 Instalando Homebrew no sistema..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "✅ Homebrew já instalado."
fi

# 4. ZINIT
echo -e "${BLUE}--- Instalando Zinit ---${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 5. Ferramentas completas via Brew
echo -e "${BLUE}--- Instalando Ferramentas Completas ---${NC}"
brew install zoxide eza bat fzf git-delta mods

# 6. NVM (Node Version Manager)
echo -e "${BLUE}--- Instalando NVM ---${NC}"
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
fi

# 7. Ferramentas de IA
echo -e "${BLUE}--- Instalando Ferramentas de IA ---${NC}"
pip3 install aider-chat

# 8. Ferramentas de desenvolvimento adicionais
echo -e "${BLUE}--- Instalando Ferramentas de Desenvolvimento ---${NC}"
sudo apt install -y htop tree ripgrep fd-find

# 9. Configuração Git completa
echo -e "${BLUE}--- Configurando Git ---${NC}"
git config --global pull.rebase false
git config --global init.defaultBranch main
git config --global core.pager "delta --dark"
git config --global delta.navigate true
git config --global delta.light false

# 10. Vim/Neovim completo
echo -e "${BLUE}--- Configurando Vim/Neovim ---${NC}"
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null

# 11. Links Simbólicos
echo -e "${BLUE}--- Configurando Ambiente ---${NC}"
ln -sf "$REPO_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"

# Scripts
mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/update.sh" "$HOME/.local/bin/update_dotfiles"
chmod +x "$REPO_DIR/update.sh"

# 12. Fontes completas
echo -e "${BLUE}--- Instalando Fontes Completas ---${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl -sL -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
curl -sL -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
curl -sL -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

if command -v fc-cache &> /dev/null; then
    fc-cache -f "$FONT_DIR"
fi

# 13. Mudar shell para Zsh
echo -e "${BLUE}--- Configurando Shell Padrão ---${NC}"
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "🔄 Mudando shell para Zsh..."
        sudo chsh -s "$(which zsh)" "$USER"
    fi
fi

# 14. Instalar extensões VS Code (se existir)
echo -e "${BLUE}--- Verificando VS Code ---${NC}"
if command -v code &> /dev/null; then
    echo "📦 Instalando extensões recomendadas..."
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-python.python
    code --install-extension bradlc.vscode-tailwindcss
    code --install-extension esbenp.prettier-vscode
fi

echo -e "\n${GREEN}✅ Instalação Personal Concluída!${NC}"
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo -e "1. Configure a fonte MesloLGS NF no seu terminal"
echo -e "2. **REINICIE O COMPUTADOR** para aplicar todas as mudanças"
echo -e "3. Abra um novo terminal (já estará em Zsh)"
echo -e "4. Instale plugins do Vim: ${BLUE}vim +PlugInstall +qall${NC}"
echo -e "5. Instale uma versão do Node: ${BLUE}nvm install 20${NC}"
echo -e "6. Configure sua API Key do Google:"
echo -e "   ${BLUE}mods --settings${NC}"
echo -e "7. Teste tudo: ${BLUE}gpro 'Teste de IA'${NC}"
echo -e "\n${GREEN}🎉 Ambiente completo configurado! Aproveite!${NC}"
