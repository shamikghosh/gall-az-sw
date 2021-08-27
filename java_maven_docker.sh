#!/bin/sh
####Install Java

export VERSION=1.8.0
echo "install java"
sudo yum install java-$VERSION-openjdk

#############################Install Maven################################################################
echo "Install Maven"
export HOME_PATH=/opt
export SOFTWARES=/home/vmadmin/bin/softwares
export M2_HOME=/opt/maven
export MAVEN_VERSION=3.6.3
export PATH=${M2_HOME}/apache-maven-$MAVEN_VERSION/bin:${PATH}
export MAVEN_LINK=https://github.com/shamikghosh/gall-az-sw/raw/main/apache-maven-$MAVEN_VERSION-bin.tar.gz
export M2_SCRIPT=/etc/profile.d/maven.sh
export JAVA_HOME=/usr/lib/jvm/java-$VERSION-openjdk-1.8.0.302.b08-0.el8_2.x86_64/jre
export PATH=$JAVA_HOME/bin:$PATH

mkdir $M2_HOME
cd $M2_HOME
wget $MAVEN_LINK
tar -xvf $M2_HOME/apache-maven-$MAVEN_VERSION-bin.tar.gz
sudo chown -R vmadmin:vmadmin $M2_HOME
sudo chmod -R 755 $M2_HOME
rm -f $M2_HOME/apache-maven-$MAVEN_VERSION-bin.tar.gz
#sudo ln -s apache-maven-3.6.3 maven
###########SETTING ENV FOR MAVEN##########################

echo "Configure Maven Env."
sudo touch $M2_SCRIPT

###Add following:

echo "export M2_HOME=/opt/maven/apache-maven-$MAVEN_VERSION" > $M2_SCRIPT
echo "export JAVA_HOME=/usr/lib/jvm/java-$VERSION-openjdk-1.8.0.302.b08-0.el8_2.x86_64/jre" >> $M2_SCRIPT
echo "export PATH=${M2_HOME}/bin:${PATH}" >> $M2_SCRIPT 

###########SETTING ENV FOR MAVEN##########################
###############################Docker Installation########################################################
export DOCKER_SW=/home/vmadmin/bin/softwares
export USERBIN=/usr/bin
export DOCKER_VERSION=18.09.0
export DOCKER_CE_VERSION=17.03.0
export DOCKER_URL=https://github.com/shamikghosh/gall-az-sw/raw/main/docker-$DOCKER_VERSION.tgz
export DOCKER_CE_URL=https://github.com/shamikghosh/gall-az-sw/raw/main/docker-$DOCKER_CE_VERSION-ce.tgz
cd $DOCKER_SW
#wget $DOCKER_URL 
wget $DOCKER_CE_URL

tar -xvf $DOCKER_SW/docker-$DOCKER_CE_VERSION-ce.tgz
#tar -xvf docker-$DOCKER_VERSION.tgz

cd $DOCKER_SW/docker
sudo cp $DOCKER_SW/docker/* $USERBIN
#sudo $USERBIN/dockerd &

rm -f $DOCKER_SW/docker-$DOCKER_CE_VERSION-ce.tgz 
###############################Docker Installation#########################################################
###############################Creating DOCKER SERVICE#####################################################
export DOCKER_DAEMON_LOC=/etc/docker
export DOCKER_SERVICE=/usr/lib/systemd/system
export DOCKER_SERVICED=/etc/systemd/system/

#sudo mkdir /etc/systemd/system/docker.service.d
#cd $DOCKER_DAEMON_LOC
echo "creating DOCKER deamon.json file at /etc/docker"
