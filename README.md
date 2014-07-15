#Sripts to inject demo data and traffic
By Santiago Bassett ([@santiagobassett](https://twitter.com/santiagobassett))

Steps to enable dummy0 network interface:
```
insmod dummy
ifconifg dummy0 up
ifconfig dummy0 promisc
```

Plugins that need to be enabled:
- aruba
- cisco-asa
- cisco-pix
- clamav
- oracle-syslog
- ossec-single-line
- snortunified (listening in dummy0)
- sonicwall
- ssh

Injecting demo data:
```
git clone https://github.com/santiago-bassett/Alienvault-Demo_scripts
cd Alienvault-Demo_scripts
nohup ./rundemo.sh & 2>&1 
```
