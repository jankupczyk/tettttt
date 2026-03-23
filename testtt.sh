for f in *.xml; do
  cp "$f" "$f.bak"
  sed -Ei 's|<XchgRate>[[:space:]]*</XchgRate>|<XchgRate>1</XchgRate>|g; s|<XchgRate[[:space:]]*/>|<XchgRate>1</XchgRate>|g' "$f"
done
