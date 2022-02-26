#!/bin/bash
# Authentication Parameters
. /usr/share/selfhost-credentials.sh

# ##########################################################################
# ONLY Change stuff bellow this line, if you know what you are doing :-)
# ##########################################################################
V1="Variables set by certbot"
V2="CERTBOT_DOMAIN: $CERTBOT_DOMAIN";
V3="CERTBOT_VALIDATION: $CERTBOT_VALIDATION";
V4="CERTBOT_TOKEN: $CERTBOT_TOKEN";
V5="CERTBOT_REMAINING_CHALLENGES: $CERTBOT_REMAINING_CHALLENGES";
V6="CERTBOT_ALL_DOMAINS: $CERTBOT_ALL_DOMAINS";

# call php script, pass the required ones. 
RESULT=$(php -f /etc/selfhosthook/selfhost-acme.php $SELFHOST_USER $SELFHOST_PASSWORD $SELFHOST_CUSTOMERNUMBER $CERTBOT_DOMAIN $CERTBOT_VALIDATION)

echo "$V1
$V2
$V3
$V4
$V5
$V6

Selfhost-Auth:
$RESULT

Sleeping 3600 seconds to give records time to propagate." | mail -s "STARTED: SSL-Certificate-Renewal for ${CERTBOT_DOMAIN}" $MAIL_RECEIVER

sleep 3600s