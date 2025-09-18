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

# Minimaler Kernel-/Netzwerk-Schutz (safe für Spieler)
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1

# ICMP (Ping) leicht limitieren (Spieler werden nicht geblockt)
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 10/second --limit-burst 20 -j ACCEPT
iptables -A INPUT -p icmp -j DROP

# FTP starten
service vsftpd start

# SSH-Server starten
service ssh start

# Danach das originale CMD/Entrypoint ausführen
exec "$@"
