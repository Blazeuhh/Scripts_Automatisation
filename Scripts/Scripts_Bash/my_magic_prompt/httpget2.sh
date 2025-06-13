httpget2() {
    read -p "Entrez l'URL de la page web : " url
    read -p "Entrez le nom du fichier de sortie (ex: page.html) : " fichier

    if [[ -z "$url" || -z "$fichier" ]]; then
        echo "Erreur : URL ou nom de fichier vide."
        return 1
    fi
    
    echo "Téléchargement de $url dans $fichier..."
    curl -s "$url" -o "$fichier"

    if [[ $? -eq 0 ]]; then
        echo "Fichier enregistré sous : $fichier"
    else
        echo "Échec du téléchargement."
    fi
}