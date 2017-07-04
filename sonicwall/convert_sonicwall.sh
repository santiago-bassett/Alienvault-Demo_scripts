#!/bin/bash
# Script to change date on sonicwall logs to today, in preparation for using them in 
#Santiago Bassett's Alienvault demo scripts   
#Kevin Geil <info@friendandfamilytech.com>

mkdir -p /var/log/demologs
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
echo `date`

while read line           
  do           
    date=`date "+%F"`;
    newline=`echo $line | sed "s/time=\"[0-9]\{4\}-[0-9][0-9]-[0-9][0-9]/time=\"$date/" >>/var/log/demologs/sonicwall.log`;
    done < $SCRIPTPATH/sonicwall.log 
