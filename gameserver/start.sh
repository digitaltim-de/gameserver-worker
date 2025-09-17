#!/bin/bash
set -e

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
