#!/bin/bash

echo "Starting 2anki server with environment variable support..."

# Update constants.ts with environment variables
/app/update-constants-runtime.sh

# Start the Node.js server
exec node src/server.js
