#!/bin/bash

function pdispcat(){
    cat programas.txt | grep -A 1000 '^@' | awk '/^@/ {if (NR != 1) print ""; print; next} {print}'

}
#function lavado(){
#    
#}
#
#function atiempo(){
#    
#}
#
#function centri(){
#    
#}

read -p "Select:" selections
case selection in
    0)
    pdispcat
    ;;
esac
