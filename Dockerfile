# Volvemos a la base más común (latest), asumiendo que es Debian/Ubuntu
FROM docker.io/n8nio/n8n:latest

# Mantenemos las ARGs
ARG GENERIC_TIMEZONE=America/Mexico_City
ARG N8N_HOST=0.0.0.0
ARG N8N_PORT=5678
ARG N8N_SECURE_COOKIE=false
ARG PUPPETEER_DISABLE_SANDBOX=true
ARG PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ARG WEBHOOK_URL=https://n8n.obertrack.com/
ARG SOURCE_COMMIT=22a47a5c1bf7904fcdd71bcac0e25c4d237d0015
ARG COOLIFY_URL=http://eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_FQDN=eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_BRANCH=main
ARG COOLIFY_RESOURCE_UUID=eswwwoc0s808ocg4sw8wssgw

USER root

# ¡USAMOS APT-GET OTRA VEZ!
# Instalamos las dependencias para Chromium en una base Debian/Ubuntu
# Nota: La sintaxis de apt-get es diferente y requiere 'install -y'
RUN apt-get update && \
    apt-get install -y \
        chromium \
        ca-certificates \
        fonts-liberation \
        libasound2 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgcc1 \
        libgdk-pixbuf2.0-0 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Configuración de Puppeteer (Ruta y deshabilitar sandbox son cruciales)
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium 
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true

USER node