#!/usr/bin/perl
use strict;
use warnings;
use JSON;

my $json_file = '/app/wpr/skrypty/tuxedo_queue.json';

open my $fh, '<', $json_file or die "Nie mogę otworzyć pliku $json_file: $!";
local $/;
my $json_text = <$fh>;
close $fh;

my $data = decode_json($json_text);

foreach my $item (@{$data->{data}}) {
    my $prog   = $item->{"{#PROGNAME}"} // 'UNKNOWN';
    my $queued = $item->{QUEUED} // 0;

    print "tux.queue.value[$prog] $queued\n";
}
