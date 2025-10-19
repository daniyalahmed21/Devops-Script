#!/bin/bash
# Script to install Tomcat 11 with remote Manager access

# 1. Install Java 17
echo "Installing Java 17..."
sudo dnf install java-17-amazon-corretto -y

# 2. Download latest Tomcat 11
TOMCAT_VERSION="11.0.12"
TOMCAT_DIR="/opt/tomcat"
echo "Downloading Tomcat $TOMCAT_VERSION..."
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
sudo tar -zxvf apache-tomcat-${TOMCAT_VERSION}.tar.gz
sudo mv apache-tomcat-${TOMCAT_VERSION} tomcat
sudo rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# 3. Configure tomcat-users.xml
echo "Configuring tomcat-users.xml..."
sudo tee $TOMCAT_DIR/conf/tomcat-users.xml > /dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users>
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <user username="tomcat" password="root123" roles="manager-gui,manager-script"/>
</tomcat-users>
EOF

# 4. Enable remote access to Manager (comment out RemoteAddrValve)
echo "Configuring Manager context for remote access..."
sudo sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve".*/<!-- & -->/' $TOMCAT_DIR/webapps/manager/META-INF/context.xml
sudo sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve".*/<!-- & -->/' $TOMCAT_DIR/webapps/host-manager/META-INF/context.xml

# 5. Start Tomcat
echo "Starting Tomcat..."
sh $TOMCAT_DIR/bin/shutdown.sh || true
sh $TOMCAT_DIR/bin/startup.sh

echo "✅ Tomcat setup complete!"
echo "Manager URL: http://<your-server-ip>:8080/manager/html"
echo "Username: tomcat"
echo "Password: root123"
