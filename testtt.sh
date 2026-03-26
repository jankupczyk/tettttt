#!/usr/bin/perl

use strict;
use warnings;

open my $onstat, "-|", "$ENV{INFORMIXDIR}/bin/onstat -u"
    or die "Cannot run onstat";

my ($active, $total);

while (my $line = <$onstat>) {
    if ($line =~ /(\d+)\D+(\d+)\D+(\d+)/) {

        my ($a, $t, $m) = ($1, $2, $3);
        next if $a > $t;          # active nie może być > total
        next if $t == 0;          # total musi mieć sens
        next if $m < $a;          # max >= active

        $active = $a;
        $total  = $t;
        last;
    }
}

close $onstat;

unless (defined $active && defined $total && $total > 0) {
    die "Cannot parse onstat -u output";
}

my $usage = ($active / $total) * 100;

printf "%.2f\n", $usage;
