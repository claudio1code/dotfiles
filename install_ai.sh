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

echo -e "${BLUE}🤖 Instalação AI Ultra-Rápida - Terminal com Inteligência Artificial${NC}"
echo -e "${YELLOW}Cenário: Foco em ferramentas de IA para produtividade máxima${NC}"

# Verificar pré-requisitos
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 não encontrado!${NC}"
    echo "Instale: sudo apt install python3 python3-pip"
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}❌ Pip3 não encontrado!${NC}"
    echo "Instale: sudo apt install python3-pip"
    exit 1
fi

# Função para download ultra-rápido
download_tool() {
    local name=$1
    local url=$2
    local extract_cmd=$3
    
    if ! command -v "$name" &> /dev/null; then
        echo "⚡ Baixando $name..."
        if [[ $extract_cmd == "tar" ]]; then
            curl -sL --connect-timeout 10 --max-time 30 "$url" | tar xz -C "$HOME/.local/bin" --strip-components=1 "$name" 2>/dev/null || true
        else
            curl -sL --connect-timeout 10 --max-time 30 -o "$HOME/.local/bin/$name" "$url"
        fi
        chmod +x "$HOME/.local/bin/$name" 2>/dev/null || true
    fi
}

# Iniciar todos os downloads em paralelo imediatamente
echo -e "${BLUE}🚀 Iniciando Downloads Paralelos...${NC}"
mkdir -p "$HOME/.local/bin"

# Downloads em background (todos ao mesmo tempo)
download_tool "eza" "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" "tar" &
download_tool "bat" "https://github.com/sharkdp/bat/releases/latest/download/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" "tar" &
download_tool "zoxide" "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-x86_64-unknown-linux-musl.tar.gz" "tar" &
download_tool "fzf" "https://github.com/junegunn/fzf/releases/latest/download/fzf-0.53.0-linux_amd64.tar.gz" "tar" &
download_tool "mods" "https://github.com/charmbracelet/mods/releases/latest/download/mods_v1.4.0_Linux_x86_64.tar.gz" "tar" &

# Zinit em paralelo
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" &
fi

# Fontes em paralelo
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
curl -sL --connect-timeout 10 -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" &
curl -sL --connect-timeout 10 -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" &
curl -sL --connect-timeout 10 -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" &
curl -sL --connect-timeout 10 -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" &

# Vim-plug em paralelo
curl -sL --connect-timeout 10 -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &

# Instalar Aider em paralelo
echo "⚡ Instalando Aider..."
pip3 install --quiet aider-chat &

# Esperar todos os downloads
echo -e "${BLUE}⏳ Aguardando downloads completarem...${NC}"
wait

# Configurações (rápido)
echo -e "${BLUE}⚙️ Configurando ambiente...${NC}"
ln -sf "$REPO_DIR/zshrc_ai" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"
mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/update.sh" "$HOME/.local/bin/update_dotfiles"
chmod +x "$REPO_DIR/update.sh"

# Cache de fontes em background
if command -v fc-cache &> /dev/null; then
    fc-cache -f "$FONT_DIR" &
fi

# Mudar shell
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)" 2>/dev/null || true
    fi
fi

wait

echo -e "\n${GREEN}⚡ Instalação AI Ultra-Rápida Concluída!${NC}"
echo -e "${YELLOW}📝 Próximos passos CRÍTICOS:${NC}"
echo -e "1. Configure a fonte MesloLGS NF no seu terminal"
echo -e "2. Abra um novo terminal ou rode: ${BLUE}zsh${NC}"
echo -e "3. Configure sua API Key do Google:"
echo -e "   ${BLUE}mods --settings${NC}"
echo -e "4. Teste a IA:"
echo -e "   ${BLUE}gpro 'Olá, como você está?'${NC}"
echo -e "5. Use commits automáticos:"
echo -e "   ${BLUE}git add . && gcommit${NC}"
echo -e "\n${RED}⚠️  IMPORTANTE: Você precisa de uma API Key do Google Gemini!${NC}"
echo -e "   Acesse: https://makersuite.google.com/app/apikey"
echo -e "\n${GREEN}🎉 Tempo total: ~3 minutos!${NC}"
