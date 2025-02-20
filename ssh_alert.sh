#!/bin/sh

# Your Email Information: Recipient (To:), Subject and Body
RECIPIENT="mahach2211@gmail.com"
SUBJECT="Email from your Server: SSH Alert"

BODY="
Вход по SSH прошел успешно, некоторая информация по безопасности:
        User:        $PAM_USER
	User IP Host: $PAM_RHOST
	Service:     $PAM_SERVICE
	TTY:         $PAM_TTY
	Date:        `date`
	Server:      `uname -a`
"

if [ ${PAM_TYPE} = "open_session" ]; then
	echo "${BODY}" | mail -s "$SUBJECT" -r gad000@bk.ru mahach2211@gmail.com
fi

exit 0


