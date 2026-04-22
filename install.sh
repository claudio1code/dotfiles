#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}🚀 Instalador Modular de Dotfiles 🚀${NC}"
echo -e "${BLUE}=======================================${NC}"

echo -e "\n${YELLOW}Qual perfil de instalação você deseja?${NC}"
echo "1) Básico (Visual + Zsh + Ferramentas Leves)"
echo "2) Desenvolvimento (Básico + Zoxide, FZF, NVM, Git avançado)"
echo "3) Ambiente 42 (Otimizado sem sudo, aliases para C/Makefile)"
echo "4) Completo / Pessoal (Tudo acima + utilitários de sistema)"
read -p "Escolha (1/2/3/4): " PROFILE_CHOICE

echo -e "\n${YELLOW}Deseja instalar as ferramentas de Inteligência Artificial (Aider, Mods)? [s/N]${NC}"
read -p "> " AI_CHOICE

# 1. Instalar Homebrew (Se não existir e não for perfil 42 restrito)
if [[ "$PROFILE_CHOICE" != "3" ]]; then
    echo -e "\n${BLUE}🍺 Verificando Homebrew...${NC}"
    if ! command -v brew &> /dev/null; then
        echo -e "  📦 Instalando Homebrew localmente..."
        if [ ! -d "$HOME/.brew" ]; then
            git clone https://github.com/Homebrew/brew ~/.brew
        fi
        eval "$($HOME/.brew/bin/brew shellenv)"
        brew update --force --quiet
    else
        echo -e "  ✅ Homebrew já instalado."
    fi
fi

# 2. Instalação de Ferramentas Base
echo -e "\n${BLUE}--- Instalando Ferramentas Base ---${NC}"
if command -v brew &> /dev/null; then
    brew install eza bat
    
    if [[ "$PROFILE_CHOICE" == "2" || "$PROFILE_CHOICE" == "4" ]]; then
        brew install zoxide fzf
    fi
else
    echo -e "⚠️ Homebrew não encontrado, pulando instalação de pacotes base."
fi

# 3. ZINIT
echo -e "\n${BLUE}--- Configurando Zinit ---${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 4. Links Simbólicos
echo -e "\n${BLUE}🔗 Criando symlinks...${NC}"
ln -sf "$REPO_DIR/configs/zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/configs/.vimrc" "$HOME/.vimrc"

mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/scripts/update.sh" "$HOME/.local/bin/update_dotfiles"
ln -sf "$REPO_DIR/scripts/clear_home42.sh" "$HOME/.local/bin/clear_home42"
chmod +x "$REPO_DIR/scripts/"*.sh

# 5. Instalação de Fontes
echo -e "\n${BLUE}--- Baixando Fontes (MesloLGS NF) ---${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    if command -v fc-cache &> /dev/null; then
        fc-cache -f "$FONT_DIR"
    fi
else
    echo -e "  ✅ Fontes já instaladas."
fi

# 6. IA Options
if [[ "$AI_CHOICE" =~ ^[SsYy]$ ]]; then
    echo -e "\n${BLUE}--- Instalando Ferramentas de IA ---${NC}"
    if command -v brew &> /dev/null; then
        brew install mods
    fi
    # Adicionar chamadas para instalar aider, etc., conforme necessidade.
    echo -e "✅ IA configurada. Lembre-se de rodar 'mods --settings' para configurar sua API Key."
fi

echo -e "\n${GREEN}🎉 Instalação Concluída!${NC}"
echo -e "Reinicie o terminal ou rode: ${BLUE}zsh${NC}"
