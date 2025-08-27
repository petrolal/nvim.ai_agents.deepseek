#!/bin/bash
# setup.sh - Configuração do Ollama

echo "🐋 Configurando Ollama Docker..."

# Cria diretórios necessários
mkdir -p models data

# Baixa modelos populares (opcional)
echo "📥 Baixando modelos populares..."
curl -s https://raw.githubusercontent.com/ollama/ollama/main/docs/modelfile.md |
  grep -o '`[a-zA-Z0-9\-]\+`' |
  tr -d '`' |
  head -5 >models/popular_models.txt

echo "✅ Setup completo!"
echo "📋 Modelos populares disponíveis em: models/popular_models.txt"
echo "🚀 Para iniciar: docker-compose up -d"
