#!/bin/sh
# Maxime BESSON 2009-07-01
# $Id: whynopty.sh 576 2010-03-15 13:08:20Z pilau $

# Diagnose "unable to open pty"

usage()
{
    echo " $0 veid"
    echo "  veid: VE name"
}


if test $# -ne 1; then
    usage
    exit 1
fi >&2

VEID=$1
ALLOK=1

if ! test -d /var/lib/vz/private/$VEID; then
    echo unable to find /var/lib/vz/private/$VEID
    exit 1
elif ! vzlist -o name | grep -q $VEID; then
    echo VE $VEID is not started
    exit 1
fi

echo Start finding out why $VEID do not have tty

# Is UDEV running?
if  grep -q "^udev /var/lib/vz/root/$VEID/dev" /proc/mounts; then
    echo "* UDEV is active"
    ALLOK=0
    P_UDEV=1
fi
if  vzctl exec $VEID pgrep udev; then
    echo "* udevd is active"
    ALLOK=0
    P_UDEV=1
fi

# Does /dev/ptmx exist?
if ! test -c /var/lib/vz/root/$VEID/dev/ptmx; then
    echo "* /dev/ptmx does not exist in VE"
    ALLOK=0
    P_PTMX=1
fi

# Does /dev/pts exist?
if ! test -d /var/lib/vz/root/$VEID/dev/pts; then
    echo "* /dev/pts does not exist in VE"
    ALLOK=0
    P_PTS=1
fi

# Not mandatory, still best to have mtab linked
if ! test `readlink /var/lib/vz/private/$VEID/etc/mtab` = x/proc/mounts; then
    echo "* /etc/mtab is not pointing to /proc/mounts"
    ALLOK=0
    P_MTAB=1
fi

# Is pts mounted
if ! grep -q /var/lib/vz/root/$VEID/dev/pts /proc/mounts; then
    echo "* /dev/pts n'est pas monté dans l'enfant"
    ALLOK=0
    P_DEVPTS=1
fi

if test $ALLOK -eq 1; then
    echo "Nothing found"
    exit 2
fi

### PROBLEM? ###

# debian
if test -f /var/lib/vz/private/$VEID/etc/debian_version; then
    test a$P_UDEV = a1 && echo "chmod -x /var/lib/vz/private/$VEID/etc/rcS.d/S10udev"
    test a$P_PTMX = a1 && echo "mknod /var/lib/vz/private/$VEID/dev/ptmx c 5 2"
    test a$P_MTAB = a1 && echo "ln -nsf /proc/mounts /var/lib/vz/private/$VEID/etc/mtab"
fi

# redhat
if test -f /var/lib/vz/private/$VEID/etc/redhat-release; then
    test a$P_UDEV = a1 && echo "# Comment out 'start_udev' from /etc/rc.sysinit"
    test a$P_PTMX = a1 && echo "mknod /var/lib/vz/private/$VEID/dev/ptmx c 5 2"
    test a$P_MTAB = a1 && echo "ln -nsf /proc/mounts /var/lib/vz/private/$VEID/etc/mtab"
fi

exit 0
