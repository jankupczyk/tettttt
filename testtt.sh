#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use IPC::Open2;



my $tmadmin = '/path/to/tmadmin';
my $debug   = 0;

my $pid = open2(my $out, my $in, "$tmadmin -r 2>/dev/null")
    or die "Nie mogę uruchomić tmadmin: $!";

print $in "pq\n";
close $in;

my %queues;
while (my $line = <$out>) {
    chomp $line;
    $line =~ s/^\s+|\s+$//g;
    next if $line eq '' or $line =~ /^Prog|^-{3,}/i;

    my @cols = split(/\s+/, $line);
    next unless scalar @cols >= 5;

    my ($prog, $queued) = ($cols[0], $cols[4]);
    $queued = 0 if ($queued !~ /^\d+$/);

    $queues{$prog} += $queued;
    print "[DEBUG] $prog -> $queued\n" if $debug;
}
close $out;

my @data;
foreach my $prog (sort keys %queues) {
    push @data, {
        '{#PROGNAME}' => $prog,
        '{#QUEUED}'   => $queues{$prog},
    };
}

my $json = JSON->new->utf8->pretty(1)->canonical(1);
my $output = $json->encode({ data => \@data });

print $output;

exit 0;
