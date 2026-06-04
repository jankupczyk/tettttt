perl -e 'use Digest::CRC qw(crc32); open(F,"plik.txt"); read(F,$_, -s F); print crc32($_), "\n";'
