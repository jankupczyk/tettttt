DATA=$(date +%Y%m%d)

for f in /data/in/*; do
    if [ -f "$f" ]; then
        cp "$f" "/data/archive/$(basename "$f").$DATA"
    fi
done
