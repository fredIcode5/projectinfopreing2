#!/bin/bash

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
		exit 1
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

if [ $exec -eq 0 ] ; then
	make
	if [ $? -ne 0 ]; then
    	echo "Erreur dans l'éxécution du Makefile"
    	exit 2
	fi
fi

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
	help
	echo "Erreur : mauvais nombre d'arguments"
	echo "Opération terminée en 0 secondes."
	exit 3
fi


#debut timer
start_time=$(date +%s)



#recuperation centrale
if [ $# -eq 4 ] ; then
	centrale=$4
else
	centrale="[^;]*"
fi

#recuperation fichier de donnée
fichier=$1

case "$2_$3" in
	
	"hvb_comp")
		if [[ $centrale == "[^;]*" ]] ; then
	    	outputfile="tests/hvb_comp.csv"
		else
			outputfile="tests/hvb_comp_$centrale.csv"
		fi

		echo "Station HVB;Capacité;Consomation (entreprises)"> "$outputfile"
		grep -E "^${centrale};[^-;]*;[-];[^;]*;[^;]*;[-];" "$fichier"|tr '-' '0'|cut -d';' -f 2,7,8| ./exec >> "$outputfile"  
		tr ';' ':' < "$outputfile"  > temp && mv temp "$outputfile" 
		cat $outputfile
		;;
		
	"hva_comp")
	    if [[ $centrale == "[^;]*" ]] ; then
	    	outputfile="tests/hva_comp.csv"
		else
			outputfile="tests/hva_comp_$centrale.csv"
		fi

		echo "Station HVA;Capacité;Consomation (entreprises)"> "$outputfile"
		grep -E "^${centrale};[^;]*;[^-;]*;[-];[^;]*;[-];" "$fichier"|tr '-' '0'|cut -d';' -f 3,7,8|./exec >> "$outputfile"
		tr ';' ':' < "$outputfile"  > temp && mv temp "$outputfile" 
		cat $outputfile
		;;
	
	"lv_comp")
		if [[ $centrale == "[^;]*" ]] ; then
	    	outputfile="tests/lv_comp.csv"
		else
			outputfile="tests/lv_comp_$centrale.csv"
		fi

		echo "Station LV;Capacité;Consomation (entreprises)"> "$outputfile"
		grep -E "^${centrale};[^;]*;[^;]*;[^-;]*;[^;]*;[-];" "$fichier"|tr '-' '0'|cut -d';' -f 4,7,8|./exec  >> "$outputfile"
		tr ';' ':' < "$outputfile"  > temp && mv temp "$outputfile" 
		cat $outputfile
		;;
	
	"lv_indiv")
		if [[ $centrale == "[^;]*" ]] ; then
	    	outputfile="tests/lv_indiv.csv"
		else
			outputfile="tests/lv_indiv_$centrale.csv"
		fi

		echo "Station LV;Capacité;Consomation (particuliers)"> "$outputfile"
		grep -E "^${centrale};[^;]*;[^;]*;[^-;]*;[-];[^;]*;" "$fichier"|tr '-' '0'|cut -d';' -f 4,7,8|./exec >> "$outputfile"
		tr ';' ':' < "$outputfile"  > temp && mv temp "$outputfile" 
		cat $outputfile
		;;
	
	"lv_all")
		if [[ $centrale == "[^;]*" ]] ; then
	    	outputfile="tests/lv_all_minmax.csv"
			minmax="tmp/lv_all.csv"
		else
			outputfile="tests/lv_all__minmax_$centrale.csv"
			minmax="tmp/lv_all_$centrale.csv"
		fi

		echo "Min and Max 'capacity-load' extreme nodes"> "$outputfile"
        echo "Station LV;Capacité;Consomation (Tous)">> "$outputfile"
		lv_temp="tmp/lv_temp.csv"
		grep -E "^${centrale};[^;]*;[^;]*;[0-9]+;[^;]*;[^;]*;" "$fichier" | tr '-' '0' | cut -d';' -f 4,7,8 | ./exec >> $lv_temp
       
		tri="tmp/tri.csv"
		sort -t';' -k3,3 -n  $lv_temp > $tri
		
		head -n 10 $tri > $minmax
		tail -n 10 $tri >> $minmax
		
		diff="tmp/diff.csv"
		awk -F';' '{sum=$2 - $3; print sum }' $minmax > $diff

		fusion="tmp/fusion.csv"
		paste -d ';' $diff "$minmax" > $fusion
		
		sort -t';' -n -k1,1 $fusion > $diff
		cut -d';' -f 2,3,4 $diff >> $outputfile
		tr ';' ':' < "$outputfile"  > temp && mv temp "$outputfile" 
		cat $outputfile
		
		rm $diff
		rm $lv_temp
		rm $fusion
		rm $tri
		;;

	*)
		help
		echo "Erreur : arguments non cohérents"
		echo "Opération terminée en 0 secondes."
		;;
		
esac

# Temps de fin
end_time=$(date +%s)

# Calculer la durée en secondes
elapsed_time=$(( (end_time - start_time) |bc))


echo "Opération terminée en $elapsed_time secondes."