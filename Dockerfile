FROM n8nio/n8n:latest-debian

USER root

# Dependencias requeridas por Chrome
RUN apt-get update && apt-get install -y wget gnupg --no-install-recommends

# Agregar repositorio oficial de Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# Instalar Google Chrome estable
RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# SETEAR Chrome como navegador para Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH="/usr/bin/google-chrome"

USER node
