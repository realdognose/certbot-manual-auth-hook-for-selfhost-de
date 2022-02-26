# certbot-manual-auth-hook-for-selfhost-de
Manual auth hook plugin for certbot for the german domain-hoster selfhost.de

Documentation on german, as it is a hoster most likely used by german speaking people :) 

---

Selfhost.de ist ein Anbieter für Domänen. Leider bietet selfhost noch keinen nativen Support
für automatische certbot renewals an. Wer jedoch gerne ein wildcard-certifikat von letsencrypt.org
hätte muss die validierung über eine dns-challenge durchführen (acme-challenge) und benötigt daher
für die automatische Verlängerung bzw. Neu beantragung ein auth-plugin um den dns eintrag automatisiert
zu setzen. 

Die webseite des hosters selfhost.de ist sehr "überschaubar" aufgebaut und hat sich in vielen Jahren nicht
verändert - sie funktioniert halt einfach. Das Auth-Script stützt sich daher lediglich auf die automatisierung
der notwendigen GET und POST Requests um den acme-challenge txt-eintrag zu erzeugen. 

Das Skript ansich ist in PHP geschrieben, kann daher sowohl unter linux als auch unter windows eingesetzt werden. 
Für Windows müsste man lediglich die sh-dateien durch entsprechende bat-dateien ersetzen. 

Der Ablauf ist im Prinzip der folgende: 

 - Session-Token von selfhost.de besorgen
 - Mit Kundendaten einloggen.
 - GET-Request senden um Domain-ID zu ermitteln.
 - POST-Request senden um challenge zu erstellen. 

Cleanup:

- GET-Request senden um eintrags ID zu ermitteln.
- GET-Requests senden um acme-challenge einträge wieder zu löschen. 

über das linux ssmtp packet schicke ich mir noch emails wenn eine erneuerung versucht wird, und das Ergebnis. 
Wer das Skript gerne noch etwas hinsichtlich error-handling erweitern möchte oder eines der TODOs übernehmen möchte,#
gerne einen pull-request erstellen. 

# TODOS:
- Batchdateien für Windows
- email, timeouts, wartezeit parametriesierbar gestalten.

---
# Benutzung:

benötigt: certbot / ssmtp / php.

- script nach /etc/selfhosthook auschecken, Login-Daten hinterlegen. 

> git clone https://github.com/realdognose/certbot-manual-auth-hook-for-selfhost-de.git /etc/selfhosthook

- kopiert die selfhost-credentials z.b. nach /usr/share/ und passt die Rechte an. Login Daten eintragen.

> mv /etc/selfhosthook/selfhost-credentials.sh /usr/share/selfhost-credentials.sh

> chmod +x /usr/share/selfhost-credentials.sh

> chmod 700  /usr/share/selfhost-credentials.sh

- Scripte ausführbar machen

> chmod +x /etc/selfhosthook/selfhost-acme.sh

> chmod +x /etc/selfhosthook/selfhost-acme-cleanup.sh

> chmod +x /etc/selfhosthook/selfhost-acme-deploy.sh

- Erstmalig empfielt es sich ein zertifikat tatsächlich manuel zu beantragen, sodass die Benutzerdaten gespeichert sind. 

- Folgenden Befehl per crontab einmal täglich ausführen (hier um 2 Uhr nachts). Wenn das zertifikat nicht erneuert werden muss "steht" der certbot mit der Rückfrage ob es dennoch erneuert werden soll. Daher nutze ich (Wenn ich 3600s Zeit für das renewal einräume) einen timeout mit 3700 um den Vorgang abzubrechen. (kill nach 3710)  

> 0 2 * * * root timeout -k 3710 3700 certbot certonly --manual --preferred-challenges dns -d MEINE_DOMAIN.DE -d *.MEINE_DOMAIN.DE --manual-public-ip-logging-ok --manual-auth-hook /etc/selfhosthook/selfhost-acme.sh --manual-cleanup-hook /etc/selfhosthook/selfhost-acme-cleanup.sh

- Fertig.
