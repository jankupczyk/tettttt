#!/bin/bash

DATA=$(date +%Y%m%d)

for f in *.unl; do
    nazwa="${f%.unl}"
    if zip "${nazwa}_${DATA}.zip" "$f"; then
        rm "$f"
    fi
done
