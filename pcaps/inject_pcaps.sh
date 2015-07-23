#!/bin/bash
# JS

#Just in case....
modprobe dummy
ifconfig dummy0 up
ifconfig dummy0 promisc

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
cd $SCRIPTPATH
while true
do
	for pcap in `ls *.pcap`
	do
		tcpreplay-edit -N '10.0.0.0/8:192.168.100.76/30,192.168.0.0/16:192.168.100.74/28' -i dummy0 --pps=10 $pcap
	done
	sleep 1200
done
