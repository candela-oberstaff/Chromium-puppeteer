# Dockerfile Final y Corregido:

# Cambiamos la base a "alpine" para que 'apk' funcione
FROM docker.io/n8nio/n8n:alpine

# Mantenemos las ARGs, aunque no las modificamos aquí
ARG GENERIC_TIMEZONE=America/Mexico_City
ARG N8N_HOST=0.0.0.0
ARG N8N_PORT=5678
ARG N8N_SECURE_COOKIE=false
ARG PUPPETEER_DISABLE_SANDBOX=true
ARG PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium # Usamos el ARG también para coherencia
ARG WEBHOOK_URL=https://n8n.obertrack.com/
ARG SOURCE_COMMIT=22a47a5c1bf7904fcdd71bcac0e25c4d237d0015
ARG COOLIFY_URL=http://eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_FQDN=eswwwoc0s808ocg4sw8wssgw.109.199.104.87.sslip.io
ARG COOLIFY_BRANCH=main
ARG COOLIFY_RESOURCE_UUID=eswwwoc0s808ocg4sw8wssgw

USER root

# Instalar Chromium y dependencias en Alpine (¡Esto es correcto para la base alpine!)
RUN apk update && \
    apk add --no-cache \
        chromium \
        nss \
        freetype \
        harfbuzz \
        ttf-freefont \
    && rm -rf /var/cache/apk/*

# Corregimos las variables de entorno para Puppeteer
# 1. Indicamos la ruta correcta (/usr/bin/chromium)
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium 
# 2. Impedimos que Puppeteer intente descargar su propia versión de Chrome
ENV PUPPETEER_SKIP_DOWNLOAD=true
# 3. Deshabilitamos el sandbox (requerido en muchos entornos Docker)
ENV PUPPETEER_DISABLE_SANDBOX=true 

USER node