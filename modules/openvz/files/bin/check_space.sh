#!/bin/sh
# $Id: check_space.sh 247 2009-01-16 09:23:14Z mabes $

# Sends a mail if some VE grows from over 20% within two starts

FILE=/vz/.space
TMPFILE=/vz/.newspace
SUBJECT=" VE diskspace watch $HOSTNAME"
TYPE=REPORT
DEST=root@unetresgrossebite.com
MESSAGE=

rm -f $TMPFILE
touch $FILE

for ve in `vzlist -Ho veid -a`
do
    curspace=`vzquota show $ve 2>/dev/null | awk '/1k-blocks/{print $2}'`
    oldspace=`grep $ve $FILE | awk '{print $2}'`

    if test "$oldspace" -a `echo "$curspace > ($oldspace * 1.20)" | bc` -eq 1; then
	percent=`echo "(100 * ($curspace - $oldspace) / $oldspace)" | bc`
	name=`vzlist -Ho name $ve`
	MESSAGE="$MESSAGE\t$name\t\t$percent%\n"
	TYPE=WARNING
    fi

    echo "$ve $curspace" >>$TMPFILE
done

mv $TMPFILE $FILE
if  test "$MESSAGE"; then
    echo -e $MESSAGE | mail -s"[$TYPE]$SUBJECT" $DEST
fi

exit 0
