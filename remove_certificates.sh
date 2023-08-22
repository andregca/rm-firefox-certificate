#!/bin/bash

# Check if IP address argument is provided
if [ -z "$1" ]; then
    echo "Please provide the IP address as a command line argument."
    exit 1
fi

# IP address to query for certificate CN
IP_ADDRESS="$1"

# Path to Firefox profile directory
PROFILE_DIRECTORY="$HOME/Library/Application Support/Firefox/Profiles"

# Find the profile directory for Firefox
PROFILE=$(ls "$PROFILE_DIRECTORY" | grep default)

# Path to the cert db file
CERT_DIR="$PROFILE_DIRECTORY/$PROFILE"

# Path to the cert_override.txt file
CERT_OVERRIDE_FILE="$CERT_DIR/cert_override.txt"

# Check if certutil command is available
if ! command -v certutil &> /dev/null; then
    echo "certutil command not found. Please make sure you have Mozilla NSS tools installed."
    exit 1
fi

# Check if cert_override.txt file exists
if [ ! -f "$CERT_OVERRIDE_FILE" ]; then
    echo "cert_override.txt file not found."
    exit 1
fi

# Retrieve the CN info for the remote server's certificate
CN_INFO=$(echo | openssl s_client -connect "$IP_ADDRESS":443 2>/dev/null | openssl x509 -noout -subject | sed -n 's/^.*CN=\([^/]*\).*$/\1/p')

if [ -z "$CN_INFO" ]; then
    echo "Failed to retrieve the Common Name (CN) of the self-signed certificate on $IP_ADDRESS."
    exit 1
fi

# Remove certificate entry from cert db at the specified path
certutil -D -d "$CERT_DIR" -n "$CN_INFO" >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Failed to remove certificate entry from cert9.db."
    exit 1
fi
echo "Certificate entries with the Common Name (CN) $CN_INFO have been removed from cert db."

# Remove all occurrences of the ip address from cert_override.txt
sed -i '' "/$IP_ADDRESS/d" "$CERT_OVERRIDE_FILE"
echo "Entries with the IP Address $IP_ADDRESS have been removed from cert_override.txt."

exit 0