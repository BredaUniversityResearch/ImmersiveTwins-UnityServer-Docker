#!/bin/bash

# get HEALTHCHECK_WRITER_MODE from env, fallback to 0 if not set
HEALTHCHECK_WRITER_MODE=${HEALTHCHECK_WRITER_MODE:-0}
# if zero or empty, exit
if [ "$HEALTHCHECK_WRITER_MODE" -eq 0 ]; then
    echo "Healthcheck writer mode is off. Exiting."
    exit 0
fi

# For dev purposes: write to the healthcheck file
TARGET="/home/mpukgame/.config/unity3d/CradleBUas/AugGIS/docker_healthcheck.txt"

mkdir -p "$(dirname "$TARGET")"

case "$HEALTHCHECK_WRITER_MODE" in
    2)
        # Mode 2: write random 0 or 1, sleep random 10-60 seconds
        while true; do
            VALUE=$((RANDOM % 2))
            SLEEP_TIME=$((RANDOM % 46 + 10))
            echo $VALUE > "$TARGET"
            sleep $SLEEP_TIME
        done
        ;;
    *)
        # Default: write 1 every 10 seconds
        while true; do
            echo 1 > "$TARGET"
            sleep 10
        done
        ;;
esac
