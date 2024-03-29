#!/bin/bash
LOGFILE="$(pwd)/setup/log.log"
ERRFILE="$(pwd)/setup/err.log"
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

STDCOLOR="\e[96m"
ERRCOLOR="\e[91m"
install_requirements() {
    local requirements=(
        "paramiko"
        "tabulate"
        "traceback2"
        "keyboard"
        "platformdirs"
        "rich"
        "simple-term-menu"
        "Pillow"
        "ipaddress"
    )
    for pkg in "${requirements[@]}"; do
        if pip install "$pkg"  >> $LOGFILE 2>$ERRFILE; then
            echo "Paquet '$pkg' instalat correctament."
        else
            echo "Error al instalar paquet '$pkg'."
            exit 1
        fi
    done
}

main() {
    if ! command -v pip >/dev/null; then
        echo "Error: pip no está instal·lat"
        exit 1
    fi

    install_requirements
    clear
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
            echo -e "\n"
            exit
            ;;
    esac
}

mkdir $(pwd)/setup
touch $LOGFILE
touch $ERRFILE
clear


apt install -y python3 >> $LOGFILE 2>$ERRFILE &
dot_check $! "Intstalant python"
apt install -y pip >> $LOGFILE 2>$ERRFILE &
dot_check $! "Intstalant pip"
apt install -y python3-venv >> $LOGFILE 2>$ERRFILE &
dot_check $! "Intstalant venv"
python3 -m venv /root/oneshot >> $LOGFILE 2>$ERRFILE &
dot_check $! "Creant entorn virtualitzat"
source /root/oneshot/bin/activate
main
read -p "Ha de presionar [Enter] per a executar oneshot.py"
python3 $(pwd)/oneshot.py
