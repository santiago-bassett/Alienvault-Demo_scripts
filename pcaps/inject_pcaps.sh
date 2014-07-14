#!/bin/bash
# Santiago Bassett <santiago.bassett@gmail.com>

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

while true
do
	find $SCRIPTPATH -maxdepth 3 | grep .pcap$ | xargs tcpreplay -i dummy0 --pps=3 >/dev/null 2>&1
done
