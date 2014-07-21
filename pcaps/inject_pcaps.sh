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
		tcpreplay -i dummy0 --pps=3 $pcap
	done
done
