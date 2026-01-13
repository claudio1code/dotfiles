#!/bin/bash

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}      DOTFILES INSTALLER MENU          ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Escolha o nível de configuração:"
echo ""
echo -e "${CYAN}1) Simples${NC}       - Apenas Prompt, Cores e Zinit (Leve)"
echo -e "${CYAN}2) Intermediário${NC} - Simples + Zoxide, FZF, Eza, Bat (Ferramentas Modernas)"
echo -e "${CYAN}3) AI / Complete${NC} - Intermediário + NVM, Node, Gemini CLI, Auto-Commit"
echo ""
echo -e "${RED}q) Sair${NC}"
echo ""
echo -n "Opção [1-3]: "
read option

case $option in
    1)
        bash ./configurations/simple/install.sh
        ;;
    2)
        bash ./configurations/intermediate/install.sh
        ;;
    3)
        bash ./configurations/ai/install.sh
        ;;
    q|Q)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opção inválida."
        exit 1
        ;;
esac