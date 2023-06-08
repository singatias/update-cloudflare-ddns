#!/bin/sh

# Get current public IP address
IP_ADDRESS=$(curl -s https://api.ipify.org)

echo "Current IP address: ${IP_ADDRESS}"

# Ensure curl completed successfully
if [[ $? -ne 0 ]]; then
    echo "Failed to get public IP address."
    exit 1
fi

# Update the DNS record
curl -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
     -H "Authorization: Bearer ${API_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'"$SUBDOMAIN"'","content":"'"$IP_ADDRESS"'","ttl":120}'

# Ensure curl completed successfully
if [[ $? -ne 0 ]]; then
    echo "Failed to update DNS record."
    exit 1
fi

echo "DNS record updated successfully."
