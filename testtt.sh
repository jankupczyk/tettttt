#!/bin/bash

if ! ifconfig en2 | grep -q "UP"; then
    echo "CRIT: en2 DOWN"
    exit 1
fi


PENDING=$(onstat -l | awk '
/^[0-9]/ {
    if ($3 ~ /U/ && $3 !~ /B/ && $3 !~ /C/)
        bad++
}
END { print bad+0 }')

if [ "$PENDING" -gt 0 ]; then
    echo "CRIT: $PENDING logs waiting for backup"
    exit 2
fi

echo "OK"
exit 0
