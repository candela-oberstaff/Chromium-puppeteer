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

# --- PASO 2: FORZAR LA DESCARGA DEL BINARIO (POST-INSTALL) ---
# Usamos el comando específico de Puppeteer para descargar el binario
# Esto permite que el error sea más claro si falla.
RUN /usr/local/lib/node_modules/puppeteer-core/node_modules/.bin/puppeteer install \
    && npm cache clean --force

# El PATH del binario de Chromium ahora es manejado por Puppeteer, pero
# necesitamos encontrarlo, ya que el número de versión puede variar.

# Temporalmente, configuraremos el ejecutable en blanco para que n8n use el
# valor por defecto si falla, o podemos reintentar la ruta que buscaste.

# Dejaremos la variable de Coolify para que la definas una vez que veamos
# la versión descargada (probaremos la ruta más común).

ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

USER node