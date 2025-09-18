#!/bin/bash
set -e

echo "=== Gameserver Container Setup ==="

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

# FTP starten
service vsftpd start
echo "✓ FTP server started"

# SSH-Server starten
service ssh start
echo "✓ SSH server started"

echo "=== Starting CS2 Gameserver ==="
# Versuche Steam-Verzeichnis Berechtigung zu setzen (falls möglich)
chown -R steam:steam /home/steam 2>/dev/null || echo "⚠ Warning: Cannot change ownership (use: sudo chown -R 1000:1000 ./cs2-data before starting)"
# Starte das originale CS2 Entrypoint als steam user
exec su steam -c "bash /home/steam/entry.sh"
