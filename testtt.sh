    if echo "$line" | grep -q "ACCEPTED"; then
        echo "<span style=\"color:green;\">$line</span>"
    elif echo "$line" | grep -q "PENDING"; then
        echo "<span style=\"color:orange;\">$line</span>"
    elif echo "$line" | grep -q "REJECTED"; then
        echo "<span style=\"color:red;\">$line</span>"
    else
        echo "$line"
    fi
