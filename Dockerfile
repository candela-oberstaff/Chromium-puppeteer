# Volvemos a la única imagen que se resuelve correctamente
FROM docker.io/n8nio/n8n:latest

USER root

# Instalamos dependencias del sistema para que Puppeteer NPM funcione en Alpine.
# Note que ya no instalamos el paquete 'chromium' de apk.
RUN apk add --no-cache \
    udev \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    libstdc++ \
    zlib \
    fontconfig \
    # Dependencia de ejecución de Alpine Musl
    && apk add --no-cache bash

# --- PASO CRUCIAL: INSTALAR PUPPETEER VIA NPM A NIVEL GLOBAL ---
# Quitamos el WORKDIR. La instalación se hace en /usr/local/lib/node_modules
# (El path de instalación del binario cambiará)
RUN npm install puppeteer-core@latest --unsafe-perm --no-cache \
    && npm cache clean --force

# Path donde NPM instala el binario de Chrome que se descarga (Ruta Global)
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/puppeteer-core/.chromium/linux-124.0.6367.73/chrome-linux/chrome
ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

USER node