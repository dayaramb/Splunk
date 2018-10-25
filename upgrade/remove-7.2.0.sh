#!/bin/bash
#change the parameter  tsidxWritingLevel = 1 to 2 in /opt/splunk/current/etc/system/default/indexs.conf

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
sudo -u splunk rm -rf /opt/splunk/7.2.0
"



remote_execute(){
	for hosts in `cat indexers.txt`
	do
		echo "Running the splunk installation in $hosts"
		ssh -t $USER@$hosts "$REMOTE_SCRIPT"
	done


}



#copy_install_file
remote_execute


