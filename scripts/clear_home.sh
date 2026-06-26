#!/usr/bin/env bash
# Faxina de caches da home. Apaga apenas caches regeneraveis,
# nunca configuracoes, extensoes instaladas ou dados de usuario.
set -uo pipefail

echo "Iniciando limpeza de caches da home..."

BEFORE=$(df -k "$HOME" | awk 'NR==2 {print $3}')

# 1. Navegadores (apenas Cache / Code Cache)
rm -rf ~/.config/google-chrome/Default/Cache/* 2>/dev/null
rm -rf ~/.config/google-chrome/Default/Code\ Cache/* 2>/dev/null
rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/Cache/* 2>/dev/null
rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/Code\ Cache/* 2>/dev/null
rm -rf ~/.cache/mozilla/firefox/* 2>/dev/null
rm -rf ~/.cache/google-chrome/* 2>/dev/null
rm -rf ~/.cache/BraveSoftware/* 2>/dev/null
echo "  navegadores: caches limpos."

# 2. Desenvolvimento (Node, Python, Rust) - apenas caches, nao binarios
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm cache clear &>/dev/null
rm -rf ~/.npm/_cacache/* 2>/dev/null
rm -rf ~/.cache/pip/* 2>/dev/null
rm -rf ~/.cargo/registry/cache/* 2>/dev/null
echo "  dev: caches limpos (npm, pip, cargo, nvm)."

# 3. VS Code - apenas cache, preserva extensoes e settings
rm -rf ~/.config/Code/Cache/* 2>/dev/null
rm -rf ~/.config/Code/CachedData/* 2>/dev/null
rm -rf ~/.config/Code/CachedExtensionVSIXs/* 2>/dev/null
echo "  vscode: caches limpos (extensoes preservadas)."

# 4. Sistema (lixeira, miniaturas, fontconfig) e caches antigos (>7 dias)
rm -rf ~/.local/share/Trash/* 2>/dev/null
rm -rf ~/.cache/thumbnails/* 2>/dev/null
rm -rf ~/.cache/fontconfig/* 2>/dev/null
find ~/.cache -type f -atime +7 -delete 2>/dev/null
echo "  sistema: lixeira, miniaturas e caches antigos limpos."

# 5. (Opcional) otimizar repositorios git em ~/42_projects, se existir
if [ -d "$HOME/42_projects" ]; then
    find "$HOME/42_projects" -name ".git" -type d -prune -exec sh -c \
        'cd "$(dirname "{}")" && git gc --prune=now --quiet' \; 2>/dev/null
    echo "  42_projects: repositorios git otimizados."
fi

AFTER=$(df -k "$HOME" | awk 'NR==2 {print $3}')
FREED_KB=$((BEFORE - AFTER)); [ "$FREED_KB" -lt 0 ] && FREED_KB=0
echo ""
echo "Faxina concluida. Espaco liberado: $((FREED_KB / 1024)) MB"
df -h "$HOME" | awk 'NR==2 {print "Uso do disco (home): " $3 " / " $2 " (" $5 ")"}'
