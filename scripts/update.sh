#!/usr/bin/env bash
# Atualiza os dotfiles: faz git pull no repositorio (seja qual for o local)
# e re-executa o instalador para pegar novas ferramentas/config.
set -euo pipefail

# Descobre o diretorio real do repo a partir deste script (resolve symlink).
SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
REPO_DIR="$(cd "$(dirname "$SCRIPT")/.." && pwd)"

cd "$REPO_DIR"
echo "Atualizando dotfiles em: $REPO_DIR"
git pull --ff-only
echo "Reaplicando instalador..."
./install.sh
echo "Dotfiles atualizados."
