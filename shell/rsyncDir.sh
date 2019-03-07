#!/usr/bin/env bash
##rsync local dir to remote dir
##with inotify
DESTHOST=$1
DESTHOSTDIR=$2
SRCDIR=$3
##first rsync
rsync -avz $SRCDIR root@${DESTHOST}:${DESTHOSTDIR} &>/dev/null

inotifywait -mr --timefmt '%d/%m/%y %H:%M' --format '%T %w %f'  \
-e create,delete,modify,attrib \
--exclude=".*.swp" $SRCDIR >> /var/log/inotify/wait.log &

while true; do
    if [[ -s "/var/log/inotify/wait.log" ]]; then
        rsync -avz --delete --exclude="*.swp" --exclude="*.swx" $SRCDIR root@${DESTHOST}:${DESTHOSTDIR} &>/dev/null 
        if [[ $? -ne 0 ]]; then
            echo "$SRCDIR sync to $SRCDIR on ${DESTHOSTDIR} at `date +"%F %T"`,please check it by manual" |\
            mail -s "inotify+Rsync error has occurred" root@localhost
        fi
        cat /dev/null > /var/log/inotify/wait.log
        rsync -avz --delete --exclude="*.swp" --exclude="*.swx" $SRCDIR root@${DESTHOST}:${DESTHOSTDIR} &>/dev/null            
    else
        sleep 1
    fi
done
