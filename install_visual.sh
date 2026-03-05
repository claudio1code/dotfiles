#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

echo -e "${BLUE}🎨 Instalação Visual - Zsh Bonito e Produtivo${NC}"
echo -e "${YELLOW}Cenário: Foco apenas na aparência e usabilidade do terminal${NC}"

# Download paralelo das ferramentas
echo -e "${BLUE}--- Baixando Ferramentas em Paralelo ---${NC}"
mkdir -p "$HOME/.local/bin"

# Função para download rápido
download_tool() {
    local name=$1
    local url=$2
    local extract_cmd=$3
    
    if ! command -v "$name" &> /dev/null; then
        echo "📦 Baixando $name..."
        if [[ $extract_cmd == "tar" ]]; then
            curl -sL "$url" | tar xz -C "$HOME/.local/bin" --strip-components=1 "$name" 2>/dev/null || true
        else
            curl -sL -o "$HOME/.local/bin/$name" "$url"
        fi
        chmod +x "$HOME/.local/bin/$name" 2>/dev/null || true
    fi
}

# Downloads em paralelo (background)
download_tool "eza" "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" "tar" &
download_tool "bat" "https://github.com/sharkdp/bat/releases/latest/download/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" "tar" &
EZA_PID=$!
BAT_PID=$!

# ZINIT (Gerenciador de Plugins)
echo -e "${BLUE}--- Instalando Zinit ---${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Esperar downloads
wait $EZA_PID $BAT_PID

# 3. Fontes para Ícones (download paralelo)
echo -e "${BLUE}--- Baixando Fontes ---${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Download das fontes em paralelo
curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" &
curl -sL -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" &
curl -sL -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" &
curl -sL -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" &

# Configuração do ambiente
echo -e "${BLUE}--- Configurando Ambiente ---${NC}"
ln -sf "$REPO_DIR/zshrc_visual" "$HOME/.zshrc"

# Esperar fontes
wait

# Atualiza cache de fontes
if command -v fc-cache &> /dev/null; then
    echo "🔄 Atualizando cache de fontes..."
    fc-cache -f "$FONT_DIR" &
fi

# 5. Mudar shell para Zsh (se possível)
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "🔄 Mudando shell para Zsh..."
        chsh -s "$(which zsh)" 2>/dev/null || echo "⚠️  Não foi possível mudar o shell automaticamente. Execute: chsh -s \$(which zsh)"
    fi
else
    echo "⚠️  Zsh não encontrado. Instale com: sudo apt install zsh"
fi

echo -e "\n${GREEN}✅ Instalação Visual Concluída!${NC}"
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo -e "1. Configure a fonte MesloLGS NF no seu terminal"
echo -e "2. Abra um novo terminal ou rode: ${BLUE}zsh${NC}"
echo -e "3. Aproveite seu terminal bonito! 🎨"
