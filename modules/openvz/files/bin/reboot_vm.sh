#!/bin/sh

exit 0
# wat?

export PATH="/usr/sbin:/usr/bin:/sbin:/bin"

DAY=`/bin/date +%e`

if test "$DAY" -lt 8; then
    shutdown -r now
else
    for vm in `vzlist -H -o name 2> /dev/null`
    do
	vzctl stop $vm
	vzctl start $vm
	sleep 8
    done
fi
