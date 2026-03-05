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

echo -e "${BLUE}🛡️ Instalação Robusta - Segura e Confiável${NC}"
echo -e "${YELLOW}Downloads sequenciais com verificação e fallback${NC}"

# Função de download robusto com verificação
download_tool_robust() {
    local name=$1
    local url=$2
    local extract_cmd=$3
    
    if command -v "$name" &> /dev/null; then
        echo "✅ $name já existe"
        return 0
    fi
    
    echo "📦 Baixando $name..."
    
    # Tentativa 1: Download direto
    if [[ $extract_cmd == "tar" ]]; then
        if curl -sL --connect-timeout 15 --max-time 60 --retry 3 "$url" | tar xz -C "$HOME/.local/bin" --strip-components=1 "$name" 2>/dev/null; then
            chmod +x "$HOME/.local/bin/$name" 2>/dev/null || true
            echo "✅ $name baixado com sucesso"
            return 0
        fi
    else
        if curl -sL --connect-timeout 15 --max-time 60 --retry 3 -o "$HOME/.local/bin/$name" "$url"; then
            chmod +x "$HOME/.local/bin/$name" 2>/dev/null || true
            echo "✅ $name baixado com sucesso"
            return 0
        fi
    fi
    
    # Fallback: Tentar versão alternativa
    echo "⚠️  Falha no download de $name, tentando alternativa..."
    case "$name" in
        "eza")
            curl -sL --connect-timeout 15 --max-time 60 -o "$HOME/.local/bin/eza" "https://github.com/eza-community/eza/releases/download/v0.18.0/eza_x86_64-unknown-linux-gnu.tar.gz" || true
            ;;
        "bat")
            curl -sL --connect-timeout 15 --max-time 60 -o "$HOME/.local/bin/bat" "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" || true
            ;;
        "zoxide")
            curl -sL --connect-timeout 15 --max-time 60 -o "$HOME/.local/bin/zoxide" "https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-x86_64-unknown-linux-musl.tar.gz" || true
            ;;
        "fzf")
            curl -sL --connect-timeout 15 --max-time 60 -o "$HOME/.local/bin/fzf" "https://github.com/junegunn/fzf/releases/download/v0.53.0/fzf-0.53.0-linux_amd64.tar.gz" || true
            ;;
        "delta")
            curl -sL --connect-timeout 15 --max-time 60 -o "$HOME/.local/bin/delta" "https://github.com/dandavison/delta/releases/download/v0.18.2/delta-0.18.2-x86_64-unknown-linux-gnu.tar.gz" || true
            ;;
        "mods")
            curl -sL --connect-timeout 15 --max-time 60 -o "$HOME/.local/bin/mods" "https://github.com/charmbracelet/mods/releases/download/v1.4.0/mods_v1.4.0_Linux_x86_64.tar.gz" || true
            ;;
    esac
    
    chmod +x "$HOME/.local/bin/$name" 2>/dev/null || true
    
    if command -v "$name" &> /dev/null; then
        echo "✅ $name baixado com fallback"
    else
        echo "❌ Falha ao baixar $name"
    fi
}

# Preparar ambiente
echo -e "${BLUE}🔧 Preparando ambiente...${NC}"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/fonts"

# Downloads sequenciais (um por vez para evitar travamento)
echo -e "${BLUE}📥 Baixando ferramentas (sequencial)...${NC}"

download_tool_robust "eza" "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" "tar"
download_tool_robust "bat" "https://github.com/sharkdp/bat/releases/latest/download/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" "tar"
download_tool_robust "zoxide" "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-x86_64-unknown-linux-musl.tar.gz" "tar"
download_tool_robust "fzf" "https://github.com/junegunn/fzf/releases/latest/download/fzf-0.53.0-linux_amd64.tar.gz" "tar"
download_tool_robust "delta" "https://github.com/dandavison/delta/releases/latest/download/delta-0.18.2-x86_64-unknown-linux-gnu.tar.gz" "tar"
download_tool_robust "mods" "https://github.com/charmbracelet/mods/releases/latest/download/mods_v1.4.0_Linux_x86_64.tar.gz" "tar"

# Zinit (com verificação)
echo -e "${BLUE}🔧 Instalando Zinit...${NC}"
if [ ! -d "$ZINIT_HOME" ]; then
    if git clone --depth 1 --timeout 60 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
        echo "✅ Zinit instalado"
    else
        echo "❌ Falha ao instalar Zinit"
    fi
else
    echo "✅ Zinit já existe"
fi

# Fontes (com verificação)
echo -e "${BLUE}🔤 Baixando fontes...${NC}"
FONT_DIR="$HOME/.local/share/fonts"

if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    if curl -sL --connect-timeout 15 --max-time 60 --retry 3 -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"; then
        echo "✅ Fonte regular baixada"
    else
        echo "❌ Falha ao baixar fonte regular"
    fi
fi

# Vim-plug
echo -e "${BLUE}🔌 Instalando Vim-plug...${NC}"
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    if curl -sL --connect-timeout 15 --max-time 60 --retry 3 -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
        echo "✅ Vim-plug instalado"
    else
        echo "❌ Falha ao instalar Vim-plug"
    fi
fi

# NVM
echo -e "${BLUE}📦 Instalando NVM...${NC}"
if [ ! -d "$HOME/.nvm" ]; then
    if curl -sL --connect-timeout 15 --max-time 60 --retry 3 -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash; then
        echo "✅ NVM instalado"
    else
        echo "❌ Falha ao instalar NVM"
    fi
else
    echo "✅ NVM já existe"
fi

# Aider (se tiver python)
if command -v pip3 &> /dev/null; then
    echo -e "${BLUE}🤖 Instalando Aider...${NC}"
    if pip3 install --quiet --timeout 300 aider-chat; then
        echo "✅ Aider instalado"
    else
        echo "❌ Falha ao instalar Aider"
    fi
fi

# Configurações
echo -e "${BLUE}⚙️ Configurando ambiente...${NC}"
ln -sf "$REPO_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$REPO_DIR/update.sh" "$HOME/.local/bin/update_dotfiles"
chmod +x "$REPO_DIR/update.sh"

# Cache de fontes
if command -v fc-cache &> /dev/null; then
    echo -e "${BLUE}🔄 Atualizando cache de fontes...${NC}"
    fc-cache -f "$FONT_DIR" 2>/dev/null || true
fi

# Mudar shell
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo -e "${BLUE}🔄 Mudando shell para Zsh...${NC}"
        chsh -s "$(which zsh)" 2>/dev/null || echo "⚠️  Execute manualmente: chsh -s \$(which zsh)"
    fi
fi

# Resumo final
echo -e "\n${GREEN}✅ Instalação Robusta Concluída!${NC}"
echo -e "${YELLOW}📊 Resumo:${NC}"

echo -e "🔧 Ferramentas:"
for tool in eza bat zoxide fzf delta mods; do
    if command -v "$tool" &> /dev/null; then
        echo -e "  ✅ $tool"
    else
        echo -e "  ❌ $tool"
    fi
done

if command -v aider &> /dev/null; then
    echo -e "  ✅ aider"
else
    echo -e "  ❌ aider"
fi

echo -e "\n${YELLOW}📝 Próximos passos:${NC}"
echo -e "1. Configure a fonte MesloLGS NF no seu terminal"
echo -e "2. Abra um novo terminal ou rode: ${BLUE}zsh${NC}"
echo -e "3. Instale plugins do Vim: ${BLUE}vim +PlugInstall +qall${NC}"
echo -e "4. Configure API Key da IA: ${BLUE}mods --settings${NC}"
echo -e "\n${GREEN}🎉 Tempo total: ~3-5 minutos (seguro e confiável)!${NC}"
