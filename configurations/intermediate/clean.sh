#!/bin/bash
# Script de Limpeza para a Configuração Intermediária
# Remove binários baixados manualmente para liberar espaço

BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}🗑️  Iniciando Limpeza das Ferramentas Intermediárias...${NC}"

# Remove binários locais
rm -f "$HOME/.local/bin/zoxide"
rm -f "$HOME/.local/bin/eza"
rm -f "$HOME/.local/bin/bat"
rm -f "$HOME/.local/bin/fzf"

# Remove pasta do FZF (Repo Git)
rm -rf "$HOME/.fzf"

# Opcional: Remover Zinit (Descomente se quiser limpeza total)
# rm -rf "$HOME/.local/share/zinit"

# Restaura zshrc anterior se existir backup
if [ -f "$HOME/.zshrc.backup" ]; then
    echo "  ↺ Restaurando .zshrc antigo..."
    mv "$HOME/.zshrc.backup" "$HOME/.zshrc"
else
    echo "  ⚠️  Nenhum backup do .zshrc encontrado. O arquivo atual permanece linkado."
fi

echo -e "${BLUE}✨ Limpeza concluída. Espaço liberado.${NC}"
