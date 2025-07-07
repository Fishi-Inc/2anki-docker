#!/bin/bash

# Script to update constants.ts at runtime with environment variables
CONSTANTS_FILE="/app/server/src/lib/constants.ts"

if [ ! -f "$CONSTANTS_FILE" ]; then
    echo "constants.ts not found at $CONSTANTS_FILE"
    exit 0
fi

echo "Updating constants.ts with environment variables..."

# Create a backup of the original file if it doesn't exist
if [ ! -f "$CONSTANTS_FILE.backup" ]; then
    cp "$CONSTANTS_FILE" "$CONSTANTS_FILE.backup"
fi

# Restore from backup to ensure we start with clean state
cp "$CONSTANTS_FILE.backup" "$CONSTANTS_FILE"

# Build the additional origins array
ADDITIONAL_ORIGINS=""

# Add ADDITIONAL_ALLOWED_ORIGINS if set
if [ ! -z "$ADDITIONAL_ALLOWED_ORIGINS" ]; then
    IFS=',' read -ra ORIGINS <<< "$ADDITIONAL_ALLOWED_ORIGINS"
    for origin in "${ORIGINS[@]}"; do
        # Trim whitespace
        origin=$(echo "$origin" | xargs)
        if [ ! -z "$origin" ]; then
            ADDITIONAL_ORIGINS="$ADDITIONAL_ORIGINS  '$origin',\n"
        fi
    done
fi

# Add IP addresses if set
if [ ! -z "$ALLOWED_IP_ADDRESSES" ]; then
    IFS=',' read -ra IPS <<< "$ALLOWED_IP_ADDRESSES"
    for ip in "${IPS[@]}"; do
        # Trim whitespace
        ip=$(echo "$ip" | xargs)
        if [ ! -z "$ip" ]; then
            ADDITIONAL_ORIGINS="$ADDITIONAL_ORIGINS  'http://$ip:8080',\n"
            ADDITIONAL_ORIGINS="$ADDITIONAL_ORIGINS  'http://$ip:2020',\n"
            ADDITIONAL_ORIGINS="$ADDITIONAL_ORIGINS  'https://$ip:8080',\n"
            ADDITIONAL_ORIGINS="$ADDITIONAL_ORIGINS  'https://$ip:2020',\n"
        fi
    done
fi

# Update the constants file if we have additional origins
if [ ! -z "$ADDITIONAL_ORIGINS" ]; then
    # Find the line with the closing bracket of ALLOWED_ORIGINS array
    # and insert our additional origins before it
    
    # Use sed to find the last occurrence of a string ending with comma and add our origins
    sed -i "/^  'https:\/\/app\.2anki\.net',$/a\\
$ADDITIONAL_ORIGINS" "$CONSTANTS_FILE"
    
    echo "Added environment-based origins to ALLOWED_ORIGINS"
else
    echo "No additional origins to add"
fi

echo "constants.ts update completed"
