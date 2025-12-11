system("grep -v -E '^(Name|----|Length|=+)\$' raport.txt | grep -v '^\\s*\$' > raport_tmp && mv raport_tmp raport.txt");


# Ścieżka do pliku wynikowego
my $raport = $output;
my $tmp = "$raport.tmp";

# Usuń nagłówki, separatory i puste linie przy pomocy sed
system("sed '/^\\s*$/d; /^Name\$/d; /^----\$/d; /^Length\$/d; /^=\\+\$/d' $raport > $tmp");

# Nadpisanie oryginalnego pliku czystym raportem
rename $tmp, $raport or die "Nie mogę nadpisać pliku $raport: $!";

