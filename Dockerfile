# Dockerfile para Ollama
FROM ubuntu:22.04

# Evita prompts interativos durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Define versões e URLs
ENV OLLAMA_VERSION=0.1.29
ENV OLLAMA_URL=https://github.com/ollama/ollama/releases/download/v${OLLAMA_VERSION}/ollama-linux-amd64
ENV OLLAMA_MODELS_DIR=/root/.ollama/models
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_PORT=11434

# Instala dependências do sistema
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  wget \
  git \
  software-properties-common \
  build-essential \
  python3 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Instala Ollama
RUN curl -L $OLLAMA_URL -o /usr/local/bin/ollama \
  && chmod +x /usr/local/bin/ollama

# Cria diretório para modelos
RUN mkdir -p $OLLAMA_MODELS_DIR

# Instala ferramentas úteis
RUN pip3 install --no-cache-dir \
  requests \
  numpy

# Configura diretório de trabalho
WORKDIR /app

# Script de inicialização
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expõe a porta do Ollama
EXPOSE 11434

# Health check
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:11434/api/tags || exit 1

ENTRYPOINT ["/entrypoint.sh"]
