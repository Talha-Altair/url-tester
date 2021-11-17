#!/bin/bash
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

if [ "$#" -ne 1 ]; then

    echo "Please Pass a Single File with a list of URLs seperated with new lines, and add an empty last line" 1>&2; # Message goes to stderr

    exit 1

fi

num_of_not_working_sites=0

while read single_url

do

    urlstatus=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "$single_url" )

    if [[ "$urlstatus" -eq 200 ]]; then

    MSG="$single_url - Site is Working - Status Code: $urlstatus - Time : $(date)"

    if test -f urls-working.txt; then

    grep -qxF $single_url urls-working.txt || echo $single_url >> urls-working.txt

    else 

    echo $single_url >> urls-working.txt

    fi

    echo $MSG

    echo $MSG >> urlstatus.txt

    else

    MSG="$single_url - Site not Working - Status Code: $urlstatus - Time : $(date)"

    ((num_of_not_working_sites=num_of_not_working_sites+1))

    echo $MSG

    echo $MSG >> urlstatus.txt

    fi

done < $1

if [[ $num_of_not_working_sites -eq 0 ]]; then

    exit 0

fi

exit 1