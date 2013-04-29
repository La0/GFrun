#!/bin/bash
#
# Configuration file for GARMIN FORERUNNER - GFrun
# Modif by Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.2"
#     Licence: GNU
############################
#
########################################################################
# wget https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
########################################################################
#
echo "# Prerequis : Configurer plugin GarminPlugin - www.connect.garmin.com'
#==========================================================================='
# + Avoir deja effectué un 1 couplage/telechargement entre PC/MONTRE'
# ou'
# + USB ANT+ connecté et fonctionnelle'
# + Montre allumée et mode couplage activée"
sleep 5

##1ere connection GExtractor
xterm -e 'cd $HOME/GFrun/ && python ./garmin.py'

##Configuration des fichiers de config avec le #HOME et le $NUMERO_DE_MA_MONTRE
NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts)

if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
	cd $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/
	ln -s $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities Activities && mv Activities $HOME/.config/garmin-extractor/Garmin/Activities
	src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
fi

src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/GFrun/resources/FIT-to-TCX-master/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/40-convert_to_tcx.py" >> /tmp/ligneCmd.sh
src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh
chmod u+x /tmp/ligneCmd.sh && sh /tmp/ligneCmd.sh

echo "PROCEDURE TERMINEE"