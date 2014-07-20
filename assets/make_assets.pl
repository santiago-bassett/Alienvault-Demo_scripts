#!/usr/bin/perl

my $num = 25;
my $start = 20;
my $range = '192.168.1.';
my @os_list = qw/Linux
Mac OS X
Unix
FreeBSD
ReactOS
Solaris
OpenBSD
AtheOS
Darwin
HP-UX
Windows XP
Windows Vista
Windows 2008
IOS/;

my @hostnames = qw/Axiom
Jarvis
Helios
Nexus
Orion
Skynet
Fusion
Phoenix
Glados
Paradox
Chromium
Cobalt
Copernicium
Copper
Curium
Darmstadtium
Dubnium
Dysprosium
Einsteinium
Erbium
Europium
Fermium
Flerovium
Fluorine
Francium
Gadolinium
Gallium
Germanium
Gold
Hafnium
Hassium
Helium
Holmium
Hydrogen
Indium
Iodine
Iridium
Iron
Krypton
Lanthanum
Lawrencium
Lead
Lithium
Livermorium
Lutetium
Magnesium
Manganese
Meitnerium
Mendelevium
Mercury
Molybdenum
Neodymium
Neon
Neptunium
Nickel
Niobium
Nitrogen
/;

my @usernames = qw/Administrator
admin
root
someuser
john
paul
ringo
mary
/;
#Support no user logged in...
push @usernames, '';

my @services = qw/http:80
https:443
dns:53
ssh:22
ntp:123
netbios:137
snmp:161
smtp:25
microsoft-ds:445
syslog:514
ldaps:636
imaps:993
/;


for (my $i = $start; $i < $num + $start; $i++) {
	my $service_string = "%s,0,%s,%s,SERVER,[%s:d],\n";
	my $mac = '';
	my $ip = $range . $i;
	$mac .= sprintf("%.2x:",rand(255)) for (1..5); 
	$mac .= sprintf("%.2x",rand(255));
	my $os = $os_list[rand @os_list];
	my $username = $usernames[rand @usernames];
	my $hostname = pop @hostnames;
	print "$ip;$hostname;$os;$mac;$username\n";
	for (1..rand(5)) {
		my ($proto, $port) = (split /:/, $services[rand @services])[0,1];
		printf ($service_string, $ip, $port, 6, $proto)
	}
}	


