#!/usr/bin/env bash
# =============================================================
#  Instalador de dotfiles (claudio1code)
#  - Leve: sem Homebrew. Usa apt (com sudo) ou binarios
#    estaticos user-local (~/.local/bin) quando nao ha sudo.
#  - Idempotente: pode rodar quantas vezes quiser.
#  Uso:
#    ./install.sh                 # detecta e instala
#    DOTFILES_NO_SUDO=1 ./install.sh   # forca modo sem sudo (42, restrito)
# =============================================================
set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
say()  { printf "\n${BLUE}== %s ==${NC}\n" "$1"; }
ok()   { printf "${GREEN}  ok: %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}  aviso: %s${NC}\n" "$1"; }
err()  { printf "${RED}  erro: %s${NC}\n" "$1"; }

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BIN_DIR="$HOME/.local/bin"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
mkdir -p "$BIN_DIR"

# --- Decidir estrategia de instalacao ---
USE_APT=0
if [ "${DOTFILES_NO_SUDO:-0}" != "1" ] && command -v apt-get >/dev/null 2>&1; then
    if [ "$(id -u)" -eq 0 ] || (command -v sudo >/dev/null 2>&1 && groups | grep -qE '\bsudo\b|\badmin\b'); then
        USE_APT=1
    fi
fi

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

# -------------------------------------------------------------
#  Helpers para instalacao de binarios estaticos (modo sem apt)
# -------------------------------------------------------------
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

latest_asset_url() {
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
        | grep -oE '"browser_download_url": *"[^"]+"' | cut -d'"' -f4 \
        | grep -E "$2" | head -1
}

install_bin() {  # repo  nome_binario  regex_asset
    local repo="$1" binname="$2" pattern="$3"
    if [ -x "$BIN_DIR/$binname" ] || command -v "$binname" >/dev/null 2>&1; then
        ok "$binname (ja presente)"; return 0
    fi
    local url; url="$(latest_asset_url "$repo" "$pattern" || true)"
    if [ -z "$url" ]; then err "asset nao encontrado para $repo"; return 1; fi
    local arc="$TMP/$(basename "$url")"
    curl -fsSL -o "$arc" "$url"
    local ex="$TMP/ex_$binname"; mkdir -p "$ex"; tar -xzf "$arc" -C "$ex"
    local found; found="$(find "$ex" -type f -name "$binname" | head -1)"
    if [ -z "$found" ]; then err "binario $binname nao encontrado no pacote"; return 1; fi
    install -m 0755 "$found" "$BIN_DIR/$binname"
    ok "$binname -> $BIN_DIR/$binname"
}

install_tools_static() {
    local MUSL='x86_64-unknown-linux-musl\.tar\.gz$'
    install_bin eza-community/eza   eza    "$MUSL" || true
    install_bin sharkdp/bat         bat    "$MUSL" || true
    install_bin sharkdp/fd          fd     "$MUSL" || true
    install_bin BurntSushi/ripgrep  rg     "$MUSL" || true
    install_bin ajeetdsouza/zoxide  zoxide "$MUSL" || true
    install_bin junegunn/fzf        fzf    'linux_amd64\.tar\.gz$' || true
    install_gh_static
}

install_gh_static() {
    if command -v gh >/dev/null 2>&1 || [ -x "$BIN_DIR/gh" ]; then ok "gh (ja presente)"; return 0; fi
    local url; url="$(latest_asset_url cli/cli 'linux_amd64\.tar\.gz$' || true)"
    if [ -z "$url" ]; then err "gh: asset nao encontrado"; return 1; fi
    local arc="$TMP/$(basename "$url")"; curl -fsSL -o "$arc" "$url"
    local ex="$TMP/ex_gh"; mkdir -p "$ex"; tar -xzf "$arc" -C "$ex"
    install -m 0755 "$(find "$ex" -type f -name gh | head -1)" "$BIN_DIR/gh"
    ok "gh -> $BIN_DIR/gh"
}

# -------------------------------------------------------------
#  1. Ferramentas
# -------------------------------------------------------------
say "Instalando ferramentas"
if [ "$USE_APT" -eq 1 ]; then
    echo "  usando apt (pode pedir sua senha de sudo)"
    $SUDO apt-get update -y
    # instala uma a uma para nao abortar se algum pacote faltar no repo
    for pkg in zsh git curl eza bat fd-find ripgrep fzf zoxide; do
        if $SUDO apt-get install -y "$pkg" >/dev/null 2>&1; then ok "$pkg"; else warn "$pkg indisponivel no apt"; fi
    done
    # gh nao vem nos repos padrao: instala binario estatico user-local
    install_gh_static
else
    echo "  sem sudo: instalando binarios estaticos em $BIN_DIR"
    install_tools_static
    if ! command -v zsh >/dev/null 2>&1; then
        warn "zsh nao instalado (precisa de sudo). Rode:  sudo apt install -y zsh"
    fi
fi

# -------------------------------------------------------------
#  2. Zinit (gerenciador de plugins do zsh)
# -------------------------------------------------------------
say "Configurando Zinit"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    ok "zinit clonado"
else
    ok "zinit ja presente"
fi

# -------------------------------------------------------------
#  3. Symlinks
# -------------------------------------------------------------
say "Criando symlinks"
ln -sf "$REPO_DIR/configs/zshrc"  "$HOME/.zshrc";  ok "~/.zshrc"
ln -sf "$REPO_DIR/configs/.vimrc" "$HOME/.vimrc";  ok "~/.vimrc"
chmod +x "$REPO_DIR/scripts/"*.sh
ln -sf "$REPO_DIR/scripts/update.sh"      "$BIN_DIR/update_dotfiles"; ok "update_dotfiles"
ln -sf "$REPO_DIR/scripts/clear_home.sh"  "$BIN_DIR/clear_home";      ok "clear_home"

# -------------------------------------------------------------
#  4. Fonte com icones (MesloLGS Nerd Font) - necessaria p/ eza --icons
# -------------------------------------------------------------
say "Instalando fonte com icones (MesloLGS NF)"
FONT_DIR="$HOME/.local/share/fonts"; mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    curl -fsSL -o "$FONT_DIR/MesloLGS NF Regular.ttf" \
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$FONT_DIR" >/dev/null 2>&1
    ok "fonte instalada"
else
    ok "fonte ja instalada"
fi

# -------------------------------------------------------------
#  5. Shell padrao (opcional)
# -------------------------------------------------------------
if command -v zsh >/dev/null 2>&1 && [ "${SHELL:-}" != "$(command -v zsh)" ]; then
    say "Shell padrao"
    echo -n "  Definir zsh como shell padrao agora? [s/N] "
    read -r ans || ans=""
    if [[ "$ans" =~ ^[SsYy]$ ]]; then
        chsh -s "$(command -v zsh)" && ok "shell padrao alterado (vale no proximo login)" || warn "nao foi possivel rodar chsh"
    fi
fi

say "Concluido"
echo "  Abra um novo terminal ou rode: zsh"
echo "  Configure o terminal para usar a fonte 'MesloLGS NF' para ver os icones."
