#!/bin/bash
set -e

echo "=== Gameserver Container Setup ==="

# Überprüfe ob die erforderlichen Environment-Variablen existieren
if [ -z "${SRCDS_TOKEN}" ]; then
    echo "❌ Error: SRCDS_TOKEN (GSLT Token) environment variable is not set"
    exit 1
fi

if [ -z "${PORT}" ]; then
    echo "❌ Error: PORT environment variable is not set"
    exit 1
fi

if [ -z "${CUSTOMER_ID}" ]; then
    echo "❌ Error: CUSTOMER_ID environment variable is not set"
    exit 1
fi

echo "✓ All required environment variables are set"

# Konfiguriere Benutzer und Passwörter basierend auf Environment-Variablen
echo "Setting up users and passwords..."

# Root-Passwort setzen
echo "root:${ROOT_PASSWORD}" | chpasswd
echo "✓ Root password set"

# FTP-User konfigurieren
if [ "$FTP_USER" != "cs2ftp" ]; then
    # Neuen FTP-User erstellen wenn anders als Standard
    if id "$FTP_USER" &>/dev/null; then
        echo "✓ User $FTP_USER already exists"
    else
        useradd -m -s /bin/bash "$FTP_USER"
        echo "✓ Created FTP user: $FTP_USER"
    fi
fi

# FTP-Passwort setzen
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
echo "✓ FTP password set for user: $FTP_USER"

echo "=== Starting Services ==="

# FTP im Hintergrund starten
service vsftpd start
echo "✓ FTP server started"

# SSH-Server im Hintergrund starten  
service ssh start
echo "✓ SSH server started"

echo "=== Starting CS2 Gameserver ==="
# Versuche Steam-Verzeichnis Berechtigung zu setzen (falls möglich)
chown -R steam:steam /home/steam 2>/dev/null || echo "⚠ Warning: Cannot change ownership (use: sudo chown -R 1000:1000 ./cs2-data before starting)"

# Wechsle zu steam user und starte CS2
exec su steam -c "cd /home/steam && bash /home/steam/entry.sh"
