DATA=$(date +%Y%m%d_%H%M%S)


for f in /data/in/*; do
    [ -f "$f" ] || continue
    cp "$f" "$ARCH_DIR/$(basename "$f").$DATA"
done

for f in /data/in/*; do
    if [ -f "$f" ]; then
        cp "$f" "/data/archive/$(basename "$f").$DATA"
    fi
done
