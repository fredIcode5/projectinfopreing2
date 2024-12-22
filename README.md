# projectinfopreing2

Projet C-Wire

Le but de ce projet est de faire une synthèse de données d'un système de distribution d'électricité. Cette synthèse pourra se faire à plusieurs niveaux du réseau. Ce réseau est constitué de centrale, d'HVB(station haute tension), d'HVA(station moyenne tension) et LV(station basse tension). Chaque station fournissant de l'énérgie à différents acteurs. Les HVB et HVA n'envoient de l'énergie qu'à des entreprises(comp) quant aux LV ils envoient de l'énergie à des entreprises et des particuliers(indiv).

Ce projet s'articule autour de plusieurs dossiers:
-Dossier principal
  -codeC (contient le code c, h, le makefile et l'éxécutable(non existant au début mais se créer à la première utilisation))
    -main.c \n
    -fonctions.c
    -passerelle.h
    -Makefile
    -exec.exe
  -graphs (contient certains résultats de manière graphique)
  -input (contient le fichier de données sur lequel se base la synthèse)
    -data.csv / DATA_CWIRE.csv / c-wire_v25.dat (à vous de fournir)
  -tests (contient les résultats de vos synthèses)
  -tmp (contient les fichiers temporaires nécéssaires au bon fonctionnement du projet)
  c-wire.sh (dossier qui sera à éxécuter pour lancer la synthèse)

Afin de lancer le programme il vous faudra éxécuter le programme shell "./c-wire.sh", puis ajouter des arguments :
-En premier, le chemin d'accès au fichier de données ici dans le dossier 'input' donc : input/NOM_DU_FICHIER
-En deuxième, le type de station voulu : hvb / hva / lv
-En troisième, les acteurs observés entreprises / particuliers / tout : comp / indiv / all
-Et pour finir optionnellemnt un numéro de centrale en partivculier si vous voulez cibler votre synthèse : 1 / 2 / 3 / 4 / 5

Exemples de commande d'appel : 
./c-wire.sh input/NOM_DU_FICHIER hvb comp
./c-wire.sh input/NOM_DU_FICHIER lv indiv
./c-wire.sh input/NOM_DU_FICHIER hva comp 4
./c-wire.sh input/NOM_DU_FICHIER lv all 2

Vous pouvez toujours utiliser l'argument -h pou retrouver les informations voulues:
./c-wire.sh -h

Maintenant vous savez tout, à vous de jouer !
