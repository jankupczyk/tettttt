#!/bin/ksh

INPUT="report.txt"
HTML="/tmp/transaction_report.html"
MAIL_TO="odbiorca@firma.pl"
SUBJECT="Transaction Acknowledgment Report"

echo "Preparing HTML report..."

{
echo "<html>"
echo "<body style=\"font-family: monospace;\">"
echo "<pre>"

while IFS= read -r line; do
    if echo "$line" | grep -q "PENDING"; then
        echo "<span style=\"color:red;\">$line</span>"
    else
        echo "$line"
    fi
done < "$INPUT"

echo "</pre>"
echo "</body>"
echo "</html>"
} > "$HTML"

echo "Sending email via sendmail..."

 /usr/sbin/sendmail -t <<EOF
To: $MAIL_TO
Subject: $SUBJECT
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8

$(cat "$HTML")
EOF

echo "Mail sent successfully."
