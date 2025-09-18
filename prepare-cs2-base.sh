#!/bin/bash

echo "Building CS2 base container (using joedwards32/cs2)..."
docker build -f Dockerfile.base -t cs2-base-with-files .

echo "Creating CS2 game files volume..."
docker volume create cs2-game-files

echo "Starting base container to copy CS2 files..."
docker run -d --name cs2-temp-base -v cs2-game-files:/volume-dest cs2-base-with-files

echo "Copying CS2 files to volume..."
docker exec cs2-temp-base cp -r /home/steam/cs2-dedicated/. /volume-dest/

echo "Cleaning up temporary container..."
docker stop cs2-temp-base
docker rm cs2-temp-base

echo "✅ CS2 base files are ready! Game files are now cached in volume 'cs2-game-files'."
echo "You can now start game servers quickly with ./start-container.sh"
