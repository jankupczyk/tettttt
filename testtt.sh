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


sudo ksh -c '
for pub in /etc/ssh/*.pub; do
    [ -f "$pub" ] || continue
    b64=$(awk "{print \$2}" "$pub")
    bits=$(echo "$b64" | awk "BEGIN { str = \"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\" ; for(i=0; i<64; i++) d[substr(str, i+1, 1)] = i } { len = length(\$0); bin = \"\"; for(i=1; i<=len && i<=80; i++) { c = substr(\$0, i, 1); if (c == \"=\") break; val = d[c]; bits_str = \"\"; for(j=0; j<6; j++) { bits_str = (val % 2) bits_str; val = int(val / 2) }; bin = bin bits_str }; for(i=1; i<=length(bin); i+=8) { b[int(i/8)] = 0; for(j=0; j<8; j++) { if(substr(bin, i+j, 1) == \"1\") b[int(i/8)] += 2^(7-j) } }; alg_len = b[0]*16777216 + b[1]*65536 + b[2]*256 + b[3]; e_offset = 4 + alg_len; e_len = b[e_offset]*16777216 + b[e_offset+1]*65536 + b[e_offset+2]*256 + b[e_offset+3]; n_offset = e_offset + 4 + e_len; n_len = b[n_offset]*16777216 + b[n_offset+1]*65536 + b[n_offset+2]*256 + b[n_offset+3]; first_b = b[n_offset+4]; if (first_b == 0) n_len--; print n_len * 8 }")

    if [ "$bits" = "1024" ]; then
        priv="${pub%.pub}"
        echo "Usuwam plik publiczny: $pub"
        rm -f "$pub"
        if [ -f "$priv" ]; then
            echo "Usuwam plik prywatny:  $priv"
            rm -f "$priv"
        fi
    fi
done
'



