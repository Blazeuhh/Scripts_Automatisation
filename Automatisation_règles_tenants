# Importer le module Exchange Online Management
Import-Module ExchangeOnlineManagement

# Connexion à Exchange Online
Connect-ExchangeOnline

# Demander les informations à l'utilisateur
$code = Read-Host "Entrez le code à inclure dans l'en-tête du message"
$AllowedSenderIpRanges = Read-Host "Entrez les plages IP autorisées, séparées par des virgules (ex: 192.168.1.1,192.168.1.2)"
$activationDate = Read-Host "Entrez la date d'activation de la règle (format: MM/JJ/AAAA X:XX PM/AM)"
$deactivationDate = Read-Host "Entrez la date de désactivation de la règle (format: MM/JJ/AAAA X:XX PM/AM)"

# Convertir les plages IP en un tableau
$AllowedSenderIpRangesArray = $AllowedSenderIpRanges -split ','

# Création de la règle de transport
New-TransportRule -Name "X-SECURE-EMAIL" `
-HeaderContainsMessageHeader "X-USECURE-EMAIL" `
-HeaderContainsWords $code `
-SenderIpRanges $AllowedSenderIpRangesArray `
-SetSCL "-1" `
-SetHeaderName "X-MS-Exchange-Organization-BypassClutter" `
-SetHeaderValue "true" `
-Mode Enforce `
-ActivationDate $activationDate `
-ExpiryDate $deactivationDate 

# Afficher les instructions pour la planification des tâches
Write-Host "La règle de transport a été créée avec succès."

# Demander les informations à l'utilisateur
$AllowedDomains = Read-Host "Entrez les domaines autorisés, séparés par des virgules (ex: domaine1.com,domaine2.com)"
$AllowedUrls = Read-Host "Entrez les URLs à autoriser, séparées par des virgules (ex: https://site1.com,https://site2.com/*)"
$AllowedSenders = Read-Host "Entrez les adresses email à autoriser (ex : no-reply@microsoft.fr,support@amaz0n.com)"
$ExpirationChoice = Read-Host "Voulez-vous définir une date d'expiration pour les URLs ? (oui/non)"

# Transformation des données en tableaux
$AllowedDomainsArray = $AllowedDomains -split ","
$AllowedSenderIpRangesArray = $AllowedSenderIpRanges -split ','
$AllowedUrlsArray = $AllowedUrls -split ","
$AllowedSendersRanges = $AllowedSenders -split ","

# Définir la date d'expiration si souhaité
$ExpirationDate = $null
if ($ExpirationChoice -eq "oui") {
    $ExpirationDate = Read-Host "Entrez la date d'expiration (format: MM/jj/aaaa)"
}

# Supprimer la règle existante si elle existe
$ExistingRule = Get-ExoPhishSimOverrideRule -PolicyName "PhishSimOverridePolicy" -ErrorAction SilentlyContinue
if ($ExistingRule) {
    Remove-ExoPhishSimOverrideRule -Identity $ExistingRule.Identity -Confirm:$false
    Write-Host "Ancienne règle supprimée avec succès."
}

# Créer une nouvelle règle avec les domaines et IPs
New-ExoPhishSimOverrideRule `
    -Policy PhishSimOverridePolicy `
    -Domains $AllowedDomainsArray `
    -SenderIpRanges $AllowedSenderIpRangesArray

Write-Host "Nouvelle règle créée avec succès pour les domaines et plages IP."

# Ajouter les URLs autorisées
if ($AllowedUrlsArray.Count -gt 0) {
    if ($ExpirationDate) {
        New-TenantAllowBlockListItems -Allow -ListType Url -ListSubType AdvancedDelivery -Entries $AllowedUrlsArray -ExpirationDate $ExpirationDate
    } else {
        New-TenantAllowBlockListItems -Allow -ListType Url -ListSubType AdvancedDelivery -Entries $AllowedUrlsArray -NoExpiration
    }
    Write-Host "Les URLs suivantes ont été ajoutées à la liste d'autorisation:"
    $AllowedUrlsArray | ForEach-Object { Write-Host " - $_" }
} else {
    Write-Host "Aucune URL à autoriser n'a été fournie."
}

# Mettre à jour la politique d'anti-spam
Set-HostedConnectionFilterPolicy -Identity Default -IPAllowList @{Add = $AllowedSenderIpRangesArray}
Set-HostedContentFilterPolicy -Identity Default -AllowedSenderDomains @{Add = $AllowedDomainsArray} -AllowedSenders @{Add = $AllowedSendersRanges}


Write-Host "La politique d'anti-spam '$ConnectionFilterPolicyName' a été mise à jour avec les plages IP autorisées."
