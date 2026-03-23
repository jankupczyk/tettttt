for f in *_*.xml; do
    mv "$f" "$(echo "$f" | sed -E 's/_[0-9]{8}\.xml$/.xml/')"
done
