#!/bin/bash
dir='/zbackup/mysql/backup/'
passwd='xxx'
cd $dir
#day of week (1..7); 1 is Monday,Backup data for one week
days=$(date +%u)
mysqldump -uroot -p$passwd --all-databases |  gzip > ${days}.sql.gz
