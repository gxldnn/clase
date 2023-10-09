#!/bin/bash
clear
#//////////////////////////////////
#//
#//
#//     FUNCIONES Y VARAIBLES
#//
#//

apt install nginx
apt install ssh
function test-email() {
        local validezemail="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

        if [[ "$email" =~ $validezemail ]]; then
                return 0
        else
                return 1
        fi
}


#//////////////////////////////////
#//
#//
#//      TOMA DE VARAIBLES
#//
#//


#Obtencion de variables necesarias

echo -e "Bienvenido a RIMOGO enterprise, ha ejecutado el programa para darse de alta en nustros servicios de hosting."
echo -e "Diganos el nombre de usuario que quiere"
read user
echo -e "Su contraseña:"
read -s passwd
echo -e "Que nombre quiere para tu pagina web ej. jaime.com"
read domain

while true; do
        echo "Por favor escirba su email: "
        read email

        test-email "$email"
        if [ $? -eq 0 ]; then
                break
        else
                echo "El E-mail que has escrito no es correcto, por favor escribalo de nuevo."
        fi

done

echo

echo -e "Necesitamos un poco mas de informacion para que tu sitio sea mas seguro"
echo -e "De que pais es tu empresa? ej. ES"
read countryname
echo -e "De que provincia o estado es?"
read statename
echo -e "De que ciudad eres?"
read city
echo -e "Como se llama tu compañia?"
read companyname
echo -e "En que sector se centra?"
read unitname

echo -e "\n Muy bien, la informacion que nos ha proporcionado es correcta, su web esta en proceso de crearse, espere."


#/////////////////////////////////
#//
#//
#//           SCRIPT
#//
#//

LOGFILE="/etc/nginx/logs/$domain.log"
ERRFILE="/etc/nginx/logs/$domain.err"
void=""
mkdir -p /etc/nginx/logs

#// WEB SERVER SCRIPT

mkdir -p /var/www/"$domain"/html
echo -e "<h1>Sitio web de "$user"</h1>" > /var/www/"$domain"/html/index.html

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/"$domain".key -out /etc/ssl/certs/"$domain".crt <<EOF >>$LOGFILE 2>$ERRFILE
$countryname
$statename
$city
$companyname
$unitname
$domain
$email
EOF

echo -e "
server {
        listen 443 ssl;
        listen [::]:443 ssl;

        ssl_certificate /etc/ssl/certs/$domain.crt;
        ssl_certificate_key /etc/ssl/private/$domain.key;
        include snippets/ssl-params.conf;

        root /var/www/$domain/html;
        index index.html index.htm index.nginx-debian.html;
        server_name $domain     www.$domain;

        location / {
                try_files \$uri \$uri/ =404;
        }
}
server {
        listen 80;
        listen [::]:80;
        server_name $domain www.$domain;
        return 302 https://\$server_name\$request_uri;
}
" >> /etc/nginx/sites-available/$domain

cp /etc/nginx/sites-available/"$domain" /etc/nginx/sites-enabled/"$domain"

nginx -t >>$LOGFILE 2>$ERRFILE
systemctl restart nginx.service >>$LOGFILE 2>$ERRFILE


#// SFTP ACCESS SCRIPT

useradd "$user"
echo "$user:$passwd" | chpasswd

echo -e "Match Group $user
\tX11Forwarding no
\tAllowTcpForwarding no
\tPermitTTY no
\tForceCommand internal-sftp
\tPasswordAuthentication yes
\tChrootDirectory /var/www/$domain
\tPermitTunnel no
\tAllowAgentForwarding no" >> /etc/ssh/sshd_config

chmod 755 /var/www/"$domain"
chmod 775 /var/www/"$domain"/html
chown -R root:"$user" /var/www/"$domain"

systemctl restart sshd
