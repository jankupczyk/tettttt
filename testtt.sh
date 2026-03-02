mkdir -p /dane/123456/OUT_BAC && find /dane/123456/OUT -maxdepth 1 -type f -newermt "2000-01-01" ! -newermt "2025-01-01" -exec mv {} /dane/123456/OUT_BAC/ \;
