#!/bin/bash

set -e

usage() {
    echo >&2 "$@"    
    exit 1
}

[ "$#" -eq 1 ] || usage "usage: ./sync.sh [PDF]"

# TODO handle path other than current directory

ATTACHMENT_FILE="$1"

ATTACHMENT_DATA="$(cat $ATTACHMENT_FILE | base64)"
BOUNDARY="B=-=-=-=-==-"
DT=$(date '+%Y%m%d-%H%M%S')
# eg. shane@digitalsanctum.com
FROM_EMAIL=""
# eg. Shane Witbeck
FROM_NAME=""
# eg. digitalsanctum.com
SENDING_DOMAIN=""
SMTP_HOST="${AWS_SES_SMTP_SERVER}:465"
# your @kindle.com email address
TO_EMAIL=""

MSG_ATTACHMENT=$(cat <<- END
EHLO ${SENDING_DOMAIN}
AUTH LOGIN
${AWS_SES_SMTP_USER_B64}
${AWS_SES_SMTP_PASS_B64}
MAIL FROM: ${FROM_EMAIL}
RCPT TO: ${TO_EMAIL}
DATA
From: ${FROM_NAME} <${FROM_EMAIL}>
To: ${TO_EMAIL}
Subject: Amazon SES SMTP Test
Content-Type: multipart/mixed; boundary="${BOUNDARY}"

--${BOUNDARY}
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

This message was sent using kindle-sync.

--${BOUNDARY}
Content-Type: application/pdf; name="${ATTACHMENT_FILE}"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="${ATTACHMENT_FILE}";

${ATTACHMENT_DATA}


--${BOUNDARY}

.
QUIT
END
)

MSG_FILE="${DT}-msg.txt"
echo "$MSG_ATTACHMENT" | tee $MSG_FILE

openssl s_client -crlf -quiet -connect ${SMTP_HOST} < ${MSG_FILE}
