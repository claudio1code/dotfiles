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

echo -e "${BLUE}🏫 Instalação 42 Ultra-Rápida - Ambiente Otimizado para Escola 42${NC}"
echo -e "${YELLOW}Cenário: Sem sudo, limite 10GB, foco em C/norminette${NC}"

# Verificar espaço disponível
AVAILABLE_SPACE=$(df -h ~ | awk 'NR==2 {print $4}' | sed 's/G//')
echo "📊 Espaço disponível: ${AVAILABLE_SPACE}GB"

if (( $(echo "$AVAILABLE_SPACE < 2" | bc -l) )); then
    echo -e "${RED}❌ Espaço insuficiente! Precisa de pelo menos 2GB livres.${NC}"
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

# Zinit em paralelo
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" &
fi

# Fonte leve em paralelo (apenas regular para economizar espaço)
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
curl -sL --connect-timeout 10 -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" &

# Vim-plug em paralelo
curl -sL --connect-timeout 10 -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &

# Esperar todos os downloads
echo -e "${BLUE}⏳ Aguardando downloads completarem...${NC}"
wait

# Configurações (rápido)
echo -e "${BLUE}⚙️ Configurando ambiente...${NC}"
ln -sf "$REPO_DIR/zshrc_42" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"

# Scripts úteis para 42
mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/clear_home42.sh" "$HOME/.local/bin/clear_home42"
chmod +x "$REPO_DIR/clear_home42.sh"

# Cache de fontes em background
if command -v fc-cache &> /dev/null; then
    fc-cache -f "$FONT_DIR" &
fi

# Mudar shell
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)" 2>/dev/null || echo "⚠️  Execute manualmente: chsh -s \$(which zsh)"
    fi
else
    echo -e "${YELLOW}⚠️  Zsh não encontrado. Peça ajuda do monitor para instalar.${NC}"
fi

wait

echo -e "\n${GREEN}⚡ Instalação 42 Ultra-Rápida Concluída!${NC}"
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo -e "1. Configure a fonte MesloLGS NF no seu terminal"
echo -e "2. Abra um novo terminal ou rode: ${BLUE}zsh${NC}"
echo -e "3. Instale plugins do Vim: ${BLUE}vim +PlugInstall +qall${NC}"
echo -e "4. Use os comandos específicos:"
echo -e "   ${BLUE}norm${NC} - para rodar norminette"
echo -e "   ${BLUE}francinette${NC} - para testes (se configurado)"
echo -e "   ${BLUE}clear_home42${NC} - para limpar a home"
echo -e "\n${YELLOW}💡 Dicas para economizar espaço:${NC}"
echo -e "- Use ${BLUE}clear_home42${NC} semanalmente"
echo -e "- Evite baixar projetos grandes na home"
echo -e "- Use git gc --prune=now nos projetos"
echo -e "\n${GREEN}🎉 Tempo total: ~2 minutos!${NC}"
