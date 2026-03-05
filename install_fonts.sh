#!/bin/bash
set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔤 Instalando Fontes Nerd Fonts${NC}"
echo -e "${YELLOW}Download + Instalação + Cache${NC}"

# Criar diretório de fontes
FONT_DIR="$HOME/.local/share/fonts"
echo -e "${BLUE}📁 Criando diretório de fontes...${NC}"
mkdir -p "$FONT_DIR"

# Baixar fontes Nerd Fonts (JetBrains Mono é mais popular)
echo -e "${BLUE}📥 Baixando JetBrains Mono Nerd Font...${NC}"

# Download do ZIP completo
echo "📦 Baixando JetBrains Mono Nerd Font..."
if curl -sL --connect-timeout 30 --max-time 300 --retry 3 -o "/tmp/JetBrainsMono.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.tar.xz"; then
    echo "✅ Download completo"
else
    echo "❌ Falha ao baixar JetBrains Mono"
    exit 1
fi

# Extrair fontes
echo -e "${BLUE}📦 Extraindo fontes...${NC}"
cd "$FONT_DIR"
if tar -xf "/tmp/JetBrainsMono.tar.xz" 2>/dev/null; then
    echo "✅ Fontes extraídas"
    rm -f "/tmp/JetBrainsMono.tar.xz"
else
    echo "❌ Falha ao extrair .tar.xz, tentando .zip..."
    # Tentar com ZIP se tar falhar
    if curl -sL --connect-timeout 30 --max-time 300 --retry 3 -o "/tmp/JetBrainsMono.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"; then
        cd "$FONT_DIR"
        if unzip -q "/tmp/JetBrainsMono.zip" 2>/dev/null; then
            echo "✅ Fontes extraídas do ZIP"
            rm -f "/tmp/JetBrainsMono.zip"
        else
            echo "❌ Falha na extração do ZIP também"
        fi
    else
        echo "❌ Falha no download do ZIP"
    fi
fi

# Baixar também FiraCode (alternativa)
echo -e "${BLUE}� Baixando FiraCode Nerd Font...${NC}"
if curl -sL --connect-timeout 30 --max-time 300 --retry 3 -o "/tmp/FiraCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.tar.xz"; then
    echo "✅ FiraCode baixado"
    cd "$FONT_DIR"
    tar -xf "/tmp/FiraCode.tar.xz" 2>/dev/null || echo "⚠️  FiraCode falhou na extração"
    rm -f "/tmp/FiraCode.zip"
else
    echo "⚠️  FiraCode falhou no download"
fi

# Baixar MesloLGS (fallback)
echo -e "${BLUE}� Baixando MesloLGS Nerd Font (fallback)...${NC}"
if curl -sL --connect-timeout 30 --max-time 120 --retry 3 -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"; then
    echo "✅ MesloLGS Regular baixado"
    curl -sL --connect-timeout 30 --max-time 120 --retry 3 -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    curl -sL --connect-timeout 30 --max-time 120 --retry 3 -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    curl -sL --connect-timeout 30 --max-time 120 --retry 3 -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    echo "✅ MesloLGS completo"
else
    echo "⚠️  MesloLGS falhou"
fi

# Verificar se os arquivos foram baixados
echo -e "${BLUE}🔍 Verificando arquivos...${NC}"
font_count=$(find "$FONT_DIR" -name "*.ttf" -o -name "*.otf" | wc -l)
if [ "$font_count" -gt 0 ]; then
    echo "✅ $font_count fontes encontradas"
    echo "📋 Fontes disponíveis:"
    find "$FONT_DIR" -name "*.ttf" -o -name "*.otf" | head -10
else
    echo "❌ Nenhuma fonte encontrada"
    exit 1
fi

# Atualizar cache de fontes
echo -e "${BLUE}🔄 Atualizando cache de fontes...${NC}"
if command -v fc-cache >/dev/null 2>&1; then
    echo "🔄 Reconstruindo cache do sistema..."
    if fc-cache -f -v 2>/dev/null; then
        echo "✅ Cache de fontes atualizado"
    else
        echo "⚠️  Erro ao atualizar cache (mas fontes foram baixadas)"
    fi
else
    echo "⚠️  fc-cache não encontrado (mas fontes foram baixadas)"
fi

# Verificar instalação
echo -e "${BLUE}🔍 Verificando instalação...${NC}"
if fc-list | grep -i "JetBrains\|FiraCode\|MesloLGS" >/dev/null 2>&1; then
    echo "✅ Fontes instaladas e reconhecidas pelo sistema"
    echo "📋 Fontes disponíveis:"
    fc-list | grep -i "JetBrains\|FiraCode\|MesloLGS" | head -5
else
    echo "⚠️  Fontes baixadas mas não reconhecidas ainda"
    echo "   Tente reiniciar o terminal ou o sistema"
fi

echo -e "\n${GREEN}✅ Instalação de Nerd Fonts concluída!${NC}"
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo -e "1. Configure uma Nerd Font no seu terminal:"
echo -e "   - VSCode/Windsurf: Ctrl+Shift+P → 'Terminal: Select Font Family'"
echo -e "   - Terminal nativo: Editar → Preferências do Perfil → Fontes"
echo -e ""
echo -e "2. Escolha uma das fontes:"
echo -e "   🎯 ${BLUE}JetBrains Mono Nerd Font${NC} (recomendado)"
echo -e "   🎯 ${BLUE}FiraCode Nerd Font${NC} (alternativa)"
echo -e "   🎯 ${BLUE}MesloLGS NF${NC} (fallback)"
echo -e ""
echo -e "3. Reinicie o terminal para ver os ícones corretamente"
echo -e ""
echo -e "${BLUE}🎉 Seu prompt ficará incrível com ícones Nerd Fonts!${NC}"
