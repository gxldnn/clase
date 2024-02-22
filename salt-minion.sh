#!/bin/bash

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

STDCOLOR="\e[96m"
ERRCOLOR="\e[91m"

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
    echo -e ''$YELLOW'  _________      .__   __               _____  .__       .__               
 /   _____/____  |  |_/  |_            /     \ |__| ____ |__| ____   ____  
 \_____  \\__  \ |  |\   __\  ______  /  \ /  \|  |/    \|  |/  _ \ /    \ 
 /        \/ __ \|  |_|  |   /_____/ /    Y    \  |   |  \  (  <_> )   |  \
/_______  (____  /____/__|           \____|__  /__|___|  /__|\____/|___|  /
        \/     \/                            \/        \/               \/ '$RESET'      '
}

function dot_check {
    echo -n $2
    dots=0

    while kill -0 $1 2>/dev/null; do
        if [ $dots -ge 4 ]; then
            echo -ne "\b\b\b\b\b         \b\b\b\b\b\b\b\b\b\b\b\b"
            dots=0
        fi
        echo -ne  " ."
        ((dots++))
        sleep 0.5
    done
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

function test-ping() {
	if [ $1 -ne 0 ]; then
        echo -e "$STDCOLOR  Conexion: \t$RED     Error $RESET"
        echo -e "\n"
        echo -e "$STDCOLOR -------------------------------- $RESET"
        exit
    else
        echo -e "$STDCOLOR Conexion: \t$GREEN     OK $RESET"
fi
}


clear

function first_install () {
    if [[ install_status == "1" ]]; then
        echo -n ""
    else
        screen
        apt purge salt-common -y >> $LOGFILE 2>$ERRFILE &
        dot_check $! "Borrando Salt"
            function cleanup() {
                rm -r /etc/salt/
                rm -r /var/run/salt
                rm -r /var/log/salt
                rm -r /var/cache/salt
            }
        cleanup >> $LOGFILE 2>$ERRFILE &
        dot_check $! "Limpiando salt-orphans"
        sleep 2
        dot_check $! "Entrando al installer"
        
    fi
    clear
    screen
    ping -c 1 -W 5 google.com >> $LOGFILE 2>$ERRFILE &
    test-ping $?

    echo -e "[$YELLOW!$RESET] Ip de el Salt-Master"
    read -p ">" master_ip
    echo -e "[$YELLOW!$RESET] Nombre del Minion"
    read -p ">" minion_id


    apt update >> $LOGFILE
    apt install curl -y >> $LOGFILE 2>$ERRFILE &
    dot_check $! "Instalando Curl"
    curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/debian/12/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
    echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/debian/12/amd64/latest bookworm main" > /etc/apt/sources.list.d/salt.list
    sleep 3 >> $LOGFILE 2>$ERRFILE &
    dot_check $! "Descargando Repositorios"
    apt update >> $LOGFILE 2>$ERRFILE &
    dot_check $! "Actualizando Repositorios"
    apt install salt-minion -y >> $LOGFILE 2>$ERRFILE &
    dot_check $! "Instalando Salt-Minion"

    echo -e "master: $master_ip" > /etc/salt/minion
    echo -e "id: $minion_id" >> /etc/salt/minion
    systemctl restart salt-minion.service >> $LOGFILE 2>$ERRFILE &
    dot_check $! "Reconfigurando Minion"
}

first_install
