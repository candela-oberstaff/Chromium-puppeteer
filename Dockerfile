# 🚀 USAR IMAGEN OFICIAL DE N8N CON CHROMIUM 🚀
FROM docker.io/n8nio/n8n:with-chromium

# Instalamos puppeteer-core (solo el módulo JS, no es necesario descargar Chromium)
# Usamos 'root' para la instalación, aunque esta imagen ya tiene muchas dependencias
USER root
RUN npm install -g puppeteer-core@latest --unsafe-perm --no-cache

# --- CONFIGURACIÓN DE VARIABLES (Obligatorio en Coolify) ---
# n8n ya sabe dónde está el binario, pero es mejor forzar la ruta
# ESTAS VARIABLES SON ABSOLUTAMENTE CRÍTICAS PARA QUE N8N LO ENCUENTRE
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_DISABLE_SANDBOX=true
ENV PUPPETEER_ARGS='--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu'

# Regresamos al usuario por defecto
USER node
# El resto de la configuración de inicio de n8n ya está en la imagen base