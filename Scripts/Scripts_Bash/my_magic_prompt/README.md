# Terminal Ronan - Interface Bash Interactive 🚀

Bienvenue dans **Terminal Ronan**, une interface en ligne de commande personnalisée développée en Bash, avec un système d’authentification, des alias de commandes, et une structure modulaire.

---

## 🧠 Fonctionnalités

- 🔐 Authentification sécurisée (login/mot de passe)
- 🧩 Chargement dynamique des fonctions depuis les fichiers `.sh`
- 🧭 Interface interactive ligne par ligne avec horodatage
- 🛠️ Alias personnalisés pour diverses commandes systèmes
- 📡 Support des commandes réseau (HTTP GET, SMTP GET)
- ❓ Aide intégrée (`help`)

---

## 🚀 Démarrage rapide

1. **Placez vos fichiers fonctionnels** (`*.sh` sauf `main.sh`) dans le même dossier.
2. Rendez `main.sh` exécutable :
   ```bash
   chmod +x main.sh
````

3. Lancez le terminal :

   ```bash
   ./main.sh
   ```

---

## 🔑 Authentification

À l'exécution, le script demande :

* **Login** : `ronan`
* **Mot de passe** : `test`

Les identifiants sont codés en dur (modifiable dans `main.sh` à la fonction `authentifier`).

---

## 🧾 Commandes disponibles

| Alias            | Commande   | Description                   |
| ---------------- | ---------- | ----------------------------- |
| `ls` / `list`    | `ls2`      | Liste les fichiers            |
| `abt` / `about`  | `about2`   | Affiche les infos système     |
| `age`            | `age2`     | Calcule l'âge                 |
| `cd`             | `cd2`      | Change de répertoire          |
| `help`           | `help2`    | Affiche l'aide                |
| `opn` / `open`   | `open2`    | Ouvre un fichier ou dossier   |
| `passwd`         | `passwd2`  | Change le mot de passe        |
| `profil`         | `profil2`  | Affiche le profil utilisateur |
| `pwd`            | `pwd2`     | Affiche le répertoire courant |
| `rm` / `remove`  | `rm2`      | Supprime un fichier           |
| `rmdir`          | `rmdir2`   | Supprime un dossier           |
| `version`, `--v` | `version2` | Affiche la version du script  |
| `hour`           | `hour2`    | Affiche l’heure courante      |
| `httpget`        | `httpget2` | Récupère une page web         |
| `smtpget`        | `smtp2`    | Reçoit des données par SMTP   |
| `quit` / `exit`  | `quit2`    | Ferme le terminal             |

> Tous les alias appellent des fonctions de type `nom2()` à implémenter dans des fichiers `.sh` à part.

---

## 📁 Structure recommandée

```
.
├── main.sh         # Script principal (interface et logique)
├── ls.sh           # Contient la fonction ls2()
├── about.sh        # Contient la fonction about2()
├── ...
```

---

## 🧪 Exemple d'ajout de commande

Pour ajouter une nouvelle commande `ping` :

1. Crée `ping.sh`
2. Déclare la fonction :

   ```bash
   ping2() {
       ping -c 4 "$1"
   }
   ```
3. Ajoute dans le `case` de `main.sh` :

   ```bash
   ping ) ping2 "$@";;
   ```

---

## 📜 Licence

Ce projet est libre, personnel et éducatif. Tu es libre de le modifier, distribuer et améliorer.

---

## 🤝 Contribuer

N'hésite pas à forker le projet ou proposer des améliorations pour le rendre encore plus fun et utile !

---

👨‍💻 *Créé avec ❤️ par Monsieur GPT*


