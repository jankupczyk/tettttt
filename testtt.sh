lsuser -c ALL | sed '1d' | awk -F: '$1!="root"{g=""; for(i=1;i<=NF;i++) if($i~/^gecos=/){sub(/^gecos=/,"",$i); g=$i} print $1 " : " g}'
