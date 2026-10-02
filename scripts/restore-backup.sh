#!/usr/bin/env bash
# =============================================================
#  Restaura o backup de migracao (pasta backup-migracao-i7) do
#  Google Drive para a nova maquina.
#  Uso:  scripts/restore-backup.sh [pasta_local_do_backup]
#  Se a pasta local nao existir, baixa do Drive com o rclone.
#  Nao contem nenhum segredo: as chaves ficam em segredos.tar.gz.gpg
#  (criptografado com a senha que so voce sabe).
# =============================================================
set -euo pipefail

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
source "$REPO_DIR/scripts/common.sh"

BIN_DIR="$HOME/.local/bin"; mkdir -p "$BIN_DIR"; export PATH="$BIN_DIR:$PATH"
SRC="${1:-$HOME/backup-migracao-i7}"
REMOTE="gdrive:backup-migracao-i7"

# --- 1. obter os arquivos ---
if [ ! -f "$SRC/SHA256SUMS" ]; then
    say "Baixando o backup do Google Drive"
    if ! command -v rclone >/dev/null 2>&1; then
        curl -fsSL -o "$TMP/rclone.zip" https://downloads.rclone.org/rclone-current-linux-amd64.zip
        command -v unzip >/dev/null 2>&1 || { detect_apt_mode; $SUDO apt-get install -y unzip >/dev/null; }
        unzip -q -o "$TMP/rclone.zip" -d "$TMP/rc"
        install -m 0755 "$TMP"/rc/rclone-*-linux-amd64/rclone "$BIN_DIR/rclone"
        ok "rclone instalado"
    fi
    if ! rclone listremotes 2>/dev/null | grep -q '^gdrive:'; then
        echo "  Vai abrir o navegador para autorizar o Google Drive."
        rclone config create gdrive drive scope=drive >/dev/null
    fi
    mkdir -p "$SRC"
    rclone copy "$REMOTE" "$SRC" --progress
fi

# --- 2. conferir integridade ---
say "Conferindo integridade (SHA256)"
( cd "$SRC" && sha256sum -c SHA256SUMS ) || { err "arquivo corrompido; baixe de novo"; exit 1; }

# --- 3. chaves (criptografadas) ---
say "Restaurando chaves SSH, keystore e credenciais"
if [ -f "$SRC/segredos.tar.gz.gpg" ]; then
    gpg -d "$SRC/segredos.tar.gz.gpg" | tar xz -C "$HOME"
    chmod 700 "$HOME/.ssh" "$HOME/.keys" 2>/dev/null || true
    chmod 600 "$HOME"/.ssh/id_* "$HOME"/.ssh/*_id_* "$HOME"/.keys/* 2>/dev/null || true
    ok "segredos restaurados"
fi

# --- 4. projetos, arquivos e configuracoes ---
# Configs especificas do COSMIC/Pop (cosmic, dconf, gtk) nao sao restauradas
# no Ubuntu: o dconf do Pop mistura chaves incompativeis com o GNOME.
EXCL=(--exclude='.config/cosmic*' --exclude='.config/dconf' --exclude='.config/gtk-3.0' --exclude='.config/gtk-4.0')
say "Restaurando projetos (dev), arquivos pessoais e configuracoes"
for f in dev pessoais configs configs-resto; do
    [ -f "$SRC/$f.tar.gz" ] || continue
    tar xzf "$SRC/$f.tar.gz" -C "$HOME" "${EXCL[@]}"
    ok "$f"
done

# --- 5. navegadores (opcional) ---
if [ -f "$SRC/navegadores.tar.gz" ] && ask_yes "Restaurar perfis do Brave/Firefox? (prefira o Sync do Brave) [s/N]" n; then
    tar xzf "$SRC/navegadores.tar.gz" -C "$HOME"; ok "navegadores"
fi

cat <<'MSG'

== Proximos passos ==
  1. Stashes: dentro de cada repositorio, 'git stash list' e 'git stash apply stash^{/pre-migracao-i7}'.
  2. Preencha ~/.env com as senhas do keystore (veja configs/env.example).
  3. Chaveiro do sistema: o Brave/gh podem pedir login de novo se a senha do usuario mudou.
  4. Revogue o acesso do rclone em https://myaccount.google.com/permissions.
MSG
