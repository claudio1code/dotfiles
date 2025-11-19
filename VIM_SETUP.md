# Configuração do Vim

Esta configuração (`.vimrc`) transforma o Vim padrão em um editor de código mais amigável e poderoso.

### O que o `.vimrc` faz?

- **Adiciona Plugins Essenciais** com o `vim-plug`:
  - `NERDTree`: Uma árvore de arquivos lateral para navegar pelo projeto (atalho: `Ctrl + n`).
  - `vim-airline`: Uma barra de status moderna e informativa.
  - `dracula/vim`: Um tema de cores agradável e popular.
  - `vim-mucomplete`: Um sistema de autocompletar leve e minimalista.
- **Melhora a Experiência de Edição:**
  - Ativa números de linha, syntax highlighting e auto-indentação.
  - Configura o `Tab` para ter 4 espaços.
  - Habilita o "undo" persistente, para que você possa desfazer alterações mesmo depois de fechar um arquivo.
- **Facilita a Navegação:**
  - Mostra o cursor e destaques em buscas.
  - Permite o uso do mouse.

### Instalação

Se você deseja apenas a configuração do Vim, sem instalar todo o resto do `dotfiles`, use este comando para baixar o arquivo `.vimrc` para sua pasta de usuário:

```bash
curl -o ~/.vimrc https://raw.githubusercontent.com/claudio1code/dotfiles/main/.vimrc
```

**Importante:** Após baixar o `.vimrc`, abra o Vim e execute o comando `:PlugInstall` para instalar os plugins.

---

## Guia de Atalhos

Para uma referência rápida dos principais comandos e atalhos do Vim, consulte o nosso guia:

[➡️ **Guia de Atalhos do Vim (vim_cheatsheet.md)**](./vim_cheatsheet.md)
