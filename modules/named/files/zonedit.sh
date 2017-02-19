#!/bin/sh

PATH=$PATH:/usr/sbin

if ! test -x /usr/sbin/named-checkzone; then
    echo "named-checkzone is not installed [bind9utils]"
    exit 1
fi

if ! test -x /usr/bin/dig; then
    echo "dig is not installed [dnsutils]"
    exit 1
fi

usage()
{
    echo " ${0##*/} [zone name]"
}

checkarg()
{
    local fl

    for fl in `find /usr/share/dnsgen -name "db.$1"`
    do
	if ! test -f "$fl"; then
	    echo "Zone file for $1 does not exist"
	    return 1
	fi
	if ! named-checkzone -q $1 $fl; then
	    echo "Zone file is invalid!"
	    echo "named-checkzone returns the following error:"
	    echo
	    named-checkzone $1 $fl
	    echo
	    echo "Zone $1 will NOT be updated"
	    return 1
	fi

	if ! test -w "$fl"; then
	    echo "Zone file is not writable"
	    return 1
	fi
    done

    return 0
}

if command -v colordiff >/dev/null 2>&1 ; then
    DIFF=colordiff
else
    DIFF=diff
fi

rollback()
{
    local fl tmpfile tmp

    for fl in `find /usr/share/dnsgen -name "db.$1"`
    do
	tmpfile=`basename $fl | sed 's|db|old|'`
	tmp=`echo $fl | sed "s|/db\..*|/$tmpfile|"`
	cp -p $tmp $fl || continue
	rm -f $tmp
    done
}

zonedit()
{
    local fl tmpfile tmp

    for fl in `find /usr/share/dnsgen -name "db.$1"`
    do
	tmpfile=`basename $fl | sed 's|db|old|'`
	tmp=`echo $fl | sed "s|/db\..*|/$tmpfile|"`
	if test -f $tmp; then
	    echo "Backup file found, somebody is already editing the $zone zone"
	    echo "Bailing out"
	    exit 1
	fi
	cp -p $fl $tmp
	test "$EDITOR" || EDITOR=vim
	$EDITOR "$fl"
# these checks won't work until zone file has been generated, ...
	if ! checkarg $1; then
	    echo "Changes are invalid, rolling back"
	    rollback $1
	    return 1
	fi

	if ! /usr/local/sbin/checkzone; then
	    echo "Zone[s] are invalid, rolling back"
	    rollback $1
	    return 2
	fi

	if cmp $tmp "$fl"; then
	    echo "No change made"
	    rm -f $tmp
	    continue
	fi

	echo "Come again?"
	$DIFF -u $tmp "$fl"
	echo "Please confirm you want to apply this change to zone $1 [y/N]"
	trap "echo User cancel" INT
	read RES
	trap - INT
	case $RES in
	    y|Y|o|O) continue ;;
	    *)
		echo "Rolling back"
		rollback $1
		return 0
		;;
	esac
    done

    /usr/local/sbin/dnsgen
}

if test -z "$1"; then
    usage
    exit 1
fi

for zone in $@
do
    if ! checkarg $zone ; then
	if checkarg $zone.in-addr.arpa ; then
	    zone=$zone.in-addr.arpa
	else
	    echo "Could not find zone $zone"
	    exit 1
	fi
    fi

    if ! zonedit $zone ; then
	echo "Editing zone $zone failed"
	exit 1
    fi
done

exit 0
