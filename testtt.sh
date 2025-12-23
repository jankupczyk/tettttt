#!/bin/bash

while IFS= read -r zip; do
  [ -z "$zip" ] && continue

  echo "======================================"
  echo "Przetwarzam: $zip"

  if [ ! -f "$zip" ]; then
    echo "  BŁĄD: plik nie istnieje"
    continue
  fi

  # Lista plików w zip (bez nagłówka i stopki)
  file_list=$(unzip -l "$zip" | sed '1,3d;$d')

  echo "  Pliki XML w ZIP:"
  echo "$file_list" | awk '{print $NF}' | grep -i '\.xml$' || echo "    (brak plików XML)"

  count=$(echo "$file_list" | wc -l)
  echo "  Łączna liczba plików w ZIP: $count"

done < lista_zip.txt
