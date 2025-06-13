smtp2() {
    read -p "Destinataire : " destinataire
    read -p "Objet : " objet
    read -p "Texte : " corps
    (echo "Subject: $objet"
    echo
    echo "$corps"
    echo
    ) | ssmtp -v "$destinataire"
}