# Guia de Atalhos Essenciais do Vim

Este guia cobre os comandos mais comuns do Vim para navegação, edição e gerenciamento de arquivos.

## Modos do Vim

O Vim é baseado em "modos". Os três principais são:

- **Modo Normal:** O modo padrão. Usado para navegar e executar comandos. Pressione `<ESC>` para retornar a este modo.
- **Modo de Inserção:** Usado para escrever texto. Pressione `i` para entrar no modo de inserção.
- **Modo Visual:** Usado para selecionar texto. Pressione `v` para entrar no modo visual.

---

## Navegação Básica (Modo Normal)

- `h`: Mover para a esquerda
- `j`: Mover para baixo
- `k`: Mover para cima
- `l`: Mover para a direita

- `w`: Pular para o início da próxima palavra
- `b`: Voltar para o início da palavra anterior
- `e`: Pular para o final da palavra atual

- `0`: Ir para o início da linha
- `$`: Ir para o final da linha

- `gg`: Ir para o início do arquivo
- `G`: Ir para o final do arquivo
- `:{número}`: Ir para a linha de número específico (ex: `:10`)

---

## Edição de Texto (Modo Normal)

- `i`: Entrar no Modo de Inserção (antes do cursor)
- `a`: Entrar no Modo de Inserção (depois do cursor)
- `o`: Adicionar uma nova linha abaixo e entrar no Modo de Inserção
- `O`: Adicionar uma nova linha acima e entrar no Modo de Inserção

- `x`: Apagar o caractere sob o cursor
- `dw`: Apagar a palavra a partir do cursor
- `dd`: Apagar a linha inteira
- `d$`: Apagar do cursor até o final da linha

- `yy`: Copiar (yank) a linha inteira
- `yw`: Copiar a palavra
- `p`: Colar (put) depois do cursor
- `P`: Colar antes do cursor

- `u`: Desfazer (undo) a última alteração
- `<C-r>`: Refazer (redo)

---

## Comandos (Modo Normal)

- `:{comando}`: Pressione `:` para abrir a linha de comando do Vim.

- `:w`: Salvar (write) o arquivo
- `:q`: Sair (quit) do Vim
- `:wq`: Salvar e sair
- `:q!`: Sair sem salvar as alterações

---

## Busca e Substituição

- `/palavra`: Buscar por "palavra" no arquivo (pressione `n` para ir para a próxima ocorrência, `N` para a anterior)
- `:%s/antigo/novo/g`: Substituir todas as ocorrências de "antigo" por "novo" no arquivo
- `:%s/antigo/novo/gc`: Substituir com confirmação para cada ocorrência

---

## Atalhos de Plugins (que instalamos)

- `<C-n>`: Abrir/fechar a árvore de arquivos **NERDTree**

---

## Trabalhando com Janelas (Splits) e Diffs

Dividir a tela para ver múltiplos arquivos é uma das funcionalidades mais poderosas do Vim.

### Dividindo a Tela

- `:vsplit {caminho/do/arquivo}`: Divide a tela **verticalmente** (lado a lado).
- `:split {caminho/do/arquivo}`: Divide a tela **horizontalmente** (um sobre o outro).

Se você não especificar um caminho de arquivo, o Vim duplicará a janela atual.

### Navegando entre Janelas

Use `<C-w>` (Ctrl + w) seguido de uma tecla de direção para mover o cursor entre as janelas:

- `<C-w> h`: Mover para a janela à **esquerda**.
- `<C-w> l`: Mover para a janela à **direita**.
- `<C-w> k`: Mover para a janela **acima**.
- `<C-w> j`: Mover para a janela **abaixo**.
- `<C-w> w`: Alternar entre as janelas abertas.

### Comparando Arquivos com Vimdiff

Para comparar dois arquivos e ver as diferenças destacadas, use o `vimdiff` diretamente do seu terminal (fora do Vim):

```bash
vimdiff arquivo1.txt arquivo2.txt
```

Dentro do `vimdiff`, você pode pular entre as diferenças com os seguintes comandos:

- `]c`: Pular para a **próxima** diferença.
- `[c`: Voltar para a diferença **anterior**.

---

Este é um bom ponto de partida. Com a prática, esses comandos se tornarão automáticos!
