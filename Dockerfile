FROM n8nio/n8n:latest-alpine

USER root

# Instalar Chromium desde Alpine (repositorios activos)
RUN apk update && \
    apk add --no-cache \
        chromium \
        nss \
        freetype \
        harfbuzz \
        ca-certificates \
        ttf-freefont

# Configuración para Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Fijar timezone si lo necesitás (opcional)
RUN apk add --no-cache tzdata && cp /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime

USER node
