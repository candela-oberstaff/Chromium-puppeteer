# Usamos la única imagen que sabemos que descarga correctamente
FROM docker.io/n8nio/n8n:latest

# Mantenemos tus argumentos
ARG GENERIC_TIMEZONE=America/Mexico_City
ARG N8N_HOST=0.0.0.0
ARG N8N_PORT=5678
ARG N8N_SECURE_COOKIE=false
ARG PUPPETEER_DISABLE_SANDBOX=true
ARG PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ARG WEBHOOK_URL=https://n8n.obertrack.com/
ARG SOURCE_COMMIT=22a47a5c1bf7904fcdd71bcac0e25c4d237d0015
ARG COOLIFY_URL=http://eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_FQDN=eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_BRANCH=main
ARG COOLIFY_RESOURCE_UUID=eswwwoc0s808ocg4sw8wssgw

USER root

# LA CLAVE: Usamos 'apk' (Alpine) sobre la imagen 'latest'
# Instalamos Chromium y las fuentes necesarias para que no crashee
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# Configuración de Puppeteer
# En Alpine, Chromium se instala en /usr/bin/chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true

USER node