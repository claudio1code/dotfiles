# Dotfiles - Claudio (Public)

Este repositório contém as configurações base do meu ambiente de desenvolvimento no Linux. Ele é focado em produtividade, interface (Zsh + temas) e desenvolvimento de software (com suporte específico para o ambiente da escola 42).

## Estrutura do Repositório

- `install.sh` - Script interativo único para instalação do ambiente.
- `configs/` - Configurações modulares (Zsh, Vim, etc).
- `scripts/` - Scripts auxiliares úteis (como `clear_home42`).

## Instalação

Clone o repositório e execute o script instalador. Ele perguntará qual perfil você deseja instalar.

```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Perfis Disponíveis:
1. **Básico:** Apenas melhorias visuais (Eza, Bat, Zsh).
2. **Desenvolvimento:** Básico + navegação inteligente e ferramentas Git.
3. **Ambiente 42:** Otimizado para rodar nas máquinas da 42 (sem permissão de sudo).
4. **Completo:** Tudo acima, incluindo ferramentas de sistema e plugins avançados.

Durante a instalação, você também poderá optar por instalar integrações de **Inteligência Artificial** (Aider, Mods) para suporte no terminal.

## Ferramentas Inclusas (Dependendo do Perfil)
- **Terminal:** Zsh, Zinit, Temas.
- **Utilidades:** Eza (ls moderno), Bat (cat com syntax highlighting), Zoxide (cd inteligente), FZF (busca fuzzy).
- **IA:** Mods (CLI para Gemini), Aider.

## Licença
MIT License
