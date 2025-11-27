# USAR IMAGEN SLIM DE NODE (Debian - Estable)
FROM node:lts-slim

# Instalar n8n (Versión deseada, aquí usamos latest)
USER root
RUN npm install -g n8n@latest --unsafe-perm

# --- PASO CRÍTICO: INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA ---
# Instalamos Chromium y sus dependencias con apt
RUN apt-get update && apt-get install -y \
    chromium \
    libnss3 \
    libgbm-dev \
    libxshmfence-dev \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libasound2 \
    libfontconfig1 \
    libgconf-2-4 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Instalamos Puppeteer-Core (solo el código JS)
# Nota: No necesitamos el gestor de navegadores de Puppeteer si instalamos Chromium directamente con apt.
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache

# --- VARIABLES DE ENTORNO CRÍTICAS ---
# La ruta del ejecutable de Chromium instalado por 'apt' en Debian.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Exponer y ejecutar n8n
EXPOSE 5678
USER node
ENTRYPOINT ["tini", "--", "n8n"]