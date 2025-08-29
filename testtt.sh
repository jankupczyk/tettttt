#!/bin/bash

PHONENUMBER="$1"
MSGTOSEND="$2"

API_USER=""
API_PASS=""
SENDER=""


if [ $# -lt 2 ]; then
    echo "uSAGE: $0 <PHONENUMBER> <MSGTOSEND>"
    exit 1
fi


if ! [[ "$PHONENUMBER" =~ ^\+48[0-9]{9}$ ]]; then
    echo "ERROR: Phone number '$PHONENUMBER' must be in format +48XXXXXXXXX"
    exit 1
fi


if [ -z "$MSGTOSEND" ]; then
    echo "ERROR:: Message text cannot be empty"
    exit 1
fi

if [ ${#MSGTOSEND} -gt 160 ]; then
    echo "WARN:: Message longer than 160 characters may be split into multiple SMS!"
fi


RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/sms_response.txt \
  -X POST "https://api.orange.pl/sms/send" \
  -u "$API_USER:$API_PASS" \
  -H "Content-Type: application/json" \
  -d '{
        "to": "'"$PHONENUMBER"'",
        "message": "'"$MSGTOSEND"'",
        "from": "'"$SENDER"'"
      }')


if [ "$RESPONSE" -eq 200 ]; then
    echo "SMS SEND TO $PHONENUMBER -REC -OK"
    exit 0
else
    echo "BŁĄD: API zwróciło kod $RESPONSE"
    cat /tmp/sms_response.txt
    exit 4
fi
