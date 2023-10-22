#!/bin/bash

# Este script ha sido desarrolado por IJRKLAN y MOSKA

# La idea de este script es que sea lo mas maleable posible
# para que cada persona que necesite utilizarlo pueda instalar
# lo necesario y solo eso
# jeje, god

# La manera de utilizarlo es comentar aquellas lineas indicadas
# para dejar de hacer ciertas tareas por ejemplo

# Comment this line if you want to unable sftp configuration
# Uncomment this line if you want to enable sftp configuration

# sftp_configuration

# la linea sftp_configuration la deberiamos comentar o no según nuestro interes

# eto e     una vaina

################################################################################################

LRED="\e[91m"
LGREEN="\e[92m"
LYELLOW="\e[93m"
LBLUE="\e[94m"
LMAGENTA="\e[95m"
LCYAN="\e[96m"
LGREY="\e[97m"
BOLD="\e[1m"
RESET="\e[0m"

# Execution checkers & Basic functions
execute_flag_ssk=0
function passwd-check() {
        if [[ "$passwd" == "$passwd2" ]]; then
                return 0
        else
                return 1
        fi
}

# Script
function newcomer() {
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
            echo -n "Vuelve a introducir la conrtaseña: "
            PROMPT=""
            while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
            do
                if [[ $CHAR == $'\0' ]] ; then
                    CHARCOUNT=0
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
function sftp_user_configuration() {
    read user
    read passwd

    chmod 755 /var/www/$domain
    chmod 755 /var/www/$domain/log
    chmod -R 775 /var/www/$domain/html
   
    echo -e "
    Match Group $user
        ChrootDirectory /var/www/$domain
        ForceCommand internal-sftp
        PubkeyAuthentication yes
        PasswordAuthentication no
        PermitTTY no" >> /etc/ssh/sshd_config

    useradd -m "$user" >>/dev/null 2>&1
    passwd "$user" <<< "$passwd"$'\n'$passwd >>/dev/null 2>&1
    systemctl restart sshd
}
function ssl_ssk() {
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$domain.key -out /etc/ssl/certs/$domain.crt<<EOF >>$LOGFILE 2>$ERRFILE
    ES
    Catalunya
    Barcelona
    IJR & Moska Trust Services
    IJR & Moska Trust Services
    $domain
    $email
EOF
    execute_flag_ssk=1
}
function vhost_http_server_config() {
    echo -e "
    server {
        listen 80;
        listen [::]:80;

        root /var/www/$domain/html;
        index index.html index.htm index.nginx-debian.html;

        server_name $domain www.$domain;

        location / {
                try_files \$uri \$uri/ =404;
        }

    }" > /etc/nginx/sites-available/$domain
    cp /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
}
function  vhost_https_server_config() {
    echo -e "
    server {
        listen 443 ssl;
        listen [::]:443 ssl;
        ssl_certificate /etc/ssl/certs/$domain.crt;
        ssl_certificate_key /etc/ssl/private/$domain.key;
        include snippets/ssl-params.conf;

        root /var/www/$domain/html;
        index index.html index.htm index.nginx-debian.html;

        server_name $domain www.$domain;

        location / {
                try_files \$uri \$uri/ =404;
        }
    }
    server {
        listen 80;
        listen [::]:80;

        server_name $domain www.$domain;

        return 302 https://\$server_name\$request_uri;
    }"
}
function create_vhost() {
    if [ "$execute_flag_ssk" -eq 1 ]; then
        vhost_http_server_config
    else
        vhost_https_server_config
    fi
}

# Zona del script modular

# Creation of an sftp user and password
sftp_user_configuration
# Creation of a self-signed certificate
ssl_ssk
# Do not comment this line (automatic detection of https or http server, it will act based on if ssl_ssk is commented out)
create_vhost
systemctl restart sshd
systemctl restart nginx
nginx -t