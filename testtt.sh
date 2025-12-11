
open my $OUT, ">", $output or die "Nie mogę otworzyć $output: $!";

foreach my $zip (@zip_list) {
    my $in_files_section = 0;
    foreach my $line (`unzip -l "$zip" 2>/dev/null`) {
        chomp $line;
        $in_files_section = 1 if $line =~ /^Name$/;
        next unless $in_files_section;
        next if $line =~ /^(Name|----|\s*)$/;
        print $OUT "$line\n";
    }
}

close($OUT);
