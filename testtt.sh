zip 2024.zip $(find . -maxdepth 1 -type f -newermt 2024-01-01 ! -newermt 2025-01-01)
zip 2025.zip $(find . -maxdepth 1 -type f -newermt 2025-01-01 ! -newermt 2026-01-01)
