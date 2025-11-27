# 🚀 USAR IMAGEN OFICIAL DE N8N CON CHROMIUM (ETIQUETA: full) 🚀
FROM docker.io/n8nio/n8n:full

# Instalamos puppeteer-core (solo el módulo JS, no es necesario descargar Chromium)
USER root
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache

# --- CONFIGURACIÓN DE VARIABLES (Obligatorio en Coolify) ---
# La ruta del ejecutable en la imagen 'full' es /usr/bin/chromium-browser
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Regresamos al usuario por defecto
USER node