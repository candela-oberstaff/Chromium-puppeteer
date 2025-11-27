# Dockerfile recomendado
FROM n8nio/n8n:latest

USER root

# evitar prompts
ENV DEBIAN_FRONTEND=noninteractive
# no queremos que Puppeteer descargue su Chromium (porque instalamos el del sistema)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# indicamos explícitamente el path donde estará Chromium
ENV PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium"

# instalar Chromium y dependencias necesarias para Puppeteer
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget gnupg \
    chromium \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libxshmfence1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# instalar Puppeteer (sin descargar otro Chromium)
RUN npm install -g puppeteer@latest --unsafe-perm

# volver al usuario de n8n
USER node
