lsuser -c -a name gecos ALL | sed '1d' | awk -F: '$1!="root"{split($NF,a,"="); print $1 " : " a[2]}' > users_gecos.txt
