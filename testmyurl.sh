#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Please Pass a Single File with a list of URLs seperated with new lines"
fi

while read single_url

do

    urlstatus=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "$single_url" )

    if [[ "$urlstatus" -eq 200 ]]; then

    MSG="$single_url - Site is Working - Status Code: $urlstatus"

    echo $MSG

    echo $MSG >> urlstatus.txt

    else

    MSG="$single_url - Site not Working - Status Code: $urlstatus"

    echo $MSG

    echo $MSG >> urlstatus.txt

    fi

done < $1

exit 1