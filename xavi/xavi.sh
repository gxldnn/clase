#!/bin/bash

function pdispcat(){
    cat programas.txt | grep "@" | awk '{print $2, $3}'

}



function lavado(){
   clear
   echo -e "Que progarma quieres ejecutar?"
   read -p ">" programa
   case programa in
        0|[Ss][Uu][Aa][Vv][Ee])
        echo "### OK ejecutando ###"
        cat programas.txt | awk 'NR==1' | awk '{print $1}'
        ;;
        1|[Ii][Nn][Tt][Ee][Nn][Ss][Oo])j
        ;;
        2|[Ll][Aa][Nn][Aa])
        ;;
        *)
        echo -e "El programa no existe: Presiona Enter para salir..."

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
        ;;
        2)
        ;;

    esac
done

