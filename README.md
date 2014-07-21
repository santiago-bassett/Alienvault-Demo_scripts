#Sripts to inject demo data and traffic

This will make AV do demo stuff
- Author: PacketInspector


Forked from Santiago Bassett ([@santiagobassett](https://twitter.com/santiagobassett))

To install:

```
git clone [url]
cd 
perl install.pl
```

The script will do all the work. Nothing to do beforehand.

Need to start over?

```
alienvault-reconfig -c -d -v --rebuild_db;sleep 15;perl install.pl
```
