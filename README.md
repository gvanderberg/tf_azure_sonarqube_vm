# SonarQube #

* [SonarQube - Installation on Ubuntu Linux](https://techexpert.tips/sonarqube/sonarqube-installation-ubuntu-linux/)
* [SonarQube - Integration with Azure Active Directory](https://www.emtec.digital/think-hub/blogs/sonarqube-integration-azure-active-directory/)
* [SonarQube - Azure AD login does not place users in correct groups](https://github.com/hkamel/sonar-auth-aad/issues/62)
* [Use the portal to attach a data disk to a Linux VM](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal)

Binaries and versions can be found at [binaries.sonarsource.com](https://binaries.sonarsource.com/?prefix=CommercialDistribution/sonarqube-enterprise/).

```
Latin1_General_CS_AS
```

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

## Upgrade Procedure

Update the variable `SONARQUBE_VERSION` in the `upgrade.sh` file to the latest version.
Before starting the sonarqube service you need to update the service unit configuration to use the new version number.
You might also need to do a manual database migration after the service started by going to URL: `https://{sonarqube}/setup`.

```bash
sudo ./upgrade.sh
sudo systemctl stop sonarqube.service
sudo mv /opt/sonarqube /opt/sonarqube-{yyyyMMdd}
sudo mv /opt/sonarqube-{SONARQUBE_VERSION} /opt/sonarqube
sudo vi /etc/systemd/system/sonarqube.service
....
sudo systemctl daemon-reload
sudo systemctl start sonarqube.service
```