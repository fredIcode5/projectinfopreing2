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

make



#test tmp et graphs
temp=0
graph=0
for list in `ls`
do
	if [[ $list == "tmp" ]] ; then
		temp=1
	#	rm tmp/*
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


start_time=$(date +%s%N)

#recuperation centrale et fichier tmp de la centrale
fichier=$1
if [ $# -eq 4 ] ; then
	centrale=$4
	#tri centrale
else
	centrale="[^;]*"
fi






case "$2_$3" in
	
	"hvb_comp")
	    outputfile="hvb_comp.csv"
		grep -E "^${centrale};[^;]*;[^-;]*;[-];[^;]*;[-];" "$fichier"|tr '-' '0'|cut -d';' -f 2,7,8| ./exec > "$outputfile"  
		cat $outputfile
		;;
		
	"hva_comp")
	    outputfile="hva_comp.csv"
		grep -E "^${centrale};[^;]*;[^-;]*;[-];[^;]*;[-];" "$fichier"|tr '-' '0'|cut -d';' -f 3,7,8|./exec > "$outputfile"
		cat $outputfile
		;;
	
	"lv_comp")
		outputfile="lv_comp.csv"
		grep -E '^[^;]*;[^;]*;[^;]*;[^-;];[-]+' "$fichier"|tr '-' '0'|cut -d';' -f 4,7,8|./exec  > "$outputfile"
		cat $outputfile
		;;
	
	"lv_indiv")
		outputfile="lv_indiv.csv"
		grep -E "^${centrale};[^;]*;[^;]*;[^-;]*;[-];[^;]*;" "$fichier"|tr '-' '0'|cut -d';' -f 4,7,8|./exec > "$outputfile"
		cat $outputfile
		;;
	
	"lv_all")
		echo lv_all
		;;	
	
	*)
		echo "Erreur : arguments non cohérents"
		help
		
		;;
		
esac

# Temps de fin en nanosecondes
end_time=$(date +%s%N)

# Calculer la durée en millisecondes
elapsed_time=$(( (end_time - start_time) / 1000000 |bc))


echo "Opération terminée en $elapsed_time millisecondes."





