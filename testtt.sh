#PROCENT LOGOW NIEZBACKPOWANYCH
onstat -l | awk '
BEGIN{i=0; bad=0}
/^[0-9]/ {
    if ($3 !~ /C/) {
        i++
        if ($3 !~ /B/) bad++
    }
}
END{
    if (i>0) printf "%.2f\n", 100*bad/i
    else print "0.00"
}'

#ILOSC LOGOW OCZEKUJACYCH NA BACKUP
onstat -l | awk '
BEGIN{bad=0}
/^[0-9]/ {
    if ($3 ~ /U/ && $3 !~ /B/ && $3 !~ /C/)
        bad++
}
END { print bad+0 }'
