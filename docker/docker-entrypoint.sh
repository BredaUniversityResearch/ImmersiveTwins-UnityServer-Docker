#!/bin/bash
# Entrypoint script to start healthcheck writer (for dev) and Unity server

if [ "$APP_ENV" = "dev" ]; then
  bash /home/mpukgame/dev-healthcheck-writer.sh &
fi

exec /app/ImmersiveTwins-Unity
