#!/usr/bin/env bash
# =============================================================
#  Instalador de dotfiles (claudio1code)
#  - Leve: sem Homebrew. Usa apt (com sudo) ou binarios
#    estaticos user-local (~/.local/bin) quando nao ha sudo.
#  - Idempotente: pode rodar quantas vezes quiser.
#  - Pergunta o que instalar atraves de um checklist interativo
#    (whiptail/dialog); sem elas, cai para perguntas [S/n].
#  Uso:
#    ./install.sh                 # detecta e instala
#    DOTFILES_NO_SUDO=1 ./install.sh   # forca modo sem sudo (42, restrito)
# =============================================================
set -euo pipefail

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BIN_DIR="$HOME/.local/bin"
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
mkdir -p "$BIN_DIR"

source "$REPO_DIR/scripts/common.sh"

# --- Decidir estrategia de instalacao ---
detect_apt_mode

# -------------------------------------------------------------
#  Catalogo de itens do checklist
#  Basicos vem pre-marcados (ON); extras vem desmarcados (OFF).
#  Infraestrutura (zsh/git/curl, zinit, symlinks, fonte) nao entra
#  no checklist: e sempre aplicada, e necessaria para o resto funcionar.
# -------------------------------------------------------------
ITEM_KEYS=(cli_tools claude docker node utils lazygit python vscode)
declare -A ITEM_DESC=(
    [cli_tools]="eza, bat, fd, ripgrep, zoxide, fzf, gh"
    [claude]="Claude Desktop + Claude Code CLI"
    [docker]="Docker + Docker Compose (requer sudo)"
    [node]="Node.js 22 + npm, via NodeSource (requer sudo)"
    [utils]="tmux, htop, ncdu, jq, direnv"
    [lazygit]="lazygit (TUI para git)"
    [python]="Python: pip, pipx e build-essential (requer sudo)"
    [vscode]="VS Code (requer sudo)"
)
declare -A ITEM_DEFAULT=(
    [cli_tools]=ON [claude]=ON
    [docker]=OFF [node]=OFF [utils]=OFF [lazygit]=OFF [python]=OFF [vscode]=OFF
)

contains() {  # valor -- true se estiver em $SELECTED
    local v
    for v in "${SELECTED[@]}"; do [ "$v" = "$1" ] && return 0; done
    return 1
}

select_with_menu() {  # nome_do_binario (whiptail ou dialog)
    local tool="$1" args=()
    for key in "${ITEM_KEYS[@]}"; do
        args+=("$key" "${ITEM_DESC[$key]}" "${ITEM_DEFAULT[$key]}")
    done
    local out
    if ! out=$("$tool" --title "Ferramentas (dotfiles)" \
        --checklist "Espaco marca/desmarca, enter confirma, esc cancela:" 20 78 "${#ITEM_KEYS[@]}" \
        "${args[@]}" 3>&1 1>&2 2>&3); then
        err "instalacao cancelada"
        exit 1
    fi
    eval "SELECTED=($out)"
}

select_with_prompts() {
    say "Selecione o que instalar (sem whiptail/dialog disponivel)"
    local key def label
    for key in "${ITEM_KEYS[@]}"; do
        if [ "${ITEM_DEFAULT[$key]}" = "ON" ]; then def="s"; label="[S/n]"; else def="n"; label="[s/N]"; fi
        if ask_yes "Instalar ${ITEM_DESC[$key]}? $label" "$def"; then
            SELECTED+=("$key")
        fi
    done
}

SELECTED=()
MENU_TOOL=""
if command -v whiptail >/dev/null 2>&1; then
    MENU_TOOL=whiptail
elif command -v dialog >/dev/null 2>&1; then
    MENU_TOOL=dialog
elif [ "$USE_APT" -eq 1 ]; then
    $SUDO apt-get install -y whiptail >/dev/null 2>&1 && MENU_TOOL=whiptail
fi

if [ -n "$MENU_TOOL" ] && [ -t 0 ]; then
    select_with_menu "$MENU_TOOL"
else
    select_with_prompts
fi

if [ "$USE_APT" -ne 1 ] && { contains docker || contains node || contains python || contains vscode; }; then
    warn "sem apt/sudo disponivel: docker, node, python e/ou vscode serao pulados"
fi

# -------------------------------------------------------------
#  Helpers para instalacao de binarios estaticos (modo sem apt)
# -------------------------------------------------------------
install_tools_static() {
    local MUSL='x86_64-unknown-linux-musl\.tar\.gz$'
    install_bin eza-community/eza   eza    "$MUSL" || true
    install_bin sharkdp/bat         bat    "$MUSL" || true
    install_bin sharkdp/fd          fd     "$MUSL" || true
    install_bin BurntSushi/ripgrep  rg     "$MUSL" || true
    install_bin ajeetdsouza/zoxide  zoxide "$MUSL" || true
    install_gh_static
}

# fzf: forcado via binario estatico em todos os modos (mesmo com apt),
# pois o apt do Ubuntu/Debian trava numa versao antiga (ex: 0.44) que
# nao suporta 'fzf --zsh', usado no zshrc para a integracao do shell.
install_fzf_static() {
    if [ -x "$BIN_DIR/fzf" ] && "$BIN_DIR/fzf" --zsh >/dev/null 2>&1; then
        ok "fzf (ja presente, versao compativel)"; return 0
    fi
    local url; url="$(latest_asset_url junegunn/fzf 'linux_amd64\.tar\.gz$' || true)"
    if [ -z "$url" ]; then err "fzf: asset nao encontrado"; return 1; fi
    local arc="$TMP/$(basename "$url")"; curl -fsSL -o "$arc" "$url"
    local ex="$TMP/ex_fzf"; mkdir -p "$ex"; tar -xzf "$arc" -C "$ex"
    install -m 0755 "$(find "$ex" -type f -name fzf | head -1)" "$BIN_DIR/fzf"
    ok "fzf -> $BIN_DIR/fzf (versao com suporte a --zsh)"
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
#  Helpers para os itens extras (docker, node, utils, lazygit, ...)
# -------------------------------------------------------------
install_docker() {
    if command -v docker >/dev/null 2>&1; then ok "docker (ja presente)"; return 0; fi
    if [ "$USE_APT" -ne 1 ]; then warn "docker precisa de apt + sudo; pulado"; return 0; fi
    say "Instalando Docker + Docker Compose"
    $SUDO install -m 0755 -d /etc/apt/keyrings
    $SUDO curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    $SUDO chmod a+r /etc/apt/keyrings/docker.asc
    local codename; codename="$(. /etc/os-release && echo "$VERSION_CODENAME")"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $codename stable" \
        | $SUDO tee /etc/apt/sources.list.d/docker.list >/dev/null
    $SUDO apt-get update -y
    if $SUDO apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
        ok "docker + docker compose"
        if $SUDO usermod -aG docker "$(id -un)"; then
            warn "usuario adicionado ao grupo 'docker'; faca logout/login (ou rode 'newgrp docker') para usar sem sudo"
        fi
    else
        err "falha ao instalar o docker"
    fi
}

install_node() {
    if command -v npm >/dev/null 2>&1; then ok "node/npm (ja presente)"; return 0; fi
    if [ "$USE_APT" -ne 1 ]; then warn "node precisa de apt + sudo; pulado"; return 0; fi
    say "Instalando Node.js 22 + npm"
    curl -fsSL https://deb.nodesource.com/setup_22.x | $SUDO -E bash -
    if $SUDO apt-get install -y nodejs; then
        ok "node $(node -v 2>/dev/null) / npm $(npm -v 2>/dev/null)"
    else
        err "falha ao instalar o node"
    fi
}

install_utils() {
    say "Instalando tmux, htop, ncdu, jq, direnv"
    if [ "$USE_APT" -eq 1 ]; then
        for pkg in tmux htop ncdu jq direnv; do
            if $SUDO apt-get install -y "$pkg" >/dev/null 2>&1; then ok "$pkg"; else warn "$pkg indisponivel no apt"; fi
        done
    else
        warn "sem sudo: tmux/htop/ncdu nao tem binario estatico simples, pulados"
        install_bin_raw jqlang/jq jq 'jq-linux-amd64$'
        if command -v direnv >/dev/null 2>&1 || [ -x "$BIN_DIR/direnv" ]; then
            ok "direnv (ja presente)"
        else
            curl -sfL https://direnv.net/install.sh | bin_path="$BIN_DIR" bash \
                && ok "direnv -> $BIN_DIR/direnv"
        fi
    fi
    add_direnv_hook
}

install_lazygit() {
    install_bin jesseduffield/lazygit lazygit 'lazygit_[0-9.]+_linux_x86_64\.tar\.gz$'
}

install_python() {
    if [ "$USE_APT" -ne 1 ]; then warn "python pip/pipx/build-essential precisam de apt + sudo; pulado"; return 0; fi
    say "Instalando Python pip, pipx e build-essential"
    for pkg in build-essential python3-pip pipx; do
        if $SUDO apt-get install -y "$pkg" >/dev/null 2>&1; then ok "$pkg"; else warn "$pkg indisponivel no apt"; fi
    done
    command -v pipx >/dev/null 2>&1 && pipx ensurepath >/dev/null 2>&1
}

install_vscode() {
    if command -v code >/dev/null 2>&1; then ok "vscode (ja presente)"; return 0; fi
    if [ "$USE_APT" -ne 1 ]; then warn "vscode precisa de apt + sudo; pulado"; return 0; fi
    say "Instalando VS Code"
    $SUDO install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor | $SUDO tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
        | $SUDO tee /etc/apt/sources.list.d/vscode.list >/dev/null
    $SUDO apt-get update -y
    if $SUDO apt-get install -y code; then ok "vscode"; else err "falha ao instalar o vscode"; fi
}

# direnv so funciona com o hook no shell; adiciona uma vez, de forma
# guardada (segue o padrao do resto do configs/zshrc)
add_direnv_hook() {
    local zshrc="$REPO_DIR/configs/zshrc"
    grep -q 'direnv hook zsh' "$zshrc" 2>/dev/null && return 0
    cat >> "$zshrc" <<'EOF'

# --- DIRENV (variaveis de ambiente por diretorio) ---
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
EOF
    ok "hook do direnv adicionado ao configs/zshrc"
}

# -------------------------------------------------------------
#  1. Ferramentas essenciais (sempre instaladas)
# -------------------------------------------------------------
say "Instalando ferramentas essenciais"
if [ "$USE_APT" -eq 1 ]; then
    echo "  usando apt (pode pedir sua senha de sudo)"
    $SUDO apt-get update -y
    for pkg in zsh git curl; do
        if $SUDO apt-get install -y "$pkg" >/dev/null 2>&1; then ok "$pkg"; else warn "$pkg indisponivel no apt"; fi
    done
else
    echo "  sem sudo: zsh precisa ser instalado manualmente"
    if ! command -v zsh >/dev/null 2>&1; then
        warn "zsh nao instalado (precisa de sudo). Rode:  sudo apt install -y zsh"
    fi
fi

# -------------------------------------------------------------
#  2. Ferramentas de linha de comando (opcional, do checklist)
# -------------------------------------------------------------
if contains cli_tools; then
    say "Instalando ferramentas de linha de comando"
    if [ "$USE_APT" -eq 1 ]; then
        for pkg in eza bat fd-find ripgrep zoxide; do
            if $SUDO apt-get install -y "$pkg" >/dev/null 2>&1; then ok "$pkg"; else warn "$pkg indisponivel no apt"; fi
        done
        install_gh_static
    else
        echo "  sem sudo: instalando binarios estaticos em $BIN_DIR"
        install_tools_static
    fi
    # fzf: sempre via binario estatico (apt costuma ter versao antiga demais)
    install_fzf_static
fi

# Extensao gh-models: IA gratuita (usada por 'gcommit' e 'ai')
if command -v gh >/dev/null 2>&1; then
    if gh extension list 2>/dev/null | grep -q 'github/gh-models'; then
        ok "gh-models (ja presente)"
    elif gh extension install github/gh-models >/dev/null 2>&1; then
        ok "gh-models (IA gratuita)"
    else
        warn "nao foi possivel instalar gh-models agora (rode 'gh auth login' e tente de novo)"
    fi
fi

# -------------------------------------------------------------
#  3. Zinit (gerenciador de plugins do zsh)
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
#  4. Symlinks
# -------------------------------------------------------------
say "Criando symlinks"
ln -sf "$REPO_DIR/configs/zshrc"  "$HOME/.zshrc";  ok "~/.zshrc"
ln -sf "$REPO_DIR/configs/.vimrc" "$HOME/.vimrc";  ok "~/.vimrc"
chmod +x "$REPO_DIR/scripts/"*.sh
ln -sf "$REPO_DIR/scripts/update.sh"      "$BIN_DIR/update_dotfiles"; ok "update_dotfiles"
ln -sf "$REPO_DIR/scripts/clear_home.sh"  "$BIN_DIR/clear_home";      ok "clear_home"

# -------------------------------------------------------------
#  5. Fonte com icones (MesloLGS Nerd Font) - necessaria p/ eza --icons
# -------------------------------------------------------------
say "Instalando fonte com icones (MesloLGS NF)"
FONT_DIR="$HOME/.local/share/fonts"; mkdir -p "$FONT_DIR"
FONT_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
FONT_VARIANTS=("Regular" "Bold" "Italic" "Bold Italic")
for v in "${FONT_VARIANTS[@]}"; do
    enc="${v// /%20}"
    [ -f "$FONT_DIR/MesloLGS NF $v.ttf" ] || \
        curl -fsSL -o "$FONT_DIR/MesloLGS NF $v.ttf" "$FONT_BASE/MesloLGS%20NF%20$enc.ttf"
done
command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$FONT_DIR" >/dev/null 2>&1
ok "fonte instalada no Linux"

if is_wsl && command -v powershell.exe >/dev/null 2>&1; then
    # ---- WSL: o terminal e um app do Windows; a fonte precisa estar la ----
    say "Ambiente WSL detectado: integrando a fonte com o Windows"
    WIN_USER="$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r\n')"
    WIN_DESK="/mnt/c/Users/$WIN_USER/Desktop/MesloLGS-NF"
    if [ -n "$WIN_USER" ] && mkdir -p "$WIN_DESK" 2>/dev/null; then
        cp "$FONT_DIR/"MesloLGS\ NF*.ttf "$WIN_DESK/" 2>/dev/null
        cat > "$WIN_DESK/install-fonts.ps1" <<'PS1'
$src = "$env:USERPROFILE\Desktop\MesloLGS-NF"
$dest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$reg = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
Get-ChildItem "$src\*.ttf" | ForEach-Object {
  Copy-Item $_.FullName (Join-Path $dest $_.Name) -Force
  $rn = [System.IO.Path]::GetFileNameWithoutExtension($_.Name) + " (TrueType)"
  New-ItemProperty -Path $reg -Name $rn -Value (Join-Path $dest $_.Name) -PropertyType String -Force | Out-Null
}
PS1
        if powershell.exe -NoProfile -ExecutionPolicy Bypass \
            -File "C:\\Users\\$WIN_USER\\Desktop\\MesloLGS-NF\\install-fonts.ps1" >/dev/null 2>&1; then
            ok "fonte instalada no Windows (por usuario, sem admin)"
        else
            warn "instale a fonte manualmente a partir de $WIN_DESK"
        fi
    fi

    # ---- Configurar o Windows Terminal automaticamente (opcional) ----
    if [ "${DOTFILES_NO_WT:-0}" != "1" ] \
       && ask_yes "Definir 'MesloLGS NF' como fonte do Windows Terminal agora? [S/n]" s; then
        WT_PS="$(mktemp --suffix=.ps1)"
        cat > "$WT_PS" <<'PS1'
$ErrorActionPreference = 'Stop'
$paths = @()
$paths += Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal*\LocalState\settings.json" -ErrorAction SilentlyContinue
$paths += Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview*\LocalState\settings.json" -ErrorAction SilentlyContinue
$unpkg = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
if (Test-Path $unpkg) { $paths += Get-Item $unpkg }
if ($paths.Count -eq 0) { Write-Output "NO_WT"; exit 0 }
foreach ($f in $paths) {
  Copy-Item $f.FullName ($f.FullName + ".bak-dotfiles") -Force
  $j = Get-Content $f.FullName -Raw | ConvertFrom-Json
  if (-not $j.profiles)          { $j | Add-Member profiles ([pscustomobject]@{}) -Force }
  if (-not $j.profiles.defaults) { $j.profiles | Add-Member defaults ([pscustomobject]@{}) -Force }
  if (-not $j.profiles.defaults.font) { $j.profiles.defaults | Add-Member font ([pscustomobject]@{}) -Force }
  $j.profiles.defaults.font | Add-Member face "MesloLGS NF" -Force
  $out = $j | ConvertTo-Json -Depth 32
  [System.IO.File]::WriteAllText($f.FullName, $out, (New-Object System.Text.UTF8Encoding $false))
  Write-Output ("OK " + $f.FullName)
}
PS1
        WT_WINPATH="$(wslpath -w "$WT_PS" 2>/dev/null)"
        WT_OUT="$(powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$WT_WINPATH" 2>/dev/null | tr -d '\r')"
        rm -f "$WT_PS"
        if printf '%s' "$WT_OUT" | grep -q '^OK'; then
            ok "Windows Terminal configurado (backup .bak-dotfiles criado)"
            echo "  Feche e reabra o Windows Terminal para aplicar."
        elif printf '%s' "$WT_OUT" | grep -q 'NO_WT'; then
            warn "settings.json do Windows Terminal nao encontrado; selecione a fonte manualmente"
        else
            warn "nao foi possivel ajustar o Windows Terminal; selecione 'MesloLGS NF' manualmente"
        fi
    fi
    echo "  VS Code (terminal): defina 'terminal.integrated.fontFamily': 'MesloLGS NF'"
else
    # ---- Linux nativo ----
    echo "  Linux nativo: selecione a fonte 'MesloLGS NF' nas preferencias do seu terminal."
fi

# -------------------------------------------------------------
#  6. Shell padrao: define zsh automaticamente
#     (opt-out: rode com DOTFILES_NO_CHSH=1 para nao alterar)
# -------------------------------------------------------------
CURRENT_SHELL="$(getent passwd "$(id -un)" | cut -d: -f7)"
if command -v zsh >/dev/null 2>&1 && [ "${DOTFILES_NO_CHSH:-0}" != "1" ] \
   && [ "$CURRENT_SHELL" != "$(command -v zsh)" ]; then
    say "Definindo zsh como shell padrao"
    if chsh -s "$(command -v zsh)" 2>/dev/null; then
        ok "shell padrao = zsh (vale no proximo login)"
    else
        warn "chsh falhou (pode pedir senha). Rode manualmente: chsh -s \"\$(which zsh)\""
    fi
fi

# -------------------------------------------------------------
#  7. Claude Desktop e Claude Code CLI (opcional, do checklist)
# -------------------------------------------------------------
if contains claude; then
    say "Instalando Claude Desktop e Claude Code CLI"

    if [ "$USE_APT" -eq 1 ]; then
        if command -v claude-desktop >/dev/null 2>&1; then
            ok "claude-desktop (ja presente)"
        else
            $SUDO curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc \
                https://downloads.claude.ai/claude-desktop/key.asc
            echo "deb [signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" \
                | $SUDO tee /etc/apt/sources.list.d/claude-desktop.list >/dev/null
            $SUDO apt-get update -y
            if $SUDO apt-get install -y claude-desktop; then
                ok "claude-desktop"
            else
                warn "claude-desktop: falha na instalacao via apt"
            fi
        fi
    else
        warn "claude-desktop precisa de apt+sudo; pulado nesta maquina"
    fi

    if command -v claude >/dev/null 2>&1; then
        ok "claude (CLI) ja presente"
    else
        curl -fsSL https://claude.ai/install.sh | bash
        ok "claude (CLI) instalado"
    fi
fi

# -------------------------------------------------------------
#  8. Extras (opcional, do checklist): Docker, Node, utilitarios...
# -------------------------------------------------------------
contains docker  && install_docker
contains node    && install_node
contains utils   && install_utils
contains lazygit && install_lazygit
contains python  && install_python
contains vscode  && install_vscode

say "Concluido"
echo "  Abra um novo terminal ou rode: zsh"
if is_wsl; then
    echo "  Feche e reabra o Windows Terminal para aplicar a fonte 'MesloLGS NF'."
else
    echo "  Selecione a fonte 'MesloLGS NF' nas preferencias do seu terminal."
fi
