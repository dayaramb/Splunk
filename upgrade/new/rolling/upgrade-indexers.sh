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
		scp $INSTALL_FILE $USER@$hosts:/tmp
		scp $CRON_FILE $USER@$hosts:/tmp
	done
}


REMOTE_SCRIPT=" 
cd /opt/splunk/current/bin
sudo -u splunk crontab -r 


cd  /opt/splunk/7.2.0/splunk/bin
sudo -u splunk ./splunk offline -auth admin:Fedex123#

sudo -u splunk tar -zxf /tmp/$INSTALL_FILE -C /opt/splunk/7.2.0
cd  /opt/splunk/7.2.0/splunk/bin
sudo -u splunk ./splunk start -auth admin:Fedex123# --accept-license --answer-yes --no-prompt  > /dev/null 2>&1
sudo -u splunk crontab /tmp/$CRON_FILE
"



remote_execute(){
	for hosts in `cat indexers.txt`
	do
		echo "Running the splunk installation in $hosts"
		ssh -t $USER@$hosts "$REMOTE_SCRIPT"
	done


}



copy_install_file
remote_execute


