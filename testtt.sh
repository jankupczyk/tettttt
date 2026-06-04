# Pokaż wszystkie unikalne sekwencje końca linii
cat -A plik.txt | grep -oP '(\^M)?\$' | sort | uniq -c

# Albo przez xxd — sprawdź czy jest \r\n czy samo \n
xxd plik.txt | grep -E '0d 0a|0d$' | head -5


# Zakładając że poprawny rekord ma np. 20 pól (19 pipe'ów) — dostosuj liczbę
awk -F'|' 'NF < 19 {print NR": (tylko "NF" pol) "$0}' plik.txt | head -20


# Wszystkie znaki kontrolne w pliku z ich kodami hex i liczbą wystąpień
cat plik.txt | LC_ALL=C grep -oP '[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]' | \
  od -An -tx1 | tr ' ' '\n' | grep -v '^$' | sort | uniq -c | sort -rn
