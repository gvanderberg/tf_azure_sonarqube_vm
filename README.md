# SonarQube #

* [SonarQube - Installation on Ubuntu Linux](https://techexpert.tips/sonarqube/sonarqube-installation-ubuntu-linux/)
* [SonarQube - Integration with Azure Active Directory](https://www.emtec.digital/think-hub/blogs/sonarqube-integration-azure-active-directory/)
* [SonarQube - Azure AD login does not place users in correct groups](https://github.com/hkamel/sonar-auth-aad/issues/62)
* [Use the portal to attach a data disk to a Linux VM](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal)

SQL Server collation
> Latin1_General_CS_AS

```bash
vi /opt/sonarqube/bin/linux-x86-64/sonar.sh
```

```bash
RUN_AS_USER=sonarqube
```

```bash
vi /opt/sonarqube/conf/sonar.properties
```

```bash
sonar.jdbc.username=sonarqube
sonar.jdbc.password=kamisama123
sonar.jdbc.url=jdbc:sqlserver://sqlserver-name.database.windows.net:1433;databaseName=sonarqube
sonar.web.javaAdditionalOpts=-server
sonar.web.host=0.0.0.0
```

```bash
sonar.path.data=/path/to/fast/io/volume/data
sonar.path.temp=/path/to/fast/io/volume/temp
```

## Upgrade steps

```bash
sudo ./upgrade.sh
sudo systemctl stop sonarqube.service
sudo mv /opt/sonarqube /opt/sonarqube-{yyyymmdd}
sudo mv /opt/sonarqube-{SONARQUBE_VERSION} /opt/sonarqube
sudo vi /etc/systemd/system/sonarqube.service

  ExecStart=/usr/bin/nohup /usr/bin/java -Xms32m -Xmx32m -Djava.net.preferIPv4Stack=true -jar /opt/sonarqube/lib/sonar-application-{SONARQUBE_VERSION}.jar

sudo systemctl daemon-reload
sudo systemctl start sonarqube.service
```

To perform database migration after upgrade open url `https://sonarqube.outsurance.co.za/setup`