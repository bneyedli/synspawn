#!/bin/bash
. /etc/synspawn.conf
ping -q -c1 $SRV &> /dev/null

if [ $? -eq 0 ]
then 
	echo "Host alive, spawning synergy client..."
	if [ $ROLE -eq 0 ]
	then
		skill -9 synergys
		synergys -a $LISTEN -c $CONF
	else
		skill -9 synergyc
		/usr/bin/synergyc $OPTS $SRV
	fi
else 
	echo "host dead"
fi
