# Dotfiles

Ambiente de terminal para Linux/WSL focado em produtividade e leveza:
Zsh com prompt Git, ferramentas modernas de linha de comando e integração
opcional com IA via Claude CLI.

Projetado para instalar em qualquer máquina sem deixar resíduos: usa o
gerenciador de pacotes nativo (`apt`) quando há `sudo`, ou binários estáticos
em `~/.local/bin` quando não há (por exemplo, máquinas restritas sem `sudo`).

## Instalação rápida

```bash
git clone https://github.com/claudio1code/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

O instalador é idempotente: pode rodar quantas vezes quiser. Ao final ele define
o `zsh` como shell padrão automaticamente (vale no próximo login); para não
alterar o shell padrão, rode com `DOTFILES_NO_CHSH=1 ./install.sh`. Abra um novo
terminal ou rode `zsh` para começar.

### Sem permissão de sudo (ex.: 42, servidores restritos)

```bash
DOTFILES_NO_SUDO=1 ./install.sh
```

Nesse modo todas as ferramentas são instaladas como binários estáticos em
`~/.local/bin`, sem tocar no sistema. O `zsh` em si precisa de `sudo`; se ele
não estiver presente, o instalador avisa o comando para instalá-lo.

## O que é instalado

| Ferramenta | Função |
|------------|--------|
| Zsh + Zinit | Shell e gerenciador de plugins (carregamento leve) |
| zsh-autosuggestions, zsh-syntax-highlighting | Sugestões e cores ao digitar |
| eza | Substituto moderno do `ls` (com ícones) |
| bat | `cat` com realce de sintaxe |
| fd | `find` mais rápido e simples |
| ripgrep (`rg`) | Busca em texto extremamente rápida |
| zoxide | `cd` inteligente, baseado em frequência |
| fzf | Busca fuzzy interativa no terminal |
| gh | GitHub CLI (PRs, issues, releases) |
| MesloLGS NF | Fonte com ícones para o prompt e o `eza` |

Por que não Homebrew: no Linux/WSL ele é pesado e lento. Aqui usamos `apt` ou
binários estáticos, que são mais leves e rápidos.

## Estrutura

- `install.sh` — instalador único e idempotente.
- `configs/zshrc` — configuração do Zsh (link para `~/.zshrc`).
- `configs/.vimrc` — configuração básica do Vim (link para `~/.vimrc`).
- `scripts/update.sh` — atualiza o repo e reaplica o instalador.
- `scripts/clear_home.sh` — limpa caches regeneráveis da home (seguro).

Os scripts ficam disponíveis no `PATH` como `update_dotfiles` e `clear_home`.

## Integração com IA (Claude CLI)

O fluxo antigo com Gemini foi removido (autenticação descontinuada). No lugar,
a configuração usa o **Claude CLI** (`claude`), que você instala e autentica
separadamente:

- `ai "sua pergunta"` — pergunta rápida no terminal (`claude -p`).
- `gcommit` — gera uma mensagem de commit no padrão Conventional Commits a
  partir do que está no stage (`git add`), pede confirmação e faz o commit.

Se o comando `claude` não estiver instalado, esses atalhos simplesmente avisam
e não quebram o terminal.

## Comandos úteis depois de instalar

```bash
update_dotfiles   # git pull + reaplica o instalador
clear_home        # limpa caches (mostra quanto liberou)
gcommit           # mensagem de commit gerada por IA
ai "como ver portas abertas?"
```

## Personalização

- Segredos locais (tokens, chaves): crie `~/.env`. Ele é carregado pelo Zsh e
  não vai para o repositório.
- Prompt: tema Dracula com informações de Git, definido em `configs/zshrc`.

## Licença

MIT. Veja `LICENSE`.
