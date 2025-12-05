for d in 2025-*; do printf "%s: " "$d"; find "$d" -type f | sed 's/.*\.//' | sort | uniq -c | awk '{printf "%d *.%s  ", $1, $2}'; echo; done


for d in 2025-*; do days=$(ls -d ${d}-*/ 2>/dev/null | wc -l); printf "%s: " "$d"; find "$d" -type f | sed 's/.*\.//' | sort | uniq -c | while read n ext; do printf "%d *.%s (avg %.2f/day)  " "$n" "$ext" "$(echo "$n / ($days>0?$days:1)" | bc -l)"; done; echo; done
