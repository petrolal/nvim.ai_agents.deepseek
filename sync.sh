#!/bin/bash

# sync.sh
echo "🔄 Sincronizando dotfiles..."

# Atualizar repositório
cd "$HOME/dotfiles"
git pull

# Sincronizar plugins
nvim --headless "+Lazy! sync" +qa

echo "✅ Sincronização completa!"
