awk '
BEGIN { found=0; prev_broken=0; prev_line="" }
{
    line = $0
    gsub(/[ \t]+$/, "", line)
 
    last_char = substr(line, length(line), 1)
 
    if (last_char != "|") {
        printf "  Linia %d: ZLAMANA - konczy sie na: [%s]\n", NR, (length(line)>40 ? "..." substr(line,length(line)-39,40) : line)
        found++
        prev_broken = 1
    } else {
        if (prev_broken == 1) {
            printf "           ^ powyzsze to kontynuacja od linii %d\n", NR-1
        }
        prev_broken = 0
    }
}
END {
    if (found == 0) print "  OK: Wszystkie linie koncza sie na |"
    else printf "\n  UWAGA: %d zlaman linii\n", found
}
' "$PLIK"
