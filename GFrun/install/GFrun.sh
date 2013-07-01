#! /bin/bash
#
# GFrun
#
#  Auteurs : Le.NoX ;o)
#  M@il : le.nox @ free.fr
Version="0.4.3"
#
#  Licence: GNU GPL
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##########################################################################################################################################################
#(STABLE - GFrun)  : wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
#(DEV    - MASTER) : wget -N https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
##########################################################################################################################################################
#
Vbranche="GFrun"
#Vbranche="master"
Vcpt=0

color()
{
printf '\033[%sm%s\033[m\n' "$@"
}

F_Chk_SUDO(){
	echo `color 32 ">>> SUDO_USER"`
	if [ ! "$SUDO_USER" ]; then
		echo `color 31 "======================================================"`
		echo "Installing - GFrun requires administrator rights."
		echo `color 31 "======================================================"`
		sudo sh $HOME/GFrunMenu.sh
	fi
}

F_uninstall(){
echo " BACKUP WILL BE DONE INSIDE : " $HOME"/GFrun_Activities_Backup.zip "
echo""
echo `color 31 "======================================================"`
echo " !! UNINSTALL !! WARNING !! UNINSTALL !!"
echo `color 31 "======================================================"`
echo -n "UNINSTALL ALL (FGrun + ConfigFiles + Activities) >> YES / [NO] :"

read Vchoix

	if [ "$Vchoix" = "YES" ]; then
			zip -ur  $HOME/GFrun_Activities_Backup.zip  $HOME/.config/garmin-extractor/
			rm -f  $HOME/.guploadrc $HOME/.local/share/icons/GFrun.svg $HOME/.local/share/applications/GFrun.desktop /usr/share/icons/GFrun.svg
			rm -Rf  $HOME/GFrun $HOME/.config/garmin-extractor $HOME/.config/garminplugin
			echo " Backup Activities DONE : $HOME/GFrun_Activities_Backup.zip "
		else
			sh $HOME/GFrun/install/GFrunMenu.sh
	fi
}

F_clear(){
echo `color 32 ">>> F_clear"`
	rm -f $HOME/GFrun.sh* $HOME/master.zip* $HOME/GFrun/resources/FIT-to-TCX-master/master.zip* $HOME/GFrun/resources/master.zip* $HOME/GFrun/resources/pygupload_20120516.zip* /tmp/ligneCmd.sh*
	rm -Rf  $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master $HOME/GFrun/Garmin-Forerunner-610-Extractor-master
}

F_mkdir(){
echo `color 32 ">>> F_mkdir"`
	mkdir -p $HOME/GFrun/resources/FIT-to-TCX-master/
	mkdir -p $HOME/.config/garmin-extractor/scripts/
	mkdir -p $HOME/.config/garminplugin
	mkdir -p $HOME/.config/garmin-extractor/dump_gconnect/
}

F_garminplugin_UBU(){
	if ! grep -q "deb http://ppa.launchpad.net/andreas-diesner/garminplugin/ubuntu $(lsb_release -cs) main" < /etc/apt/sources.list
	 then
		sudo apt-add-repository -y ppa:andreas-diesner/garminplugin
		sudo apt-get update
		sudo apt-get install -y garminplugin
	else
		sudo apt-get update
		sudo apt-get install -y garminplugin
	fi
}

F_garminplugin_DEB(){
	MACHINE_TYPE=`uname -m`
	if [ ${MACHINE_TYPE} == 'x86_64' ]; then
	  Varchi='~raring_amd64.deb'
	else
	  Varchi='~raring_i386.deb'
	fi

	wget http://ppa.launchpad.net/andreas-diesner/garminplugin/ubuntu/pool/main/g/garminplugin/garminplugin_0.3.17-1$Varchi
	sudo dpkg -i garminplugin_0.3.17-1$Varchi

	mkdir -p $HOME/.mozilla/plugins
	ln -s /usr/lib/mozilla/plugins/npGarminPlugin.so $HOME/.mozilla/plugins/npGarminPlugin.so
}

F_apt(){
echo `color 32 ">>> F_apt"`
	dpkg -l > /tmp/pkg-before.txt
	
	sudo apt-get upgrade
	sudo apt-get install -y lsb-release python python-pip libusb-1.0-0 python-lxml python-pkg-resources python-poster python-serial
	pip install pyusb

		if [ "$(lsb_release -is)" = "ubuntu" ]; then
			F_garminplugin_UBU
		fi
		
		if [ "$(lsb_release -is)" = "debian" ]; then
			F_garminplugin_DEB
		fi

	dpkg -l > /tmp/pkg-after.txt
}

F_wget(){
echo `color 32 ">>> F_wget"`
	cd $HOME && wget -N https://github.com/Tigge/Garmin-Forerunner-610-Extractor/archive/drivers.zip && mv drivers.zip master.zip
	cd $HOME/GFrun/resources/ && wget -N https://github.com/Tigge/FIT-to-TCX/archive/master.zip
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && wget -N https://github.com/dtcooper/python-fitparse/archive/master.zip
	cd $HOME/GFrun/resources/ && wget -N http://freefr.dl.sourceforge.net/project/gcpuploader/pygupload_20120516.zip
	cd $HOME && wget https://github.com/xonel/GFrun/raw/$Vbranche/GFrunOffline.zip
}

F_unzip(){
echo `color 32 ">>> F_unzip"`
	#Garmin-Forerunner-610-Extractor-master
	cd $HOME && unzip -o master.zip -d GFrun
	#FIT-to-TCX-master
	cd $HOME/GFrun/resources/ && unzip -o master.zip
	#python-fitparse-master
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && unzip -o master.zip
	#gupload
	cd $HOME/GFrun/resources/ && unzip -o pygupload_20120516.zip
	#script install
	cd $HOME && unzip -oC GFrunOffline.zip "GFrun/install/*" "GFrun/resources/dump_gconnect.py" ".config/*" ".local/*" -d $HOME/
}

F_cpmv(){
echo `color 32 ">>> F_cpmv"`

	cp -f $HOME/GFrun/resources/ant-usbstick2.rules /etc/udev/rules.d/
	udevadm control --reload-rules

	#Garmin-Forerunner-610-Extractor-master
	cp -Rf $HOME/GFrun/Garmin-Forerunner-610-Extractor-master/* $HOME/GFrun
	##Convert fit to tcx & auto-Upload ConnectGarmin
	cp -f $HOME/GFrun/scripts/40-convert_to_tcx.py $HOME/.config/garmin-extractor/scripts/
	cp -f $HOME/GFrun/scripts/01-upload-garmin-connect.py $HOME/.config/garmin-extractor/scripts/
	cp -Rf $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master/fitparse $HOME/GFrun/resources/FIT-to-TCX-master/
	mv -f $HOME/GFrunOffline.zip $HOME/GFrun/resources/
	#Icons
	cp -f $HOME/.local/share/icons/GFrun.svg /usr/share/icons/
	#getkey.py
	cp -f $HOME/GFrun/resources/getkey.py $HOME/GFrun/
}

F_extractfit(){
echo `color 32 ">>> F_extractfit"`
	#Extractor FIT
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e 'cd $HOME/GFrun/ && python ./garmin.py'
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
}

F_getkey(){
echo `color 32 ">>> F_getkey"`
	#Pairing Key
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e 'cd $HOME/GFrun/ && python ./getkey.py'
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
}

F_configfiles(){
echo `color 32 ">>> F_configfiles"`

	#$NUMERO_DE_MA_MONTRE
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts | grep -v dump_gconnect)

	#GarminDevice.xml
	if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
		echo $NUMERO_DE_MA_MONTRE >> $HOME/GFrun/resources/IDs
		cd $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/
		ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities -T $HOME/.config/garmin-extractor/Garmin/Activities
		ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE -T $HOME/GFrun/$NUMERO_DE_MA_MONTRE
		src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
		
		echo `color 32 "============================================="`
		echo "...> CONFIG KEY Forerunner - OK - : " $Vcpt 
		echo `color 32 "============================================="`	
	else
		if [ $Vcpt -lt 3 ]; then
			Vcpt=$(($Vcpt+1))
					
			echo `color 31 "============================================="`
			echo "...> Grab Key from Forerunner - Testing" $Vcpt "/3" 
			echo `color 31 "============================================="`	
			echo "You need :"	
			echo "...1) Garmin ForeRunner [ ON ] + [PARING MODE ]"
			echo "...2) Dongle USB-ANT plugged"
			echo ""
			echo `color 31 "============================================="`
			F_getkey
			sleep 3
			F_configfiles
			sleep 3 #Delay USB-ANT time out connect 
		fi
	fi

	#40-convert_to_tcx.py
	src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/GFrun/resources/FIT-to-TCX-master/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/40-convert_to_tcx.py" >> /tmp/ligneCmd.sh
	src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh

	#ligneCmd.sh
	chmod u+x /tmp/ligneCmd.sh && sh /tmp/ligneCmd.sh
}

F_chownchmod(){
echo `color 32 ">>> F_chownchmod"`
	#Chown Chmod
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garminplugin $HOME/.config/garmin-extractor $HOME/GFrun $HOME/.local/share/
	chmod -R a+x $HOME/.config/garmin-extractor/scripts/ $HOME/GFrun/install/ $HOME/GFrun/scripts/ 
}

F_chk_GFrunOffline(){
echo `color 32 ">>> F_chk_GFrunOffline"`
if [ -f $HOME/GFrunOffline.zip ] ; then
		unzip -o $HOME/GFrunOffline.zip -d $HOME/
	else
		if [ -f $HOME/GFrun/resources/GFrunOffline.zip ] ; then
			unzip -o $HOME/GFrun/resources/GFrunOffline.zip -d $HOME/
			else
				cd $HOME && wget https://github.com/xonel/GFrun/raw/$Vbranche/GFrunOffline.zip && unzip -o GFrunOffline.zip
				unzip -o $HOME/GFrunOffline.zip -d $HOME/
		fi
fi
}

F_conf_gupload(){
	echo "
	# Username and password credentials may be placed in a configuration file
	# located either in the current working directory, or in the user's home
	# directory.  WARNING, THIS IS NOT SECURE. USE THIS OPTION AT YOUR OWN
	# RISK.  Username and password are stored as clear text in a file
	# format that is consistent with Microsoft (r) INI files."
	echo ""
echo `color 32 "============================================="`
	echo "Configuration Auto-Upload on connect.garmin.com"
echo `color 32 "============================================="`

	if [ ! -f $HOME/.guploadrc ]; then
			read -p 'USERNAME : on connect.garmin.com >> ' Read_user
			read -p 'PASSWORD : on connect.garmin.com >> ' Read_password

			echo "[Credentials]" >> $HOME/.guploadrc
			echo "enabled = True" >> $HOME/.guploadrc
			echo "username="$Read_user"" >> $HOME/.guploadrc
			echo "password="$Read_password"" >> $HOME/.guploadrc
		else
			echo  "CHECK >> $HOME/.guploadrc"
			echo ""
			echo `color 31 "============================================="`
						echo "Configuration file already exist"
			echo `color 31 "============================================="`

			read -p 'Do you want create new one (N/y) ?' Vo
			case "$Vo" in
			 y|Y)	rm -f $HOME/.guploadrc
					F_conf_gupload;;
			 n|N) echo "OK";;
			 *) echo "not an answer";;
			esac
	fi
}

F_Dump_Gconnect(){
	echo `color 32 "======================================================================="`
	echo ">>>>>  DUMP ALL ACTIVITIES FROM CONNECT GARMIN <<<<<< " 
	echo `color 32 "======================================================================="`
	echo ""
	echo " (10 ~ 20) mins - PLEASE WAIT ... "
	echo ""
	cd $HOME/.config/garmin-extractor/dump_gconnect/ && python $HOME/GFrun/resources/dump_gconnect.py
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor/dump_gconnect
}

F_Diag(){
	echo " DIAG FONCTION"
	echo '==================================================================='
	echo 'rm -f $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/authfile'
	echo '==================================================================='
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts | grep -v dump_gconnect)
	rm -f $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/authfile
	
	echo "GFrun - $Vbranche - $Version ">> $HOME/GFrun/resources/DIAG
	echo '='>> $HOME/GFrun/resources/DIAG
	echo '==================================================================='>> $HOME/GFrun/resources/DIAG
	echo 'usb-devices'>> $HOME/GFrun/resources/DIAG
	echo '==================================================================='>> $HOME/GFrun/resources/DIAG
	usb-devices | grep Vendor=0fcf >> $HOME/GFrun/resources/DIAG
	echo '==================================================================='>> $HOME/GFrun/resources/DIAG
	echo 'cat $HOME/GFrun/resources/IDs'>> $HOME/GFrun/resources/DIAG
	echo '==================================================================='>> $HOME/GFrun/resources/DIAG
	echo 'cat /etc/udev/rules.d/ant-usbstick2.rules'>> $HOME/GFrun/resources/DIAG
	echo '==================================================================='>> $HOME/GFrun/resources/DIAG
	cat $HOME/GFrun/resources/IDs >> $HOME/GFrun/resources/DIAG
	echo '==================================================================='>> $HOME/GFrun/resources/DIAG
	cat /etc/udev/rules.d/ant-usbstick2.rules >> $HOME/GFrun/resources/DIAG
}

F_Upload_Gconnect_GoScript()
{
	echo `color 31 "============================================="`
	echo " LOCAL > ...> Upload Activities on going >... > GARMIN.COM" 
	echo `color 31 "============================================="`	

	echo " Script >>> python $HOME/GFrun/resources/pygupload/gupload.py -v 1 $Vactivities"
	cd $HOME/.config/garmin-extractor/Garmin/Activities
	python $HOME/GFrun/resources/pygupload/gupload.py -v 1 $Vactivities
}

F_Upload_Gconnect(){
echo ""
echo ""
echo `color 32 "=================================="`
echo "SELECT ACTIVITIES PERIOD"
echo `color 32 "=================================="`
echo ""
echo " (T) - Today"
echo " (W) - Week" 
echo " (M) - Month"
echo " (Y) - Years" 
echo ""
echo -n "Choise : (t) . (w) . (m) . (y) "
read Vchoix

        case $Vchoix
        in
          [tT]) # 2013-04-14_10-29-04-80-9375.fit
		################################
		Vactivities=$(date +%Y-%m-%d_*)
			F_Upload_Gconnect_GoScript
            ;;

          [wW])  # Lancer le Script pour : 
		################################	
		for c in 1 2 3 4 5 6 7
			do 
			Vactivities=$(date "+%Y-%m-%d_*" -d "$c days ago")
			F_Upload_Gconnect_GoScript
		done
            ;;

          [mM]) # Lancer le Script pour :     
		################################
		Vactivities=$(date +%Y-%m-*)
		F_Upload_Gconnect_GoScript
            ;;

          [yY]) # Lancer le Script pour : 
		################################
		Vactivities=$(date +%Y-*)
		F_Upload_Gconnect_GoScript
            ;;
        esac
}

## MAIN ##
echo `color 32 "========================================================================"`
echo "#     :......::::..::::::::..:::::..:::.......:::..::::..::"
echo "#      :'######:::'########:'########::'##::::'##:'##::: ##:"
echo "#      '##... ##:: ##.....:: ##.... ##: ##:::: ##: ###:: ##:"
echo "#       ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:"
echo "#       ##::'####: ######::: ########:: ##:::: ##: ## ## ##:"
echo "#       ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:"
echo "#       ##::: ##:: ##::::::: ##::. ##:: ##:::: ##: ##:. ###:"
echo "#     .  ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:"
echo "#     :......::::..::::::::..:::::..:::.......:::..::::..::"
echo `color 32 "======================================================================="`
echo "Arg :.........>>>>>>>" $1 "<<<<<<................"
echo ""
echo ""
	case $1
		in

          -s) # 1. STABLE.........................(GFrun.sh -s .)
		####################################################################
				F_Chk_SUDO
				F_clear
				F_mkdir
				F_chk_GFrunOffline
				F_apt
#				F_wget
				F_unzip
				F_cpmv
				F_configfiles
				F_chownchmod
				F_conf_gupload
#				F_extractfit
				F_clear
            ;;
          -d) #2. DEV ...........................(GFrun.sh -d .)
		####################################################################
				F_Chk_SUDO
				F_clear
				F_mkdir
#				F_chk_GFrunOffline
				F_apt
				F_wget
				F_unzip
				F_cpmv
				F_configfiles
				F_chownchmod
				F_conf_gupload
#				F_extractfit
				F_clear
            ;;
          -up) # 3. UPDATE.........................(GFrun.sh -up)
		####################################################################
				F_Chk_SUDO
				F_clear
				F_mkdir
				F_chk_GFrunOffline
#				F_apt
#				F_wget
				F_unzip
				F_cpmv
				F_configfiles
				F_chownchmod
				F_extractfit
				F_clear
             ;;
             
          -cp) # 4. Conf-Pairing...................(GFrun.sh -cp )
		####################################################################
				F_getkey
             ;;
             
          -cg) # 5. Conf-Garmin.com................(GFrun.sh -cg )
		####################################################################
				F_configfiles
				F_conf_gupload
             ;;
             
          -el) # 6. Extract.Fit >> Local...........(GFrun.sh -el ) 
		####################################################################
				F_extractfit
             ;;
             
          -gl) #7. Garmin.com .>> Local ..........(GFrun.sh -gl ) 
		####################################################################
				F_Dump_Gconnect

             ;;
             
          -lg) # 8. Local.Fit ..>> Garmin.com .....(GFrun.sh -lg ) 
		####################################################################
				F_Upload_Gconnect
             ;;

          -eg) # 9. Extract.Fit >> Garmin.com......(GFrun.sh -eg ) 
		####################################################################
				F_extractfit
				Vactivities=$(date +%Y-%m-*)
				F_Upload_Gconnect_GoScript
             ;;
             
          -cd) #D. Conf-Diag .....................(GFrun.sh -cd ) 
		####################################################################
				F_Diag
				F_extractfit
             ;;

          -un) #U. UNINSTALL......................(GFrun.sh -un )
		####################################################################
				F_uninstall
				F_clear
             ;;

          *) # anything else
		####################################################################
            echo
            echo "\"$1\" NO VALID ENTRY  - GFrun.sh"
            sleep 3
            ;;
        esac
echo ".........................       GFrun       ..........................."
echo "                                 !!!            o           _   _     "
echo "    -*~*-          ###           _ _           /_\          \\-//     "
echo "    (o o)         (o o)      -  (OXO)  -    - (o o) -       (o o)     "
echo "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-"
echo ""                              $Version
echo ""
echo ".........................PROCEDURE TERMINEE..........................."

	if [ -f $HOME/GFrunMenu.sh ]; then
		sleep 3
		sh $HOME/GFrunMenu.sh
	else
		if [ -f $HOME/GFrun/install/GFrunMenu.sh ]; then
			sleep 3
			sh $HOME/GFrun/install/GFrunMenu.sh
		fi
	fi
exit

