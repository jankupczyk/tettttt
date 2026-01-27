$patterns = '127\.0\.0\.1','192\.168\.0\.1','10\.0\.0\.1'
Get-ChildItem -Recurse -File |
  Select-String -Pattern $patterns -CaseSensitive:$false |
  Select-Object -Unique Path
