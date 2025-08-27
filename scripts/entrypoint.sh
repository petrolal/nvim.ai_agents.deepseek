#!/bin/bash

# Script de inicialização do Ollama
set -e

echo "🚀 Iniciando Ollama Server..."

# Inicia o Ollama em background
ollama serve &

# Aguarda o servidor iniciar
sleep 5

# Função para verificar se o servidor está rodando
check_ollama() {
  curl -s http://localhost:11434/api/tags >/dev/null
  return $?
}

# Aguarda até o servidor estar pronto
echo "⏳ Aguardando Ollama iniciar..."
until check_ollama; do
  sleep 2
  echo "⏳ Aguardando Ollama..."
done

echo "✅ Ollama está rodando!"

# Se existirem modelos para carregar
if [ -d "/models" ] && [ "$(ls -A /models)" ]; then
  echo "📦 Carregando modelos..."
  for model_file in /models/*; do
    if [ -f "$model_file" ]; then
      model_name=$(basename "$model_file" | cut -d. -f1)
      echo "📥 Carregando modelo: $model_name"
      ollama pull "$model_name" || true
    fi
  done
fi

# Mantém o container rodando
echo "🎯 Ollama pronto na porta 11434"
echo "💡 Use: curl http://localhost:11434/api/generate -d '{\"model\": \"model_name\", \"prompt\": \"Hello\"}'"

wait
