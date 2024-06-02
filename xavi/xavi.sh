#!/bin/bash

function pdispcat(){
    cat programas.txt | grep "@" | awk '{print $2, $3}'

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
    *)
    pdispcat
    ;;
esac
