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

#Set stuff...
my $dir =  dirname(Cwd::realpath($0));
require "$dir/Daemon-Control-0.001006/blib/lib/Daemon/Control.pm";

=begin comment
exit Daemon::Control->new(
	name        => "Logger Generator",
	lsb_start   => '$syslog $remote_fs',
	lsb_stop    => '$syslog',
	lsb_sdesc   => 'Logger Generator',
	lsb_desc    => 'Sends Logs',
        program	    => 'sub()',
        pid_file    => '/tmp/logger.pid',
        stderr_file => '/tmp/logger.error.out',
        stdout_file => '/tmp/logger.stdout.out',
)->run;
=cut


#Pcaps

my $plugin_dir = "$dir/plugins";
opendir(DIR, $plugin_dir) or die $!;

my @logs = grep { /\.log$/ && -f "$plugin_dir/$_" } readdir(DIR);
closedir(DIR);

#random IP
#$rip = join ".", map int rand 255, 1 .. 4;
my $otx_grab = `shuf -n10 /etc/ossim/server/reputation.data | awk -F# '{print $1}'`;
my @otx = split(/\n/, $otx_grab);
my %clean_logs;

load_logs();
print Dumper(%clean_logs);

sub load_logs {
	foreach my $log (@logs) {
		#Get basename
		my ($base) = (split /\./, $log)[0];
		$data = `head -50 $plugin_dir/$log`;
		@lines = split(/\n/, $data);
		foreach (@lines) {
			next if /^#/;
			chomp;
			#strip syslog header out....
			#Some have year...
			s/^\w{3}\s{1,2}\d{1,2}\s\d{2}\:\d{2}\:\d{2}\s+\d{4}\s+\S+\s+//;
			#Some don't....
			s/^\w{3}\s{1,2}\d{1,2}\s\d{2}\:\d{2}\:\d{2}\s+\S+\s+//;
			#send_message($base,$_);
			push(@{$clean_logs{$base}}, $_);
		}
	}
}
sub send_message {
	my($name, $log) = @_;	
	openlog($name, '', 'lpr');    # don't forget this
	syslog("debug", $log);
	closelog();
}

