#!/bin/bash
echo "🚀 Iniciando faxina COMPLETA na home..."

# Capturar espaço usado antes da limpeza
BEFORE=$(df -k ~ | awk 'NR==2 {print $3}')

# 1. Navegadores (Chrome, Brave e resquícios de Firefox)
rm -rf ~/.config/google-chrome/Default/Cache/*
rm -rf ~/.config/google-chrome/Default/Code\ Cache/*
rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/Cache/*
rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/Code\ Cache/*
rm -rf ~/.cache/mozilla/firefox/*
rm -rf ~/.cache/google-chrome/*
rm -rf ~/.cache/BraveSoftware/*
echo "✅ Caches de Navegadores limpos (Brave, Chrome, Firefox)."

# 2. Desenvolvimento (Node, Python, Go, Rust)
# Node/NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm cache clear &> /dev/null
rm -rf ~/.npm/_cacache/*
# Python
rm -rf ~/.cache/pip/*
# Rust (Cargo) - Limpa apenas o cache de registros, não os binários instcd doalados
rm -rf ~/.cargo/registry/cache/*
echo "✅ Caches de Desenvolvimento limpos (npm, pip, cargo, nvm)."

# 3. VS Code e Editores
rm -rf ~/.config/Code/Cache/*
rm -rf ~/.config/Code/User/workspaceStorage/*
rm -rf ~/.config/Code/CachedExtensionVSIXs/*
rm -rf ~/.vscode/extensions/ms-vscode.cpptools*
echo "✅ Caches de Editores (VS Code) limpos."

# 4. Sistema e Caches Gerais
rm -rf ~/.local/share/Trash/*
rm -rf ~/.cache/thumbnails/*
rm -rf ~/.cache/fontconfig/*
# Limpa arquivos temporários antigos em ~/.cache (mais de 7 dias)
find ~/.cache -type f -atime +7 -delete &> /dev/null
echo "✅ Lixeira, miniaturas e caches de sistema limpos."

# Otimização de Projetos 42
if [ -d "$HOME/42_projects" ]; then
    find "$HOME/42_projects" -name ".git" -type d -exec sh -c 'cd "{}"/.. && git gc --prune=now --quiet' \;
    echo "✅ Repositórios em 42_projects otimizados."
fi

# Capturar espaço usado depois da limpeza
AFTER=$(df -k ~ | awk 'NR==2 {print $3}')

# Calcular diferença
FREED_KB=$((BEFORE - AFTER))
if [ $FREED_KB -lt 0 ]; then FREED_KB=0; fi
FREED_MB=$(echo "scale=2; $FREED_KB / 1024" | bc)

echo -e "\n✨ Faxina concluída!"
echo -e "🧹 Espaço liberado nesta rodada: ${FREED_MB} MB"
echo -e "📊 Uso do Disco (Home):"
df -h ~ | awk 'NR==2 {print $3 " / " $2 " (" $5 " usado)"}'
