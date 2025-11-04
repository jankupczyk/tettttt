#!/bin/bash

export TUXDIR=/app/tuxedo
export TUXCONFIG=/app/wpr/tuxedo/tuxconfig
export PATH=$TUXDIR/bin:$PATH
export LD_LIBRARY_PATH=$TUXDIR/lib:$LD_LIBRARY_PATH

exec /usr/bin/perl /usr/local/zabbix/scripts/tuxedo_lld.pl
$ENV{'TUXDIR'} = '/app/tuxedo';
$ENV{'TUXCONFIG'} = '/app/wpr/tuxedo/tuxconfig';
$ENV{'PATH'} = "$ENV{'TUXDIR'}/bin:$ENV{'PATH'}";
$ENV{'LD_LIBRARY_PATH'} = "$ENV{'TUXDIR'}/lib:$ENV{'LD_LIBRARY_PATH'}";






my $env_file = '/app/tuxedo/tux.env';
my $tmadmin  = '/app/tuxedo/bin/tmadmin';
my $debug    = 0;


if (-f $env_file) {
    open my $fh, '<', $env_file or die "Nie mogę otworzyć $env_file: $!";
    while (my $line = <$fh>) {
        next if $line =~ /^\s*#/;
        next unless $line =~ /=/;
        $line =~ s/;\s*export.*$//;
        $line =~ s/export\s+//;
        chomp $line;

        if ($line =~ /^(\w+)=(.*)$/) {
            my ($key, $val) = ($1, $2);
            $val =~ s/^"|"$//g;
            $ENV{$key} = $val;
            print "[DEBUG] ENV $key=$val\n" if $debug;
        }
    }
    close $fh;
} else {
    die "Brak pliku środowiska: $env_file\n";
}
