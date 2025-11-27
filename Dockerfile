FROM docker.io/n8nio/n8n:latest

# Mantenemos tus argumentos
ARG GENERIC_TIMEZONE=America/Mexico_City
ARG N8N_HOST=0.0.0.0
ARG N8N_PORT=5678
ARG N8N_SECURE_COOKIE=false
ARG PUPPETEER_DISABLE_SANDBOX=true
# ARG PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium  <-- BORRA O IGNORA ESTA LINEA EN LOS ARGS
ARG WEBHOOK_URL=https://n8n.obertrack.com/
ARG SOURCE_COMMIT=22a47a5c1bf7904fcdd71bcac0e25c4d237d0015
ARG COOLIFY_URL=http://eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_FQDN=eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_BRANCH=main
ARG COOLIFY_RESOURCE_UUID=eswwwoc0s808ocg4sw8wssgw

USER root

# Instalamos Chromium y fuentes en Alpine
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev

# --- CORRECCIÓN AQUÍ ---
# En Alpine, el binario se llama usualmente 'chromium-browser'
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Configuraciones adicionales de seguridad para Docker
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true
# Argumentos extra para lanzar Chrome en entornos limitados
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

USER node