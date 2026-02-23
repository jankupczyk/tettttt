onstat -l | awk '
BEGIN{i=0; bad=0}
/^[0-9]/ {
    i++
    if ($3 !~ /B/) bad++
}
END{
    if (i>0) printf "%.2f\n", 100*bad/i
}'
