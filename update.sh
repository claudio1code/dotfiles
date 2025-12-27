#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Get the directory where this script is located
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -e "${BLUE}🔄 Checking for updates in $REPO_DIR...${NC}"

# Navigate to repo
cd "$REPO_DIR"

# Pull latest changes
echo "-> Git Pull..."
if git pull; then
    echo -e "${GREEN}✅ Repository updated.${NC}"
else
    echo -e "${RED}❌ Failed to pull updates. Check your internet connection or git status.${NC}"
    exit 1
fi

# Re-run install script to apply changes
echo -e "${BLUE}🛠️  Re-running install script...${NC}"
bash "./install.sh"

echo -e "${GREEN}✨ Update complete!${NC}"
