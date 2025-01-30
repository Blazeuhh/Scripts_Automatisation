function Show-Menu {
    param (
        [string]$Title = @"
 ____                         _        
|  _ \ ___  _ __   __ _ _ __ ( )___    
| |_) / _ \| '_ \ / _` | '_ \|// __|   
|  _ < (_) | | | | (_| | | | | \__ \   
|_| \_\___/|_| |_|\__,_|_| |_| |___/   
     _____           _ _               
    |_   _|__   ___ | | |__   _____  __
      | |/ _ \ / _ \| | '_ \ / _ \ \/ /
      | | (_) | (_) | | |_) | (_) >  < 
      |_|\___/ \___/|_|_.__/ \___/_/\_\
    
"@
    )
    cls 
    Write-Host "=====================================" -ForegroundColor Blue
    Write-Host " $Title" -ForegroundColor Blue
    Write-Host "=====================================" -ForegroundColor Blue
    Write-Host "1. Diagnostic de protocole réseau"
    Write-Host "2. Voir les caches ARP (arp -a)"
    Write-Host "3. Diagnostic complet des disques"
    Write-Host "4. Redémarrer une carte réseau (admin requis)"
    Write-Host "5. Diagnostic complet du PC"
    Write-Host "6. Diagnostic des services Windows"
    Write-Host "7. Diagnostic des événements système"
    Write-Host "8. Diagnostic du CPU et de la RAM" 
    Write-Host "0. Quitter"
}

function Network-Protocol-Diagnostic {
    $protocols = @("TCP", "UDP", "ICMP", "HTTP", "HTTPS", "Kerberos", "SSH")
    $protocol = Read-Host "Veuillez spécifier le protocole (TCP, UDP, ICMP, HTTP, HTTPS, Kerberos, SSH)"

    if ($protocols -contains $protocol) {
        switch ($protocol) {
            "TCP" {
                Write-Host "`nDiagnostic des connexions TCP en cours..."
                netstat -an | Select-String "TCP"
            }
            "UDP" {
                Write-Host "`nDiagnostic des connexions UDP en cours..."
                netstat -an | Select-String "UDP"
            }
            "ICMP" {
                $target = Read-Host "Veuillez entrer l'adresse IP ou le nom de domaine à tester"
                Write-Host "`nDiagnostic ICMP en cours..."
                ping $target
            }
            "HTTP" {
                $url = Read-Host "Veuillez entrer l'URL à tester (e.g., http://example.com)"
                Write-Host "`nDiagnostic HTTP en cours..."
                try {
                    Invoke-WebRequest -Uri $url -UseBasicParsing
                    Write-Host "Connexion HTTP réussie."
                } catch {
                    Write-Host "Échec de la connexion HTTP."
                }
            }
            "HTTPS" {
                $url = Read-Host "Veuillez entrer l'URL à tester (e.g., https://example.com)"
                Write-Host "`nDiagnostic HTTPS en cours..."
                try {
                    Invoke-WebRequest -Uri $url -UseBasicParsing
                    Write-Host "Connexion HTTPS réussie."
                } catch {
                    Write-Host "Échec de la connexion HTTPS."
                }
            }
            "Kerberos" {
                Write-Host "`nDiagnostic Kerberos en cours..."
                klist
            }
            "SSH" {
                $sshTarget = Read-Host "Veuillez entrer l'adresse IP ou le nom de domaine du serveur SSH"
                Write-Host "`nTest de la connexion SSH en cours..."
                $sshTest = Test-NetConnection -ComputerName $sshTarget -Port 22
                if ($sshTest.TcpTestSucceeded) {
                    Write-Host "Connexion SSH réussie à $sshTarget sur le port 22."
                } else {
                    Write-Host "Échec de la connexion SSH à $sshTarget."
                }
            }
        }
    } else {
        Write-Host "Protocole invalide. Veuillez réessayer."
    }
}

function Show-ARP-Cache {
    Write-Host "Affichage des caches ARP..."
    arp -a
}

function Disk-Diagnostic {
    Write-Host "====================================="
    Write-Host "   Diagnostic complet des disques   "
    Write-Host "====================================="

    # Affichage des informations sur les disques physiques
    Write-Host "`nDisques physiques :"
    $physicalDisks = Get-PhysicalDisk
    if ($physicalDisks) {
        $physicalDisks | Format-Table DeviceID, FriendlyName, MediaType, OperationalStatus, HealthStatus, @{Name="Size(GB)"; Expression={[math]::round($_.Size / 1GB, 2)}} -AutoSize
    } else {
        Write-Host "Aucun disque physique détecté."
    }

    # Affichage des informations sur les volumes logiques
    Write-Host "`nVolumes logiques :"
    $volumes = Get-Volume
    if ($volumes) {
        $volumes | Format-Table DriveLetter, FileSystem, @{Name="Size(GB)"; Expression={[math]::round($_.Size / 1GB, 2)}}, @{Name="Size Remaining(GB)"; Expression={[math]::round($_.SizeRemaining / 1GB, 2)}} -AutoSize
    } else {
        Write-Host "Aucun volume logique détecté."
    }
}

function Restart-Network-Adapter {
    # Récupérer les adaptateurs réseau dont le statut est "Up"
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

    # Vérifier si des adaptateurs sont trouvés
    if ($adapters) {
        # Afficher la liste des adaptateurs actifs
        Write-Host "Cartes réseau actives :"
        $adapters | ForEach-Object { Write-Host "$($_.Name) - $($_.Status)" }

        # Demander à l'utilisateur de choisir un adaptateur à redémarrer
        $adapterName = Read-Host "Entrez le nom de la carte réseau à redémarrer"

        # Vérifier si l'adaptateur existe parmi ceux actifs
        $selectedAdapter = $adapters | Where-Object { $_.Name -eq $adapterName }
        if ($selectedAdapter) {
            Write-Host "Redémarrage de la carte réseau $adapterName en cours..."

            # Désactiver l'adaptateur
            Disable-NetAdapter -Name $adapterName -Confirm:$false
            Start-Sleep -Seconds 2

            # Réactiver l'adaptateur
            Enable-NetAdapter -Name $adapterName -Confirm:$false
            Write-Host "Carte réseau $adapterName redémarrée avec succès."
        } else {
            Write-Host "L'adaptateur spécifié '$adapterName' n'a pas été trouvé dans la liste des cartes actives."
        }
    } else {
        Write-Host "Aucune carte réseau active détectée."
    }
}

function Get-SystemInfo {
    Write-Host "Récupération des informations système..."
    $computerName = $env:COMPUTERNAME
    $os = Get-CimInstance Win32_OperatingSystem
    $bios = Get-CimInstance Win32_BIOS
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

    Write-Host "`nInformations Système :"
    Write-Host "-------------------------------------"
    Write-Host "Nom du poste : $computerName"
    Write-Host "Version de l'OS : $($os.Caption) - Version $($os.Version) ($($os.BuildNumber))"
    Write-Host "Version du BIOS : $($bios.Manufacturer) - $($bios.SMBIOSBIOSVersion)"
    Write-Host "Dernier redémarrage : $($os.LastBootUpTime)"
    Write-Host "Compte administrateur : $(if ($isAdmin) {'Oui'} else {'Non'})"
}

function Services-Diagnostic {
    Write-Host "Diagnostic des services Windows en cours..."
    Get-Service | Format-Table Name, DisplayName, Status
}

function System-Events-Diagnostic {
    Write-Host "Diagnostic des événements système en cours..."
    Get-EventLog -LogName System -Newest 10 | Format-Table EventID, Source, EntryType, Message, TimeGenerated
}

function System-Performance-Diagnostic {
    Write-Host "====================================="
    Write-Host " Diagnostic complet du CPU et de la RAM "
    Write-Host "====================================="

    # Diagnostic du CPU
    Write-Host "`nInformations sur le CPU :"
    $cpu = Get-WmiObject Win32_Processor
    $cpu | Format-Table Name, Manufacturer, MaxClockSpeed, NumberOfCores, NumberOfLogicalProcessors -AutoSize

    # Utilisation actuelle du CPU
    $cpuUsage = Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor
    $cpuUsage | Where-Object { $_.Name -eq "_Total" } | Format-Table Name, PercentProcessorTime -AutoSize

    # Diagnostic de la RAM
    Write-Host "`nInformations sur la RAM :"
    $ram = Get-WmiObject Win32_PhysicalMemory
    $ram | Format-Table Manufacturer, Capacity, Speed, MemoryType -AutoSize

    # Utilisation actuelle de la RAM
    $ramUsage = Get-WmiObject Win32_OperatingSystem
    $ramUsage | Format-Table TotalVisibleMemorySize, FreePhysicalMemory, TotalVirtualMemorySize, FreeVirtualMemory -AutoSize
}

function Pause {
    Read-Host -Prompt "Appuyez sur Entrée pour continuer..."
}

do {
    Show-Menu
    $choice = Read-Host "Choisissez une option"

    switch ($choice) {
        1 { Network-Protocol-Diagnostic }
        2 { Show-ARP-Cache }
        3 { Disk-Diagnostic }
        4 { Restart-Network-Adapter }
        5 { Get-SystemInfo }
        6 { Services-Diagnostic }
        7 { System-Events-Diagnostic }
        8 { System-Performance-Diagnostic } 
        0 { Write-Host "Au revoir!" }
        default { Write-Host "Option invalide. Veuillez réessayer." }
    }

    if ($choice -ne 0) { Pause }
} while ($choice -ne 0)
