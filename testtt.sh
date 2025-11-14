#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::stat;

my %app_map = (
    'E' => 'ETEST',
    'F' => 'FILETEST',
    'M' => 'MPITEST',
);

my ($mode, $app_type, $log_file, $pattern);

GetOptions(
    "mode=s"    => \$mode,      # log | dir
    "app=s"     => \$app_type,  # E|F|M
    "log=s"     => \$log_file,  # ścieżka do logu
    "pattern=s" => \$pattern,   # regex do wyszukania
);

die "Użycie: $0 -mode <log|dir> -app <E/F/M>\n" unless $mode && $app_type;
die "Nieprawidłowy typ aplikacji\n" unless exists $app_map{$app_type};

my $app_name = $app_map{$app_type};
my $base_path = "/app/$app_name";

my $today = get_today_date();
if ($mode eq 'log') {

    die "Musisz podać -log i -pattern\n"
        unless $log_file && $pattern;

    open(my $fh, '<', $log_file)
        or die "Nie mogę otworzyć logu $log_file: $!\n";

    my $count = 0;

    while (my $line = <$fh>) {
        next unless $line =~ /\b$today\b/;
        $count++ if $line =~ /$pattern/;
    }

    print $count;
    exit 0;
}

if ($mode eq 'dir') {

    my $err_dir = "$base_path/in_err";

    opendir(my $dh, $err_dir)
        or die "Nie mogę otworzyć katalogu $err_dir: $!\n";

    my @files = grep { !/^\./ } readdir($dh);
    closedir($dh);

    my $count_today = 0;

    for my $f (@files) {
        my $path = "$err_dir/$f";

        next unless -f $path;
        my $st = stat($path);

        my ($year, $month, $day) = get_date_from_epoch($st->mtime);

        my $file_date = sprintf("%04d-%02d-%02d", $year, $month, $day);

        $count_today++ if $file_date eq $today;
    }

    print $count_today;
    exit 0;
}

die "Nieznany tryb: $mode\n";

sub get_today_date {
    my @t = localtime();
    return sprintf("%04d-%02d-%02d", $t[5]+1900, $t[4]+1, $t[3]);
}

sub get_date_from_epoch {
    my $epoch = shift;
    my @t = localtime($epoch);
    return ($t[5]+1900, $t[4]+1, $t[3]);
}
