#!/bin/bash
USER=db3700817
STR="
[replication_port://9887]\n

[clustering]\n
master_uri = https://c0010407.test.cloud.fedex.com:8089\n
mode = slave\n
pass4SymmKey = dayafedex\n
"
REMOTE_SCRIPT="
sudo -u splunk sh -c  'echo -e $STR >> /tmp/server.conf'
"

for host in `cat indexers`
do
	ssh -l -n $USER@$host $REMOTE_SCRIPT
done

