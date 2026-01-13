#!/bin/bash
set -e

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd )"
SIMPLE_DIR="$REPO_DIR/configurations/simple"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

echo -e "${BLUE}🔧 Instalando Configuração Simples (Baseada em 'basic')...${NC}"

# 1. Zinit
echo -e "${BLUE}--- Configurando Zinit ---${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    echo -e "  ✅ Zinit instalado."
else
    echo -e "  ✅ Zinit já existe."
fi

# 2. Fontes (MesloLGS NF)
echo -e "${BLUE}--- Baixando Fontes (MesloLGS NF) ---${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

for font in "Regular" "Bold" "Italic" "Bold%20Italic"; do
    filename="MesloLGS NF $(echo $font | sed 's/%20/ /g').ttf"
    if [ ! -f "$FONT_DIR/$filename" ]; then
        curl -sL -o "$FONT_DIR/$filename" "https://github.com/romkatv/powerlevel10k-media/raw/master/$font.ttf"
    fi
done

if command -v fc-cache &> /dev/null; then
    fc-cache -f "$FONT_DIR"
fi
echo -e "  ✅ Fontes MesloLGS NF verificadas/instaladas."

# 3. Links Simbólicos
echo -e "${BLUE}--- Criando Links Simbólicos ---${NC}"

backup_and_link() {
    if [ -f "$2" ] && [ ! -L "$2" ]; then
        echo "  💾 Preservando seu $2 antigo em ${2}_local"
        mv "$2" "${2}_local"
    fi
    ln -sf "$1" "$2"
}

backup_and_link "$SIMPLE_DIR/zshrc" "$HOME/.zshrc"


echo -e "\n${GREEN}🎉 Instalação Simples Concluída!${NC}"
echo -e "Execute ${BLUE}source ~/.zshrc${NC} ou abra um novo terminal."