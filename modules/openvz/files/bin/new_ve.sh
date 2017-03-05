#!/bin/sh

test -f /etc/vz/vz.conf        && . /etc/vz/vz.conf
test -f /etc/virtual.conf      && . /etc/virtual.conf

PARENT_NAME=`hostname -f`

test -e "$MODEL_DIR"  || MODEL_DIR=/modeles
test -e "$VZ_STORAGE" || VZ_STORAGE=/mnt/disk1
test -e "$VZ_DIR"     || VZ_DIR=/var/lib/vz
test -z "$DOMAIN"     && DOMAIN=`expr $PARENT_NAME : '[^\.]*.\(.*\)'`
test -z "$APT"        && APT=apt.$DOMAIN
test -z "$BRIDGE"     && BRIDGE=$(brctl show 2>/dev/null | grep -o "^br[0-9]" | head -1)
test -z "$QUOTA"      && QUOTA=unlimited
test -z "$MAILHOST"   && MAILHOST=smtp.$DOMAIN
test -n "$TEMPLATE"   && VZ_DIR=${TEMPLATE%/*}
test -z "$DNS"        && DNS=`awk '/^nameserver/{print $2}' /etc/resolv.conf | tr \\n \ `

BRCHILD_IF=eth0

usage()
{
    cat <<EOF
Usage: ${0##*/} [OPTIONS] hostname ip source veid [quota]
Creates a new VE from a model

Options:
	-h --help		this usage
	-a --autostart		enable VE autostart
	-p --nopasswd		disable root password
	-s --start		start VE after its creation
	-y --yes		no confirmation

Required:
	hostname		ve hostname
	ip			ve address
	source			ve source (tar.gz or directory)
	veid			ve unique ID
EOF

    if test -d "$MODEL_DIR"; then
	echo "Available templates:"
	echo "$(ls -1 $MODEL_DIR/*)"
    fi

    echo "Variables are:"
    cat <<EOF
VZ_STORAGE=$VZ_STORAGE
QUOTA=$QUOTA
PARENT_NAME=$PARENT_NAME
DOMAIN=$DOMAIN
BRIDGE=$BRIDGE
AKEYSPATH=$AKEYSPATH
MAILHOST=$MAILHOST
DNS=$DNS
APT=$APT
EOF
}

parse_args()
{
    AUTOSTART=false
    CONFIRM=true
    MORETODO=true
    NOPASSWD=false
    START=false

    while $MORETODO
    do
	case X"$1" in
	    X--help|X-h)
		usage
		shift
		exit 0
		;;
	    X--autostart|X-a)
		AUTOSTART=true
		;;
	    X--nopasswd|X-p)
		NOPASSWD=true
		;;
	    X--start|X-s)
		START=true
		;;
	    X--yes|-y)
		CONFIRM=false
		;;
	    X-*|X\?*)
		usage
		exit 1
		;;
	    *)
		MORETODO=false
		;;
	esac
	$MORETODO && shift
    done

    if test $# -lt 4; then
	echo "${0##*/} error: too few arguments."
	usage
	exit 1
    elif test $# -gt 5; then
	echo "${0##*/} error: too many arguments."
	usage
	exit 1
    fi >&2

    case x$1 in
	x[a-z]*[a-z0-9])
	    VHOST="$1"
	    ;;
	*)
	    echo "${0##*/} error: $1 must be a hostname for the ve"
	    echo 'e.g. "alpha"'
	    exit 1
	    ;;
    esac >&2
    shift

    # This does for an octet: ([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]) ;-)
    case x$1 in
	x[0-9]*.[0-9]*.[0-9]*.[0-9]*)
	    IP=$1
	    ;;
	*)
	    echo "${0##*/} error: $1 requires a single IPv4 e.g.: \"10.1.1.1\""
	    exit 1
	    ;;
    esac >&2
    shift

    if test -f ./$1; then
	FILEMODEL=`pwd`/$1
    elif test -f $1; then
	FILEMODEL=$1
    elif test -f $MODEL_DIR/$1; then
	FILEMODEL=$MODEL_DIR/$1
    elif test -f $MODEL_DIR/$1.tar.gz; then
	FILEMODEL=$MODEL_DIR/$1.tar.gz
    elif test -f $MODEL_DIR/vserver-modele-$1.tar.gz; then
	FILEMODEL=$MODEL_DIR/vserver-modele-$1.tar.gz
    elif rsync $1/bin/bash; then
	FILEMODEL=$1
    else
	echo "${0##*/} error: $1 is not a valid tgz, does not exist in $MODEL_DIR, or is not a valid linux directory"
	exit 1
    fi >&2
    shift

    if test 0"$1" -lt 100; then
	echo "VEID must be >= 100"
	exit 1
    else
	VEID=$1
    fi >&2
    shift

    if test "$1"; then
	QUOTA=$1
    fi
}

create_conf()
{
    cat <<EOF >/etc/vz/conf/$VEID.conf
# Primary parameters
NUMPROC="unlimited:unlimited"
AVNUMPROC="2255:2255"
NUMTCPSOCK="unlimited:unlimited"
NUMOTHERSOCK="unlimited:unlimited"
VMGUARPAGES="unlimited:unlimited"

# Secondary parameters
KMEMSIZE="unlimited:unlimited"
TCPSNDBUF="unlimited:unlimited"
TCPRCVBUF="unlimited:unlimited"
OTHERSOCKBUF="unlimited:unlimited"
DGRAMRCVBUF="unlimited:unlimited"
OOMGUARPAGES="unlimited:unlimited"
PRIVVMPAGES="unlimited:unlimited"

# Auxiliary parameters
LOCKEDPAGES="unlimited:unlimited"
SHMPAGES="unlimited:unlimited"
PHYSPAGES="0:unlimited"
NUMFILE="unlimited:unlimited"
NUMFLOCK="unlimited:unlimited"
NUMPTY="unlimited:unlimited"
NUMSIGINFO="unlimited:unlimited"
DCACHESIZE="unlimited:unlimited"
NUMIPTENT="200:200"

DISKINODES="9223372036854775807:9223372036854775807"
VE_ROOT="$VZ_DIR/root/$VHOST"
VE_PRIVATE="$VZ_DIR/private/$VHOST"
ORIGIN_SAMPLE="vps.basic"
OSTEMPLATE="debian"
ONBOOT="yes"
EOF

    vzctl set $VEID --cpuunits 1000 --save
    vzctl set $VEID --diskspace $QUOTA --save
    vzctl set $VEID --diskinodes unlimited --save
    vzctl set $VEID --cpuunits 1000 --save
    vzctl set $VEID --name $VHOST --save

    if test x$BRIDGE = x -o x$BRIDGE = xfalse; then
	echo "IP_ADDRESS=\"$IP\"" >>/etc/vz/conf/$VEID.conf
    else
	echo "CONFIG_CUSTOMIZED=\"yes\"" >>/etc/vz/conf/$VEID.conf
	vzctl set $VEID --netif_add $BRCHILD_IF --save
	vzctl set $VEID --ifname $BRCHILD_IF --host_mac FE:FF:FF:FF:FF:FF --save
	sed -i "/^NETIF=/s/\"$/,bridge=$BRIDGE\"/" /etc/vz/conf/$VEID.conf
    fi
}

ve_conf()
{
    sed -i "s/root-[^:]*/root-$VHOST/" $VZ_STORAGE/$VHOST/etc/passwd

    if ! $NOPASSWD; then
	PLAINTEXT_PASSWD="$VHOST"
    else
	PLAINTEXT_PASSWD=`</dev/urandom LANG=C tr -dc [:graph:] | head -c 10`
    fi

    SALT=`</dev/urandom LANG=C tr -dc [:alnum:] | head -c 16`
    export PLAINTEXT_PASSWD
    export SALT

    NEWPASSWD=`perl -e 'print crypt("$ENV{PLAINTEXT_PASSWD}", "\\$6\\$$ENV{SALT}\\$")'`
    sed -i "s#root:[^:]*#root:$NEWPASSWD#" $VZ_STORAGE/$VHOST/etc/shadow

    touch $VZ_STORAGE/$VHOST/var/log/wtmp $VZ_STORAGE/$VHOST/var/log/btmp

    echo $VHOST >$VZ_STORAGE/$VHOST/etc/hostname
    echo $VHOST.$DOMAIN >$VZ_STORAGE/$VHOST/etc/mailname
    cat <<EOF >$VZ_STORAGE/$VHOST/etc/hosts
127.0.0.1	localhost
$IP	$VHOST.$DOMAIN $VHOST

# The following lines are desirable for IPv6 capable hosts
# (added automatically by netbase upgrade)

::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

    if test -n "$AKEYSPATH"; then
	if wget -q ${AKEYSPATH} -O /tmp/authorized_keys; then
	    mkdir -p $VZ_STORAGE/$VHOST/root/.ssh
	    chmod 700 $VZ_STORAGE/$VHOST/root/.ssh
	    mv /tmp/authorized_keys $VZ_STORAGE/$VHOST/root/.ssh
	else
	    rm /tmp/authorized_keys
	    echo "Unable to retrieve authorized_keys file from $AKEYSPATH"
	fi
    fi

    if test "$DNS"; then
	cat /etc/resolv.conf
    else
	echo search $DOMAIN
	for i in $DNS
	do
	    echo nameserver $i
	done
    fi >$VZ_STORAGE/$VHOST/etc/resolv.conf

    if test -d $VZ_STORAGE/$VHOST/etc/ssmtp; then
	cat <<EOF >$VZ_STORAGE/$VHOST/etc/ssmtp/ssmtp.conf
root=CHANGEME
mailhub=$MAILHOST
rewriteDomain=unetresgrossebite.com
hostname=$VHOST.$DOMAIN
FromLineOverride=YES
EOF
    fi
    if test -e $VZ_STORAGE/$VHOST/etc/mail/submit.cf; then
	if grep -q '^[# 	]*DS[ 	$]' $VZ_STORAGE/$VHOST/etc/mail/submit.cf; then
	    sed -i "s|^[# 	]*DS[ 	$].*|DS $MAILHOST|" $VZ_STORAGE/$VHOST/etc/mail/submit.cf
	else
	    echo "DS $MAILHOST" >>$VZ_STORAGE/$VHOST/etc/mail/submit.cf
	fi
	if test -e $VZ_STORAGE/$VHOST/etc/mail/submit.mc; then
	    if grep "^[ 	]*FEATURE(\`msp'" $VZ_STORAGE/$VHOST/etc/mail/submit.mc; then
		sed -i "s|^[ 	]*FEATURE(\`msp'.*|FEATURE(\`msp', \`[$MAILHOST]')|" $VZ_STORAGE/$VHOST/etc/mail/submit.mc
	    else
		echo "FEATURE(\`msp' \`[$MAILHOST]')" >>$VZ_STORAGE/$VHOST/etc/mail/submit.mc
	    fi
	fi
    fi

    if test -f $VZ_STORAGE/$VHOST/etc/debian_version -o -f $VZ_STORAGE/$VHOST/etc/devuan_version; then
	eval archives=false version=
	if test -f etc/devuan_version; then
	    version=`cat etc/devuan_version`
	elif grep -q 5.[0-9] $VZ_STORAGE/$VHOST/etc/debian_version; then
	    eval version=lenny archives=true
	elif grep -q 6.[0-9] $VZ_STORAGE/$VHOST/etc/debian_version; then
	    version=squeeze
	elif grep -q 7.[0-9] $VZ_STORAGE/$VHOST/etc/debian_version; then
	    version=wheezy
	elif grep -q 8.[0-9] $VZ_STORAGE/$VHOST/etc/debian_version; then
	    version=jessie
	elif grep -q 9.[0-9] $VZ_STORAGE/$VHOST/etc/debian_version; then
	    version=stretch
	fi

	if test "$verion"; then
	    if test -f $VZ_STORAGE/$VHOST/etc/devuan_version; then
		cat <<EOF
deb http://auto.mirror.devuan.org/merged/ $version main contrib non-free
deb http://auto.mirror.devuan.org/merged/ $version-security main contrib non-free
deb http://auto.mirror.devuan.org/merged/ $version-updates main contrib non-free
EOF
	    elif $archives; then
		cat <<EOF
deb http://archive.debian.org/debian $version main contrib non-free
deb http://archive.debian.org/debian-security $version/updates main contrib non-free
EOF
	    else
		cat <<EOF
deb http://ftp.debian.org/debian $version main contrib non-free
deb http://security.debian.org $version/updates main contrib non-free
EOF
	    fi >$VZ_STORAGE/$VHOST/etc/apt/sources.list
	fi
	cat <<EOF >$VZ_STORAGE/$VHOST/etc/apt/apt.conf
Acquire::http::Proxy "http://$APT:3142/";
EOF

	if test "$BRIDGE" -a x$BRIDGE != xfalse; then
	    cat <<EOF >$VZ_STORAGE/$VHOST/etc/network/interfaces
auto lo
iface lo inet loopback

auto $BRCHILD_IF
iface $BRCHILD_IF inet static
    address $IP
    netmask $BRCHILD_NETMASK
    gateway $BRCHILD_GATEWAY
EOF
	fi
    elif test -f $VZ_STORAGE/$VHOST/etc/redhat-release; then
	vzctl set $VEID --ostemplate rhel-4 --save
	echo "HOSTNAME=\"$VHOST\"" >$VZ_STORAGE/$VHOST/etc/sysconfig/network

	if test "$BRIDGE" -a x$BRIDGE != xfalse; then
	    cat <<EOF >$VZ_STORAGE/$VHOST/etc/sysconfig/network
NETWORKING="yes"
HOSTNAME="$VHOST"
GATEWAY="$BRCHILD_GATEWAY"
EOF
	    cat <<EOF >$VZ_STORAGE/$VHOST/etc/sysconfig/network-scripts/ifcfg-$BRCHILD_IF
DEVICE=$BRCHILD_IF
BOOTPROTO=static
NM_CONTROLLED=no
ONBOOT=yes
IPADDR=$IP
NETMASK=$BRCHILD_NETMASK
EOF
	fi
	if test -f $VZ_STORAGE/$VHOST/etc/wwwacct.conf; then
	    (
		echo ADDR $IP
		echo ETHDEV $BRCHILD_IF
		echo NS ns.$DOMAIN
		echo NS2 ns.$DOMAIN
	    ) >>$VZ_STORAGE/$VHOST/etc/wwwacct.conf
	fi
    fi
}

parse_args $@

if test -x /usr/bin/id -a 0"`id -u`" -ne 0; then
    echo "${0##*/} error: Must be run as root!"
    exit 1
elif ! test -x /usr/bin/mkpasswd; then
    echo "You need to install whois to get mkpasswd command."
    echo "Run 'aptitude install whois'"
    exit 1
elif ! test -e $VZ_STORAGE; then
    echo "Directory does not exist $VZ_STORAGE"
    exit 1
fi >&2

if test `readlink -m $FILEMODEL` != `readlink -m $VZ_STORAGE/$VHOST` -a -e $VZ_STORAGE/$VHOST; then
    echo "WARNING!! $VZ_STORAGE/$VHOST already exists!"
    if $CONFIRM; then
	echo -n "Do you want to proceed (not recommended)? (y/N) "
	read RESPONSE
	case $RESPONSE in
	    Y|y|yes)
		;;
	    *)
		echo "Abort"
	       	exit 1
		;;
	esac
    else
	echo "Abort"
	exit 1
    fi
fi

echo
echo "Virtual server creation: "
echo "name:      $VHOST"
echo "ip:        $IP"
test -n "$BRIDGE" && echo "bridge:    $BRIDGE"
echo "model:     $FILEMODEL"
echo "veid:      $VEID"
echo "quota:     $QUOTA"
echo "domain:    $DOMAIN"
echo "parent:    $PARENT_NAME"
echo "dns:       $DNS"
echo "mailhost:  $MAILHOST"
echo "apt:       $APT"
echo

if $CONFIRM; then
    if test `readlink -m $FILEMODEL` = `readlink -m $VZ_STORAGE/$VHOST`; then
	echo
	echo "-------------------------------------------"
	echo "You're about to re-configure an existing VE"
	echo "its previous parameters will be lost"
	echo "-------------------------------------------"
	echo
    fi
	echo -n "Is this OK ? (y/n) "
	read RESPONSE
	case $RESPONSE in
		Y|y|yes)
		    ;;
		*)
		    echo "Abort on user exit."
		    exit 0
		    ;;
	esac
fi

create_conf

mkdir -p $VZ_STORAGE/$VHOST

if test `readlink -f $VZ_STORAGE` != `readlink -f $VZ_DIR/private`; then
    ln -s $VZ_STORAGE/$VHOST $VZ_DIR/private/$VHOST
fi

if test `readlink -m $FILEMODEL` != `readlink -m $VZ_STORAGE/$VHOST`; then
    if test -f $FILEMODEL; then
	tar -zxvf $FILEMODEL --numeric-owner -C $VZ_STORAGE/$VHOST
    else
	rsync -av --numeric-ids $FILEMODEL/* $VZ_STORAGE/$VHOST
    fi
fi

mkdir -p $VZ_DIR/root/$VHOST

ve_conf

if $AUTOSTART; then
    echo $VHOST >>/var/www/vm_manager/scripts/vm_start_list.txt
#   echo $VHOST:01/$(expr `date +%m` + 1)/`date +%Y` >>/var/www/vm_manager/scripts/vm_whitelist.txt
    echo $VHOST:01/12/`date +%Y` >>/var/www/vm_manager/scripts/vm_whitelist.txt
    if ! grep -q ^ONBOOT=\"[Yy][Ee][Ss]\" /etc/vz/names/$VHOST; then
	sed -i 's/ONBOOT=.*/ONBOOT="yes"/' /etc/vz/names/$VHOST
    fi
fi
if $START; then
    vzctl start $VHOST
    msg=started
else
    msg=created
fi

echo "Server has been $msg: $VHOST.$DOMAIN (root/$PLAINTEXT_PASSWD)"

exit 0
