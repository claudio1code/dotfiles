#!/bin/bash
set -e

# Get the directory of the script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "$DOTFILES_DIR"

echo "Pulling latest changes from GitHub..."
git pull

echo "Applying updates..."
sh install.sh

echo "Update complete!"
