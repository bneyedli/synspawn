#!/bin/bash

ARGS=$1
LCONF=/etc/synspawn.conf

if [ -z "$1" ]
then
	echo "No arguments given! Must supply at least one."
	echo "USAGE: $(basename $BASH_SOURCE) START | STOP"
	exit 67
fi


if [ "$ARGS" = "START" ] || [ "$ARGS" = "STOP" ]
then
	echo "Argument $ARGS OK!"
else
	echo "Bad Argument: $ARGS"
	exit 67 
fi



if [ -f $LCONF ]
then
	. $LCONF
else
	echo "Configuration not found, exiting..."
	exit 111
fi


function HostCheck {
	ping -q -c1 $SRV &> /dev/null
	if [ $? -eq 0 ]
	then
		echo "Host $SRV Alive!!!"
		$HSTATE='1'
	else
		echo "host $SRV dead."
		$HSTATE='0'
	fi
}

function WetWork {
	if [ $ROLE -eq 0 ]
	then
		skill -9 synergys
	else
		skill -9 synergyc
	fi
}

function ClientSpawn {
	ps auxwww|grep synergyc|grep -v grep
	if [ $? -eq 0 ]
	then
		WetWork
	fi

	/usr/bin/synergyc $OPTS $SRV
}
function ServerSpawn {
	ps auxwww|grep synergys|grep -v grep
	if [ $? -eq 0 ]
	then
		WetWork
	fi
	/usr/bin/synergys -a $LISTEN -c $SCONF
}

if [ "$ARGS" = "STOP" ]
then
	WetWork
fi

if [ "$ARGS" = "START" ]
then
	if [ $ROLE -eq 0 ]
	then
		ServerSpawn
	else
		ClientSpawn
	fi
fi
exit 0
