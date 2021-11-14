#Questo script crea un redirect di una porta verso un altro ip, con netsh.
#Sblocca inoltre la porta aggiungendo una regola a windows firewall
Write-Host "
PORT REDIRECT script 
uso: port_redirect PORTA IP
"
$porta = $args[0]
$ip_destinazione = $args[1]
If (( $porta -eq $null ) -or ( $ip_destinazione -eq $null )) {
       $porta = Read-Host -Prompt "Seleziona il numero di porta" 
	   echo ""
	   $ip_destinazione = Read-Host -Prompt "Seleziona l'ip di destinazione" 
	   echo ""
    }
If (($porta -ne $null ) -and ($ip_destinazione -ne $null )) {
        Write-Host "
		Conferma opzioni:
		+-------------++-------------------------++--------------
		| Porta di destinazione 	||  $porta				 
		| IP di destinazione		||  $ip_destinazione	
		+-------------++-------------------------++-------------- 
		"
		$Answer = Read-Host -Prompt "Confermare le impostazioni?"
		If (( $Answer -eq "n" ) -or ( $Answer -eq "no" ) -or ( $Answer -eq "N" ) -or ( $Answer -eq "No" )) {
        exit
		}
		If (($Answer -eq "y" ) -or ($Answer -eq "yes" ) -or ($Answer -eq "Y" ) -or ($Answer -eq "Yes" ) -or ($Answer -eq "si" ) -or ($Answer -eq "Si" ) -or ($Answer -eq "SI" ) ) {
        New-NetFirewallRule -Name in_redirectPorta$porta -DisplayName "Redirect porta $porta" -Direction Inbound -Protocol tcp -LocalPort "$porta" -Action Allow -Enabled True
		New-NetFirewallRule -Name out_redirectPorta$porta -DisplayName "Redirect porta $porta" -Direction Outbound -Protocol tcp -LocalPort "$porta" -Action Allow -Enabled True
		netsh interface portproxy add v4tov4 listenport=$porta connectport=$porta connectaddress=$ip_destinazione
		Invoke-FirewallRules
		}
	}
	