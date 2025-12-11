#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use POSIX qw(mktime);

my ($directory, $period, $since, $until, $listfile, $output);
GetOptions(
    "dir=s"    => \$directory,
    "period=i" => \$period,
    "since=s"  => \$since,
    "until=s"  => \$until,
    "list=s"   => \$listfile,
    "out=s"    => \$output,
);

unless ($output) {
    die "Brak parametru --out <plik_wyjściowy>\n";
}

my @zip_list;

if ($listfile) {
    open(my $LF, "<", $listfile) or die "Nie mogę otworzyć listy ZIP-ów: $listfile: $!\n";
    while (<$LF>) {
        chomp;
        next unless /\S/;
        my $zip = $_;
        if (-f $zip) {
            push @zip_list, $zip;
        } else {
            warn "Plik nie istnieje albo nie jest plikiem: $zip — pomijam\n";
        }
    }
    close($LF);
}
else {
    unless ($directory && ($period || $since)) {
        die "Jeśli nie podajesz --list, musisz podać --dir i (--period lub --since)\n";
    }

    my $time_from;
    my $time_to = time();

    if ($period) {
        $time_from = time() - ($period * 60);
    } else {
        $since =~ s/[-: ]/ /g;
        my @t = split /\s+/, $since;
        $time_from = mktime(0, $t[4], $t[3], $t[2], $t[1]-1, $t[0]-1900);
    }

    if ($until) {
        $until =~ s/[-: ]/ /g;
        my @t2 = split /\s+/, $until;
        $time_to = mktime(0, $t2[4], $t2[3], $t2[2], $t2[1]-1, $t2[0]-1900);
    }

    opendir(my $DIR, $directory) or die "Nie mogę otworzyć katalogu: $directory: $!\n";
    while (my $f = readdir($DIR)) {
        next unless $f =~ /\.zip$/i;
        my $full = "$directory/$f";
        next unless -f $full;
        my $mtime = (stat($full))[9];
        next if $mtime < $time_from || $mtime > $time_to;
        push @zip_list, $full;
    }
    closedir($DIR);
}

if (!@zip_list) {
    die "Nie znaleziono ZIP-ów do przetworzenia.\n";
}

open(my $OUT, ">", $output) or die "Nie mogę otworzyć pliku wyjściowego $output: $!\n";

foreach my $zip (@zip_list) {
    print $OUT "=== ZIP: $zip ===\n";
    my @lines = `jar tf "$zip" 2>/dev/null`;
    if (@lines) {
        print $OUT @lines;
    } else {
        print $OUT "(Brak dostępu lub ZIP pusty / nie-zip)\n";
    }
    print $OUT "\n";
}

close($OUT);

print "Zrobione. Wynik w: $output\n";
