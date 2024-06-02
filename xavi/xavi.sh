#!/bin/bash

function pdispcat(){
    cat programas.txt | grep "@" | awk '{print $2, $3}'

}
function lavado(){
   clear
   echo -e "Que progarma quieres ejecutar?"
   read -p ">" programa
   case programa in
        0)
        pdispcat
        echo -e "Presiona [Enter para salir]:"
        read a
        break
        ;;
        1)
        lavado
    esac
}

#function atiempo(){
#    
#}
#
#function centri(){
#    
#}

read -p "Select:" selections

while true; do
    case selection in
        0)
        pdispcat
        echo -e "Presiona [Enter para salir]:"
        read a
        break
        ;;
        1)
        lavado
    esac
done

