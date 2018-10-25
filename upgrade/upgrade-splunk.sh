#!/bin/bash

#RUN THIS ONLY ON INDEXERS, PLEASE MAINTAIN A LIST OF INDEXERS IN indexers.txt FILE 

# BASED ON ROLLING UPGRADES

#PLEASE RUN THE COMMAND 
INSTALL_FILE="splunk-7.2.0-8c86330ac18-Linux-x86_64.tgz"
SPLUNK_HOME="/opt/splunk/7.2.0/splunk"
USER=db3700817
CRON_FILE="mycron.txt"
copy_install_file(){
	for hosts in `cat indexers.txt`
	do
		echo "copying the $INSTALL_FILE to $hosts"
		scp $INSTALL_FILE $USER@$hosts:
		scp $CRON_FILE $USER@$hosts:
	done
}


REMOTE_SCRIPT=" 
sudo -u mkdir /opt/splunk/7.2.0
sudo -u splunk cp -rp /opt/splunk/7.1.2/*  /opt/splunk/7.2.0

sudo -u splunk mv /home/$USER/$INSTALL_FILE /opt/splunk/

sudo -u splunk cd /opt/splunk/current/bin
sudo -u splunk ./splunk offline

sudo -u splunk crontab -r 
sudo tar -zxf $INSTALL_FILE -C /opt/splunk/7.2.0

sudo -u splunk cd /opt/splunk 
sudo -u splunk rm current
sudo -u splunk ln -s 7.2.0/splunk current
sudo -u splunk cd  /opt/splunk/7.2.0/splunk/bin


sudo -u splunk crontab /home/$USER/$CRON_FILE
"



remote_execute(){
	for hosts in `cat forwarders.txt`
	do
		echo "Running the splunk installation in $hosts"
		ssh -t $USER@$hosts "$REMOTE_SCRIPT"
	done


}



copy_install_file
remote_execute


