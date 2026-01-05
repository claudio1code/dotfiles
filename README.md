# 🚀 Claudio's Dotfiles

Bem-vindo ao meu setup de terminal! Este kit transforma um terminal Linux padrão (bash) em um ambiente de desenvolvimento moderno, bonito e produtivo, com **Zsh**, **Vim turbinado** e **IA integrada**.

Funciona perfeitamente em:
- **42 School** (Ambientes sem permissão de root)
- **Linux** (Ubuntu, Debian, Arch, etc.)
- **WSL** (Windows Subsystem for Linux)

---

## 📋 Pré-requisitos

Antes de instalar os dotfiles, você precisa ter algumas ferramentas instaladas no seu sistema.

### 1️⃣ Homebrew/Linuxbrew (Gerenciador de Pacotes)

O Homebrew é essencial para instalar várias ferramentas modernas sem precisar de `sudo`.

**Instalação:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Depois da instalação, adicione o Homebrew ao seu PATH (o instalador vai te mostrar os comandos). Geralmente é algo como:
```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

**Verificar se funcionou:**
```bash
brew --version
```

### 2️⃣ Python e Pip

A maioria das distribuições Linux já vem com Python. Verifique:
```bash
python3 --version
pip3 --version
```

Se não tiver, instale:
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install python3 python3-pip

# Arch
sudo pacman -S python python-pip
```

### 3️⃣ Go (Opcional, mas recomendado)

Algumas ferramentas de IA podem usar Go. Instale via Homebrew:
```bash
brew install go
```

---

## 📥 Instalação

Abra seu terminal e rode os comandos abaixo, um por um:

### Passo 1: Clone o Repositório
```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
```

### Passo 2: Instale o Zinit (Gerenciador de Plugins do Zsh)

O Zinit gerencia os plugins do Zsh (autocomplete, syntax highlighting, etc.).

```bash
mkdir -p ~/.local/share/zinit
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
```

### Passo 3: Instale as Ferramentas de IA

Estas são as ferramentas que trazem inteligência artificial para o seu terminal:

#### 🤖 Mods (Interface CLI para Gemini)
```bash
brew install mods
```

O `mods` é usado pelos comandos `gpro`, `gflash` e `gemini-ui` no terminal.

#### 🧑‍💻 Aider (Pair Programming com IA)
```bash
pip3 install aider-chat
```

O Aider permite que você faça pair programming com a IA diretamente no terminal.

### Passo 4: Execute o Instalador Principal

Agora rode o script de instalação que vai configurar tudo automaticamente:
```bash
cd ~/dotfiles
bash install.sh
```

> **O que o instalador faz?**
> - Baixa ferramentas modernas (`eza`, `bat`, `zoxide`) para sua pasta local
> - Configura o Zsh como seu shell padrão
> - Instala plugins do Zinit
> - Configura o Vim/Neovim
> - Instala a fonte MesloLGS NF com ícones
> - Copia os arquivos de configuração (`.zshrc`, `.vimrc`)

---

## 🎨 Passo Crítico: Configurando a Fonte

**LEIA COM ATENÇÃO:** Para que os ícones (pastinhas, setas, git branches) apareçam corretamente e não fiquem como quadrados (□), você precisa configurar o seu terminal para usar a fonte **MesloLGS NF**.

O script já instalou essa fonte no seu sistema Linux (`~/.local/share/fonts`). Agora você precisa dizer ao seu emulador de terminal para usá-la.

### 🖥️ No VS Code
1. Abra as configurações (`Ctrl + ,`)
2. Digite na busca: `terminal font`
3. Em **Terminal > Integrated: Font Family**, coloque exatamente:
   ```text
   'MesloLGS NF'
   ```
   *(Mantenha as aspas simples)*

### 🪟 No Windows Terminal (WSL)
Se você usa WSL, você precisa instalar a fonte **no Windows**, não só no Linux.
1. Baixe os arquivos `.ttf` [neste link](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
2. Clique duas vezes no arquivo baixado e clique em **Instalar**
3. No Windows Terminal:
   - Vá em **Configurações** → Selecione seu perfil (Ubuntu/Debian) → **Aparência**
   - Em **Tipo de fonte**, selecione `MesloLGS NF`

### 🐧 No Linux (Gnome Terminal / Terminator)
1. Clique com botão direito no terminal → **Preferências**
2. Vá na aba do seu perfil (geralmente "Sem nome" ou "Padrão")
3. Marque a caixa **Fonte personalizada**
4. Procure e selecione `MesloLGS NF Regular`

---

## ⚙️ Configuração da IA

Para usar as ferramentas de inteligência artificial, você precisa configurar as credenciais:

### 🔑 Configurar Google API Key (Gemini)

1. **Obtenha sua chave de API:**
   - Acesse [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Crie uma chave de API gratuita

2. **Configure o Mods na primeira vez:**
   ```bash
   mods --settings
   ```
   Siga as instruções para adicionar sua API key do Google.

3. **Teste se funcionou:**
   ```bash
   gemini-ui "Olá! Como você está?"
   ```

### 🔧 Configurar Aider (Opcional)

Se você quiser usar o Aider para pair programming:

```bash
export AIDER_MODEL="gemini/gemini-2.0-flash-001"
```

Este comando já está no `.zshrc`, então você não precisa fazer nada. Basta garantir que o Mods está configurado.

---

## 📖 Guia de Uso

### 🚀 Navegação Super Rápida (`z`)
Esqueça o comando `cd` longo. O `z` aprende quais pastas você mais usa.
- **Ir para uma pasta:** `z dot` (te leva para `~/dotfiles`)
- **Voltar:** `z -`

### 📂 Comandos Modernos
Substituí os comandos antigos por versões melhores:

| Comando | O que eu digito | O que ele faz |
|---------|-----------------|---------------|
| **Listar** | `ls` | Lista arquivos com ícones e cores (usa `eza`) |
| **Listar Tudo** | `la` | Lista arquivos ocultos e detalhes |
| **Ler Arquivo** | `cat arquivo.js` | Mostra o conteúdo colorido e com linhas (usa `bat`) |
| **Buscar** | `Ctrl + R` | Busca no histórico de comandos |
| **Limpar** | `ç` ou `Ctrl + L` | Limpa a tela |

### 🤖 Inteligência Artificial no Terminal

Você tem 3 comandos principais para IA:

#### `gpro` - Gemini 2.0 Flash (Rápido e Poderoso)
```bash
gpro "Como faço um loop for em Rust?"
```

#### `gflash` - Gemini 1.5 Flash (Ultra Leve)
```bash
gflash "Explica o que é recursão"
```

#### `gemini-ui` - Interface Interativa
```bash
gemini-ui
```
Entre no modo chat e converse livremente com a IA.

#### `gcommit` - Commits Automáticos com IA 🎯
Uma das funcionalidades mais legais! A IA lê suas mudanças e sugere uma mensagem de commit:

```bash
git add .
gcommit
```

A IA vai:
1. Ler o diff do seu código
2. Sugerir uma mensagem seguindo Conventional Commits
3. Perguntar se você quer usar

### 📝 Editor Vim/Neovim (Estilo IDE)
O Vim está configurado com plugins essenciais.
- **Abrir editor:** `vim arquivo.txt` ou `nvim arquivo.txt`
- **Abrir árvore de arquivos:** `Ctrl + n`
- **Navegar entre janelas:** `Ctrl + w` + setas
- **Sair:** `:q` (ou `:wq` para salvar)

---

## 🔄 Como Atualizar

Eu atualizo este repositório frequentemente. Para puxar as novidades para sua máquina, basta rodar este comando de qualquer lugar:

```bash
update_dotfiles
```

Isso vai baixar as mudanças e reinstalar o que for necessário automaticamente.

---

## 🛠️ Ferramentas Instaladas

Este setup instala e configura as seguintes ferramentas:

### Essenciais
- **Zsh** - Shell moderno e poderoso
- **Zinit** - Gerenciador de plugins do Zsh
- **Eza** - Substituto moderno do `ls`
- **Bat** - Substituto moderno do `cat`
- **Zoxide** - Navegação inteligente (`z`)
- **FZF** - Busca fuzzy interativa

### Inteligência Artificial
- **Mods** - Interface CLI para LLMs (Gemini)
- **Aider** - Pair programming com IA

### Desenvolvimento
- **Neovim** - Editor de texto turbinado
- **NVM** - Gerenciador de versões do Node.js
- **Git** - Controle de versão (com integração IA)

---

## 🐛 Troubleshooting

### Os ícones não aparecem
- Certifique-se de que configurou a fonte `MesloLGS NF` no seu terminal
- Reinicie o terminal completamente

### `command not found: brew`
- Adicione o Homebrew ao PATH:
  ```bash
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  ```

### `command not found: mods`
- Instale via Homebrew: `brew install mods`
- Verifique se o Homebrew está no PATH

### A IA não responde
- Configure sua API key: `mods --settings`
- Teste a conexão: `gemini-ui "teste"`

---

## 📝 Licença

MIT License - Use e modifique à vontade!
