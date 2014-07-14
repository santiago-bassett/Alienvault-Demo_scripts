#!/bin/bash
# Santiago Bassett <santiago.bassett@gmail.com>

RANGE=40
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

while true
do
  while read line           
  do           
    number=$RANDOM;
    let "number %= $RANGE";
    sleep $number;
    date=`date "+%F %T"`;
    newline=`echo $line | sed -r "s/time=\".*[0-9]\"/time=\"$date\"/"`;
    logger "$newline";
  done < $SCRIPTPATH/sonicwall.log
done
