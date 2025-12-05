for d in 2025-*; do printf "%s: " "$d"; find "$d" -type f | sed 's/.*\.//' | sort | uniq -c | awk '{printf "%d *.%s  ", $1, $2}'; echo; done
