STATUS=$(echo "$line" | awk -F"|" '{gsub(/^[ \t]+|[ \t]+$/, "", $NF); print $NF}')
