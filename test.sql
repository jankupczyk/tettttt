#!/usr/bin/perl
use strict;
use warnings;



open my $onstat, "-|", "/onstat -u"
    or die "ERROR:: Cannot execute onstat: $!\n";

my ($active, $total);

while (my $line = <$onstat>) {
    if ($line =~ /(\d+)\s+active,\s+(\d+)\s+total,\s+(\d+)\s+maximum concurrent/) {
        $active = $1;
        $total  = $2;
        last;
    }
}
close $onstat;

unless (defined $active && defined $total && $total > 0) {
    die "ERROR:: Cannot parse onstat -u output\n";
}

my $userthread_pool_utilization = ($active / $total) * 100;

printf "%.2f\n", $userthread_pool_utilization;
