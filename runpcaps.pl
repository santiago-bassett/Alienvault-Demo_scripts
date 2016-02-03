#!/usr/bin/perl
use Cwd;
use File::Basename;

#Set stuff...
my $dir =  dirname(Cwd::realpath($0));
require "$dir/Daemon-Control-0.001006/blib/lib/Daemon/Control.pm";

exit Daemon::Control->new(
	name        => "Pcap Player",
	lsb_start   => '$syslog $remote_fs',
	lsb_stop    => '$syslog',
	lsb_sdesc   => 'Pcap Player',
	lsb_desc    => 'Sends pcaps',
        program	    => "$dir/pcaps/inject_pcaps.sh",
        pid_file    => '/tmp/pcaps.pid',
        stderr_file => '/tmp/pcaps.error.out',
        stdout_file => '/tmp/pcaps.stdout.out',
)->run;

print "Running From $dir Turning into a daemon...\n";

