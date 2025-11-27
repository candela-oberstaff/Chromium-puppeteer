# Base: Imagen oficial de n8n
FROM docker.io/n8nio/n8n:latest

# Cambiamos a root para instalar paquetes
USER root

# --- PASO 1: INSTALAR DEPENDENCIAS DE SISTEMA Y HERRAMIENTAS ---
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

# --- PASO 2: INSTALAR EL MÓDULO PUPPETEER-CORE (SIN DESCARGA) ---
# Instalamos la librería Node.js, pero le decimos que OMITA la descarga AHORA.
RUN npm install puppeteer-core@latest --unsafe-perm --no-cache --ignore-scripts

# --- PASO 3: FORZAR LA DESCARGA DEL BINARIO (USANDO RUTA ABSOLUTA) ---
# Usamos la ruta absoluta del binario global: /usr/local/bin/puppeteer
# Esto evita por completo el error de 'not found' del PATH.
RUN /usr/local/bin/puppeteer install \
    && npm cache clean --force

# --- PASO 4: CONFIGURACIÓN DE VARIABLES (PARA N8N) ---
# RUTA MÁS PROBABLE DESPUÉS DE LA DESCARGA EXITOSA.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/puppeteer-core/.chromium/chrome/linux-x64/chrome
ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Regresamos al usuario por defecto
USER node