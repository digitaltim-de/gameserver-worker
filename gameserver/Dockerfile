FROM joedwards32/cs2

USER root

# Installiere FTP, SSH und htop
RUN apt-get update && apt-get install -y --no-install-recommends \
    vsftpd \
    openssh-server \
    htop \
    iptables \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Standard Environment-Variablen (können beim Container-Start überschrieben werden)
ENV FTP_USER=cs2ftp
ENV FTP_PASSWORD=changeme
ENV ROOT_PASSWORD=changeme

# Einfacher FTP-User (wird beim Start dynamisch konfiguriert)
RUN useradd -m -s /bin/bash cs2ftp

# SSH-Server vorbereiten (Passwort wird beim Start gesetzt)
RUN mkdir -p /var/run/sshd && \
    sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Ports freigeben
EXPOSE 21 22

# Kopiere die FTP-Konfig und Start-Skript
COPY vsftpd.conf /etc/vsftpd.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
