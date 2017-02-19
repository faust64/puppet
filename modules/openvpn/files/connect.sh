#!/bin/sh

export PATH=/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin

test -z "$LOG" && LOG=/var/log/openvpn-connect.log
test -z "$DIRECTORIES" && DIRECTORIES=ldap.example.com
test -z "$SRCHOU" && SRCHOU="dc=example,dc=com"
test -z "$FILTER" && FILTER="(!(pwdAccountLockedTime=000001010000Z))"
TRAILER="[loc=$ifconfig_pool_remote_ip certif=$X509_0_CN rmt=$trusted_ip]"
alias mdate='date "+%Y-%m-%d %H:%M:%S"'

mlog()
{
    if tty >/dev/null; then
	echo $@ >&2
    fi
    echo "[`mdate`] $@" >>$LOG
}

search()
{
    local res directory

    res=0
    for directory in $DIRECTORIES
    do
	ldapsearch -LLL -x -h $directory -b $SRCHOU -D $BINDDN -w $BINDPW -ZZ \
		$FILTER | grep $lookup && res=1 && break
    done >/dev/null 2>&1
    if test $res -ne 0; then
	return 0
    fi

    return 1
}

if test -z "$BINDDN" -o -z "$BINDPW"; then
    mlog "ERROR: LDAP account not configured"
    exit 1
elif test -z "$ifconfig_pool_remote_ip"; then
    mlog "ERROR: Unable to find remote IP $TRAILER"
    exit 2
elif test -z "$X509_0_CN"; then
    mlog "ERROR: Unable to extract certificate CN $TRAILER"
    exit 3
elif test -z "$trusted_ip"; then
    mlog "ERROR: Unable to get client IP $TRAILER"
    exit 4
fi

lookup=$X509_0_CN
lip=$ifconfig_pool_remote_ip
rip=$trusted_ip

if ! search; then
    mlog "ERROR: LDAP Validation failure $TRAILER"
    exit 42
fi
mlog "SUCCESS: user $lookup identified from $rip and has been granted the use for $lip"

exit 0
