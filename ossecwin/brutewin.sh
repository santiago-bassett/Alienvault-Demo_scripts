#!/bin/bash
# Santiago Bassett <santiago.bassett@gmail.com>

line='AV - Alert - "1367083144" --> RID: "18106"; RL: "5"; RG: "windows,win_authentication_failed,"; RC: "Windows Logon Failure."; USER: "None"; SRCIP: "None"; HOSTNAME: "(windows70) 10.0.0.70->WinEvtLog"; LOCATION: "(windows70) 10.0.0.70->WinEvtLog"; EVENT: "[INIT]WinEvtLog: Security: AUDIT_FAILURE(4625): Microsoft-Windows-Security-Auditing: (no user): no domain: AMAZONA-D4ONP5E: An account failed to log on. Subject:  Security ID:  S-1-0-0  Account Name:  -  Account Domain:  -  Logon ID:  0x0  Logon Type:   3  Account For Which Logon Failed:  Security ID:  S-1-0-0  Account Name:  ADMINISTRATOR  Account Domain:  10.0.0.70  Failure Information:  Failure Reason:  %2313  Status:   0xc000006d  Sub Status:  0xc000006a  Process Information:  Caller Process ID: 0x0  Caller Process Name: -  Network Information:  Workstation Name: 10.0.0.70  Source Network Address: -  Source Port:  -  Detailed Authentication Information:  Logon Process:  NtLmSsp   Authentication Package: NTLM  Transited Services: -  Package Name (NTLM only): -  Key Length:  0  This event is generated when a logon request fails. It is generated on the computer where access was attempted.  [END]";' 


while true
do

  let "times = ($RANDOM % 30) + 10"

  for ((i = 0; i <= $times ; i++ ))
    do
      date=`date "+%s"`
      newline=`echo $line | sed -r "s/[0-9]{10}/$date/"`
      echo $newline >> /var/ossec/logs/alerts/alerts.log
      let "sleeptime = $RANDOM % 3"
      sleep $sleeptime
    done

  let "sleeptime = ($RANDOM * 1000) % 86400"
  sleep $sleeptime

done
