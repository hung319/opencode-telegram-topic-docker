FROM node:20-slim

# Cài đặt môi trường cơ bản
RUN apt-get update && \
    apt-get install -y git bash curl && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt OpenCode và Bot bản Group Topics
RUN npm install -g opencode-ai opencode-telegram-group-topics-bot

WORKDIR /workspace

# Script khởi chạy và tự động cấu hình (Chỉ thêm biến có giá trị)
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'CONFIG_DIR="/root/.config/opencode-telegram-group-topics-bot"' >> /start.sh && \
    echo 'CONFIG_FILE="$CONFIG_DIR/.env"' >> /start.sh && \
    echo 'mkdir -p "$CONFIG_DIR"' >> /start.sh && \
    echo '> "$CONFIG_FILE"' >> /start.sh && \
    echo 'add_env() { if [ ! -z "$(eval echo \$$1)" ]; then echo "$1=$(eval echo \$$1)" >> "$CONFIG_FILE"; fi; }' >> /start.sh && \
    echo 'echo "🚀 Đang khởi động OpenCode server..."' >> /start.sh && \
    echo 'opencode serve & ' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'echo "⚙️ Đang cấu hình biến môi trường..."' >> /start.sh && \
    echo 'add_env TELEGRAM_BOT_TOKEN' >> /start.sh && \
    echo 'add_env TELEGRAM_ALLOWED_USER_ID' >> /start.sh && \
    echo 'add_env TELEGRAM_PROXY_URL' >> /start.sh && \
    echo 'add_env OPENCODE_API_URL' >> /start.sh && \
    echo 'add_env OPENCODE_SERVER_USERNAME' >> /start.sh && \
    echo 'add_env OPENCODE_SERVER_PASSWORD' >> /start.sh && \
    echo 'add_env OPENCODE_MODEL_PROVIDER' >> /start.sh && \
    echo 'add_env OPENCODE_MODEL_ID' >> /start.sh && \
    echo 'add_env BOT_LOCALE' >> /start.sh && \
    echo 'add_env HIDE_THINKING_MESSAGES' >> /start.sh && \
    echo 'add_env HIDE_TOOL_CALL_MESSAGES' >> /start.sh && \
    echo 'add_env SERVICE_MESSAGES_INTERVAL_SEC' >> /start.sh && \
    echo 'add_env MESSAGE_FORMAT_MODE' >> /start.sh && \
    echo 'add_env STT_API_URL' >> /start.sh && \
    echo 'add_env STT_API_KEY' >> /start.sh && \
    echo 'add_env STT_MODEL' >> /start.sh && \
    echo 'add_env TTS_API_URL' >> /start.sh && \
    echo 'add_env TTS_API_KEY' >> /start.sh && \
    echo 'add_env TTS_MODEL' >> /start.sh && \
    echo 'add_env TTS_VOICE' >> /start.sh && \
    echo 'echo "🤖 Đang khởi động OpenCode Group Topics Bot..."' >> /start.sh && \
    echo 'opencode-telegram-group-topics-bot start' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
