#!/bin/sh

test -z "$LOG" && LOG=/var/log/openvpn-connect.log

TRAILER="[loc=$ifconfig_pool_remote_ip cetif=$X509_0_CN rmt=$trusted_ip]"
alias mdate='date "+%Y-%m-%d %H:%M:%S"'

mlog()
{
    if tty >/dev/null; then
	echo $@ >&2
    fi
    echo "[`mdate`] $@" >>$LOG
}

lookup=$X509_0_CN
lip=$ifconfig_pool_remote_ip
rip=$trusted_ip

mlog "SUCCESS: user $lookup disconnected from $rip and is releasing $lip"

exit 0
