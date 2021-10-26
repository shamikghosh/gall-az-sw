#!/bin/sh
####Install Java

export VERSION=1.8.0
export JVM_PATH=/usr/lib/jvm
export AWK_PATH=/usr/bin
echo "install java"
sudo yum -y install java-$VERSION-openjdk
JAVA_VERSION=`ls -ltr $JVM_PATH |grep -i java-$VERSION | $AWK_PATH/awk -F " " '{print$9}' |grep -i java-$VERSION-openjdk`
#############################Install Maven################################################################
echo "Install Maven"
export HOME_PATH=/opt
export SOFTWARES=/home/vmadmin/bin/softwares
export M2_HOME=/opt/maven
export MAVEN_VERSION=3.6.3
export PATH=${M2_HOME}/apache-maven-$MAVEN_VERSION/bin:${PATH}
export MAVEN_LINK=https://github.com/shamikghosh/gall-az-sw/raw/main/apache-maven-$MAVEN_VERSION-bin.tar.gz
export M2_SCRIPT=/etc/profile.d/maven.sh
export JAVA_HOME=/usr/lib/jvm/$JAVA_VERSION/jre
export PATH=$JAVA_HOME/bin:$PATH

sudo mkdir $M2_HOME
cd $M2_HOME
wget $MAVEN_LINK
sudo tar -xvf $M2_HOME/apache-maven-$MAVEN_VERSION-bin.tar.gz
sudo chown -R vmadmin:vmadmin $M2_HOME
sudo chmod -R 755 $M2_HOME
rm -f $M2_HOME/apache-maven-$MAVEN_VERSION-bin.tar.gz
###########SETTING ENV FOR MAVEN##########################
echo "Configure Maven Env."
sudo touch $M2_SCRIPT
sudo chmod -R 755 $M2_SCRIPT

sudo sh -c "cat > $M2_SCRIPT" << EOF
export M2_HOME=/opt/maven/apache-maven-$MAVEN_VERSION
export JAVA_HOME=/usr/lib/jvm/$JAVA_VERSION/jre
export PATH=${M2_HOME}/bin:${PATH}
EOF
###############################Docker Installation########################################################
export DOCKER_SW=/home/vmadmin/bin/softwares
export USERBIN=/usr/bin
export DOCKER_VERSION=18.09.0
export DOCKER_CE_VERSION=17.03.0
export DOCKER_URL=https://github.com/shamikghosh/gall-az-sw/raw/main/docker-$DOCKER_VERSION.tgz
export DOCKER_CE_URL=https://github.com/shamikghosh/gall-az-sw/raw/main/docker-$DOCKER_CE_VERSION-ce.tgz
cd $DOCKER_SW
wget $DOCKER_CE_URL

tar -xvf $DOCKER_SW/docker-$DOCKER_CE_VERSION-ce.tgz

cd $DOCKER_SW/docker
sudo cp $DOCKER_SW/docker/* $USERBIN

rm -f $DOCKER_SW/docker-$DOCKER_CE_VERSION-ce.tgz 
###############################Creating DOCKER SERVICE#####################################################
export DOCKER_DAEMON_LOC=/etc/docker
export DOCKER_SERVICE=/usr/lib/systemd/system
export DOCKER_SERVICED=/etc/systemd/system/
echo "creating DOCKER deamon.json file at /etc/docker"
########
sudo touch $DOCKER_DAEMON_LOC/deamon.json
sudo chmod 755 $DOCKER_DAEMON_LOC/deamon.json
sudo sh -c "cat > $DOCKER_DAEMON_LOC/deamon.json" <<EOF
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}
EOF
########
echo "creating docker.service file for start, stop & restart"

sudo touch $DOCKER_SERVICE/docker.service
sudo chmod 755 $DOCKER_SERVICE/docker.service
sudo sh -c "cat > $DOCKER_SERVICE/docker.service" << EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF
###############################Start DOCKER SERVICE#####################################################
echo "#Start docker"
sudo systemctl daemon-reload
sudo systemctl restart docker.service
############################### End of file#####################################################