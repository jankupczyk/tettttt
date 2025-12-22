#!/bin/bash

while IFS= read -r zip; do
  [ -z "$zip" ] && continue

  echo "Przetwarzam: $zip"

  if [ ! -f "$zip" ]; then
    echo "  BŁĄD: plik nie istnieje"
    continue
  fi

  count=$(unzip -l "$zip" | sed '1,3d;$d' | wc -l)
  echo "  Liczba plików w ZIP: $count"
done < lista_zip.txt
