# =============================================================
#  Funcoes compartilhadas entre install.sh e install-extra.sh
#  Nao executa nada sozinho: e feito para ser "source"ado.
# =============================================================

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
say()  { printf "\n${BLUE}== %s ==${NC}\n" "$1"; }
ok()   { printf "${GREEN}  ok: %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}  aviso: %s${NC}\n" "$1"; }
err()  { printf "${RED}  erro: %s${NC}\n" "$1"; }

is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }

# pergunta sim/nao com default; em modo nao-interativo usa o default
ask_yes() {  # texto  default(s/n)
    local prompt="$1" def="${2:-s}" ans
    if [ ! -t 0 ]; then [ "$def" = "s" ] && return 0 || return 1; fi
    echo -n "  $prompt "
    read -r ans || ans=""
    ans="${ans:-$def}"
    [[ "$ans" =~ ^[SsYy]$ ]]
}

# decide se usamos apt (com sudo) ou binarios estaticos user-local
# define as variaveis globais USE_APT e SUDO
detect_apt_mode() {
    USE_APT=0
    if [ "${DOTFILES_NO_SUDO:-0}" != "1" ] && command -v apt-get >/dev/null 2>&1; then
        if [ "$(id -u)" -eq 0 ] || (command -v sudo >/dev/null 2>&1 && groups | grep -qE '\bsudo\b|\badmin\b'); then
            USE_APT=1
        fi
    fi
    SUDO=""
    [ "$(id -u)" -ne 0 ] && SUDO="sudo"
}

# diretorio temporario compartilhado, limpo ao sair do script que
# fez o "source" deste arquivo
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

latest_asset_url() {  # repo  regex_asset
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
        | grep -oE '"browser_download_url": *"[^"]+"' | cut -d'"' -f4 \
        | grep -E "$2" | head -1
}

# instala um binario a partir de um release .tar.gz no Github,
# em $BIN_DIR (precisa estar definida por quem faz o source)
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

# instala um binario estatico (arquivo unico, sem compactacao) a
# partir de um release no Github, em $BIN_DIR
install_bin_raw() {  # repo  nome_binario  regex_asset
    local repo="$1" binname="$2" pattern="$3"
    if [ -x "$BIN_DIR/$binname" ] || command -v "$binname" >/dev/null 2>&1; then
        ok "$binname (ja presente)"; return 0
    fi
    local url; url="$(latest_asset_url "$repo" "$pattern" || true)"
    if [ -z "$url" ]; then err "asset nao encontrado para $repo"; return 1; fi
    curl -fsSL -o "$BIN_DIR/$binname" "$url"
    chmod 0755 "$BIN_DIR/$binname"
    ok "$binname -> $BIN_DIR/$binname"
}
