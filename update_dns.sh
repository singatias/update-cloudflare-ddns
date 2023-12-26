#!/bin/sh

# Get current public IP address
IP_ADDRESS=$(curl -s https://api.ipify.org)

echo "Current IP address: ${IP_ADDRESS}"

# Ensure curl completed successfully
if [ $? -ne 0 ]; then
    echo "Failed to get the public IP address."
    exit 1
fi

# Update the DNS record based on AUTH_TYPE
if [ "$AUTH_TYPE" = "BEARER_TOKEN" ]; then
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
         -H "Authorization: Bearer ${API_KEY}" \
         -H "Content-Type: application/json" \
         --data '{"type":"A","name":"'"$SUBDOMAIN"'","content":"'"$IP_ADDRESS"'","ttl":120}'
elif [ "$AUTH_TYPE" = "AUTH_KEY" ]; then
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
         -H "X-Auth-Email: ${EMAIL}" \
         -H "X-Auth-Key: ${API_KEY}" \
         -H "Content-Type: application/json" \
         --data '{"type":"A","name":"'"$SUBDOMAIN"'","content":"'"$IP_ADDRESS"'","ttl":120}'
else
    echo "Invalid AUTH_TYPE. Supported values: BEARER_TOKEN, AUTH_KEY."
    exit 1
fi

# Ensure curl completed successfully
if [ $? -ne 0 ]; then
    echo "Failed to update the DNS record."
    exit 1
fi

echo "DNS record updated successfully."
