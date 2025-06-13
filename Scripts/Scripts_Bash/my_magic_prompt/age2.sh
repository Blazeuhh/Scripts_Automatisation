age2(){
    read -p " Donnez-vous votre age :" age
    if [[ $age -lt 18 ]]; then
        echo "Vous êtes mineur"
    elif [[ $age -ge 18 && $age -lt 60 ]]; then
        echo "Vous êtes majeur"
    elif [[ $age -ge 60 ]]; then
        echo "Vous êtes senior"
    else
        echo "Âge invalide"
    fi
}