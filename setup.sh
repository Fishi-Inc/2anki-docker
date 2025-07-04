#!/bin/bash

# Create directory structure
mkdir -p ~/src/github.com/2anki
cd ~/src/github.com/2anki

# Clone repositories
if [ ! -d "server" ]; then
    git clone https://github.com/2anki/server
fi

if [ ! -d "web" ]; then
    git clone https://github.com/2anki/web server/web
fi

if [ ! -d "create_deck" ]; then
    git clone https://github.com/2anki/create_deck
fi

# Copy Docker files
cp docker-compose.yml ~/src/github.com/2anki/
cp Dockerfile.* ~/src/github.com/2anki/

# Create environment file
cat > ~/src/github.com/2anki/server/.env <<EOF
WORKSPACE_BASE=/tmp/genanki
NODE_ENV=production
EOF

# Create workspace directory
mkdir -p /tmp/genanki

echo "Setup complete! You can now run: docker-compose up -d"