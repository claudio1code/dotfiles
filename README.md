# Claudio's Dotfiles 🚀

Configuração de ambiente de desenvolvimento portátil, robusta e moderna. Projetada para oferecer uma experiência consistente tanto em **máquinas pessoais** (com acesso root/sudo) quanto em **ambientes restritos** (como a 42 School, laboratórios universitários e containers Docker), onde você não tem permissões de administrador.

## ⚡ Principais Recursos

### Shell & Navegação
- **Zsh + Oh My Zsh**: Configuração otimizada com plugins essenciais.
- **Tema**: Tema `gnzh` limpo e funcional.
- **Zoxide (`z`)**: Navegação inteligente. Nunca mais digite caminhos longos (ex: `z proj` leva você direto para `~/code/meu-projeto`).
- **FZF**: Buscador "fuzzy" ultra-rápido para histórico e arquivos.

### Ferramentas Modernas (Rust-based)
Substitutos modernos para comandos clássicos, instalados localmente (`~/.local/bin`) sem precisar de `apt` ou `brew`:
- **Eza** (substituto do `ls`): Listagem com ícones, cores e informações de git.
- **Bat** (substituto do `cat`): Visualizador de arquivos com syntax highlighting.

### Editor (Vim)
- **Plugins Gerenciados**: Uso do `vim-plug` para instalação automática.
- **IDE-like**: Árvore de arquivos (`NERDTree`), autocompletar, suporte a mouse e temas visuais (Dracula).
- **Cheat Sheet**: Guia de atalhos integrado.

### IA & Dev
- **Node.js via NVM**: Gerenciamento de versões do Node sem sudo.
- **Gemini CLI**: Inteligência Artificial do Google integrada ao terminal para dúvidas rápidas de código.

---

## 📥 Instalação

O processo é simples e idempotente (pode rodar várias vezes sem quebrar nada).

### 1. Clonar e Instalar
Abra seu terminal e execute:

```bash
# Clone o repositório (pode ser em qualquer pasta)
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles

# Entre na pasta e execute o instalador
cd ~/dotfiles
bash install.sh
```

### 2. O que o script faz?
1. **Verifica Dependências**: Baixa binários portáteis se não estiverem instalados.
2. **Configura Zsh**: Instala Oh My Zsh e plugins (`autosuggestions`, `syntax-highlighting`).
3. **Configura Vim**: Linka o `.vimrc` e roda `:PlugInstall` automaticamente.
4. **Configura Fontes**: Baixa e instala *Meslo Nerd Font* em `~/.local/share/fonts`.
5. **Configura Node/IA**: Instala NVM e o pacote `gemini-cli`.

---

## 🛠️ Pós-Instalação

### 1. Reiniciar o Shell
Para aplicar as mudanças imediatamente:
```bash
exec zsh
```
Ou feche e abra o terminal novamente.

### 2. Configurar Fonte (Importante)
Para ver os ícones corretamente (no prompt e no `ls`), configure seu emulador de terminal (iTerm2, Alacritty, GNOME Terminal, VSCode, Zed) para usar a fonte **MesloLGS NF**. O script já a instalou na sua pasta de fontes do usuário.

### 3. Login no Gemini (Primeira vez)
Se quiser usar a IA no terminal:
```bash
gemini login
```
Siga as instruções para autenticar com sua conta Google.

---

## 📖 Como Usar

### Atalhos do Terminal
| Comando | Ação |
| :--- | :--- |
| `z <nome>` | Pular para diretório (ex: `z dot` -> `~/dotfiles`) |
| `ls` / `la` | Listar arquivos com ícones |
| `cat <arq>` | Ler arquivo com cores |
| `guia` | Abrir guia rápido de comandos |
| `update_dotfiles` | Atualizar todo o ambiente |
| `gemini "pergunta"` | Perguntar algo rápido para a IA |

### Atalhos do Vim
| Atalho | Ação |
| :--- | :--- |
| `Ctrl + n` | Abrir/Fechar árvore de arquivos lateral |
| `:vsplit` | Dividir tela verticalmente |
| `Ctrl + w` + setas | Navegar entre janelas divididas |

---

## 🔄 Atualização

Para atualizar suas configurações, plugins e ferramentas para a versão mais recente deste repositório, basta rodar o comando (alias) de qualquer lugar:

```bash
update_dotfiles
```
