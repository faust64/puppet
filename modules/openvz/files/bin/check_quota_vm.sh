#!/bin/sh

CONFVZ=/etc/vz/vz.conf

if test -e $CONFVZ; then
    QUOTASSTATUS=`grep -i "DISK_QUOTA=" $CONFVZ | cut -d= -f2`
fi

if test "$QUOTASSTATUS" = "yes"; then
    MAXQUOTA=90
    FQDN=`hostname -f`
    TMPFILE=/tmp/checkquotas.tmp
    DEST=root@unetresgrossebite.com
    CFGDIR=/etc/vz/conf/

    rm -f $TMPFILE
    for vm in `/usr/sbin/vzlist -H -o veid`
    do
	Quota=`(/usr/sbin/vzquota stat $vm || /usr/sbin/vzquota show $vm) 2>/dev/null | awk '/1k-blocks/{print $2/$3*100-$2/$3*100%1}'`
	if test "$Quota" -ge "$MAXQUOTA"; then
	    VENAME=`grep -i "^NAME=" $CFGDIR$vm.conf | cut -d\" -f2`
	    echo "$VENAME ($vm) - Quota reached $Quota% (Alert threshold $MAXQUOTA%) - VM on" >>$TMPFILE
	fi
    done

    for vm in `/usr/sbin/vzlist -H -S -o veid`
    do
	VENAME=`grep -i "^NAME=" $CFGDIR$vm.conf | cut -d\" -f2`
	DISKUSAGE=`du -s $(readlink /vz/$VENAME) | awk '{print $1}'`
	DISKMAXUSAGE=`grep -i "^DISKSPACE=" $CFGDIR$vm.conf | cut -d\" -f2 | cut -d: -f1`

	if test "$DISKMAXUSAGE" -a  "$DISKMAXUSAGE" != "unlimited"; then
	    Quota=`echo "scale=0;$DISKUSAGE*100/$DISKMAXUSAGE" | bc -l`
	    MAXQUOTAREACHED=`echo "$Quota>=$MAXQUOTA" | bc -l`
	    if test "$MAXQUOTAREACHED" -eq 1; then
		echo "$VENAME ($vm) - Quota reached $Quota% (Alert threshold $MAXQUOTA%) - VM off" >>$TMPFILE
	    fi
	else
	    echo "$VENAME ($vm) - UNLIMITED (used => ${DISKUSAGE}Ko) - VM off" >>$TMPFILE
	fi
    done

    if test -e $TMPFILE; then
	cat $TMPFILE | mail -s"[REPORT] Quotas VM on: $FQDN" $DEST
    fi
else
    echo "Quotas are inactive"
fi
