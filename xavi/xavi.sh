#!/bin/bash

funciton pdispcat(){
    cat programas.txt | grep -A 1000 '^@' | awk '/^@/ {if (NR != 1) print ""; print; next} {print}'

}
funciton lavado(){
    
}

funciton atiempo(){
    
}

funciton centri(){
    
}

read -p "Select:" selections
case selection in
    0)
    pdispcat
    ;;
esac
