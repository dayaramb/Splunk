#!/bin/bash

#Automate the installation of Splunk with general user splunk and configure cronjob to start automatically when reboot, change to the slave license connecting to the master. 
#/splunk hash-passwd Fedex123#

#$6$GMjAMB8TnMv7DUk0$GJh6Hmk7wwQuhPHRWhme77j6.agkSg5.tfnl4m5bDLIggwiJnxOQdo/TgfwtW50DIHisqryeXPQ3H/ofpfuGQ/

# THESE ITEMS NOT RUNNING: Need to check 
#sudo -u splunk ./splunk enable boot-start -user splunk

#sudo -u splunk ./splunk edit licenser-localslave -master-uri 'https://vrh04032.ute.fedex.com:8089'
INSTALL_FILE="splunk-7.1.3-51d9cac7b837-Linux-x86_64.tgz"
SPLUNK_HOME="/opt/splunk/7.1.3/splunk"
USER=db3700817
PASSWD_FILE="user-seed.conf"
CRON_FILE="mycron.txt"
LICENSE_FILE="lic.txt"
copy_install_file(){
	for hosts in `cat hosts.txt`
	do
		echo "copying the $INSTALL_FILE to $hosts"
		scp $INSTALL_FILE $USER@$hosts:
		scp $PASSWD_FILE $USER@$hosts:
		scp $CRON_FILE $USER@$hosts:
		scp $LICENSE_FILE $USER@$hosts:
	done
}


REMOTE_SCRIPT=" 
sudo mkdir -p /opt/splunk/7.1.3

sudo mv /home/$USER/$INSTALL_FILE /opt/splunk/7.1.3
cd /opt/splunk/7.1.3
sudo tar -zxf $INSTALL_FILE
getent passwd $1 > /dev/null 2>&1 
if [ $? -eq 0 ]
then
	echo 'splunk user already exits'

else
	echo 'Creating user splunk'
	sudo useradd -m -r splunk

fi
sudo chown -R splunk.splunk /opt/splunk

cd /opt/splunk
sudo -u splunk ln -s 7.1.3/splunk current
cd  /opt/splunk/7.1.3/splunk/bin

sudo -u splunk ./splunk start --accept-license --answer-yes --no-prompt  > /dev/null 2>&1

sudo -u splunk cp /home/$USER/$PASSWD_FILE $SPLUNK_HOME/etc/system/local/user-seed.conf

sudo -u splunk bash -c 'cat /home/$USER/$LICENSE_FILE  >> /opt/splunk/7.1.3/splunk/etc/system/local/server.conf'

sudo -u splunk ./splunk restart
sudo -u splunk crontab /home/$USER/$CRON_FILE
"



remote_execute(){
	for hosts in `cat hosts.txt`
	do
		echo "Running the splunk installation in $hosts"
		ssh -t $USER@$hosts "$REMOTE_SCRIPT"
	done


}



copy_install_file
remote_execute


