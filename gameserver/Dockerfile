FROM joedwards32/cs2

USER root

# Installiere FTP, SSH und htop
RUN apt-get update && apt-get install -y --no-install-recommends \
    vsftpd \
    openssh-server \
    htop \
    iptables \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Einfacher FTP-User (Passwort bitte ändern!)
RUN useradd -m -s /bin/bash cs2ftp && \
    echo "gameserver:changeme" | chpasswd

# SSH-Server vorbereiten und root-Passwort setzen
RUN echo "root:changeme" | chpasswd && \
    mkdir -p /var/run/sshd && \
    sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Ports freigeben
EXPOSE 21 22

# Kopiere die FTP-Konfig und Start-Skript
COPY vsftpd.conf /etc/vsftpd.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
