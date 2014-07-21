#!/usr/bin/perl

use Sys::Syslog;                        # all except setlogsock()
use Sys::Syslog qw(:standard :macros);  # standard functions & macros


#Send Logs
#
#Logs should just be copied from rsyslog files, no parsing necessary
#
#Pcaps

my $plugin_dir = './plugins';
opendir(DIR, $plugin_dir) or die $!;

my @logs = grep { /\.log$/ && -f "$plugin_dir/$_" } readdir(DIR);
closedir(DIR);


foreach my $log (@logs) {
	#Get basename
	my ($base) = (split /\./, $log)[0];
	$data = `head -50 $plugin_dir/$log`;
	@lines = split(/\n/, $data);
	foreach (@lines) {
		#strip syslog header out....
		chomp;
		#Some have year...
		s/^\w{3}\s{1,2}\d{1,2}\s\d{2}\:\d{2}\:\d{2}\s+\d{4}\s+\S+\s+//;
		#Some don't....
		s/^\w{3}\s{1,2}\d{1,2}\s\d{2}\:\d{2}\:\d{2}\s+\S+\s+//;
		send_message($base,$_);
	}
	
	#Mar 11 08:23:34 2014 aruba1.demo
	#We want the raw message, we'll add the rest
	
}

sub send_message {
	my($name, $log) = @_;	
	openlog($name, '', 'lpr');    # don't forget this
	syslog("debug", $log);
	closelog();
}

