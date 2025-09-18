#!/bin/bash
set -e

echo "Building CS2 Gameserver Base Image..."

# Build the base Docker image from gameserver directory
docker build -t cs2-gameserver-base ./gameserver

echo "Base image 'cs2-gameserver-base' built successfully!"
echo ""
echo "=== Usage Examples ==="
echo ""
echo "1. Run with default credentials:"
echo "docker run -d -p 2201:22 -p 2101:21 -p 27015:27015/tcp -p 27015:27015/udp cs2-gameserver-base"
echo ""
echo "2. Run with custom credentials:"
echo "docker run -d \\"
echo "  -e ROOT_PASSWORD='your-root-password' \\"
echo "  -e FTP_USER='your-ftp-user' \\"
echo "  -e FTP_PASSWORD='your-ftp-password' \\"
echo "  -p 2201:22 -p 2101:21 -p 27015:27015/tcp -p 27015:27015/udp \\"
echo "  cs2-gameserver-base"
echo ""
echo "=== Default Credentials ==="
echo "SSH: ssh -p 2201 root@your-server-ip (password: changeme)"
echo "FTP: User 'cs2ftp', Password 'changeme' on port 2101"
echo ""
echo "=== Environment Variables ==="
echo "ROOT_PASSWORD - Root user password (default: changeme)"
echo "FTP_USER - FTP username (default: cs2ftp)"
echo "FTP_PASSWORD - FTP user password (default: changeme)"