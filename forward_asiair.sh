#!/bin/bash

# List of ports to forward
#!/bin/bash

# Forwards port to the ASI AIR. You can now access the asiair with the phone/tablet client by writting down the tailscale ip of your Mele. 

PORTS=(4350 4360 4400 4410 4500 4700 4710 4720 4800 4810 9624)

# Interface for Tailscale (check with `ip a`)
IN_IFACE=tailscale0   # <----- you might need to modify this. Check it with ip addr.
# Interface serving the AP
OUT_IFACE=wlp3s0  # <----- you might need to modify it. Check it with ip addr. 

# Get ASIAIR IP from hostname
ASIAIR_IP="$1"

if [[ -z "$ASIAIR_IP" ]]; then
  echo "Could not determine ASIAIR IP!"
  exit 1
fi

echo "ASIAIR found at $ASIAIR_IP"


# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Flush old rules (optional but helps avoid duplicates)
iptables -t nat -F
iptables -F FORWARD

# Add forwarding rules
for PORT in "${PORTS[@]}"; do
  iptables -t nat -A PREROUTING -i $IN_IFACE -p tcp --dport $PORT -j DNAT --to-destination $ASIAIR_IP
  iptables -t nat -A PREROUTING -i $IN_IFACE -p udp --dport $PORT -j DNAT --to-destination $ASIAIR_IP

  iptables -A FORWARD -p tcp -d $ASIAIR_IP --dport $PORT -j ACCEPT
  iptables -A FORWARD -p udp -d $ASIAIR_IP --dport $PORT -j ACCEPT
done

# Masquerade traffic going out through the AP
iptables -t nat -A POSTROUTING -o $OUT_IFACE -j MASQUERADE

echo "Port forwarding set up to $ASIAIR_IP"
