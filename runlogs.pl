#!/usr/bin/perl

#Send Logs
#
#Logs should just be copied from rsyslog files, no parsing necessary
# Your log sample can have:
# <RANDIP> - will be replaced with random IP
# <OTXIP> - will be replaced with random OTX member

use Sys::Syslog;                        # all except setlogsock()
use Sys::Syslog qw(:standard :macros);  # standard functions & macros
use Cwd;
use File::Basename;
use Data::Dumper;
use Time::HiRes qw(usleep nanosleep);

#Set stuff...
my $dir =  dirname(Cwd::realpath($0));
require "$dir/Daemon-Control-0.001006/blib/lib/Daemon/Control.pm";


exit Daemon::Control->new(
	name        => "Logger Generator",
	lsb_start   => '$syslog $remote_fs',
	lsb_stop    => '$syslog',
	lsb_sdesc   => 'Logger Generator',
	lsb_desc    => 'Sends Logs',
        program	    => sub { goforever(); },
        pid_file    => '/tmp/logger.pid',
        stderr_file => '/tmp/logger.error.out',
        stdout_file => '/tmp/logger.stdout.out',
)->run;



my $otx_grab = `shuf -n100 /etc/ossim/server/reputation.data | awk -F\# '{print \$1}'`;
my @otx = split(/\n/, $otx_grab);

#goforever();

#The hash will be used soon for new feature, right now it is overhead...
sub goforever () {
	my %clean_logs = load_logs();
	while (1) {
		send_logs(%clean_logs);
		print "Logs sent. Sleeping...\n";
		sleep(300);
	}
}

sub send_logs {
	my %hash = @_;
	#print Dumper(%hash);
	foreach my $logname (keys %hash) {
		#print $logname;
		foreach(@{$hash{$logname}}) {
			send_message($logname,$_);
			usleep(200000);
		}
	}
}	

sub load_logs {
	my $plugin_dir = "$dir/plugins";
	opendir(DIR, $plugin_dir) or die $!;
	my @logs = grep { /\.log$/ && -f "$plugin_dir/$_" } readdir(DIR);
	closedir(DIR);
	my %clean_logs;
	foreach my $log (@logs) {
		#Get basename
		my ($base) = (split /\./, $log)[0];
		$data = `head -75 $plugin_dir/$log`;
		@lines = split(/\n/, $data);
		foreach (@lines) {
			next if /^#/;
			chomp;
			#strip syslog header out....
			#Some have year...
			s/^\w{3}\s{1,2}\d{1,2}\s\d{2}\:\d{2}\:\d{2}\s+\d{4}\s+\S+\s+//;
			#Some don't....
			s/^\w{3}\s{1,2}\d{1,2}\s\d{2}\:\d{2}\:\d{2}\s+\S+\s+//;
			#remove prevaling spaces
			s/^\s+//;
			#send_message($base,$_);
			#usleep(200000);
			push(@{$clean_logs{$base}}, $_);
		}
	}
	return %clean_logs;
}
sub send_message {
	#send log message, changing IPs if needed....
	my($name, $log) = @_;
	my $rip = join ".", map int rand 255, 1 .. 4;
	my $otx_ip = $otx[rand @otx];
	$log =~ s/<RANDIP>/$rip/g;
	$log =~ s/<OTXIP>/$otx_ip/g;	
	openlog($name, '', 'lpr');    # don't forget this
	syslog("debug", $log);
	closelog();
}

