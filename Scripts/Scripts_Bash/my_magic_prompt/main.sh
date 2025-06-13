#!/bin/bash

# Importation des fonctions depuis les fichiers .sh

for file in *.sh; do
    if [[ "$file" != "main.sh" ]]; then
        source "./$file"
    fi
done

# Fonction d'authentification

authentifier() {
    local LOGIN_ATTENDU="ronan"
    local MDP_ATTENDU="test"

    echo -n "Login : "
    read login

    echo -n "Mot de passe : "
    read -s mdp
    echo ""

    if [[ "$login" == "$LOGIN_ATTENDU" && "$mdp" == "$MDP_ATTENDU" ]]; then
        echo "Authentification réussie. Bienvenue, $login !"
    else
        echo "Identifiants incorrects. Accès refusé."
        exit 1
    fi
}

authentifier

# Fonction pour exécuter les commandes
cmd(){
  cmd=$1
  argument=$@
  shift

  case "${cmd}" in
    ls | list ) ls2 "$@";;
    abt | about ) about2 "$@";;
    age ) age2 "$@";;
    cd | changedirectory ) cd2 "$@";;
    help ) help2 "$@";;
    opn | open ) open2 "$@";;
    passwd ) passwd2 "$@";;
    profil ) profil2 "$@";;
    pwd ) pwd2 "$@";;
    rm | remove ) rm2 "$@";;
    rmdir ) rmdir2 "$@";;
    version | --v | vers ) version2 "$@";;
    hour ) hour2 "$@";;
    httpget ) httpget2 "$@";;
    smtpget ) smtp2 "$@";;
    quit | exit ) quit2 "$@";;
    * ) echo "404 : Command Not Found :/" "$@";;
  esac
}

# Fonction pour customiser le cmd
main() {
  lineCount=1

  while [ 1 ]; do
    date=$(hour3)
    echo -ne "${date} - [\033[36m${lineCount}\033[0m] - \033[33mRonan\033[m ~ 🤓 ~ "
    read string

    cmd $string
    lineCount=$(($lineCount+1))
  done
}

main


