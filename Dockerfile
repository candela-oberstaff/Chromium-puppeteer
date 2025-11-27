# USAR IMAGEN SLIM DE NODE (Debian - Estable)
FROM node:lts-slim

# Instalar n8n y Tini (como en la última versión)
USER root
RUN apt-get update && apt-get install -y \
    tini \
    chromium \
    libnss3 libgbm-dev libxshmfence-dev libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libasound2 libfontconfig1 libgconf-2-4 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# --- PASO CRÍTICO DE ENLACE Y VERIFICACIÓN ---
# Intentamos renombrar/enlazar el binario 'chromium' al nombre que Puppeteer suele buscar.
# También listamos el contenido de /usr/bin para que puedas ver el nombre exacto en el log de Coolify.
RUN ln -sf /usr/bin/chromium /usr/bin/chromium-browser \
    && ls -l /usr/bin/chromium*

# Instalamos Puppeteer-Core
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache

# --- VARIABLES DE ENTORNO CRÍTICAS ---
# Usamos el nombre 'chromium-browser' que acabamos de enlazar/crear.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Exponer y ejecutar n8n
EXPOSE 5678
USER node
ENTRYPOINT ["tini", "--", "/usr/local/bin/n8n"]