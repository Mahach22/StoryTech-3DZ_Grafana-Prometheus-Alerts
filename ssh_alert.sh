#!/bin/sh

# Email Information
RECIPIENT="mahach2211@gmail.com"
SUBJECT="⚠️Обнаружен вход на сервер `uname -n` по ssh⚠"
FROM="gad000@bk.ru"

BODY="<html>
<head>
    <meta charset='UTF-8'>
</head>
<body>
    <p><b>Информация о входе на сервер:</b></p>
    <table style='border-collapse: collapse; width: auto;'>
        <tr><td style='text-align: left; padding-right: 5px;'>Имя сервера:</td> <td><b>`uname -n`</b></td></tr>
        <tr><td style='text-align: left; padding-right: 5px;'>Использованная учетная запись:</td> <td><b>$PAM_USER</b></td></tr>
        <tr><td style='text-align: left; padding-right: 5px;'>IP-адрес, с которого подключились:</td> <td><b>$PAM_RHOST</b></td></tr>
        <tr><td style='text-align: left; padding-right: 5px;'>Дата:</td> <td><b>`date`</b></td></tr>
    </table>
</body>
</html>"






if [ "${PAM_TYPE}" = "open_session" ]; then
    echo "$BODY" | mailx -a "Content-Type: text/html; charset=UTF-8" -s "$SUBJECT" -r "$FROM" "$RECIPIENT"
fi

exit 0
