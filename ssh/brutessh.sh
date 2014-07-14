#!/bin/bash
# Santiago Bassett <santiago.bassett@gmail.com>

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

while true
do

  attacker_ip=`shuf -n 1 $SCRIPTPATH/attackers.txt`
  target_ip=`shuf -n 1 $SCRIPTPATH/targets.txt`

  grep $attacker_ip $SCRIPTPATH/sshd.log > $SCRIPTPATH/tmp.log
  sed -e "s/alien12/$target_ip/" -i $SCRIPTPATH/tmp.log

  while read line
  do
    logger "$line"
    let "divisor = ($RANDOM % 5) + 1" 
    sleeptime=`echo "scale = 2; 1 / $divisor" | bc`
    sleep $sleeptime
  done < $SCRIPTPATH/tmp.log
    
  let "sleeptime = ($RANDOM * 1000) % 86400"  
  sleep $sleeptime;

done
