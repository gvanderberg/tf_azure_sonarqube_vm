#!/bin/bash

set -eux

apt-get update
apt-get install -y \
  default-jdk \
  nginx \
  software-properties-common \
  unzip \
  wget

SONARQUBE_VERSION="8.7.0.41497"
SONARQUBE_ZIP_URL="https://binaries.sonarsource.com/CommercialDistribution/sonarqube-enterprise/sonarqube-enterprise-${SONARQUBE_VERSION}.zip"

mkdir -p /downloads
cd /downloads

wget $SONARQUBE_ZIP_URL
unzip sonarqube-enterprise-${SONARQUBE_VERSION}.zip
rm -rf sonarqube-enterprise-${SONARQUBE_VERSION}.zip

mkdir /opt/sonarqube

mv sonarqube-${SONARQUBE_VERSION}/* /opt/sonarqube

adduser --system --no-create-home --group --disabled-login sonarqube
chown -R sonarqube:sonarqube /opt/sonarqube

echo -e "vm.max_map_count=262144" | tee -a /etc/sysctl.conf
echo -e "fs.file-max=65536" | tee -a /etc/sysctl.conf

cat <<EOF > /etc/security/limits.d/99-sonarqube.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOF

cat <<EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=sonarqube
Group=sonarqube
PermissionsStartOnly=true
ExecStart=/usr/bin/nohup /usr/bin/java -Xms32m -Xmx32m -Djava.net.preferIPv4Stack=true -jar /opt/sonarqube/lib/sonar-application-${SONARQUBE_VERSION}.jar
StandardOutput=syslog
LimitNOFILE=131072
LimitNPROC=8192
TimeoutStartSec=5
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable sonarqube.service

cat <<'EOF' > /opt/sonarqube/conf/nginx.conf
server {
  # port to listen on. Can also be set to an IP:PORT
  listen 80;

  # sets the domain[s] that this vhost server requests for
  server_name 127.0.0.1 sonarqube;

  return 301 https://$host$request_uri;
}

server {
  client_max_body_size 20M;
  
  # port to listen on. Can also be set to an IP:PORT
  listen 443 ssl;

  ssl_certificate /data/sonarqube/certs/sonarqube.pem;
  ssl_certificate_key /data/sonarqube/certs/sonarqube.key;

  location / {
    proxy_pass http://localhost:9000;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto https;
  }
}
EOF

cat <<'EOF' > /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
      worker_connections 768;
      # multi_accept on;
}

http {

      ##
      # Basic Settings
      ##

      sendfile on;
      tcp_nopush on;
      tcp_nodelay on;
      keepalive_timeout 65;
      types_hash_max_size 2048;
      # server_tokens off;

      # server_names_hash_bucket_size 64;
      # server_name_in_redirect off;

      include /etc/nginx/mime.types;
      default_type application/octet-stream;

      ##
      # SSL Settings
      ##

      ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
      ssl_prefer_server_ciphers on;

      ##
      # Logging Settings
      ##

      access_log /var/log/nginx/access.log;
      error_log /var/log/nginx/error.log;

      ##
      # Gzip Settings
      ##

      gzip on;

      # gzip_vary on;
      # gzip_proxied any;
      # gzip_comp_level 6;
      # gzip_buffers 16 8k;
      # gzip_http_version 1.1;
      # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

      ##
      # Virtual Host Configs
      ##

      include /etc/nginx/conf.d/*.conf;
      include /etc/nginx/sites-enabled/*;
      include /opt/sonarqube/conf/nginx.conf;
}


#mail {
#     # See sample authentication script at:
#     # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#     # auth_http localhost/auth.php;
#     # pop3_capabilities "TOP" "USER";
#     # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#     server {
#       listen     localhost:110;
#       protocol   pop3;
#       proxy      on;
#     }
#
#     server {
#       listen     localhost:143;
#       protocol   imap;
#       proxy      on;
#     }
#}
EOF
