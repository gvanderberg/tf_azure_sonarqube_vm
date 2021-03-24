#!/bin/bash

set -eux

SONARQUBE_VERSION="8.7.1.42226"
SONARQUBE_ZIP_URL="https://binaries.sonarsource.com/CommercialDistribution/sonarqube-enterprise/sonarqube-enterprise-${SONARQUBE_VERSION}.zip"

mkdir -p /downloads
cd /downloads

wget $SONARQUBE_ZIP_URL
unzip sonarqube-enterprise-${SONARQUBE_VERSION}.zip

cp -rf /opt/sonarqube/conf/* /downloads/sonarqube-${SONARQUBE_VERSION}/conf/

mkdir /opt/sonarqube-${SONARQUBE_VERSION}

mv sonarqube-${SONARQUBE_VERSION}/* /opt/sonarqube-${SONARQUBE_VERSION}

chown -R sonarqube:sonarqube /opt/sonarqube-${SONARQUBE_VERSION}
