#!/bin/bash

# Nom du fichier passé en argument
file="$1"
var="$2"

tr '-' '0' < "$file" > temp && mv temp "$file"

touch "tempresult9.txt"

if [[ "$var" == "hva" ]] ; then
# tri hva 
grep -E '^[^;]*;[^;]*;[^0;];[0]+' "$file"|cut -d';' -f 3,7,8 
>> tempresult9.txt 
fi

if [[ "$var" = "hvb" ]] ; then
#hvb
grep -E '^[^;]*;[^0;]*;[^;]*;[0]+' "$file"|cut -d';' -f 2,7,8 
 >> tempresult9.txt 
fi

if [[ "$var" = "lv" ]] ; then
#lv
grep -E '^[^;]*;[^;]*;[^;]*;[^0;];[0]+' "$file"|cut -d';' -f 4,7,8
 >> tempresult9.txt 
fi


#remplacer les tirt par des 0






