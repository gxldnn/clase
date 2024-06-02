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
        cat programas.txt | grep
        ;;
        1|[Ii][Nn][Tt][Ee][Nn][Ss][Oo])
        ;;
        2|[Ll][Aa][Nn][Aa])
        ;;
        *)
        echo -e "El programa no existe: Presiona Enter para salir..."

    esac
}

extract_program() {
  local program_name="$1"
  awk -v program="$program_name" '
  BEGIN { print_program = 0 }
  {
    if ($0 ~ "^@ " program) {
      print_program = 1
      next
    } 
    if ($0 ~ "^@ " && print_program) {
      print_program = 0
    }
    if (print_program) {
      print
    }
  }' "$FILE"
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
        extract_program "Programa suave""
        ;;

    esac
done

