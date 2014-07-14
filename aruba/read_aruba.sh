#!/bin/bash
# Santiago Bassett <santiago.bassett@gmail.com>

RANGE=600
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

while true
do
  while read line           
  do           
    number=$RANDOM;
    let "number %= $RANGE";
    sleep $number;
    logger "$line";
  done < $SCRIPTPATH/aruba.log
done
