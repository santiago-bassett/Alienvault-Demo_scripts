#!/bin/bash
# Santiago Bassett <santiago.bassett@gmail.com>

#Add to /etc/logrotate.d/rsyslog
#/var/log/aruba.log
#/var/log/clamav.log
#/var/log/cisco.log
#/var/log/cisco-asa.log
#/var/log/oracle.log

#add plugins to ossim_setup and run ossim-reconfig

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

#Adding necessary files to /etc/rsyslog.d/
echo "adding files to /etc/rsyslog.d/"
cp $SCRIPTPATH/aruba/aruba.conf /etc/rsyslog.d/
cp $SCRIPTPATH/cisco/cisco-asa.conf /etc/rsyslog.d/
cp $SCRIPTPATH/cisco/worm/cisco-pix.conf /etc/rsyslog.d/
cp $SCRIPTPATH/clamav/clamav.conf /etc/rsyslog.d/
cp $SCRIPTPATH/oracle/oracle-syslog.conf /etc/rsyslog.d/
cp $SCRIPTPATH/ssh/sshlogs.conf /etc/rsyslog.d/
cp $SCRIPTPATH/sonicwall/sonicwall.conf /etc/rsyslog.d/
/etc/init.d/rsyslog restart
echo "finished adding files to /etc/rsyslog.d/"

#Adding modified plugins to /etc/ossim/agent/plugins/
echo "adding modified plugins to /etc/ossim/agent/plugins"
cp $SCRIPTPATH/aruba/aruba.cfg.local /etc/ossim/agent/plugins/
cp $SCRIPTPATH/cisco/cisco-asa.cfg.local /etc/ossim/agent/plugins/
cp $SCRIPTPATH/cisco/worm/cisco-pix.cfg.local /etc/ossim/agent/plugins/
cp $SCRIPTPATH/clamav/clamav.cfg.local /etc/ossim/agent/plugins/
cp $SCRIPTPATH/oracle/oracle-syslog.cfg.local /etc/ossim/agent/plugins/
cp $SCRIPTPATH/ossecwin/ossec-single-line.cfg.local /etc/ossim/agent/plugins/
echo "finished adding modified plugins to /etc/ossim/agent/plugins"

#Adding modified .sql files to the database
echo "inserting modified sql files into database"
cat $SCRIPTPATH/oracle/oracle-syslog.sql | ossim-db
cat $SCRIPTPATH/aruba/aruba.sql | ossim-db
cat $SCRIPTPATH/sonicwall/sonicwall.sql | ossim-db
cat $SCRIPTPATH/clamav/clamav.sql | ossim-db
/etc/init.d/ossim-server restart
echo "finished inserting modified sql file into database"

#Adding modified ossec.conf file to ossec configuration
echo "adding modified ossec.conf file to /var/ossec/etc/"
cp $SCRIPTPATH/ossecwin/ossec.conf /var/ossec/etc/
/etc/init.d/ossec restart
echo "finished adding modified ossec.conf file to /var/ossec/etc/"

#Running scripts in background
echo "running scripts in background"
nohup $SCRIPTPATH/cisco/read_logs.sh & 2>&1
nohup $SCRIPTPATH/cisco/worm/worm.sh & 2>&1
nohup $SCRIPTPATH/pcaps/inject_pcaps.sh & 2>&1
nohup $SCRIPTPATH/ossecwin/brutewin.sh & 2>&1
nohup $SCRIPTPATH/ssh/brutessh.sh & 2>&1
nohup $SCRIPTPATH/oracle/read_oracle.sh & 2>&1
nohup $SCRIPTPATH/aruba/read_aruba.sh & 2>&1
nohup $SCRIPTPATH/clamav/read_clamav.sh & 2>&1
nohup $SCRIPTPATH/sonicwall/read_sonicwall.sh & 2>&1
echo "finished running scripts in background"
