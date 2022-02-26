#!/bin/bash
# Authentication Parameters
. /usr/share/selfhost-credentials.sh

# ##########################################################################
# ONLY Change stuff bellow this line, if you know what you are doing :-)
# ##########################################################################
CERTBOT_DOMAIN=$1

#resulting certificate name
filename=/etc/letsencrypt/live/$CERTBOT_DOMAIN/cert.pem

#check, if the certificate was renewed successfully or not. 
fileage=$(($(date +%s) - $(date +%s -r "$filename")))

# younger than an hour, so it worked. 
if [[ $fileage>=3600 ]] 
then

	echo "Renewal was successfull:
	
	Invoking Apache Service Restart." | mail -s "SUCCESS: SSL-Certificate-Renewal for ${CERTBOT_DOMAIN}" $MAIL_RECEIVER

	service apache2 restart
else
	echo "Renewal failed.
	" | mail -s "FAILED: SSL-Certificate-Renewal for ${CERTBOT_DOMAIN}" $MAIL_RECEIVER
fi