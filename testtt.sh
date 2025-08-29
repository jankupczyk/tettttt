#!/bin/bash


validate_number() {
    NUM="$1"

    CLEANNUM=$(echo "$NUM" | tr -d ' -')


    case "$CLEANNUM" in
        +48*) ;;
        *)
            echo "ERROR: Phone number '$NUM' must start with +48"
            return 1
            ;;
    esac


    DIGITS=$(echo "$CLEANNUM" | cut -c4-)
    if ! echo "$DIGITS" | grep -q '^[0-9]\{9\}$'; then
        echo "ERROR: Phone number '$NUM' must have exactly 9 digits after +48"
        return 1
    fi

    return 0
}


NUM="$1"
MSG="$2"
SRVCNME="testsendsmsz"


if [ $# -lt 2 ]; then
    echo "Usage: $0 <phone_number> <message>"
    exit 1
fi

validate_number "$NUM" || exit 2


if [ -z "$MSG" ]; then
    echo "ERROR: Message text cannot be empty"
    exit 3
fi



if [ $? -eq 0 ]; then
    echo "SUCCESS: SMS sent to $NUM"
else
    echo "FAILURE: Could not send SMS via Tuxedo"
    exit 4
fi
