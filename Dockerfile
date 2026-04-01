FROM node:20-slim

RUN apt-get update && \
    apt-get install -y git bash curl && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai opencode-telegram-group-topics-bot

WORKDIR /workspace

# Đảm bảo PATH và HOME nhất quán
ENV HOME=/root

RUN echo '#!/bin/sh' > /start.sh && \
    echo 'CONFIG_DIR="$HOME/.config/opencode-telegram-group-topics-bot"' >> /start.sh && \
    echo 'CONFIG_FILE="$CONFIG_DIR/.env"' >> /start.sh && \
    echo 'mkdir -p "$CONFIG_DIR"' >> /start.sh && \
    # Khởi tạo file .env với các giá trị mặc định hoặc bắt buộc để tránh Wizard
    echo 'echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}" > "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "TELEGRAM_ALLOWED_USER_ID=${TELEGRAM_ALLOWED_USER_ID}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "OPENCODE_API_URL=${OPENCODE_API_URL:-http://127.0.0.1:4096}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "OPENCODE_MODEL_PROVIDER=${OPENCODE_MODEL_PROVIDER:-opencode}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "OPENCODE_MODEL_ID=${OPENCODE_MODEL_ID:-big-pickle}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "BOT_LOCALE=${BOT_LOCALE:-en}" >> "$CONFIG_FILE"' >> /start.sh && \
    # Hàm add_env để thêm các biến tùy chọn khác (chỉ thêm nếu bạn điền trên Dokploy)
    echo 'add_env() { if [ ! -z "$(eval echo \$$1)" ]; then echo "$1=$(eval echo \$$1)" >> "$CONFIG_FILE"; fi; }' >> /start.sh && \
    echo 'add_env HIDE_THINKING_MESSAGES' >> /start.sh && \
    echo 'add_env HIDE_TOOL_CALL_MESSAGES' >> /start.sh && \
    echo 'add_env SERVICE_MESSAGES_INTERVAL_SEC' >> /start.sh && \
    echo 'add_env ANTHROPIC_API_KEY' >> /start.sh && \
    echo 'add_env OPENAI_API_KEY' >> /start.sh && \
    echo 'add_env GEMINI_API_KEY' >> /start.sh && \
    echo 'add_env STT_API_KEY' >> /start.sh && \
    echo 'add_env TTS_API_KEY' >> /start.sh && \
    # Chạy Server
    echo 'echo "🚀 Starting OpenCode server..."' >> /start.sh && \
    echo 'opencode serve & ' >> /start.sh && \
    echo 'sleep 5' >> /start.sh && \
    echo 'echo "🤖 Starting Bot..."' >> /start.sh && \
    echo 'opencode-telegram-group-topics-bot start' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
