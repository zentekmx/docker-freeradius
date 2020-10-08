#!/bin/sh

/wait-for.sh ${DB_HOST}:${DB_PORT} -t ${TIMEOUT} || exit
if [ "${RAD_DEBUG}" = "yes" ]
  then
    [ ! -f /bootstrapped ] && mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} -P${DB_PORT} -D${DB_NAME} -e "source testusers.sql"
    touch /bootstrapped
    /usr/sbin/radiusd -X -f -d /etc/raddb
  else
    /usr/sbin/radiusd -f -d /etc/raddb
fi
