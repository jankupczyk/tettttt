#!/usr/bin/perl

use strict;
use warnings;

my $onstat = `onstat -u`;

my ($active, $total);

if ($onstat =~ /(\d+)\s+active,\s+(\d+)\s+total/) {
    ($active, $total) = ($1, $2);
} else {
    die "Cannot parse onstat -u output";
}

if ($total == 0) {
    die "Total is zero";
}

my $usage = ($active / $total) * 100;

printf "%.2f\n", $usage;
