#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use POSIX qw(mktime);

my ($directory, $listfile, $output, $period, $since, $until);
GetOptions(
    "dir=s"    => \$directory,
    "list=s"   => \$listfile,
    "out=s"    => \$output,
    "period=i" => \$period,
    "since=s"  => \$since,
    "until=s"  => \$until,
);

die "Użycie:\n  --dir <katalog> [--list plik.txt] --out wynik.txt [--period min | --since ... [--until ...]]\n"
    unless $directory && $output;
my @zip_list;

if ($listfile) {
    open my $LF, "<", $listfile or die "Nie mogę otworzyć $listfile: $!";
    while (<$LF>) {
        chomp;
        next unless $_;
        my $zip_path = -f $_ ? $_ : "$directory/$_";
        push @zip_list, $zip_path if -f $zip_path;
    }
    close $LF;
} else {
    my $time_from;
    my $time_to = time();

    if ($period) {
        $time_from = time() - ($period * 60);
    } elsif ($since) {
        $since =~ s/[-: ]/ /g;
        my @t = split /\s+/, $since;
        $time_from = mktime(0, $t[4], $t[3], $t[2], $t[1]-1, $t[0]-1900);
    } else {
        $time_from = 0;
    }

    if ($until) {
        $until =~ s/[-: ]/ /g;
        my @u = split /\s+/, $until;
        $time_to = mktime(0, $u[4], $u[3], $u[2], $u[1]-1, $u[0]-1900);
    }
    opendir my $D, $directory or die "Nie mogę otworzyć katalogu $directory: $!";
    foreach my $f (grep { /\.zip$/i } readdir($D)) {
        my $full = "$directory/$f";
        my $mtime = (stat($full))[9];
        next if $mtime < $time_from || $mtime > $time_to;
        push @zip_list, $full;
    }
    closedir $D;
}

open my $OUT, ">", $output or die "Nie mogę otworzyć $output: $!";
foreach my $zip (@zip_list) {
    my @lines = map { (split)[3] } grep { $_ !~ /^(Length|=|$)/ } `unzip -l "$zip"`;
    print $OUT "$_\n" for @lines;
}
close($OUT);

print "Raport gotowy: $output\n";
