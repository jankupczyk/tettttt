for f in *_*.xml
do
    new=$(echo "$f" | sed 's/_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\.xml$/.xml/')
    mv "$f" "$new"
done
