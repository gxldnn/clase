#!/bin/bash
function passwd-check() {
        if [[ "$passwd" == "$passwd2" ]]; then
                return 0
        else
                return 1
        fi
}

function newcomer() {
    clear
    echo -e "$LMAGENTA"
    echo -e "Bienvenido a el script modular de VHOSTING con SFTP hecho por IJR & MOSKA$RESET"
    echo -e "Por favor escriba su nombre de usuario"
    read -p ">" user

    while true; do
        unset passwd
        unset passwd2
        echo -n "Introduzca su contraseña: "
        stty -echo
        PROMPT=""
        CHARCOUNT=0
            while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
            do
                if [[ $CHAR == $'\0' ]] ; then
                    break
                fi
                if [[ $CHAR == $'\177' ]] ; then
                    if [ $CHARCOUNT -gt 0 ] ; then
                        CHARCOUNT=$((CHARCOUNT-1))
                        PROMPT=$'\b \b'
                        passwd="${passwd%?}"
                    else
                        PROMPT=''
                    fi
                elif [[ $CHAR == $'\n' ]] ; then
                    break
                else
                    CHARCOUNT=$((CHARCOUNT+1))
                    PROMPT='*'
                    passwd+="$CHAR"
                fi
            done
            echo
            echo -n "Vuelve a introducir la contraseña: "
            CHARCOUNT=0
            PROMPT=""
            while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
            do
                if [[ $CHAR == $'\0' ]] ; then
                    break
                fi
                if [[ $CHAR == $'\177' ]] ; then
                    if [ $CHARCOUNT -gt 0 ] ; then
                        CHARCOUNT=$((CHARCOUNT-1))
                        PROMPT=$'\b \b'
                        passwd2="${passwd2%?}"
                    else
                        PROMPT=''
                    fi
                else
                    CHARCOUNT=$((CHARCOUNT+1))
                    PROMPT='*'
                    passwd2+="$CHAR"
                fi
            done
        passwd-check
        if [ $? -eq 0 ]; then
            stty echo
            echo
            break
        else
            echo
            echo "La contraseña que has escrito no es correcta, por favor escribela de nuevo."
        fi
    done
}