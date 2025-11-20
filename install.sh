#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando o Setup do Kit Claudio...${NC}"

# --- 1. SETUP DOTFILES REPO ---
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}ERRO: Este script deve ser executado de dentro do repositório 'dotfiles' clonado.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Repositório de dotfiles encontrado em $DOTFILES_DIR.${NC}"
fi

# Garante que estamos no diretório do repositório
cd "$DOTFILES_DIR"

# --- 2. INSTALAÇÃO DE FERRAMENTAS MODERNAS (SEM BREW) ---
echo -e "${BLUE}📦 Instalando/Verificando ferramentas...${NC}"

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Adiciona ao PATH do script atual para garantir que os comandos sejam encontrados
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    export PATH="$LOCAL_BIN:$PATH"
fi

# Função para instalar ferramentas de forma idempotente
install_tool() {
    local tool_name=$1
    local download_url=$2
    local file_in_tar=$3
    local strip_components=${4:-0}

    if ! command -v "$tool_name" &> /dev/null; then
        echo "  -> Instalando ${tool_name}..."
        TEMP_DIR=$(mktemp -d)
        wget -qO "$TEMP_DIR/tool.tar.gz" "$download_url"
        
        # Constrói os argumentos do tar dinamicamente
        local tar_command="tar -xf $TEMP_DIR/tool.tar.gz -C $LOCAL_BIN"
        if [ "$strip_components" -gt 0 ]; then
            tar_command="$tar_command --strip-components=$strip_components"
        fi
        if [ -n "$file_in_tar" ]; then
            tar_command="$tar_command $file_in_tar"
        fi
        
        eval "$tar_command"
        rm -r "$TEMP_DIR"
        echo -e "  ${GREEN}✅ ${tool_name} instalado.${NC}"
    else
        echo -e "  ${GREEN}✅ ${tool_name} já está instalado.${NC}"
    fi
}

install_tool "eza" "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" "eza"
install_tool "bat" "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" "bat-v0.24.0-x86_64-unknown-linux-gnu/bat" 1
install_tool "zoxide" "https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-0.9.4-x86_64-unknown-linux-musl.tar.gz" "zoxide"

# Oh-my-posh
if ! command -v oh-my-posh &> /dev/null; then
    echo "  -> Instalando oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$LOCAL_BIN"
else
    echo -e "  ${GREEN}✅ oh-my-posh já está instalado.${NC}"
fi

# FZF (ainda usa o método de clone do git, que é bem universal)
if [ ! -d "$HOME/.fzf" ]; then
    echo "  -> Instalando fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
else
    echo -e "  ${GREEN}✅ fzf já está instalado.${NC}"
fi

# --- 3. NODE.JS & IA (NVM) ---
echo -e "${BLUE}🤖 Configurando Node.js via NVM...${NC}"
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    echo "  -> Instalando NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! nvm list | grep -q "lts"; then
    echo "  -> Instalando Node.js LTS..."
    nvm install --lts
    nvm use --lts
else
    echo -e "  ${GREEN}✅ Node.js LTS já instalado.${NC}"
fi

# --- 4. ZSH & ZINIT ---
echo -e "${BLUE}⚡ Instalando Zinit (Gerenciador de Plugins)...${NC}"
if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
    mkdir -p "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit/zinit.git"
else
    echo -e "  ${GREEN}✅ Zinit já instalado.${NC}"
fi

# --- 5. FONTS (NERD FONT) ---
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    echo -e "${BLUE}🅰️  Instalando fontes Meslo Nerd Font...${NC}"
    curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    if command -v fc-cache >/dev/null 2>&1; then
        echo -e "${BLUE}🔄 Atualizando cache de fontes...${NC}"
        fc-cache -f "$FONT_DIR"
    fi
else
    echo -e "${GREEN}✅ Fontes já instaladas.${NC}"
fi

# --- 6. SYMLINKING DOTFILES ---
echo -e "${BLUE}🔗 Criando symlinks para os dotfiles...${NC}"
# Assumindo que os arquivos de configuração estão na raiz do repositório
ln -sf "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
# Adicione outros links conforme necessário
echo -e "  ${GREEN}✅ Symlinks criados.${NC}"


# --- 7. CRIANDO SCRIPTS E GUIAS ---
echo -e "${BLUE}📝 Criando guia e script de update...${NC}"

# Guia
cat << 'EOF' > "$HOME/.guia.md"
# 🚀 GUIA DE ATALHOS E FERRAMENTAS (CLÁUDIO)
## 🧠 Zoxide (Navegação Inteligente)
... (conteúdo do guia) ...
EOF

# Update Script
cat << 'EOF' > "$DOTFILES_DIR/update.sh"
#!/bin/bash
set -e
echo "Pulling latest changes from dotfiles repository..."
git -C "$(dirname "$0")" pull
echo "Re-running install script to apply updates..."
bash "$(dirname "$0")/install.sh"
echo "Update complete!"
EOF
chmod +x "$DOTFILES_DIR/update.sh"

echo -e "  ${GREEN}✅ Guia e script de update criados.${NC}"

echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA!${NC}"
echo -e "Reinicie o terminal ou digite: ${BLUE}source ~/.zshrc${NC}"
echo -e "Para atualizar no futuro, rode: ${BLUE}bash ~/dotfiles/update.sh${NC}"
