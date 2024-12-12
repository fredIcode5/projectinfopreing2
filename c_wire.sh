#!/bin/bash

#changer les - en 0 pour le C
#tr - 0

#filtrer les lignes
#grep -o MOTIF data.csv 




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

for arg in $@
do
	if [[ $arg == "-h" ]] ; then
		help()
	fi
done

for list in `ls`
do
	if [[ $list == "tmp" ]] ; then
		
	fi
	
	if [[ $list == "graphs" ]] ; then
		
	fi
done

if [[ $# -ne 3 ] || [[ $# -ne 4 ] ; then
do
	echo "Erreur : mauvais nombre d'arguments"
fi


# Revision des if par un swicth case
case "$2_$3" in
	
	"hvb_comp")
		echo hvb_comp
		;;
		
	"hva_comp")
		echo hva_comp
		;;
	
	"lv_comp")
		echo lv_comp
		;;
	
	"lv_indiv")
		echo lv_indiv
		;;
	
	"lv_all")
		echo lv_all
		;;	
	
	*)
		echo "Erreur : arguments non cohérents"
		help()
		;;
		
esac





