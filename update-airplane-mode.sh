#!/bin/bash

# DISCLAIMER: The Piboy DMG is made by ExperimentalPi. The authors of this script is not affiliated and does not own ExperimentalPi or the Piboy DMG. They are properties of their respective owners.

# This is the airplane-mode scripts update/install script.
# This will look to see if you have the airplane-mode scripts installed, and do it for you automagically.
# It also doubles as an updater, so you can just run this from the emulationstation menu and it will update the scripts seamlessly for you.

# RAM=Retropie-airplane-mode. It does not stand for random-access memory.

RAM_DIR=~/RetroPie/retropiemenu/wireless
RAM_OLD_DIR=~/RetroPie/roms/ports/wireless

RAM_INSTALL() {
git clone https://github.com/brandflake11/Retropie-Airplane-Mode.git ~/RetroPie/retropiemenu/wireless
chmod +x ~/RetroPie/retropiemenu/wireless/.install-to-games-list.sh
~/RetroPie/retropiemenu/wireless/.install-to-games-list.sh
}

RAM_UPDATE() {
git -C ~/RetroPie/retropiemenu/wireless pull
}

RAM_UPDATE_OLD_FILES() {
mv ~/RetroPie/roms/ports/wireless ~/RetroPie/retropiemenu/wireless && git -C ~/RetroPie/retropiemenu/wireless pull
}

RAM_IS_THIS_PIBOY() {
    ps aux | grep "/home/pi/osd/[o]sd"    
}    

RAM_PIBOY_QUESTIONS() {
    # This will ask questions if the script detects you have a Piboy DMG and make the appropriate variables.
    echo "Piboy DMG detected."
    # Detect if this is already set. We don't need to ask this question every update.
    # Skip all of this code if this variable is already set. If echoing the variable is empty
    if [[ -z $(echo $RAM_PIBOY_OSD) ]]
    then
	# This question gets saved to $RAM_PIBOY_RESPONSE
	read -p "Do you want the RetroPie-Airplane-Mode scripts to manage your osd icons? [y]es, [n]o: " RAM_PIBOY_RESPONSE
	if [[ $RAM_PIBOY_RESPONSE == 'y' || $RAM_PIBOY_RESPONSE == 'Y' || $RAM_PIBOY_RESPONSE == "yes" ]]
	then
	    export RAM_PIBOY_OSD=1
	    echo "export RAM_PIBOY_OSD=1" >> ~/.bashrc
	    echo "Copying variable to bashrc to equal 1"
	elif [[ $RAM_PIBOY_RESPONSE == "n" || $RAM_PIBOY_RESPONSE == "N" || $RAM_PIBOY_RESPONSE == "no" ]]
	then
	    export RAM_PIBOY_OSD=0
	    echo "export RAM_PIBOY_OSD=0" >> ~/.bashrc
	    echo "Copying variable to bashrc to equal 0"
	    echo
	else
	    echo "Error, not a valid response."
	    exit
	fi
	echo "If you don't know what this means, you have nothing to worry about."
	echo
	echo "If at any time you don't want RetroPie-Airplane-Mode to manage your osd, simply"
	echo "change this line in your .bashrc in your home directory from:"
	echo "export RAM_PIBOY_OSD=1"
	echo "to:"
	echo "export RAM_PIBOY_OSD=0"
	echo
	echo "Make sure you reboot for the osd choice to take effect."
    fi	
}

RAM_PIBOY_CHECK() {
    # Check if the osd is running
    if [ -n "$(RAM_IS_THIS_PIBOY)" ]
    then
	RAM_PIBOY_QUESTIONS
    fi
}

## Check to see if the old RetroPie-airplane-mode exists and move it/update it
if [ -d $RAM_OLD_DIR ]
then
   echo "Moving old install of RetroPie-Airplane-Mode to Settings"
   RAM_UPDATE_OLD_FILES
fi
   
## Install logic. Only installs if installation is not found.
if [ -d $RAM_DIR ]
then
    echo RetroPie-airplane-mode is already installed!
else
    echo RetroPie-airplane-mode not installed. Installing now...
    RAM_INSTALL
    echo "Check under Retropie > Settings > Wireless to try them out"
fi
# This last line looks to see if you are on the Piboy DMG, and asks appropriate questions.
RAM_PIBOY_CHECK

## Update Logic. Only updates if installation is found.
if [ -d $RAM_DIR ]
then
    echo "Updating Retropie-Airplane-Mode scripts."
    RAM_UPDATE
    echo "Update done."
fi

