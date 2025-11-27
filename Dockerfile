# Volvemos a la única imagen que se resuelve correctamente
FROM docker.io/n8nio/n8n:latest

USER root

# Instalamos dependencias del sistema y herramientas de red necesarias
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
    # Herramientas de red CRÍTICAS para la descarga
    wget \
    curl \
    # Dependencia de ejecución de Alpine Musl
    && apk add --no-cache bash

# --- PASO 1: INSTALAR EL MÓDULO PUPPETEER-CORE (SIN DESCARGA) ---
# Instalamos la librería Node.js, pero le decimos que OMITA la descarga AHORA.
RUN npm install puppeteer-core@latest --unsafe-perm --no-cache --ignore-scripts

# --- PASO 2: FORZAR LA DESCARGA DEL BINARIO (CORRECCIÓN CRÍTICA DE RUTA) ---
# El binario 'puppeteer' ya está en el PATH global (/usr/local/bin)
RUN puppeteer install \
    && npm cache clean --force

# Path del binario de Chromium (Usamos la ruta más probable después de la descarga)
# Deberás revisar esta ruta después del despliegue exitoso (ver paso 2).
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/puppeteer-core/.chromium/chrome/linux-x64/chrome
ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

USER node