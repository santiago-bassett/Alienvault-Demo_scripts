#!/bin/bash
# Santiago Bassett <santiago.bassett@gmail.com>

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

while true
do

  while read line
  do
    logger "$line"
    let "divisor = ($RANDOM % 5) + 1" 
    sleeptime=`echo "scale = 2; 1 / $divisor" | bc`
    sleep $sleeptime
  done < $SCRIPTPATH/worm.log

  let "sleeptime = ($RANDOM * 1000) % 86400"
  sleep $sleeptime

done
