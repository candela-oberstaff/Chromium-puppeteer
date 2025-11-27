# Usar la imagen base de Node.js en Debian (slim es más pequeño)
FROM node:lts-slim

# Instalar n8n (basado en la documentación oficial para imágenes no oficiales)
RUN npm install -g n8n@latest --unsafe-perm

# Cambiamos a root para instalar paquetes
USER root

# --- PASO 1: INSTALAR DEPENDENCIAS DE SISTEMA (DEBIAN) ---
# Instalamos wget, curl, y las librerías necesarias para Chromium
RUN apt-get update \
    && apt-get install -y \
    wget \
    curl \
    gnupg \
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

# --- PASO 2: INSTALAR MÓDULO PUPPETEER-CORE Y DESCARGAR CHROMIUM ---
# Puppeteer se instala en modo seguro y automáticamente descarga Chromium
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache \
    && npm cache clean --force

# --- PASO 3: CONFIGURACIÓN DE VARIABLES ---
# En Debian, la ruta es diferente. Puppeteer es más fácil de ubicar.
# ESTA RUTA DEBE CONFIGURARSE COMO VARIABLE DE ENTORNO EN COOLIFY
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/puppeteer-core/.chromium/chrome/linux-x64/chrome
ENV PUPPETEER_SKIP_DOWNLOAD=false
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Exponer el puerto
EXPOSE 5678

# Regresamos al usuario por defecto y definimos el comando de inicio
USER node
WORKDIR /usr/local/lib/node_modules/n8n
CMD ["n8n", "start"]