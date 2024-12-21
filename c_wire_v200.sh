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
exec=0
cd codeC
for arg in `ls`
do
	if [[ $arg == "exec.exe" ]] ; then
		exec=1
	fi
done

#if [ $exec -eq 0 ] ; then
	#compil makefile
#fi

cd ..



#test tmp et graphs
temp=0
graph=0
for list in `ls`
do
	if [[ $list == "tmp" ]] ; then
		temp=1
		cd tmp
		rm -rf ./*
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

#debut timer
start_time=$(date +%s%N)



#recuperation centrale et fichier tmp de la centrale
fichier=$1
if [ $# -eq 4 ] ; then
	centrale=$4
else
	centrale='.'
fi



#tr '-' '0' < "$fichier" > temp && mv temp "$fichier"

case "$2_$3" in
	
	"hvb_comp")
		output_file="hvb_comp.csv"
		echo "ID;capacité;consomation" > "$output_file"
		cat $fichier | grep -E '^[^;]*;[^-;]*;[-];[-];'|tr '-' '0'|cut -d';' -f 2,7,8| ./exec >> "$output_file"
		cat $output_file
		#cat c-wire_v00.dat | grep -E '^[0-9]+;[0-9]+;-;-;' | tr '-' '0' | cut -d';'  -f 2,7,8 >> "$test.csv"
		#./exec >> "$output_file"
		;;
		
	"hva_comp")
		output_file="hva_comp.csv"
		echo "ID;capacité;consomation" > "$output_file"
		cat $fichier | grep -E '^[^;]*;[^;]*;[^-;]*;[-];'|tr '-' '0'|cut -d';' -f 2,7,8| ./exec >> "$output_file"
		;;
	
	"lv_comp")
		output_file="lv_comp.csv"
		echo "ID;capacité;consomation" > "$output_file"
		cat $fichier | grep -E '^[^;]*;[^;]*;[^;]*;[^-;]*;[^-;]*;[-];'|tr '-' '0'|cut -d';' -f 2,7,8| ./exec >> "$output_file"
		;;
	
	"lv_indiv")
		output_file="lv_indiv.csv"
		echo "ID;capacité;consomation" > "$output_file"
		cat $fichier | grep -E '^[^;]*;[^;]*;[^;]*;[^-;]*;[-];[^-;]*;'|tr '-' '0'|cut -d';' -f 2,7,8| ./exec >> "$output_file"
		echo lv_indiv
		;;
	
	"lv_all")
		output_file="lv_all.csv"
		echo "ID;capacité;consomation" > "$output_file"
		cat $fichier | grep -E '^[^;]*;[^;]*;[^;]*;[^-;]*;'|tr '-' '0'|cut -d';' -f 2,7,8| ./exec >> "$output_file"
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

# Temps de fin en nanosecondes
end_time=$(date +%s%N)

# Calculer la durée en millisecondes
elapsed_time=$(( (end_time - start_time) / 1000000 |bc ))


echo "Opération terminée en $elapsed_time millisecondes."

