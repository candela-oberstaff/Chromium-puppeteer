# USAR ESTA IMAGEN BASE ESTABLE EN LUGAR DE LA ALPINE 'latest'
FROM docker.io/n8nio/n8n:full

USER root

# Instalamos Chromium con APT (el gestor de Debian/Ubuntu)
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        chromium \
        wget \
        # Dependencias comunes de Puppeteer en Debian
        ca-certificates fonts-liberation libasound2 libatk1.0-0 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Configuramos el path estándar de Debian
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

USER node