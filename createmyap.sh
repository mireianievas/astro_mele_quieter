#!/bin/bash

# Start create_ap in background and capture its PID
sudo create_ap wlp3s0 wlp3s0 Mele 'MyWifiPassword' & # <-------- MODIFY with your hotspot details
AP_PID=$!

# Wait for AP to come up and clients to connect
sleep 20

echo "Starting ASIAIR watchdog loop..."

ASIAIR_MAC="XX:XX:XX:XX:XX:XX"            # <---------- MODIFY with your asiair mac.
LAST_IP_FILE="/tmp/last_asiair_ip"

# Watchdog loop: runs while create_ap is running
while kill -0 $AP_PID 2>/dev/null; do
  # Check if ASIAIR MAC appears in ip neighbor table
  ASIAIR_IP=$(ip neigh | grep -i "$ASIAIR_MAC" | awk '{print $1}')

  if [[ -n "$ASIAIR_IP" ]]; then
    LAST_IP=""
    [[ -f "$LAST_IP_FILE" ]] && LAST_IP=$(cat "$LAST_IP_FILE")

    if [[ "$ASIAIR_IP" != "$LAST_IP" ]]; then
      echo "$(date) - New ASIAIR IP detected: $ASIAIR_IP (was: $LAST_IP). Running forwarding script."
      echo "$ASIAIR_IP" > "$LAST_IP_FILE"
      sudo /usr/local/bin/forward_asiair.sh "$ASIAIR_IP"
    else
      echo "$(date) - ASIAIR IP unchanged at $ASIAIR_IP. Skipping forwarding."
    fi
  else
    echo "$(date) - ASIAIR not found (MAC $ASIAIR_MAC), checking again in 30 seconds."
  fi

  sleep 30
done

echo "create_ap process ended. Exiting script."
