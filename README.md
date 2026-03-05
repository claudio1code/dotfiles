# Claudio's Dotfiles

Bem-vindo ao meu setup de terminal modular! Este kit transforma um terminal Linux padrão em um ambiente de desenvolvimento moderno, bonito e produtivo, com **instalações adaptadas para diferentes cenários**.

## Escolha Seu Perfil de Instalação

Escolha o cenário que melhor se adapta às suas necessidades:

---

### **Perfil Visual** - Apenas Beleza e Usabilidade
**Ideal para:** Quem só quer um terminal bonito e moderno, sem ferramentas pesadas.

**O que instala:**
- Zsh + Zinit (plugins de autocomplete e syntax highlighting)
- Eza (ls moderno com ícones)
- Bat (cat colorido)
- Fonte MesloLGS NF (ícones perfeitos)
- Prompt bonito tema Dracula

**Instalação:**
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install_visual.sh
```

**Espaço necessário:** ~50MB

---

### **Perfil Work** - Produtividade para Desenvolvimento
**Ideal para:** Desenvolvedores que precisam de ferramentas produtivas no dia a dia.

**O que instala:**
- Tudo do Perfil Visual +
- Zoxide (navegação inteligente `z`)
- FZF (busca fuzzy)
- Git Delta (diffs bonitos)
- NVM (gerenciador Node.js)
- Neovim configurado
- Git otimizado

**Instalação:**
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install_work.sh
```

**Espaço necessário:** ~200MB
**Tempo estimado:** 2-3 minutos

---

### **Perfil AI** - Terminal com Inteligência Artificial
**Ideal para:** Quem quer IA integrada ao terminal para máxima produtividade.

**O que instala:**
- Tudo do Perfil Work +
- Mods (interface CLI para Gemini)
- Aider (pair programming com IA)
- Comandos `gpro`, `gflash`, `gemini-ui`
- `gcommit` (commits automáticos com IA)

**Instalação:**
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install_ai.sh
```

**Espaço necessário:** ~300MB
**Tempo estimado:** 3-4 minutos
**Requer:** API Key do Google Gemini (grátis)

---

### **Perfil Fast** - Instalação Ultra-Rápida ⚡
**Ideal para:** Quem quer TUDO instalado no menor tempo possível.

**O que instala:**
- ABSOLUTAMENTE TUDO (Personal + AI) +
- Downloads paralelos massivos
- Cache inteligente
- Instalação otimizada

**Instalação:**
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install_fast.sh
```

**Espaço necessário:** ~600MB
**Tempo estimado:** 2 minutos
**Requer:** API Key do Google Gemini (grátis)

---

### **Perfil 42** - Otimizado para Escola 42
**Ideal para:** Alunos da 42 com restrições (sem sudo, limite 10GB).

**O que instala:**
- Zsh + plugins essenciais
- Ferramentas leves (instalação local)
- Integração com norminette
- Aliases para C/Makefile
- Scripts de limpeza de espaço
- Suporte para Francinette

**Instalação:**
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install_42.sh
```

**Espaço necessário:** ~100MB
**Funciona:** Sem sudo, limite 10GB

---

### **Perfil Personal** - Setup Completo (Recomendado)
**Ideal para:** Computador pessoal com permissões sudo.

**O que instala:**
- TUDO dos perfis anteriores +
- Instalação via apt/brew (sistema)
- Ferramentas adicionais (htop, tree, ripgrep)
- Extensões VS Code
- Configuração completa do sistema

**Instalação:**
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install_personal.sh
```

**Espaço necessário:** ~500MB
**Requer:** Permissão sudo

---

### **Perfil Completo** - Instalação Ultra-Completa
**Ideal para:** Quem quer TUDO instalado de uma vez (máximo poder).

**O que instala:**
- ABSOLUTAMENTE TUDO +
- Ferramentas de desenvolvimento adicionais
- Configurações avançadas
- Scripts de manutenção
- Optimizações de performance

**Instalação:**
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

**Espaço necessário:** ~600MB
**Requer:** Permissão sudo e espaço disponível

---

## Tabela Comparativa

| Recurso | Visual | Work | AI | 42 | Personal | Completo |
|---------|--------|------|----|----|----------|----------|
| Zsh + Plugins | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Ferramentas Visuais | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Navegação Inteligente | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Git Avançado | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Node.js/NVM | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Inteligência Artificial | ❌ | ❌ | ✅ | ❌ | ✅ | ✅ |
| Suporte C/Norminette | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |
| Instalação Sistema | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Sem Sudo | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Scripts Manutenção | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

---

## Configuração Pós-Instalação

### 1. Configurar a Fonte (CRÍTICO)

Para que os ícones apareçam corretamente, configure a fonte **MesloLGS NF** no seu terminal:

#### VS Code:
1. `Ctrl + ,` (configurações)
2. Busque: `terminal font`
3. Em **Terminal > Integrated: Font Family**, coloque:
   ```
   'MesloLGS NF'
   ```

#### Linux (Gnome Terminal/Terminator):
1. Botão direito → Preferências
2. Marque **Fonte personalizada**
3. Selecione `MesloLGS NF Regular`

#### Windows Terminal (WSL):
1. Baixe a fonte [aqui](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
2. Instale no Windows
3. Configurações → Perfil → Aparência → Fonte: `MesloLGS NF`

### 2. Configurar IA (Apenas Perfis AI e Personal)

```bash
# Configure sua API Key do Google
mods --settings

# Teste
gpro "Olá! Como você está?"
```

**Obtenha sua API Key gratuita:** [Google AI Studio](https://makersuite.google.com/app/apikey)

---

## Comandos Principais

### Navegação:
```bash
z nome_da_pasta    # Navegação inteligente
ls                 # Lista com ícones (eza)
la                 # Lista arquivos ocultos
cat arquivo        # Mostra conteúdo colorido (bat)
```

### Git:
```bash
gs                 # Git status
ga .               # Git add all
gcommit            # Commit automático com IA (perfis AI/Personal)
```

### IA (perfis AI/Personal):
```bash
gpro "pergunta"     # Gemini 2.0 Flash (rápido)
gflash "pergunta"   # Gemini 1.5 Flash (leve)
gemini-ui           # Modo chat interativo
aider-pair          # Pair programming com IA
```

### 42 (perfil 42):
```bash
norm arquivo.c      # Verifica norminette
compile_check x.c   # Compila e verifica norminette
clean_42            # Limpa arquivos temporários
clear_home42        # Libera espaço na home (SUPER ÚTIL!)
```

### Manutenção (todos os perfis):
```bash
clear_home42        # Limpeza pesada da home (útil para qualquer um)
update_dotfiles     # Atualiza o dotfiles
```

---

## Como Atualizar

Para atualizar seu dotfiles para a versão mais recente:

```bash
update_dotfiles
```

Este comando:
1. Baixa as atualizações do repositório
2. Reinstala o que for necessário
3. Mantém suas configurações pessoais

---

## Troubleshooting

### Ícones não aparecem (quadrados □):
- Configure a fonte MesloLGS NF (veja acima)
- Reinicie completamente o terminal

### Comando não encontrado:
- Verifique se executou o script de instalação correto
- Abra um novo terminal após a instalação
- Para perfil 42: verifique se as ferramentas foram instaladas em `~/.local/bin`

### IA não responde:
- Configure sua API Key: `mods --settings`
- Teste conexão: `gpro "teste"`
- Verifique se o Mods está instalado: `which mods`

### Problemas de permissão (perfil 42):
- Os scripts instalam tudo localmente em `~/.local/bin`
- Não precisa de sudo para nenhuma ferramenta
- Se algo falhar, verifique o espaço disponível com `df -h ~`

---

## Estrutura dos Arquivos

```
dotfiles/
├── install_visual.sh      # Instalação apenas visual
├── install_work.sh        # Instalação para trabalho
├── install_ai.sh          # Instalação com IA
├── install_fast.sh        # Instalação ultra-rápida ⚡
├── install_42.sh          # Instalação para 42 (sem sudo)
├── install_personal.sh    # Instalação completa (com sudo)
├── install.sh             # Instalação ultra-completa (tudo)
├── zshrc                  # Configuração completa
├── zshrc_visual           # Configuração visual
├── zshrc_work             # Configuração trabalho
├── zshrc_ai               # Configuração IA
├── zshrc_42               # Configuração 42
├── .vimrc                 # Configuração Vim
├── clear_home42.sh        # Limpeza pesada (SUPER ÚTIL)
├── update.sh              # Atualização do sistema
└── LICENSE                # Licença MIT
```

---

## Comece Agora

Escolha seu perfil e execute a instalação:

```bash
# Escolha um:
bash install_visual.sh      # Mais leve (~1 minuto)
bash install_work.sh        # Produtivo (~2-3 minutos)
bash install_ai.sh          # Com IA (~3-4 minutos)
bash install_fast.sh        # Ultra-Rápido ⚡ (~2 minutos)
bash install_42.sh          # Para 42 (~2 minutos)
bash install_personal.sh    # Completo (~5 minutos)
bash install.sh             # Ultra-Completo (~15 minutos)
```

**Recomendação:** 
- **Mais rápido:** `install_fast.sh` - Tudo em 2 minutos
- **Computador pessoal:** `install_fast.sh` ou `install_personal.sh`
- **Escola 42:** `install_42.sh`
- **Apenas beleza:** `install_visual.sh`

---

## Licença

MIT License - Use e modifique à vontade!

---

**Transforme seu terminal hoje mesmo!**
