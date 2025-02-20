# Задания
1. Мониторинг. Дашборды должны быть публичными
  - Дашборд активности пользователей в юпитер (количество операций в день)
  - Дашборд по топовым тетрадкам (сколько подъедают)
  - Дашборд топовых таблиц в постресе с их владельцами
2. Алерты
  - Настроить алерт при заходе пользователя на сервер по ssh на почту.
  - Настроить почтовый алерт при потребление общим количеством контейнеров мощности более чем на 80 % - алертить.

## Мониторинг
- [Дашбород активности пользователей JupyterHub](https://grafana.story-tech.ru/public-dashboards/68f835b78d6848d5bde2eda44bf77863)
  Реализация через прямой сбор метрик с юпитерхаба прометеусом.
- [Дашбород топовых тетрадок(по размеру) юпитер ноутбуков](https://grafana.story-tech.ru/public-dashboards/58614ae327a4487aa84d6dc0192b7c2a)
  реализовано с помощью [баш скрипта](./check_volumes.sh), который записывает данные контейнеров юпитер ноутбуков. Обновление данных через крон, сбор с помощью нод экспортера, прометеуса и вывод в графану.
- [Дашборд топовых таблиц постгрес с их владельцами](https://grafana.story-tech.ru/public-dashboards/034c81d55254466caf571622cbafd515)
  реализация через прямое подключение постгреса в графану и запросы в постгрес. Также есть график с таймлайном, который берет данные с кадвизора, но кадвизор не отдает владельцев таблиц, их можно подсмотреть в соседней таблице или графике.


## Алерт вход по ssh
 - реализовано с использованием postfix, pam.d и bash скрипта
 
Устанавливаем mailutils, который включает в себя postfix
```
sudo apt install mailutils
```
настраиваем данные сервера и аутентификации в файле postfix/main.cf
```
sudo nano /etc/postfix/main.cf
```
```
relayhost = [smtp.mail.ru]:465
smtp_tls_wrappermode = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt  
smtp_use_tls = yes                 #мыло.ру приходится использовать с тлс
smtp_tls_security_level = encrypt
```
настраиваем логин и пароль в файле postfix/sasl_passwd
```
[smtp.mail.ru]:465 emaillogin:password
```
устанавливаем доступ к данным логина и пароля только для рута
```
sudo chmod 600 /etc/postfix/sasl_passwd
```
перезапускаем postfix
```
sudo systemctl restart postfix
```
Настраиваем запуск [нашего скрипта](./ssh_alert.sh) при входе по ssh

Открываем в редакторе конфиг pam ssh
```
sudo nano /etc/pam.d/sshd 
```
добавляем в него следующую строку
```
session    required   pam_exec.so /"путь к каталогу со скриптом"/ssh_alert.sh
```
Результат при авторизации по ssh на почте

![alert_container](img/ssh_alert.png)

## Алерт использования процессора контейнерами выше 80%
- Реализовано с помощью prometheus, alertmanager и cadvisor

Настраиваем алерт в прометеусе [alert.yml](./prometheus_stack/prometheus/alert.yml)
Настраиваем данные почты для отправки по smtp в [alertmanager](./prometheus_stack/alertmanager/alertmanager.yml.examle)

результат в прометеусе

![alert_container](img/alert_container_cpu_usage.png)

алерт на почте

![alert_container_mail](img/alert_container_cpu_usage_mail.png)
