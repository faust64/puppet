#!/bin/sh

if test $# -lt 1;then
    cat << EOF
Usage:  ${0##*/} pid
EOF
    exit 1
fi

ARG_PID=$1
VZPID=`vzpid $1`

if test $? = 1; then
    echo No process found with PID $1
    exit 1
else
    VEID=`echo $VZPID | cut -d" " -f 5`
    if test $VEID -eq 0; then
	echo `hostname`
    else
	grep "^NAME=" /etc/vz/conf/$VEID.conf | cut -d\" -f2
    fi
fi

exit 0
