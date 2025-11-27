# Base: Imagen oficial de n8n
FROM docker.io/n8nio/n8n:latest

# Cambiamos a root para garantizar permisos de instalación
USER root

# --- PASO 1: INSTALAR DEPENDENCIAS DE SISTEMA Y HERRAMIENTAS ---
# Se incluyen todas las librerías necesarias para correr Chromium en Alpine.
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
    bash

# --- PASO 2: INSTALAR MÓDULO PUPPETEER-CORE GLOBALMENTE ---
# Usamos '-g' (global) para forzar la instalación del paquete base.
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache

# --- PASO 3: FORZAR LA DESCARGA DE CHROMIUM (Método Definitivo) ---
# Usamos 'npm exec' para ejecutar el binario 'puppeteer' de manera fiable
# sin importar dónde lo haya colocado NPM en el sistema de archivos de Alpine.
RUN npm exec puppeteer -- install \
    && npm cache clean --force

# --- PASO 4: CONFIGURACIÓN DE VARIABLES (PARA N8N) ---
# ESTA RUTA DEBE CONFIGURARSE COMO VARIABLE DE ENTORNO EN COOLIFY
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/puppeteer-core/.chromium/chrome/linux-x64/chrome
ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Regresamos al usuario por defecto
USER node