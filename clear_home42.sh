#!/bin/bash
echo "🚀 Iniciando faxina PESADA na home..."

# Carregar ambiente NVM para o comando funcionar no script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 1. Limpeza Chrome (Caches e Instaladores de Componentes)
rm -rf ~/.config/google-chrome/Default/Cache/*
rm -rf ~/.config/google-chrome/Default/Code\ Cache/*
rm -rf ~/.config/google-chrome/Default/IndexedDB/*
rm -rf ~/.config/google-chrome/Default/Service\ Worker/*
rm -rf ~/.config/google-chrome/component_crx_cache/*
rm -rf ~/.config/google-chrome/extensions_crx_cache/*
echo "✅ Chrome limpo (Cache, componentes e dados de sites)."

# 2. Limpeza VS Code (Removendo duplicatas e instaladores)
rm -rf ~/.config/Code/Cache/*
rm -rf ~/.config/Code/User/workspaceStorage/*
rm -rf ~/.config/Code/CachedExtensionVSIXs/*
# Removendo especificamente a versão antiga da extensão de C++ que vimos no seu log
rm -rf ~/.vscode/extensions/ms-vscode.cpptools-1.30.4-linux-x64
echo "✅ VS Code limpo (Instaladores e versão antiga da extensão de C++ removidos)."

# 3. NVM e Caches Gerais
nvm cache clear
rm -rf ~/.local/share/Trash/*
rm -rf ~/.cache/*
echo "✅ NVM, Lixeira e ~/.cache esvaziados."

# 4. Otimização de Projetos (Exemplo: fract-ol)
if [ -d "$HOME/cadete42/milestones/milestone2/fract-ol" ]; then
    cd "$HOME/cadete42/milestones/milestone2/fract-ol" && git gc --prune=now --aggressive &> /dev/null
    echo "✅ Histórico do Git do fract-ol otimizado."
fi

echo -e "\n📊 Espaço atual na Home:"
du -sh ~



