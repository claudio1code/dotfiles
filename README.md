# 🚀 Dotfiles Modulares & Inteligentes

> Configuração de terminal otimizada, modular e pronta para IA. Projetada para ser leve, compatível com a **42 School** (ambientes sem root/sudo) e altamente produtiva.

---

## 🎯 Qual versão escolher?

O instalador interativo permite escolher entre três níveis de personalização. Veja qual se adapta melhor ao seu momento:

| Nível | Perfil de Uso | O que inclui? | Espaço |
| :--- | :--- | :--- | :--- |
| **1. Simples** | **Servidores / Minimalista**<br>Apenas o essencial para um terminal bonito. | • Prompt Dracula + Git<br>• Syntax Highlighting<br>• Autosuggestions | ~2MB |
| **2. Intermediária** | **Dev Moderno (Sem Root)**<br>Ferramentas Rust poderosas sem precisar de `sudo`. | • Tudo da Simples<br>• `zoxide` (cd inteligente)<br>• `eza` (ls melhorado)<br>• `bat` (cat com cores)<br>• `fzf` (histórico fuzzy) | ~50MB |
| **3. AI / Complete** | **Power User + IA**<br>Automação total com Gemini e Node.js. | • Tudo da Intermediária<br>• **Gemini CLI** (Chat no terminal)<br>• **Auto-Commit** (Mensagens via IA)<br>• **NVM** (Node Version Manager) | ~200MB+ |

---

## 📦 Instalação

Basta clonar e rodar o script. Um menu interativo guiará você.

```bash
git clone https://github.com/claudio1code/dotfiles.git
cd dotfiles
./install.sh
```

---

## ✨ Detalhes das Funcionalidades

### 🧠 Inteligência Artificial (Apenas v3)

Na versão **AI / Complete**, você ganha superpoderes:

*   **`gcommit`**: Cansado de escrever mensagens de commit?
    1.  Dê `git add .`
    2.  Digite `gcommit`
    3.  A IA lê suas mudanças e gera uma mensagem no padrão *Conventional Commits*.

*   **`gemini "pergunta"`**: Tire dúvidas de código sem sair do terminal.

> **Nota:** Requer uma API Key do Google. Crie um arquivo `~/.env`:
> ```bash
> export GEMINI_API_KEY="sua_chave_aqui"
> ```

### 🛡️ Modo Seguro (Preservação)

**Nós respeitamos seu setup atual.**
Ao instalar, o script **NÃO apaga** seu `.zshrc` antigo.
1.  Ele renomeia seu arquivo atual para `~/.zshrc_local`.
2.  O novo configuração carrega esse arquivo automaticamente.
3.  **Resultado:** Seus aliases e funções antigas continuam funcionando magicamente!

---

## 🔧 Ferramentas Inclusas (v2 e v3)

Estas ferramentas são instaladas localmente em `~/.local/bin` (não precisa de `brew` nem `sudo`):

- **[Zoxide](https://github.com/ajeetdsouza/zoxide):** O comando `cd` que aprende. Digite `z pasta` e ele te leva lá.
- **[Eza](https://github.com/eza-community/eza):** Um `ls` moderno com ícones e cores.
- **[Bat](https://github.com/sharkdp/bat):** Um `cat` com syntax highlighting e paginação.
- **[FZF](https://github.com/junegunn/fzf):** Aperte `Ctrl+R` e encontre qualquer comando do passado instantaneamente.

---

## 🗑️ Desinstalação / Limpeza

Precisa liberar espaço na cota da 42?
Rodamos um script que remove apenas os binários baixados, mantendo seus dotfiles.

```bash
./configurations/intermediate/clean.sh
```
