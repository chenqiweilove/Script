#!/bin/bash
##del ES index from DEFAULT_DATE ago,and keep 5 days or less
DEFAULT_DATE=55
DEL_DATE=`date -d '-'"50"'day' +%Y-%m-%d`
$IP='10.114.11.11'
$PORT='9200'
for ((c=5;c<=50;c++))
   do 
      LAST_DATE=$((${DEFAULT_DATE} - ${c})) 
      DATE=`date -d '-'"${LAST_DATE}"'day' +%Y-%m-%d`
      echo  "===========现在删除${DATE}日的ES的索引================"
           sleep 3 
       curl -XDELETE $IP:$PORT/crm-config-${DATE}
       curl -XDELETE $IP:$PORT/crm-zuul-${DATE}
       curl -XDELETE $IP:$PORT/crm-information-${DATE}
       curl -XDELETE $IP:$PORT/crm-production-${DATE}
       curl -XDELETE $IP:$PORT/crm-resource-${DATE}
       curl -XDELETE $IP:$PORT/crm-zipkin-${DATE}
       curl -XDELETE $IP:$PORT/crm-filemanager-a-${DATE}
       curl -XDELETE $IP:$PORT/crm-filemanager-b-${DATE}
       curl -XDELETE $IP:$PORT/crm-filemanager-c-${DATE}
       curl -XDELETE $IP:$PORT/crm-filemanager-d-${DATE}
       curl -XDELETE $IP:$PORT/crm-filemanager-e-${DATE}
  done

echo "=======================" 
echo    "执行完成"
echo "======================="

