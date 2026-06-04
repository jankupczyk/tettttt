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
####NOWEE

awk -v total="$TOTAL_LINES" \
    -v oczek="$OCZEKIWANE_PIPE" \
    -v ost_pipe="$OSTATNIA_PIPE" \
    -v ost_pref="$OSTATNIA_PREFIKS" '
BEGIN {
    blad=0
    zlamane=0
    naprawa_bufor=""
    naprawa_lnum=0
    oczekuje_kontynuacji=0
}
{
    lnum = NR
    linia = $0
 
    gsub(/[ \t\r]+$/, "", linia)
 
    pipe_count = 0
    tmp = linia
    while (index(tmp, "|") > 0) {
        pipe_count++
        pos = index(tmp, "|")
        tmp = substr(tmp, pos+1)
    }
 
    if (lnum == total) {
        if (substr(linia, 1, length(ost_pref)) != ost_pref) {
            printf "  BLAD    linia %d (OSTATNIA): nie zaczyna sie od '%s' | tresc: [%s]\n", \
                lnum, ost_pref, substr(linia,1,60)
            blad++
        } else if (pipe_count != ost_pipe) {
            printf "  BLAD    linia %d (OSTATNIA): oczekiwano %d separatorow, jest %d | tresc: [%s]\n", \
                lnum, ost_pipe, pipe_count, substr(linia,1,60)
            blad++
        } else {
            printf "  OK      linia %d (OSTATNIA): S|<crc>| - poprawna\n", lnum
        }
        next
    }
    if (pipe_count == oczek) {
        # Linia kompletna
        if (oczekuje_kontynuacji == 1) {
            printf "          (koniec zlamanego bloku przed linia %d)\n", lnum
        }
        oczekuje_kontynuacji = 0
        naprawa_bufor = ""
        naprawa_lnum = 0
 
    } else if (pipe_count < oczek) {
        zlamane++
        blad++
 
        brakuje = oczek - pipe_count
 
        if (oczekuje_kontynuacji == 0) {
            printf "  ZLAMANA linia %d: ma %d separatorow, brakuje %d | poczatek: [%s]\n", \
                lnum, pipe_count, brakuje, substr(linia,1,70)
            oczekuje_kontynuacji = 1
            naprawa_lnum = lnum
        } else {
            # Kontynuacja poprzedniego zlamania
            printf "  KONTYN. linia %d: ma %d separatorow (nadal brakuje %d do kompletu) | tresc: [%s]\n", \
                lnum, pipe_count, brakuje, substr(linia,1,70)
        }
        if (pipe_count == oczek) {
            printf "          -> po sklejeniu z poprzednia: rekord bylby kompletny\n"
            oczekuje_kontynuacji = 0
        }
 
    } else {
        blad++
        nadmiar = pipe_count - oczek
        printf "  NADMIAR linia %d: ma %d separatorow, o %d za duzo | tresc: [%s]\n", \
            lnum, pipe_count, nadmiar, substr(linia,1,70)
        oczekuje_kontynuacji = 0
    }
}
END {
    print ""
    if (blad == 0) {
        print "  OK: Wszystkie linie maja poprawna liczbe separatorow"
    } else {
        printf "  UWAGA: %d linii z bledna liczba separatorow (w tym %d zlaman)\n", blad, zlamane
    }
}
' "$PLIK"
