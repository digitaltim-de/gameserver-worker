#!/bin/bash

echo "Building CS2 base container (using joedwards32/cs2)..."
docker build -f gameserver/Dockerfile.base -t cs2-base-with-files ./gameserver/

echo "Creating CS2 game files volume..."
docker volume create cs2-game-files

echo "Starting base container and downloading CS2 files..."
echo "This will take several minutes (downloading ~57GB)..."
docker run -d --name cs2-temp-base \
    -e SRCDS_TOKEN="dummy" \
    -e CUSTOMER_ID="base-setup" \
    -v cs2-game-files:/volume-dest \
    cs2-base-with-files

echo "Waiting for CS2 server to fully initialize and download all files..."
echo "Monitoring container logs (press Ctrl+C when you see the server is fully started)..."

# Warte bis der Server vollständig geladen ist
docker logs -f cs2-temp-base &
LOGS_PID=$!

echo ""
echo "Waiting for CS2 download to complete..."
echo "The container will download CS2 files first, then start the server."
echo "Wait until you see messages like 'Server is ready' or 'Map loaded' before continuing."
echo ""
echo "Press ENTER when the download and server startup is complete..."
read -p ""

# Stoppe die Log-Ausgabe
kill $LOGS_PID 2>/dev/null || true

echo "Copying CS2 files from running container to volume..."
docker exec cs2-temp-base cp -r /home/steam/cs2-dedicated/. /volume-dest/

echo "Cleaning up temporary container..."
docker stop cs2-temp-base
docker rm cs2-temp-base

echo "✅ CS2 base files are ready! Game files are now cached in volume 'cs2-game-files'."
echo "You can now start game servers quickly with ./start-container.sh"
