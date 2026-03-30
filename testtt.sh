encode_all_reports() {

    # 0. Sprawdzenie OpenSSL
    if [ -z "$SSL_PRG" ]; then
        error_exit "Nie ustawiono zmiennej SSL_PRG"
    fi

    OPENSSL_VER=$($SSL_PRG version 2>/dev/null)
    [ $? -eq 0 ] || error_exit "Nie można pobrać wersji OpenSSL ($SSL_PRG)"

    log "Używany OpenSSL: $OPENSSL_VER"

    # 1. Kodowanie plików
    for FILE in "$RAP1" "$RAP2" "$RAP3"
    do
        log "Kodowanie base64: $FILE"

        [ -f "$FILE" ] || error_exit "Brak pliku: $FILE"

        $SSL_PRG base64 -in "$FILE" -out "$FILE.b64"
        RC=$?

        [ $RC -eq 0 ] || error_exit "Błąd kodowania: $FILE"

        # opcjonalnie check czy plik nie jest pusty
        [ -s "$FILE.b64" ] || error_exit "Plik wynikowy pusty: $FILE.b64"

        log "OK: $FILE.b64"
    done
}
