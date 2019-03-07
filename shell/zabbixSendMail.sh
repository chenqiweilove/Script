#!/bin/bash
#dep sendmail
to=$1
subject=$2
body=$3
$mail=""
$passwd=""
/opt/sendEmail/sendEmail -f $mail -t "$to" -s smtp.163.com -u "$subject" \
-o message-content-type=html -o message-charset=utf8 -xu $mail \
-xp $passwd -m "$body" -o tls=auto
