# Dockerfile Corregido:

FROM docker.io/n8nio/n8n:full

USER root

# Instalar Chromium y dependencias en Alpine
RUN apk update && \
    apk add --no-cache \
        chromium \
        nss \
        freetype \
        harfbuzz \
        ttf-freefont \
    && rm -rf /var/cache/apk/*

# AHORA CORREGIMOS LA RUTA
# Ajustar Puppeteer para usar Chromium del sistema
# Usar /usr/bin/chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium 
# También es crucial omitir la descarga para que use el instalado por apk
ENV PUPPETEER_SKIP_DOWNLOAD=true

USER node
