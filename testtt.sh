{
echo "<html>"
echo "<body style=\"font-family: monospace;\">"

echo "<p>Hello team,</p>"
echo "<p>Here are the acknowledgments for transactions executed within the last 6 hours.</p>"
echo "<p>Status colors: <span style=\"color:green\">ACCEPTED</span>, <span style=\"color:yellow\">PENDING</span>, <span style=\"color:red\">REJECTED</span></p>"

echo "<pre>"

while IFS= read -r line; do
    STATUS=$(echo "$line" | awk -F"|" '{print $NF}')
    case "$STATUS" in
        "ACCEPTED")
            echo "<span style=\"color:green;\">$line</span>"
            ;;
        "PENDING")
            echo "<span style=\"color:orange;\">$line</span>"
            ;;
        "REJECTED")
            echo "<span style=\"color:red;\">$line</span>"
            ;;
        *)
            echo "$line"
            ;;
    esac
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
