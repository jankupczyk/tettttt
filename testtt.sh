#!/bin/bash

# ===== Konfiguracja =====
ZASOB="/mnt/zasob"
PLIKI_LISTA="$ZASOB/pliki.txt"
PLIKI_TEST="pliki_test.txt"
PLIK1_OUT="plik1_out.txt"
PLIK2_OUT="plik2_out.txt"

SMTP_HOST="smtp.twojadomena.com"
SMTP_PORT=25
SMTP_FROM="nadawca@domena.com"
SMTP_TO="odbiorca@domena.com"
SMTP_SUBJECT="Raport plików ZIP"

# ===== Montowanie zasobu =====
if ! mount | grep -q "$ZASOB"; then
    echo "Montowanie zasobu $ZASOB..."
    mount -t nfs server:/ścieżka "$ZASOB"
fi

# ===== Sprawdzenie pliki.txt =====
if [ ! -f "$PLIKI_LISTA" ]; then
    echo "Plik $PLIKI_LISTA nie istnieje!"
    exit 1
fi

# ===== Czyszczenie plików wynikowych =====
> "$PLIKI_TEST"
> "$PLIK1_OUT"
> "$PLIK2_OUT"

# ===== Iteracja po ZIP-ach =====
while IFS= read -r ZIP_FILE; do
    ZIP_PATH="$ZASOB/$ZIP_FILE"
    if [ -f "$ZIP_PATH" ]; then
        echo "Przetwarzanie $ZIP_FILE..."
        unzip -Z1 "$ZIP_PATH" >> "$PLIKI_TEST"
    else
        echo "Plik $ZIP_PATH nie istnieje!"
    fi
done < "$PLIKI_LISTA"

# ===== dbaccess dla każdego pliku =====
if [ -s "$PLIKI_TEST" ]; then
    while IFS= read -r PLIK; do
        echo "dbaccess -e dla $PLIK"
        dbaccess -e "$PLIK"
    done < "$PLIKI_TEST"
fi

# ===== Przygotowanie plików Base64 =====
base64 "$PLIKI_TEST" > "$PLIKI_TEST.b64"
base64 "$PLIK1_OUT" > "$PLIK1_OUT.b64"
base64 "$PLIK2_OUT" > "$PLIK2_OUT.b64"

# ===== Wysyłka maila przez Telnet =====
(
echo "HELO localhost"
echo "MAIL FROM:<$SMTP_FROM>"
echo "RCPT TO:<$SMTP_TO>"
echo "DATA"
echo "Subject: $SMTP_SUBJECT"
echo "From: $SMTP_FROM"
echo "To: $SMTP_TO"
echo "MIME-Version: 1.0"
echo "Content-Type: multipart/mixed; boundary=\"BOUNDARY123\""
echo
echo "--BOUNDARY123"
echo "Content-Type: text/plain; charset=\"UTF-8\""
echo
echo "W załączniku przesyłam pliki wynikowe."
echo
for FILE in "$PLIKI_TEST.b64" "$PLIK1_OUT.b64" "$PLIK2_OUT.b64"; do
    BASENAME=$(basename "$FILE" .b64)
    echo "--BOUNDARY123"
    echo "Content-Type: text/plain; name=\"$BASENAME\""
    echo "Content-Transfer-Encoding: base64"
    echo "Content-Disposition: attachment; filename=\"$BASENAME\""
    cat "$FILE"
    echo
done
echo "--BOUNDARY123--"
echo "."
echo "QUIT"
) | telnet "$SMTP_HOST" "$SMTP_PORT"

echo "Skrypt zakończony."
