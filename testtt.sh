#!/usr/bin/perl
$ENV{'TUXDIR'} = '/app/tuxedo';
$ENV{'TUXCONFIG'} = '/app/wpr/tuxedo/tuxconfig';
$ENV{'PATH'} = "$ENV{'TUXDIR'}/bin:$ENV{'PATH'}";
$ENV{'LD_LIBRARY_PATH'} = "$ENV{'TUXDIR'}/lib:$ENV{'LD_LIBRARY_PATH'}";

use warnings;
use strict;
use JSON;
use IPC::Open2;
use Tie::IxHash;

my $tmadmin = '/app/tuxedo22/tuxedo22.1.0.0.0/bin/tmadmin';
my $domain  = shift @ARGV || '';

my $pid = open2(my $out, my $in, "$tmadmin -r 2>/dev/null")
    or die "ERROR:: Cannot execute tmadmin: $!\n";

print $in "pd -d $domain\n";
close $in;

my %status;   # domainid => 1 (connected) / 0 (disconnected)
my $mode = '';

while (my $line = <$out>) {
    chomp $line;
    $line =~ s/^\s+|\s+$//g;
    next if $line eq '';

    if ($line =~ /^Connected domains:/i) {
        $mode = 'connected';
        next;
    }
    if ($line =~ /^Disconnected domains/i) {
        $mode = 'disconnected';
        next;
    }
    next unless $line =~ /^Domainid:\s*(\S+)/i;

    my $domid = $1;
    if ($mode eq 'connected') {
        $status{$domid} = 1;
    } elsif ($mode eq 'disconnected') {
        $status{$domid} = 0;
    }
}
close $out;
waitpid($pid, 0);

my @data;
foreach my $domid (sort keys %status) {
    tie my %ordered, 'Tie::IxHash';
    %ordered = (
        '{#DOMAINID}' => $domid,
        'DOMAINID'    => $domid,
        'STATUS'      => $status{$domid},
    );
    push @data, \%ordered;
}

my %json_out = ( data => \@data );

print to_json(\%json_out, { utf8 => 1, pretty => 0 }) . "\n";
