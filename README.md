# 🚀 Claudio's Dotfiles

Bem-vindo ao meu setup de terminal! Este kit transforma um terminal Linux padrão (bash) em um ambiente de desenvolvimento moderno, bonito e produtivo, com **Zsh**, **Vim turbinado** e **IA integrada**.

Funciona perfeitamente em:
- **42 School** (Ambientes sem permissão de root)
- **Linux** (Ubuntu, Debian, Arch, etc.)
- **WSL** (Windows Subsystem for Linux)

---

## 📥 Instalação

Abra seu terminal e rode os comandos abaixo, um por um:

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
   ```

2. **Entre na pasta e instale:**
   ```bash
   cd ~/dotfiles
   bash install.sh
   ```

> **O que o instalador faz?** Ele baixa ferramentas modernas (`eza`, `bat`, `zoxide`) para sua pasta local, configura o Zsh, instala plugins, configura o Vim e instala fontes. Tudo seguro, sem precisar de senha de administrador (`sudo`).

---

## 🎨 Passo Crítico: Configurando a Fonte

**LEIA COM ATENÇÃO:** Para que os ícones (pastinhas, setas, git branches) apareçam corretamente e não fiquem como quadrados (□), você precisa configurar o seu terminal para usar a fonte **MesloLGS NF**.

O script já instalou essa fonte no seu sistema Linux (`~/.local/share/fonts`). Agora você precisa dizer ao seu emulador de terminal para usá-la.

### 🖥️ No VS Code
1. Abra as configurações (`Ctrl + ,`).
2. Digite na busca: `terminal font`.
3. Em **Terminal > Integrated: Font Family**, coloque exatamente:
   ```text
   'MesloLGS NF'
   ```
   *(Mantenha as aspas simples)*

### 🪟 No Windows Terminal (WSL)
Se você usa WSL, você precisa instalar a fonte **no Windows**, não só no Linux.
1. Baixe os arquivos `.ttf` [neste link](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf).
2. Clique duas vezes no arquivo baixado e clique em **Instalar**.
3. No Windows Terminal:
   - Vá em **Configurações** -> Selecione seu perfil (Ubuntu/Debian) -> **Aparência**.
   - Em **Tipo de fonte**, selecione `MesloLGS NF`.

### 🐧 No Linux (Gnome Terminal / Terminator)
1. Clique com botão direito no terminal -> **Preferências**.
2. Vá na aba do seu perfil (geralmente "Sem nome" ou "Padrão").
3. Marque a caixa **Fonte personalizada**.
4. Procure e selecione `MesloLGS NF Regular`.

---

## ⚙️ Primeiros Passos

Depois de instalar e arrumar a fonte:

1. **Recarregue o terminal:**
   ```bash
   source ~/.zshrc
   ```

2. **Login na IA (Gemini):**
   Para usar a inteligência artificial no terminal, faça login na primeira vez:
   ```bash
   gemini login
   ```
   *(Siga o link que aparecerá para autenticar com seu Google)*

---

## 📖 Guia de Uso

### 🚀 Navegação Super Rápida (`z`)
Esqueça o comando `cd` longo. O `z` aprende quais pastas você mais usa.
- **Ir para uma pasta:** `z dot` (te leva para `~/dotfiles`)
- **Voltar:** `z -`

### 📂 Comandos Modernos
Substituí os comandos antigos por versões melhores:

| Comando | O que eu digito | O que ele faz |
| :--- | :--- | :--- |
| **Listar** | `ls` | Lista arquivos com ícones e cores (usa `eza`) |
| **Listar Tudo** | `la` | Lista arquivos ocultos e detalhes |
| **Ler Arquivo** | `cat arquivo.js` | Mostra o conteúdo colorido e com linhas (usa `bat`) |
| **Buscar** | `Ctrl + R` | Busca no histórico de comandos |
| **Limpar** | `ç` ou `Ctrl + L` | Limpa a tela |

### 🤖 Inteligência Artificial
Dúvida de código? Pergunte direto no terminal.
```bash
gemini "Como faço um loop for em Rust?"
```
Ou entre no modo chat digitando apenas `gemini`.

### 📝 Editor Vim (Estilo IDE)
O Vim está configurado com plugins essenciais.
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