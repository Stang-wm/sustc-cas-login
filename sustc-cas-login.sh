#!/bin/sh
# Usage: ./sustc-cas-login.sh [username] [password]

URL=`curl --head baidu.com 2> /dev/null | grep "Location: http://enet.10000.gd.cn" | sed 's/Location: //'`
if echo $URL | grep -q "http"
then
DATE=`date "+%Y-%m-%d %H:%M:%S"`
URL=`echo "$URL" | sed 's/\r$//g'`
echo "[$DATE] Logging..."
URL2="http://enet.10000.gd.cn:10001/sz/sz112/"`curl -L "${URL}" 2> /dev/null | grep "window.location" | sed -e 's/window.location = //' -e 's/;//' -e 's/\t//g' -e 's/["'\'']//g'`
# https://stackoverflow.com/questions/35018899/using-curl-in-a-bash-script-and-getting-curl-3-illegal-characters-found-in-ur
FORM=`curl -L "${URL2%$'\r'}" 2> /dev/null`
# "\1"'s mean in sed: https://stackoverflow.com/questions/4609949/what-does-1-in-sed-do
EXEC=`echo "${FORM}" | grep '<input type="hidden" name="execution" ' | sed -e 's/<input type="hidden" name="execution" value="\(.*\)".*/\1/' -e 's/\([^"]*\)"\/>.*/\1/' -e 's/ //g'`
DATA="username=$1&password=$2&execution=$EXEC&_eventId=submit&geolocation="
RESULT=`curl -L --data "${DATA}" "${URL2%$'\r'}" 2> /dev/null`
if echo $RESULT | grep -q "<h2>success"
then
echo "Success"
else
echo "Failed"
fi
fi
exit 0