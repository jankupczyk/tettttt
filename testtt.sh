# Każdy znak kontrolny z numerem linii, numerem bajtu w linii i kodem hex
awk '{
  n = split($0, chars, "")
  for (i = 1; i <= n; i++) {
    code = ord(chars[i])
    if (code < 32 && code != 9) {  # wszystko oprócz tabulatora
      printf "linia %d, pozycja %d, hex \\x%02x\n", NR, i, code
    }
  }
}
function ord(c) { return sprintf("%d", c+0) }' plik.txt



cat -n plik.txt | grep -Pn '[^\x09\x0A\x20-\x7E]' | \
  while IFS= read -r line; do
    lineno=$(echo "$line" | grep -oP '^\s*\d+')
    echo "$line" | grep -oP '[^\x09\x0A\x20-\x7E]' | \
    od -An -tx1 | tr ' ' '\n' | grep -v '^$' | \
    while read hex; do
      echo "linia $lineno -> znak \\x$hex"
    done
  done | head -50




  
