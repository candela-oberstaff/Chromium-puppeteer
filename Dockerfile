# Usar la imagen base de Node.js en Debian (slim es más pequeño)
FROM node:lts-slim

# Instalar n8n (basado en la documentación oficial para imágenes no oficiales)
RUN npm install -g n8n@latest --unsafe-perm

# Cambiamos a root para instalar paquetes
USER root

# --- PASO 1: INSTALAR DEPENDENCIAS DE SISTEMA (DEBIAN) ---
# Instalamos las librerías necesarias para Chromium usando el gestor de paquetes de Debian (apt)
RUN apt-get update \
    && apt-get install -y \
    wget \
    curl \
    gnupg \
    # Dependencias de Chromium:
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
    # Limpieza
    && rm -rf /var/lib/apt/lists/*

# --- PASO 2: INSTALAR PUPPETEER Y FORZAR LA DESCARGA EN UNA RUTA CONOCIDA ---
# 1. Instalar puppeteer-core (solo el módulo Node.js, sin descarga automática)
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache --ignore-scripts

# 2. Usar el nuevo gestor de navegadores de Puppeteer para descargar Chromium
#    y FORZAR la instalación en la ruta que n8n buscará:
RUN npm exec puppeteer browsers install chromium \
    --path=/usr/local/lib/node_modules/puppeteer-core/.chromium/ \
    && npm cache clean --force

# --- PASO 3: CONFIGURACIÓN DE VARIABLES para que n8n encuentre el binario ---
# La ruta apunta a la subcarpeta del binario dentro de la carpeta que FORZAMOS en el Paso 2.
# ESTA RUTA DEBE CONFIGURARSE COMO VARIABLE DE ENTORNO EN COOLIFY
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/puppeteer-core/.chromium/chrome/linux-x64/chrome
ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Exponer el puerto
EXPOSE 5678

# Regresamos al usuario por defecto y definimos el comando de inicio de n8n
USER node
WORKDIR /usr/local/lib/node_modules/n8n
CMD ["n8n", "start"]