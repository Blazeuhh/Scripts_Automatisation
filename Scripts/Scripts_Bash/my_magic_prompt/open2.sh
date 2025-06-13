open2() {
    if [ -z "$1" ]; then
        echo "Veuillez spécifier un nom de fichier."
        return 1
    fi

    vim "$1"
}
