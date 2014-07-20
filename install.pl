#!/usr/bin/perl
use Term::ANSIColor qw(:constants);

#Installer
#  Add plugins and logs for plugins to ./plugins  They must all have the same basename!!!!
#  Add Pcaps to ./pcaps
#  Asset stuff in ./assets/
#
# 
# This script can be run over and over


my $plugin_dir = './plugins';
opendir(DIR, $plugin_dir) or die $!;

my @plugins = grep { /\.cfg$/ && -f "$plugin_dir/$_" } readdir(DIR);
closedir(DIR);

#Save names for ossim_setup
my @plugin_names;


print "Installing plugins for Demo use...........................\n";
foreach my $plugin (@plugins) {
	#Get basename
	my ($base) = (split /\./, $plugin)[0];
	print "Found ", GREEN, "$base", RESET, ".  Installing...\n";
	#I want to overwrite, so not checking for existance...
	print "Copying...";
	`cp $plugin_dir/$plugin /etc/ossim/agent/plugins/`;
	my $local = "[config]\nlocation=/var/log/demologs/$base.log\n";
	print "Adding Local Config...";
	`echo "$local" > /etc/ossim/agent/plugins/$plugin.local`;
	if (-e "$plugin_dir/$base.sql") {
		print YELLOW, "Found SQL...Adding..", RESET;
		`cat $plugin_dir/$base.sql | ossim-db`;
		print "Added.";
	}
	push @plugin_names, $base;
	print "Done\n";
}

print "Bringing Up Dummy Network...\n";
`modprobe dummy`;
`ifconfig dummy0 up`;
`ifconfig dummy0 promisc`;
print "Done\n";

print YELLOW, "Adding Rsyslog config...", RESET;
`cp ./misc/aa-demo.conf /etc/rsyslog.d/`;
print "Done\n";

print CYAN, "Adding logrotate file...", RESET;
`cp ./misc/logrotate /etc/logrotate.d/demologs`;
print "Done\n";

if (-e "/etc/ossim/ossim_setup.conf.demo") {
	print CYAN, "Backup file already exists.\n", RESET;
} else {
	`cp /etc/ossim/ossim_setup.conf /etc/ossim/ossim_setup.conf.demo`;
	print GREEN, "Created Backup File of ossim_setup.\n", RESET;
}


my $detectors = `grep detectors= /etc/ossim/ossim_setup.conf`;
my ($d) = (split /=/, $detectors)[1];
chomp($d);
my @d2 = split /\,\s/, $d;
my %dupecheck;
my @d3 = grep( !$dupecheck{$_}++, @d2, @plugin_names);
my $to_insert = join(', ', @d3);
print "Adding detectors... $to_insert ....\n";
`sed -i -e 's/detectors=.*/detectors=$to_insert/' /etc/ossim/ossim_setup.conf`;

#Adding Dummy Interface..
my $interfaces = `grep interfaces= /etc/ossim/ossim_setup.conf`;
my ($i) = (split /=/, $interfaces)[1];
chomp($i);
my @i2 = split /\,\s*/, $i;
my %dupecheck2;
my @interface_name = ('dummy0');
my @i3 = grep( !$dupecheck2{$_}++, @i2, @interface_name);
$to_insert = join(',', @i3);
print "Adding dummy interface... $to_insert ....\n";
`sed -i -e 's/interfaces=.*/interfaces=$to_insert/' /etc/ossim/ossim_setup.conf`;

print "Adding Modified ossec.conf....";
`cp ./ossecwin/ossec.conf /var/ossec/etc/`;
print "Done\n";

print "Adding prads local...";
#`cp ./misc/prads_dummy0.cfg.local /etc/ossim/agent/plugins/`;
print "Done\n";

print "Finished updating ", CYAN, "ossim_setup", RESET, ".  Running re-config...\n";


	



