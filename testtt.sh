find /dane -mindepth 2 -maxdepth 2 -type d -name OUT -exec sh -c '
    nik=$(basename "$(dirname "$1")")
    count=$(find "$1" -maxdepth 1 -type f | wc -l)
    echo "$nik $count"
' _ {} \;
