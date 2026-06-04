python3 - <<'EOF'
with open("plik.txt", "rb") as f:
    for lineno, line in enumerate(f, 1):
        decoded = line.rstrip(b'\n\r')
        fields = decoded.split(b'|')
        for col, field in enumerate(fields, 1):
            for pos, byte in enumerate(field):
                if byte < 0x20 and byte not in (0x09,):
                    print(f"linia {lineno:>6}, kolumna_pipe {col:>3}, pozycja {pos+1:>4}, hex \\x{byte:02x}")
EOF
