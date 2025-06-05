#!/bin/bash

CHECK_INTERVAL=30
MAX_RETRIES=4
RETRY_COUNT=0

# IP to ping (Cloudflare's DNS is reliable and fast)
PING_TARGET="1.1.1.1"

while true; do
    if ping -c 1 -W 2 $PING_TARGET > /dev/null 2>&1; then
        # Internet is up, reset retry counter
        RETRY_COUNT=0
    else
        # No internet
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
            echo "[$(date)] No internet for $((CHECK_INTERVAL * RETRY_COUNT))s. Creating AP..."
            /usr/local/bin/createmyap.sh
            RETRY_COUNT=0
        fi
    fi
    sleep $CHECK_INTERVAL
done
