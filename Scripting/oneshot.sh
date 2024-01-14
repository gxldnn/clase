#!/bin/bash
# Script bien bellako made by goldn n moska

#######################
##
##      COLORS && MoRE
##

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
GREY="\e[37m"
RESET="\e[0m"

TICK="\xE2\x9C\x93"
CROSS="\xE2\x9C\x98"

#####################
##
##      VARS
##


function oneshotttyx(){
    echo -ne "$RED     _       ___  __       _ ___ 
    / ) )\ ) )_  (_ \` )_) / ) )  
    (_/ (  ( (__ .__) ( ( (_/ ($RESET"
}

function oneshotttya(){
    echo -ne "$GREEN     _       ___  __       _ ___ 
    / ) )\ ) )_  (_ \` )_) / ) )  
    (_/ (  ( (__ .__) ( ( (_/ ($RESET"
}

function tick {
	echo -e "\r [ $GREEN$TICK$RESET ] $1"
}

function cross {
	echo -e "\r [ $RED$CROSS$RESET ] $1"
}

function dot_check {
    echo -n $2
	while kill -0 $1 2>/dev/null; do
        echo -ne  " ." > /dev/tty
        sleep 2
    done
	wait $1
	direct_check $? "$2"
}
function direct_check {
    case $1 in
        0)
            echo -ne "\r "$2" [$TICK]          "
            ;;
        *)
            echo -ne "\r "$2" [$CROSS]          "
            exit
            ;;
    esac
}



clear

sleep 5 >> /dev/null 2>&1 &
dot_check $! "Do a Sleep for risas"