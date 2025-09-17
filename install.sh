#!/bin/bash
set -e

echo "Building CS2 Gameserver Base Image..."

# Build the base Docker image
docker build -t cs2-gameserver-base .

echo "Base image 'cs2-gameserver-base' built successfully!"
echo ""
echo "To run a container with custom ports:"
echo "docker run -d -p <ssh-port>:22 -p <ftp-port>:21 -p 27015:27015/tcp -p 27015:27015/udp cs2-gameserver-base"
echo ""
echo "Example:"
echo "docker run -d -p 2201:22 -p 2101:21 -p 27015:27015/tcp -p 27015:27015/udp cs2-gameserver-base"
echo ""
echo "SSH: ssh -p 2201 root@your-server-ip"
echo "FTP: Connect to your-server-ip:2101"