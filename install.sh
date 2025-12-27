#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. DYNAMIC REPOSITORY PATH
# Get the directory where this script is located
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo -e "${BLUE}🚀 Starting Dotfiles Setup from: ${REPO_DIR}${NC}"

# Directories
LOCAL_BIN="$HOME/.local/bin"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
FONTS_DIR="$HOME/.local/share/fonts"

# Add local bin to path for this session
export PATH="$LOCAL_BIN:$PATH"
mkdir -p "$LOCAL_BIN"

# --- HELPER FUNCTIONS ---

install_tool_binary() {
    local tool_name=$1
    local download_url=$2
    local binary_path_in_tar=$3 # Path inside tar, or filename if direct
    local strip_components=${4:-0}

    if ! command -v "$tool_name" &> /dev/null; then
        echo -e "  -> Installing ${YELLOW}${tool_name}${NC}..."
        TEMP_DIR=$(mktemp -d)

        # Check if URL ends with tar.gz
        if [[ "$download_url" == *.tar.gz ]]; then
            curl -sL "$download_url" | tar -xz -C "$TEMP_DIR"

            # Find the binary in the temp dir
            if [ "$strip_components" -gt 0 ]; then
                # If stripped, it might be messy, try to find by name
                find "$TEMP_DIR" -name "$(basename $binary_path_in_tar)" -type f -exec cp {} "$LOCAL_BIN/$tool_name" \;
            else
                # Direct path extraction attempt
                if [ -f "$TEMP_DIR/$binary_path_in_tar" ]; then
                     cp "$TEMP_DIR/$binary_path_in_tar" "$LOCAL_BIN/$tool_name"
                else
                     # Fallback search
                     find "$TEMP_DIR" -name "$(basename $binary_path_in_tar)" -type f -exec cp {} "$LOCAL_BIN/$tool_name" \;
                fi
            fi
        else
            # Assume raw binary
            curl -sL "$download_url" -o "$LOCAL_BIN/$tool_name"
        fi

        chmod +x "$LOCAL_BIN/$tool_name"
        rm -rf "$TEMP_DIR"
        echo -e "  ${GREEN}✅ ${tool_name} installed.${NC}"
    else
        echo -e "  ${GREEN}✅ ${tool_name} is already installed.${NC}"
    fi
}

backup_file() {
    local file=$1
    if [ -f "$file" ] || [ -L "$file" ]; then
        echo -e "  -> Backing up existing $file to $file.bak"
        mv "$file" "$file.bak"
    fi
}

# --- 2. INSTALL LOCAL BINARIES (NO ROOT REQUIRED) ---
echo -e "${BLUE}📦 Installing Tools (Binaries)...${NC}"

# Eza (Modern ls)
install_tool_binary "eza" \
    "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" \
    "eza"

# Bat (Modern cat)
install_tool_binary "bat" \
    "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" \
    "bat"

# Zoxide (Smarter cd)
install_tool_binary "zoxide" \
    "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-x86_64-unknown-linux-musl.tar.gz" \
    "zoxide"

# FZF (Fuzzy Finder)
if [ ! -d "$HOME/.fzf" ]; then
    echo -e "  -> Installing ${YELLOW}fzf${NC}..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish --bin > /dev/null
    # Symlink binary to local bin just in case
    ln -sf "$HOME/.fzf/bin/fzf" "$LOCAL_BIN/fzf"
else
    echo -e "  ${GREEN}✅ fzf is already installed.${NC}"
fi

# --- 3. OH MY ZSH & PLUGINS ---
echo -e "${BLUE}⚡ Configuring Zsh Environment...${NC}"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "  -> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "  ${GREEN}✅ Oh My Zsh already installed.${NC}"
fi

# Zsh Autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "  -> Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Zsh Syntax Highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "  -> Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Symlink .zshrc
backup_file "$HOME/.zshrc"
ln -sf "$REPO_DIR/.zshrc" "$HOME/.zshrc"
echo -e "  ${GREEN}✅ .zshrc linked.${NC}"

# --- 4. VIM CONFIGURATION ---
echo -e "${BLUE}🎮 Configuring Vim...${NC}"

# Install Vim-Plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "  -> Installing Vim-Plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Symlink .vimrc
backup_file "$HOME/.vimrc"
ln -sf "$REPO_DIR/.vimrc" "$HOME/.vimrc"
echo -e "  ${GREEN}✅ .vimrc linked.${NC}"

# Install Plugins (non-interactive)
echo "  -> Installing Vim plugins (this might take a moment)..."
vim -es -u "$HOME/.vimrc" -i NONE -c "PlugInstall" -c "qa"
echo -e "  ${GREEN}✅ Vim plugins installed.${NC}"

# --- 5. NODE.JS & AI TOOLS (NVM) ---
echo -e "${BLUE}🤖 Configuring Node.js & AI...${NC}"

export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "  -> Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Load NVM for this session
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if command -v nvm &> /dev/null; then
    if ! nvm list | grep -q "lts"; then
        echo "  -> Installing Node LTS..."
        nvm install --lts
    fi
    nvm use --lts > /dev/null

    # Install Gemini CLI
    if ! npm list -g @google/gemini-cli > /dev/null 2>&1; then
        echo "  -> Installing Google Gemini CLI..."
        npm install -g @google/gemini-cli
    else
        echo -e "  ${GREEN}✅ Gemini CLI already installed.${NC}"
    fi

    # Create Wrapper Script for Gemini if it doesn't exist
    # The .zshrc expects start_gemini.sh in local/bin
    if [ ! -f "$LOCAL_BIN/start_gemini.sh" ]; then
        echo "  -> Creating start_gemini.sh wrapper..."
        cat << 'EOF' > "$LOCAL_BIN/start_gemini.sh"
#!/bin/bash
# Wrapper to ensure NVM is loaded before running gemini
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Check if user passed arguments
if [ $# -eq 0 ]; then
    gemini chat
else
    gemini "$@"
fi
EOF
        chmod +x "$LOCAL_BIN/start_gemini.sh"
    fi
else
    echo -e "${RED}⚠️ Could not load NVM. Skipping Node.js setup.${NC}"
fi

# --- 6. FONTS ---
echo -e "${BLUE}🅰️  Installing Fonts...${NC}"
mkdir -p "$FONTS_DIR"
if [ ! -f "$FONTS_DIR/MesloLGS NF Regular.ttf" ]; then
    curl -sL "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o "$FONTS_DIR/MesloLGS NF Regular.ttf"
    echo -e "  ${GREEN}✅ Meslo Nerd Font installed.${NC}"
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$FONTS_DIR"
    fi
else
    echo -e "  ${GREEN}✅ Fonts already present.${NC}"
fi

# --- 7. DOCUMENTATION & FINALIZATION ---
echo -e "${BLUE}📝 Generating Guide...${NC}"
cp "$REPO_DIR/vim_cheatsheet.md" "$HOME/.vim_cheatsheet.md" 2>/dev/null || true

cat << 'EOF' > "$HOME/.guia.md"
# 🚀 GUIA RÁPIDO DO AMBIENTE

## 📂 Navegação & Arquivos
z <nome>       # Pular para pasta (ex: z desktop)
ls             # Listar arquivos (com ícones)
cat <arq>      # Ler arquivo (com syntax highlighting)

## 🤖 IA (Gemini)
gemini         # Iniciar chat
gemini "msg"   # Pergunta rápida

## ⌨️ Vim
Ctrl+n         # Abrir árvore de arquivos
:PlugInstall   # Instalar plugins (se faltar algo)

## 🛠️ Manutenção
update_dotfiles # (Se configurado) ou 'git pull' na pasta dotfiles
EOF

echo -e "\n${GREEN}🎉 INSTALAÇÃO CONCLUÍDA!${NC}"
echo -e "Por favor, reinicie seu terminal ou execute: ${BLUE}source ~/.zshrc${NC}"
