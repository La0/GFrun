#!/bin/bash
#
# Configuration file for GARMIN FORERUNNER - GFrun
# Modif by Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.3.3"
#     Licence: GNU
############################
#
########################################################################
# wget https://github.com/xonel/GFrun/raw/master/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
########################################################################
#
echo "#:'######:::'########:'########::'##::::'##:'##::: ##:
#   '##... ##:: ##.....:: ##.... ##: ##:::: ##: ###:: ##:
#    ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:
#    ##::'####: ######::: ########:: ##:::: ##: ## ## ##:
#    ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:
#    ##::: ##:: ##::::::: ##::. ##:: ##:::: ##: ##:. ###:
#   . ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:
#   :......::::..::::::::..:::::..:::.......:::..::::..::"
#
##[preactions]
dpkg -l > /tmp/pkg-before.txt

##[repos]
sudo apt-add-repository -y ppa:andreas-diesner/garminplugin
sudo apt-get update

##[packages]
sudo apt-get install -y git git-core 
sudo apt-get install -y python python-pip libusb-1.0-0 python-lxml python-pkg-resources python-poster python-serial
sudo apt-get install -y garminplugin
sudo apt-get upgrade
dpkg -l > /tmp/pkg-after.txt

##[postactions]
pip install pyusb
rm -Rf $HOME/master.zip* $HOME/Garmin-Forerunner-610-Extractor-master/resources/master.zip* $HOME/Garmin-Forerunner-610-Extractor-master/resources/pygupload_20120516.zip* $HOME/.config/_.GFrunGarminplugin.zip* /tmp/ligneCmd.sh*
cd $HOME && wget https://raw.github.com/xonel/GFrun/master/GFrunOffline.zip && unzip -o GFrunOffline.zip

##Garmin-Forerunner-610-Extractor
#cd $HOME && wget https://github.com/Tigge/Garmin-Forerunner-610-Extractor/archive/master.zip 
cd $HOME && unzip -o master.zip
cp $HOME/Garmin-Forerunner-610-Extractor-master/resources/ant-usbstick2.rules /etc/udev/rules.d
mkdir -p $HOME/.config/garmin-extractor/scripts/ && mkdir -p $HOME/.config/garmin-extractor/Garmin

##Convert fit to tcx
cp -f $HOME/Garmin-Forerunner-610-Extractor-master/scripts/40-convert_to_tcx.py $HOME/.config/garmin-extractor/scripts/
#cd $HOME/Garmin-Forerunner-610-Extractor-master/resources/ && wget https://github.com/Tigge/FIT-to-TCX/archive/master.zip
cd $HOME/Garmin-Forerunner-610-Extractor-master/resources/ && unzip -o master.zip
#cd $HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/ && wget https://github.com/dtcooper/python-fitparse/archive/master.zip
cd $HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/ && unzip -o master.zip
mv $HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/python-fitparse-master/fitparse $HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/

##gcpuploader (Auto-upload connect.garmin.com)
#cd $HOME/Garmin-Forerunner-610-Extractor-master/resources/ && wget http://freefr.dl.sourceforge.net/project/gcpuploader/pygupload_20120516.zip 
cd $HOME/Garmin-Forerunner-610-Extractor-master/resources/ && unzip -o pygupload_20120516.zip
#cd $HOME/.config/ && wget https://raw.github.com/xonel/GFrun/master/_.config/_.GFrunGarminplugin.zip
cd $HOME/.config/ && unzip -o _.GFrunGarminplugin.zip

##1ere connection GExtractor
xterm -e 'cd $HOME/Garmin-Forerunner-610-Extractor-master/ && python ./garmin.py'

##Configuration des fichiers de config avec le #HOME et le $NUMERO_DE_MA_MONTRE
NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts)

if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
	cd $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/
	ln -s $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities Activities && mv Activities $HOME/.config/garmin-extractor/Garmin/Activities
	src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
fi

src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/40-convert_to_tcx.py" >> /tmp/ligneCmd.sh
src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh
chmod u+x /tmp/ligneCmd.sh && sh /tmp/ligneCmd.sh

###Chown Chmod
chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garminplugin $HOME/.config/garmin-extractor $HOME/Garmin-Forerunner-610-Extractor-master
chmod -R a+x $HOME/.config/garmin-extractor/scripts/ $HOME/Garmin-Forerunner-610-Extractor-master/scripts/

##Nettoyage
echo "======================= Clean Up =================== "
rm -Rf $HOME/master.zip* $HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/master.zip* $HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/python-fitparse-master/ $HOME/Garmin-Forerunner-610-Extractor-master/resources/master.zip* $HOME/Garmin-Forerunner-610-Extractor-master/resources/pygupload_20120516.zip* $HOME/.config/_.GFrunGarminplugin.zip* /tmp/ligneCmd.sh*
echo "PROCEDURE TERMINEE"