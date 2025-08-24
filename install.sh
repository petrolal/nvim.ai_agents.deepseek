#!/bin/bash
# install.sh

echo "🚀 Instalando Dotfiles..."

# Backup
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
if [ -d "$HOME/.config/nvim" ]; then
  echo "💾 Backup do config existente..."
  mv "$HOME/.config/nvim" "$BACKUP_DIR"
fi

# Clone repo
if [ ! -d "$HOME/Projects/Dotfiles" ]; then
  git clone git@github.com:petrolal/nvim.dotfiles.turas_vim.git "$HOME/Projects/Dotfiles/nvim"
fi

# Symlinks
echo "🔗 Criando symlinks..."
ln -sfn "$HOME/Projects/Dotfiles/nvim.dotfiles.turas_vim" "$HOME/.config/nvim"

# Dependências
echo "📦 Instalando dependências..."
suso pacman -Syu
sudo pacman -Sy curl git python3-pip nodejs npm

# Ollama
if ! command -v ollama &>/dev/null; then
  echo "🤖 Instalando Ollama..."
  curl -fsSL https://ollama.ai/install.sh | sh
  echo "📥 Baixando modelo deepseek-coder..."
  ollama pull deepseek-coder
fi

# Plugins
echo "⚡ Instalando plugins..."
nvim --headless "+Lazy! sync" +qa

echo "✅ Instalação completa!"
