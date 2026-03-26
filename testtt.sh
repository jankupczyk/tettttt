#!/usr/bin/perl

use strict;
use warnings;

my $onstat = `onstat -u`;

my ($total);
if ($onstat =~ /\d+\s+active,\s+(\d+)\s+total/) {
    $total = $1;
} else {
    die "Cannot parse total connections";
}

my $cfg = `onstat -g cfg | grep USERTHREADS`;

$cfg =~ /USERTHREADS\s+(\d+)/;
my $max = $1;

if (!$max) {
    die "Cannot read USERTHREADS";
}

my $usage = ($total / $max) * 100;

printf "%.2f\n", $usage;
