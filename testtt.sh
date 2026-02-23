#!/bin/bash

for val in FOLDER1 FOLDER2 FOLDER3
do
    ls -1t /test/folder/$val/OUT 2>/dev/null | head -10
done
