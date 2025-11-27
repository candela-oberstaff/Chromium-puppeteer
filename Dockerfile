FROM n8nio/n8n:latest-alpine

USER root

# Instalar Chromium
RUN apk update && \
    apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    tzdata

# Puppeteer config
ENV PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium"
ENV PUPPETEER_SKIP_DOWNLOAD="true"

# Timezone
RUN cp /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime

# Copiar tu código (IMPORTANTE)
WORKDIR /usr/src/app
COPY . .

# Instalar dependencias si usás scripts propios
RUN npm install

USER node
