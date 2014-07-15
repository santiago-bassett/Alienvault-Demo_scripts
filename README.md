#Sripts to inject demo data and traffic
By Santiago Bassett ([@santiagobassett](https://twitter.com/santiagobassett))

Steps to enable a dummy network interface:
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
- Download github repo
- Run script rundemo.sh
