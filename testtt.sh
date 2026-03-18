#!/bin/bash

output="prawa_jdk.sh"
echo "#!/bin/bash" > $output
echo "set -e" >> $output

find . -exec stat -c '%a %U %G %n' {} \; 2>/dev/null | while read mode user group file; do
    echo "chown $user:$group \"$file\"" >> $output
    echo "chmod $mode \"$file\"" >> $output
done

chmod +x $output
