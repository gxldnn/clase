#!/bin/bash
# Script bien bellako made by goldn

###################################
##
##      COLORS && MoRE
##
cd
LOGFILE=$(pwd)/vpnlog/logfile.log
ERRFILE=$(pwd)/vpnlog/errfile.err
mkdir -p $(pwd)/vpnlog
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

function screen(){
    echo -ne "$GREEN ____   _____________________   
\   \ /   /\______   \      \  
 \   Y   /  |     ___/   |   \ 
  \     /   |    |  /    |    \ 
   \___/    |____|  \____|__  /
                            \/ $RESET     $MAGENTA[$YELLOW gxldn $MAGENTA]$RESET\n\n"
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


clear
screen

if [ "`timeout 0.2 ping -c 1 google.com`" ]
then
  echo -n ""
else
  echo -e "[$RED WARNING$RESET ] Asegurate de que tienes ping antes de ejecutar el script: (con resolucion DNS).\n\n"
  exit 0
fi


echo -e "Para poder montar el servidor openvpn es necesario recavar ciertos datos\n"

echo -e "Cual es la ip externa de tu nftables o Router?"
read -p ">" remote_ip
clear
screen

echo -e "Que ip privada tiene tu servidor VPN?"
read -p ">" vpn_ip
clear
screen

echo -e "Que ip privada tiene tu servidor CA?"
read -p ">" ca_ip
clear


screen
echo -e "Es cierta esta info?:"
echo -e "IP red externa (publica):"$RED $remote_ip$RESET
echo -e "IP de el servidor VPN:"   $CYAN $vpn_ip$RESET
echo -e "IP de el servidor CA:"    $GREEN $ca_ip$RESET
read -s -n 1 -r -p "Presione [Enter] si es correcta, en el caso contrario presione [X]" check

if [[ $check == "x" ]]; then
    echo -e "\nOperation cancelled."
    exit 1
else
    echo -n ""
fi

clear
screen

####################################################################################
#####################################SCRIPT#########################################
####################################################################################

apt-get update >> $LOGFILE 2>$ERRFILE &
dot_check $! "Actualizando repos"

apt-get install -y curl openvpn easy-rsa >> $LOGFILE 2>$ERRFILE &
dot_check $! "Instalando recursos"

mkdir -p /root/client-configs/keys
mkdir -p /root/easy-rsa
ln -s /usr/share/easy-rsa/* /root/easy-rsa/ >> $LOGFILE 2>$ERRFILE &
dot_check $! "Creando directorios de trabajo" 





cd /root/easy-rsa/
./easyrsa init-pki >> $LOGFILE 2>$ERRFILE &
dot_check $! "Configurando easy-rsa CA"
echo -e "set_var EASYRSA_REQ_COUNTRY    \\\"ES\\\"" > pki/vars
echo -e "set_var EASYRSA_REQ_PROVINCE   \\\"Barcelona\\\"" >> pki/vars
echo -e "set_var EASYRSA_REQ_CITY       \\\"Castelldefels\\\"" >> pki/vars
echo -e "set_var EASYRSA_REQ_ORG        \\\"BLAUS\\\"" >> pki/vars
echo -e "set_var EASYRSA_REQ_EMAIL      \\\"admin@admin.admin\\\"" >> pki/vars
echo -e "set_var EASYRSA_REQ_OU         \\\"2SMIX\\\"" >> pki/vars
echo -e "set_var EASYRSA_ALGO           \\\"ec\\\"" >> pki/vars
echo -e "set_var EASYRSA_DIGEST         \\\"sha512\\\"" >> pki/vars
sleep 0.5 >> $LOGFILE 2>$ERRFILE &
dot_check $! "Retocando VARS CA"

