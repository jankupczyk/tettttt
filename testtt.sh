open my $OUT, ">", $output or die "Nie mogę otworzyć $output: $!";

foreach my $zip (@zip_list) {
    foreach my $line (`unzip -l "$zip" 2>/dev/null`) {
        chomp $line;
        $line =~ s/^\s+|\s+$//g;      # usuń białe znaki na początku i końcu
        next unless $line;             # pomiń puste linie
        # Pomijamy linie nagłówków i separatorów
        next if $line =~ /^(Length|Name|----|=+)$/i;
        # Wszystko inne traktujemy jako nazwę pliku
        print $OUT "$line\n";
    }
}

close($OUT);
