#!/bin/bash
# Script bien bellako made by goldn n moska

##################################
##
##      COLORS && MoRE
##

LOGFILE=$(pwd)/oneshotlog/logfile.log
ERRFILE=$(pwd)/oneshotlog/errfile.err
mkdir -p $(pwd)/oneshotlog
touch $LOGFILE
touch $ERRFILE

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
function tick {
	echo -e "\r [ $GREEN$TICK$RESET ] $1"
}
function cross {
	echo -e "\r [ $RED$CROSS$RESET ] $1"
}
##################################
##
##      MAIN FUNCTIONS
##

function screen () {
    echo '  _________      .__   __               _____  .__       .__               
 /   _____/____  |  |_/  |_            /     \ |__| ____ |__| ____   ____  
 \_____  \\__  \ |  |\   __\  ______  /  \ /  \|  |/    \|  |/  _ \ /    \ 
 /        \/ __ \|  |_|  |   /_____/ /    Y    \  |   |  \  (  <_> )   |  \
/_______  (____  /____/__|           \____|__  /__|___|  /__|\____/|___|  /
        \/     \/                            \/        \/               \/ '
}

function dot_check {
    echo -n $2
    dots=0git 

    while kill -0 $1 2>/dev/null; do
        if [ $dots -ge 4 ]; then
            echo -ne "\b\b\b\b\b         \b\b\b\b\b\b\b\b\b\b\b\b"
            dots=0
        fi
        echo -ne  " ."
        ((dots++))
        sleep 0.5
    done
s
    wait $1
    direct_check $? "$2"
}

function direct_check {
    case $1 in
        0)
            printf "\r%-35s%s [ $GREEN$TICK$RESET ] done.\n" "$2" ""
            ;;
        *)
            printf "\r%-35s%s [ $RED$CROSS$RESET ]̉̉\n Check the error at: $ERRFILE " "$2" ""
            exit
            ;;
    esac
}

clear
screen
