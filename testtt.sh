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


$.data[?(@["{#PROGNAME}"]=="{#PROGNAME}")].QUEUED.first()

$.data[?(@["{#PROGNAME}"]=="{#PROGNAME}")].QUEUED.first() || 0


var obj = JSON.parse(value);
var prog = "{#PROGNAME}";
for (var i=0; i<obj.data.length; i++) {
  if (obj.data[i]["{#PROGNAME}"] === prog) {
    return obj.data[i].QUEUED;
  }
}
return null;




var obj = JSON.parse(value);
var prog = "{#PROGNAME}";
var found = [];
for (var i = 0; i < obj.data.length; i++) {
    found.push(obj.data[i]["{#PROGNAME}"]);
    if (obj.data[i]["{#PROGNAME}"] === prog) {
        return obj.data[i].QUEUED;
    }
}
return "Szukano " + prog + ", znaleziono: " + found.join(",");







var obj = JSON.parse(value);
var prog = "{#PROGNAME}";
var output = [];
for (var i = 0; i < obj.data.length; i++) {
    for (var key in obj.data[i]) {
        output.push(JSON.stringify(key) + " = " + JSON.stringify(obj.data[i][key]));
    }
}
return output.join("\n");


