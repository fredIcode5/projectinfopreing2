#!/bin/bash


file="$1"
var="$2"
touch "tempresult6.txt"

if [[ "$var" == "hva" ]] ; then
# tri hva 
grep -E '^[^;]*;[^;]*;[^-;];[-]+' "$file"|cut -d';' -f7,8 
>> tempresult6.txt 
fi

if [[ "$var" = "hvb" ]] ; then
#hvb
grep -E '^[^;]*;[^-;]*;[^;]*;[-]+' "$file"|cut -d';' -f7,8 
 >> tempresult6.txt 
fi

if [[ "$var" = "lv" ]] ; then
#lv
grep -E '^[^;]*;[^;]*;[^;]*;[^-;];[-]+' "$file"|cut -d';' -f7,8
 >> tempresult6.txt 
fi


#remplacer les tirt par des 0


