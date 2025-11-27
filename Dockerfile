FROM node:20-slim

# ----------
# 1) Instalar dependencias del sistema necesarias para Chromium + Puppeteer
# ----------
RUN apt-get update && apt-get install -y \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    wget \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# ----------
# 2) Instalar n8n globalmente
# ----------
RUN npm install -g n8n

# ----------
# 3) Instalar Puppeteer (trae Chromium)
# ----------
RUN npm install -g puppeteer

# ----------
# 4) Crear usuario no root (Coolify recomienda esto)
# ----------
RUN useradd -m nodeuser
USER nodeuser

# ----------
# 5) Variables para que n8n funcione + Puppeteer sin sandbox (recomendado en contenedores)
# ----------
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true

# ----------
# 6) Exponer puerto n8n
# ----------
EXPOSE 5678

# ----------
# 7) Ejecutar n8n
# ----------
CMD ["n8n", "start"]
