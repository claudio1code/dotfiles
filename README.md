# Dotfiles

Ambiente de terminal para Linux/WSL focado em produtividade e leveza:
Zsh com prompt Git, ferramentas modernas de linha de comando e integração
opcional com IA gratuita via GitHub Models.

Projetado para instalar em qualquer máquina sem deixar resíduos. O instalador
se adapta ao ambiente automaticamente:

- usa o gerenciador de pacotes nativo (`apt`) quando há `sudo`, ou binários
  estáticos em `~/.local/bin` quando não há (ex.: máquinas restritas sem `sudo`);
- detecta se está em **WSL** ou **Linux nativo** e, no WSL, instala a fonte de
  ícones no Windows e oferece configurar o Windows Terminal automaticamente.

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

## Integração com IA (GitHub Models, gratuito)

O fluxo antigo com Gemini foi removido (autenticação descontinuada). No lugar,
a configuração usa o **GitHub Models** através do `gh models` — gratuito,
incluso no GitHub CLI, sem chave de API. Basta estar logado: `gh auth login`.
O instalador já adiciona a extensão automaticamente.

- `ai "sua pergunta"` — pergunta rápida no terminal.
- `gcommit` — gera uma mensagem de commit no padrão Conventional Commits (sem
  emojis) a partir do que está no stage (`git add`), pede confirmação e commita.

O modelo padrão é `openai/gpt-4o-mini`; para trocar, defina a variável
`GH_MODELS_DEFAULT` (ex.: `export GH_MODELS_DEFAULT="meta/llama-3.3-70b-instruct"`).
Veja os modelos disponíveis com `gh models list`. Se o `gh` não estiver
instalado/logado, os atalhos apenas avisam e não quebram o terminal.

## Comandos úteis depois de instalar

```bash
update_dotfiles   # git pull + reaplica o instalador
clear_home        # limpa caches (mostra quanto liberou)
gcommit           # mensagem de commit gerada por IA
ai "como ver portas abertas?"
```

## Fonte de ícones (Linux nativo x WSL)

Os ícones do prompt e do `eza` precisam de uma Nerd Font (MesloLGS NF). O
instalador trata os dois ambientes de forma diferente, detectando
automaticamente em qual você está:

**Linux nativo:** a fonte é instalada em `~/.local/share/fonts/`. Basta
selecionar `MesloLGS NF` nas preferências do seu emulador de terminal.

**WSL:** quem desenha o terminal é um app do Windows, então a fonte precisa
estar instalada no Windows, não só no Linux. O instalador:

1. instala a fonte no Windows (por usuário, sem admin);
2. pergunta se você quer definir `MesloLGS NF` no **Windows Terminal**
   automaticamente (faz backup do `settings.json` em `.bak-dotfiles`);
3. lembra como configurar o VS Code, caso use o terminal integrado.

Depois disso, **feche e reabra o Windows Terminal** para aplicar.

- Configurar o Windows Terminal manualmente: Configurações > seu perfil >
  Aparência > Tipo de fonte > `MesloLGS NF`.
- VS Code: defina `"terminal.integrated.fontFamily": "MesloLGS NF"`.

Para não mexer no Windows Terminal automaticamente, rode com
`DOTFILES_NO_WT=1 ./install.sh` (ou responda "n" na pergunta).

## Variáveis de configuração do instalador

Todas opcionais. Use antes do comando, ex.: `DOTFILES_NO_WT=1 ./install.sh`.

| Variável | Efeito |
|----------|--------|
| `DOTFILES_NO_SUDO=1` | Não usa `apt`; instala tudo como binário estático em `~/.local/bin`. |
| `DOTFILES_NO_CHSH=1` | Não altera o shell padrão (não roda `chsh`). |
| `DOTFILES_NO_WT=1` | No WSL, não mexe no `settings.json` do Windows Terminal. |
| `GH_MODELS_DEFAULT` | Modelo de IA usado por `gcommit` e `ai` (padrão `openai/gpt-4o-mini`). |

## Personalização

- Segredos locais (tokens, chaves): crie `~/.env`. Ele é carregado pelo Zsh e
  não vai para o repositório.
- Prompt: tema Dracula com informações de Git, definido em `configs/zshrc`.

## Licença

MIT. Veja `LICENSE`.
