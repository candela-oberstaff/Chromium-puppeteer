FROM docker.io/n8nio/n8n:latest

USER root

# 1. Instalamos Chromium y dependencias necesarias en Alpine
# 'udev' y 'ttf-freefont' son críticos para evitar errores de renderizado
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev

# 2. Variables de entorno de respaldo (por si Coolify no las inyecta)
# Apuntamos DIRECTO al binario, ignorando el launcher script
ENV PUPPETEER_EXECUTABLE_PATH=/usr/lib/chromium/chromium
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

USER node