#!/bin/bash
USER=db3700817
STR="[replication_port://9887]\n[clustering]\nmaster_uri = https://c0010407.test.cloud.fedex.com:8089\nmode = slave\npass4SymmKey = dayafedex\n"
SPLUNK_HOME="/opt/splunk/current"

REMOTE_SCRIPT="
 echo -e '[replication_port://9887]\n[clustering]\nmaster_uri = https://c0010407.test.cloud.fedex.com:8089\nmode = slave\npass4SymmKey = dayafedex\n' |sudo -u splunk tee -a $SPLUNK_HOME/etc/system/local/server.conf
sudo -u splunk /opt/splunk/current/bin/splunk restart
"
for host in `cat indexers`
do
	ssh -t $USER@$host "$REMOTE_SCRIPT"
done

echo -e "$STR"
