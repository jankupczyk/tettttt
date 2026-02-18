zip 2024.zip $(find . -maxdepth 1 -type f -newermt 2024-01-01 ! -newermt 2025-01-01)
zip 2025.zip $(find . -maxdepth 1 -type f -newermt 2025-01-01 ! -newermt 2026-01-01)


for f in /katalog_zrodlowy/*; do [ -f "$f" ] && echo "INFO:: FILE - $(basename "$f")" && mv "$f" /katalog_docelowy/ && sleep 15; done
ls -1tr /katalog_zrodlowy | while IFS= read -r plik; do echo "Przenoszę: $plik"; mv "/katalog_zrodlowy/$plik" /katalog_docelowy/ && sleep 15; done
