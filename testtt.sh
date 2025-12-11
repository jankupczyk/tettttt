open my $OUT, ">", $output or die "Nie mogę otworzyć $output: $!";

foreach my $zip (@zip_list) {
    foreach my $line (`unzip -l "$zip" 2>/dev/null`) {
        chomp $line;
        next if $line =~ /^\s*$/;         # pomiń puste linie
        next if $line =~ /^(Length|----|Name)/; # pomiń nagłówki/separatory
        my @cols = split ' ', $line;
        next unless @cols >= 4;
        # ostatnia kolumna to nazwa pliku
        print $OUT "$cols[-1]\n";
    }
}

close($OUT);
