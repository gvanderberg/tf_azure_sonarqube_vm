#!/bin/bash

set -eux

CURRENT_DATE=$(date "+%Y%m%d")
SONARQUBE_VERSION="9.1.0.47736"
SONARQUBE_ZIP_URL="https://binaries.sonarsource.com/CommercialDistribution/sonarqube-enterprise/sonarqube-enterprise-${SONARQUBE_VERSION}.zip"

mkdir -p /downloads
cd /downloads

wget $SONARQUBE_ZIP_URL
unzip sonarqube-enterprise-${SONARQUBE_VERSION}.zip
rm -rf sonarqube-enterprise-${SONARQUBE_VERSION}.zip

cp -rf /opt/sonarqube/conf/* /downloads/sonarqube-${SONARQUBE_VERSION}/conf/
cp -rf /opt/sonarqube/extensions/plugins/* /downloads/sonarqube-${SONARQUBE_VERSION}/extensions/plugins/

mv sonarqube-${SONARQUBE_VERSION} /opt

chown -R sonarqube:sonarqube /opt/sonarqube-${SONARQUBE_VERSION}

systemctl stop sonarqube.service

mv /opt/sonarqube /opt/sonarqube-${CURRENT_DATE}
mv /opt/sonarqube-${SONARQUBE_VERSION} /opt/sonarqube

sed -i.bak "s/sonar-application-.*/sonar-application-${SONARQUBE_VERSION}.jar/g" /etc/systemd/system/sonarqube.service

systemctl daemon-reload
systemctl start sonarqube.service

echo "To perform database migration after upgrade open url: https://sonarqube.outsurance.co.za/setup"