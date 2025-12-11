awk '{ for(i=1;i<=NF;i++) if($i !~ /^(Name|----|Length|=+)$/) print $i }' raport.txt > raport_czysty.txt
