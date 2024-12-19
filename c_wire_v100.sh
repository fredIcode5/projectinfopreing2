#!/bin/bash

#changer les - en 0 pour le C
#tr - 0

#filtrer les lignes
#grep -o MOTIF data.csv 

#tri
#cat data.txt | grep  | cut -d ';' -f 3,4 | ./exec


help(){
	echo ◦ chemin du fichier de données :
	echo 	• obligatoire
	echo 	• indique l’endroit où se trouve le fichier d’entrée
	echo ◦ type de station à traiter
	echo 	• obligatoire
	echo 	• valeurs possibles :
	echo 		hvb "(high-voltage B)"
	echo 		hva "(high-voltage A)"
	echo 		lv "(low-voltage)"
	echo ◦ type de consommateur à traiter
	echo 	• obligatoire
	echo 	• valeurs possibles :
	echo 		comp "(entreprises)"
	echo 		indiv "(particuliers)"
	echo 		all "(tous)"
	echo 	• ATTENTION : les options suivantes sont interdites car seules des entreprises sont connectées aux stations HV-B et HV-A :
	echo 		hvb all
	echo 		hvb indiv
	echo 		hva all
	echo 		hva indivecho 
	echo ◦ Identifiant de centrale :
	echo 	• optionnel
	echo 	• filtre les résultats pour une centrale spécifique
	echo 	• si cette option est absente, les traitements seront effectués sur toutes les centrales du fichier
}

#regarde pour un -h
for arg in $@
do
	if [[ $arg == "-h" ]] ; then
		help
	fi
done



#test compil du c

gcc projetInfoAVL.c -o exec



#test tmp et graphs
temp=0
graph=0
for list in `ls`
do
	if [[ $list == "tmp" ]] ; then
		temp=1
		cd tmp
		rm *
		cd ..
	fi
	
	if [[ $list == "graphs" ]] ; then
		graph=1
	fi
done

if [ $temp -eq 0 ] ; then
	mkdir tmp
fi

if [ $graph -eq 0 ] ; then
	mkdir graphs
fi



#test nombre arguments
if [ $# -ne 3 ] && [ $# -ne 4 ] ; then
	echo "Erreur : mauvais nombre d'arguments"
fi



#recuperation centrale et fichier tmp de la centrale
fichier=$1
if [ $# -eq 4 ] ; then
	centrale=$4
	#tri centrale
	#faire fichier tmp de la centrale en particulier
else
	centrale=0
fi



 #tr '-' '0' < "$fichier" > temp && mv temp "$fichier"

case "$2_$3" in
	
	"hvb_comp")
		output_file="hvb_comp.csv"
		touch test.csv 
		echo "ID;capacité;consomation" > "$output_file"
		cat $1 | grep -E '^[^;]*;[^-;]*;[-];[-];'|tr '-' '0'|cut -d';' -f 2,7,8| ./exec >> "$output_file"
		cat $output_file
		#cat c-wire_v00.dat | grep -E '^[0-9]+;[0-9]+;-;-;' | tr '-' '0' | cut -d';'  -f 2,7,8 >> "$test.csv"
		#./exec >> "$output_file"
		;;
		
	"hva_comp")
		grep -E '^[^;]*;[^;]*;[^0;];[0]+' "$fichier" | tr '-' '0' | cut -d';' -f 3,7,8 | ./exec
		;;
	
	"lv_comp")
		grep -E '^[^;]*;[^;]*;[^;]*;[^0;];[0]+' "$fichier" | tr '-' '0' | cut -d';' -f 4,7,8 | ./exec
		;;
	
	"lv_indiv")
		grep -E '^[^;]*;[^;]*;[^;]*;[0];[^0;]+' "$fichier" | tr '-' '0' | cut -d';' -f 4,7,8 | ./exec
		echo lv_indiv
		;;
	
	"lv_all")
		grep -E '^[^;]*;[^;]*;[^;]*;[^0;];[0]+' "$fichier" | tr '-' '0' | cut -d';' -f 4,7,8 | ./exec
		echo lv_all
		#faire le grep
		#reprendre le fichier résultat
		#faire la différence (capa-conso)
		#puis trier les lv par ordre croissant de la différence
		#refaire un fichier résultat final après le tri (format normal pas de colonne de la différence)
		;;	
	
	*)
		echo "Erreur : arguments non cohérents"
		help
		;;
		
esac


