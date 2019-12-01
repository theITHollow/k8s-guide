#!/bin/sh
SQLROOTPASS="Password123"
STS_REMOTESERVER="mysql-0.mysql" # container where writable SQL lives
POD_REMOTESERVER="hollowdb"
MYSQLPASS="Password123"
DATABASE="hollowapp"
USER="hollowapp"

#### Create Database
if [ "$DATABASE_URL" = "mysql+pymysql://hollowapp:Password123@mysql-0.mysql:3306/hollowapp"]; then
    mysql -h $STS_REMOTESERVER -uroot -e "CREATE DATABASE IF NOT EXISTS $DATABASE;"
    mysql -h $STS_REMOTESERVER -uroot -e "GRANT ALL PRIVILEGES ON $DATABASE.* TO '$USER'@'%' IDENTIFIED BY '$MYSQLPASS';"
    mysql -h $STS_REMOTESERVER -uroot -e "FLUSH PRIVILEGES;"
else
    mysql -h $POD_REMOTESERVER -uroot -p$SQLROOTPASS -e "CREATE DATABASE IF NOT EXISTS $DATABASE;"
    mysql -h $POD_REMOTESERVER -uroot -p$SQLROOTPASS -e "GRANT ALL PRIVILEGES ON $DATABASE.* TO '$USER'@'%' IDENTIFIED BY '$MYSQLPASS';"
    mysql -h $POD_REMOTESERVER -uroot -p$SQLROOTPASS -e "FLUSH PRIVILEGES;"
fi


#### Start App
source venv/bin/activate
while true; do
    flask db upgrade
    if [[ "$?" == "0" ]]; then
        break
    fi
    echo Upgrade command failed, retrying in 5 secs...
    sleep 5
done
flask translate compile
exec gunicorn -b :5000 --access-logfile - --error-logfile - taskapp:app