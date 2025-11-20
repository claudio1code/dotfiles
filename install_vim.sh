#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${BLUE}Clonando o repositório de dotfiles...${NC}"
    git clone https://github.com/claudio1code/dotfiles.git "$DOTFILES_DIR"
else
    echo -e "${GREEN}✅ Repositório de dotfiles já existe.${NC}"
fi

echo -e "${BLUE}🔗 Criando symlink para o .vimrc...${NC}"
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"

echo -e "${BLUE}🔌 Instalando vim-plug...${NC}"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo -e "${GREEN}✅ Configuração do Vim concluída!${NC}"
echo -e "Abra o Vim e execute ${BLUE}:PlugInstall${NC} para instalar os plugins."
