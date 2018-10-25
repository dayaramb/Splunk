#!/bin/bash
#MAKE A BACKUP COPY OF INDEXERS RUNNING  VERSION 7.1.2 TO 7.2.0
#RUN THIS ONLY ON INDEXERS, PLEASE MAINTAIN A LIST OF INDEXERS IN indexers.txt FILE 

SPLUNK_HOME="/opt/splunk/7.2.0/splunk"

#CHANGE THE USER NAME TO YOUR UID
USER=db3700817

REMOTE_SCRIPT=" 
cd /opt/splunk/current/bin
sudo -u splunk ./splunk stop

sudo -u splunk rm -rf /opt/splunk/7.2.0
sudo -u splunk  mkdir /opt/splunk/7.2.0
sudo -u splunk cp -rp /opt/splunk/7.1.2/*  /opt/splunk/7.2.0

sudo -u splunk crontab -r 
cd /opt/splunk 

sudo -u splunk rm current
sudo -u splunk ln -s 7.2.0/splunk current

cd  /opt/splunk/7.2.0/splunk/bin
sudo -u splunk ./splunk start --accept-license --answer-yes --no-prompt  > /dev/null 2>&1
"
remote_execute(){
	for hosts in `cat indexers.txt`
	do
		echo "Running the backup  in $hosts"
		ssh -t $USER@$hosts "$REMOTE_SCRIPT"
	done


}


remote_execute


