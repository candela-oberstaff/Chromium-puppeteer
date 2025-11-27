FROM n8nio/n8n:latest

USER root

# Instalar dependencias + Chrome
RUN apt-get update && apt-get install -y wget gnupg --no-install-recommends

# Repo oficial de Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_EXECUTABLE_PATH="/usr/bin/google-chrome"

USER node
