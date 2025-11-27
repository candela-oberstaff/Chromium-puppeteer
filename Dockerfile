FROM docker.io/n8nio/n8n:latest

USER root

# Instalamos todo (incluyendo las librerías confirmadas)
RUN apk add --no-cache \
    chromium \
    nss freetype harfbuzz ca-certificates ttf-freefont udev \
    libstdc++ zlib fontconfig \
    # Limpieza
    && rm -rf /var/cache/apk/*

# --- PASO CRUCIAL: REPARAR PERMISOS ---
# 1. Aseguramos que el binario de Chromium sea totalmente ejecutable por todos.
RUN chmod 755 /usr/lib/chromium/chromium

# 2. Reafirmamos que el directorio de datos pertenece a 'node' (por si las dudas).
# Esto es esencial para que Chrome pueda escribir datos temporales.
RUN chown -R node:node /home/node /usr/lib/chromium

# 3. Reafirmamos el ejecutable y los argumentos (por si el ENV no entra bien)
ENV PUPPETEER_EXECUTABLE_PATH=/usr/lib/chromium/chromium
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

USER node