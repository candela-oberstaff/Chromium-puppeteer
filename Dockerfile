# 🚀 USAR IMAGEN OFICIAL DE N8N (ETIQUETA: latest, la más estable) 🚀
FROM docker.io/n8nio/n8n:latest

# Instalamos puppeteer-core (sin la descarga automática, solo el módulo Node.js)
USER root
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache --ignore-scripts

# --- PASO 2: INSTALAR DEPENDENCIAS DE SISTEMA (para Chromium) ---
# La imagen :latest de n8n está basada en Debian, por lo que usamos apt.
# Solo incluimos las dependencias mínimas necesarias para Chromium.
RUN apt-get update \
    && apt-get install -y \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libasound2 \
    libxshmfence-dev \
    && rm -rf /var/lib/apt/lists/*

# --- PASO 3: FORZAR LA DESCARGA DE CHROMIUM EN UNA RUTA CONOCIDA ---
# Usamos el gestor de navegadores de Puppeteer para descargar Chromium
# El binario terminará en la subcarpeta 'chrome-linux/chrome' dentro de este path.
RUN npm exec puppeteer browsers install chromium \
    --path=/usr/local/lib/node_modules/puppeteer-core/ \
    && npm cache clean --force

# --- CONFIGURACIÓN DE VARIABLES (CRÍTICO) ---
# La ruta final del ejecutable DENTRO de la carpeta forzada arriba.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/puppeteer-core/chrome-linux/chrome
ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Regresamos al usuario por defecto
USER node