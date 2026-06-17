#!/usr/bin/perl

use strict;
use warnings;
use Fcntl qw(SEEK_SET);

my $LOGDIR = "/home/app/logs";
my $STATE  = "/var/tmp/log_monitor.state";

my @patterns = (
    qr/Program error/,
    qr/A character variable has referenced subscripts that/
);

my %offsets;

if (-f $STATE) {
    open(my $sfh, "<", $STATE) or die "Cannot open state file";

    while (<$sfh>) {
        chomp;
        my ($file,$offset) = split(/\|/, $_, 2);
        $offsets{$file} = $offset;
    }

    close($sfh);
}

my $found = 0;
my @alerts;

opendir(my $dh, $LOGDIR) or die "Cannot open $LOGDIR";

while (my $file = readdir($dh)) {

    next if $file =~ /^\./;

    my $full = "$LOGDIR/$file";

    next unless -f $full;

    my $size = -s $full;

    my $offset = $offsets{$full} || 0;

    if ($offset > $size) {
        $offset = 0;
    }

    open(my $fh, "<", $full) or next;

    seek($fh, $offset, SEEK_SET);

    while (my $line = <$fh>) {

        foreach my $pattern (@patterns) {

            if ($line =~ $pattern) {

                chomp $line;

                push @alerts,
                     "$full => $line";

                $found = 1;
            }
        }
    }

    $offsets{$full} = tell($fh);

    close($fh);
}

closedir($dh);

open(my $sfh, ">", $STATE)
    or die "Cannot write state file";

foreach my $file (sort keys %offsets) {
    print $sfh "$file|$offsets{$file}\n";
}

close($sfh);

if ($found) {

    print "ERROR FOUND\n";

    foreach (@alerts) {
        print "$_\n";
    }

    exit 1;
}

print "OK\n";
exit 0;


find / -type f \( -name "*.pem" -o -name "*.crt" -o -name "*.cer" \) 2>/dev/null | while read f
do
    openssl x509 -in "$f" -noout -text 2>/dev/null | grep -qi "emailAddress=.*twoj@email.pl"
    if [ $? -eq 0 ]; then
        echo "Znaleziono w: $f"
    fi
done

find / -type f \( -name "*.crt" -o -name "*.cer" -o -name "*.pem" \) 2>/dev/null | while read f
do
    openssl x509 -in "$f" -noout -subject -issuer 2>/dev/null | \
    grep -q "CN=Test Certificate" && echo "$f"
done

