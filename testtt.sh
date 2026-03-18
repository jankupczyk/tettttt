BASE=$(pwd)

find . -exec ls -ld {} \; | awk -v base="$BASE" '
{
  perms=$1
  user=$3
  group=$4
  file=$9

  split("rwx", map, "")
  mode=0

  for(i=2;i<=10;i+=3){
    val=0
    if(substr(perms,i,1)=="r") val+=4
    if(substr(perms,i+1,1)=="w") val+=2
    if(substr(perms,i+2,1)=="x") val+=1
    mode = mode*10 + val
  }

  fullpath = base "/" substr(file,3)

  print "chown " user ":" group " \"" fullpath "\""
  print "chmod " mode " \"" fullpath "\""
}'
