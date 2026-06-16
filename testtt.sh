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


python3 -c '
import os, base64, struct

for f in os.listdir("/etc/ssh/"):
    if f.endswith(".pub"):
        pub_path = os.path.join("/etc/ssh/", f)
        priv_path = pub_path.rsplit(".pub", 1)[0]
        try:
            with open(pub_path, "r") as file:
                parts = file.read().split()
                if len(parts) < 2: continue
                key_bytes = base64.b64decode(parts[1])
                alg_len = struct.unpack(">I", key_bytes[:4])[0]
                e_len = struct.unpack(">I", key_bytes[4+alg_len:8+alg_len])[0]
                n_len = struct.unpack(">I", key_bytes[8+alg_len+e_len:12+alg_len+e_len])[0]
                n_bytes = key_bytes[12+alg_len+e_len : 12+alg_len+e_len+n_len]
                bits = (len(n_bytes) - (1 if n_bytes[0] == 0 else 0)) * 8
                
                if bits == 1024:
                    print(f"Do usunięcia (Para 1024 bit):")
                    print(f"  -> Publiczny: {pub_path}")
                    if os.path.exists(priv_path):
                        print(f"  -> Prywatny:  {priv_path}")
                    else:
                        print(f"  -> Prywatny:  Nie znaleziono pliku prywatnego")
        except Exception:
            pass
'

sudo python3 -c '
import os, base64, struct

for f in os.listdir("/etc/ssh/"):
    if f.endswith(".pub"):
        pub_path = os.path.join("/etc/ssh/", f)
        priv_path = pub_path.rsplit(".pub", 1)[0]
        try:
            with open(pub_path, "r") as file:
                parts = file.read().split()
                if len(parts) < 2: continue
                key_bytes = base64.b64decode(parts[1])
                alg_len = struct.unpack(">I", key_bytes[:4])[0]
                e_len = struct.unpack(">I", key_bytes[4+alg_len:8+alg_len])[0]
                n_len = struct.unpack(">I", key_bytes[8+alg_len+e_len:12+alg_len+e_len])[0]
                n_bytes = key_bytes[12+alg_len+e_len : 12+alg_len+e_len+n_len]
                bits = (len(n_bytes) - (1 if n_bytes[0] == 0 else 0)) * 8
                
                if bits == 1024:
                    print(f"Usuwam klucz publiczny: {pub_path}")
                    os.remove(pub_path)
                    if os.path.exists(priv_path):
                        print(f"Usuwam klucz prywatny:  {priv_path}")
                        os.remove(priv_path)
        except Exception:
            pass
'





