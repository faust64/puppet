#!/bin/sh

test -f /etc/virtual.conf && . /etc/virtual.conf

BRCHILD_IF=eth0
[ "$MODEL_DIR" ]      || MODEL_DIR=/modeles
[ "$VZ_STORAGE" ]     || VZ_STORAGE=/mnt/disk1
[ "$VZ_DIR" ]         || VZ_DIR=/var/lib/vz
[ "$AKEYSPATH" ]      || AKEYSPATH=http://somewhere.over.the.rainbow/pubkeys.txt

PARENT_NAME=`hostname -f`
if [ "$DOMAIN" = "" ]; then
	DOMAIN=`expr $PARENT_NAME : '[^\.]*.\(.*\)'`
fi

if [ "$DNS" = "" ]; then
    DNS=`grep ^nameserver /etc/resolv.conf | cut -d ' ' -f 2 | xargs echo`
fi

if [ "$MAILHOST" = "" ]; then
    MAILHOST="smtp.$DOMAIN"
fi

if [ "$APT" = "" ]; then
    APT="apt"
fi

if [ "$QUOTA" = "" ]; then
    QUOTA="unlimited"
fi

if [ "$BRIDGE" = "" ]; then
    BRIDGE=$(brctl show 2>/dev/null | grep -v bond0.101 | grep -o "^br[0-9]" | head -1)
fi

usage()
{
    cat << EOF
Usage:  ${0##*/} [OPTIONS] hostname ip source veid [quota]
Creates a new VE from a model

Options :
	-h --help             this usage
	-p --nopasswd         disable root password
	-y                    no confirmation

Required :
	hostname              ve hostname
	ip                    ve address
	source                ve source (tar.gz or directory)
	veid	              ve unique ID

Available templates on ${PARENT_NAME} :
$(ls -1 $MODEL_DIR/*)

Variables are :
MODEL_DIR=${MODEL_DIR}
AKEYSPATH=${AKEYSPATH}
VZ_STORAGE=${VZ_STORAGE}
QUOTA=${QUOTA}
PARENT_NAME=${PARENT_NAME}
DOMAIN=${DOMAIN}
BRIDGE=${BRIDGE}
MAILHOST=${MAILHOST}
DNS=${DNS}
APT=${APT}


EOF
}

parse_args()
{
    MORETODO=true
    CONFIRM=true
    NOPASSWD=false

    while ${MORETODO} ; do
	case X"$1" in
	    X--help|X-h)
		usage
		shift
		exit 0
		;;
	    X-y)
		CONFIRM=false
		;;
	    X--nopasswd|X-p)
		NOPASSWD=true
		;;
	    X-*)
		usage
		exit 1
		;;
	    X\?*)
		usage
		exit 1
		;;
	    *)
		MORETODO=false
		;;
	esac
	${MORETODO} && shift
    done

    if [ $# -lt 4 ] ; then
	echo "${0##*/} error: too few arguments." 1>&2
	usage
	exit 1
    fi
    if [ $# -gt 5 ] ; then
	echo "${0##*/} error: too many arguments." 1>&2
	usage
	exit 1
    fi

    case "$1" in
	[a-z]*[a-z0-9])
	    VHOST="$1"
	    ;;
	*)
	    echo "${0##*/} error: $1 must be a hostname for the ve" 1>&2
	    echo 'e.g. "alpha"' 1>&2
	    exit 1
	    ;;
    esac
    shift

    case "$1" in
	[0-9]*.[0-9]*.[0-9]*.[0-9]*)
	    IP="$1"
	    ;;
	*)
	    echo "${0##*/} error: $1 requires a single IPv4  e.g. \"10.1.1.1\"" 1>&2
	    exit 1
	    ;;
    esac
    shift

    if test -d $VZ_STORAGE/$1; then
	FILEMODEL=$VZ_STORAGE/$1
    else
	echo "${0##*/} error: $1 is not a valid tgz, does not exist in $MODEL_DIR, or is not a valid linux directory" 1>&2
	exit 1
    fi
    shift

    if [ $1 -lt 100 ] ; then
	echo "Choisissez un VEID au moins éga a 100"
	exit 1
    else
	VEID=$1
    fi
    shift

    if [ "$1" ] ; then
	QUOTA=$1
    fi
}

create_conf ()
{
    cat << EOF > /etc/vz/conf/$VEID.conf
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

    if [ "$BRIDGE" = "" -o "$BRIDGE" = "false" ]; then
	echo "IP_ADDRESS=\"$IP\"" >> /etc/vz/conf/$VEID.conf
    else
	echo "CONFIG_CUSTOMIZED=\"yes\"" >> /etc/vz/conf/$VEID.conf
	vzctl set $VEID --netif_add $BRCHILD_IF --save
	vzctl set $VEID --ifname $BRCHILD_IF --host_mac FE:FF:FF:FF:FF:FF --save
	sed -i "/^NETIF=/s/\"$/,bridge=$BRIDGE\"/" /etc/vz/conf/$VEID.conf
    fi
}

ve_conf ()
{
    sed -i "s/root-[^:]*/root-$VHOST/" $VZ_STORAGE/$VHOST/etc/passwd
    if ! $NOPASSWD ; then
	    NEWPASSWD=`mkpasswd -m sha-256 $VHOST -S $(</dev/urandom LANG=C tr -dc [:alnum:] | head -c 16)`
    else
	    NEWPASSWD='!'"$( mkpasswd -m sha-256 "$(</dev/urandom LANG=C tr -dc [:graph:] | head -c 10)" -S "$(</dev/urandom tr -dc [:alnum:] | head -c 16)" )"
    fi
    sed -i "s#root:[^:]*#root:$NEWPASSWD#" $VZ_STORAGE/$VHOST/etc/shadow
    echo $VHOST.$DOMAIN > $VZ_STORAGE/$VHOST/etc/mailname
    touch $VZ_STORAGE/$VHOST/var/log/wtmp $VZ_STORAGE/$VHOST/var/log/btmp
}

ve_local_conf ()
{
    echo $VHOST > $VZ_STORAGE/$VHOST/etc/hostname
    cat <<EOF > $VZ_STORAGE/$VHOST/etc/hosts
127.0.0.1       localhost
$IP     $VHOST.$DOMAIN $VHOST

# The following lines are desirable for IPv6 capable hosts
# (added automatically by netbase upgrade)

::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

EOF

    if [ "$DNS" = "" ]; then
	cp /etc/resolv.conf $VZ_STORAGE/$VHOST/etc/resolv.conf
    else
	echo "search $DOMAIN"  > $VZ_STORAGE/$VHOST/etc/resolv.conf
	for i in $DNS ; do
	   echo "nameserver $i" >> $VZ_STORAGE/$VHOST/etc/resolv.conf
	done
    fi

    if [ -d  $VZ_STORAGE/$VHOST/etc/ssmtp ] ; then
	cat << EOF > $VZ_STORAGE/$VHOST/etc/ssmtp/ssmtp.conf
root=CHANGEME
mailhub=$MAILHOST
rewriteDomain=unetresgrossebite.com
hostname=$VHOST.$DOMAIN
FromLineOverride=YES
EOF
    fi

    if [ -f $VZ_STORAGE/$VHOST/etc/debian_version ]; then
	if grep -q "5.0" $VZ_STORAGE/$VHOST/etc/debian_version ; then
	    if [ "$APT" != "" ] ; then
    			cat << EOF > $VZ_STORAGE/$VHOST/etc/apt/sources.list
deb http://$APT/debian/ lenny main non-free contrib
deb http://security.debian.org/ lenny/updates main contrib non-free
EOF
	    fi
	fi
	if ! [ "$BRIDGE" = "" -o "$BRIDGE" = "false" ]; then
	    cat <<EOF > $VZ_STORAGE/$VHOST/etc/network/interfaces
auto lo
iface lo inet loopback

auto $BRCHILD_IF
 iface $BRCHILD_IF inet static
 address $IP
 netmask $BRCHILD_NETMASK
 gateway $BRCHILD_GATEWAY
EOF
	fi
    fi
    if [ -f $VZ_STORAGE/$VHOST/etc/redhat-release ]; then
	vzctl set $VEID --ostemplate rhel-4 --save
	echo "HOSTNAME=\"$VHOST\"" > $VZ_STORAGE/$VHOST/etc/sysconfig/network

	if ! [ "$BRIDGE" = "" -o "$BRIDGE" = "false" ]; then
	    cat <<EOF > $VZ_STORAGE/$VHOST/etc/sysconfig/network
NETWORKING="yes"
HOSTNAME="$VHOST"
GATEWAY="$BRCHILD_GATEWAY"
EOF
	    cat <<EOF > $VZ_STORAGE/$VHOST/etc/sysconfig/network-scripts/ifcfg-$BRCHILD_IF
DEVICE=$BRCHILD_IF
BOOTPROTO=static
ONBOOT=yes
IPADDR=$IP
NETMASK=$BRCHILD_NETMASK
EOF
	fi
    fi
}

parse_args $@

if [ -x /usr/bin/id ] && [ `id -u` -ne 0 ]; then
    echo "${0##*/} error: Must be run as root!" 1>&2
    exit 1
fi

if [ ! -x /usr/bin/mkpasswd ]; then
    echo "You need to install whois to get mkpasswd command."
    echo "Run 'aptitude install whois'"
fi

if [ ! -e $VZ_STORAGE ]; then
    echo "Directory does not exist $VZ_STORAGE"
    exit 1
fi

if [ `readlink -m $FILEMODEL` != `readlink -m $VZ_STORAGE/$VHOST` -a -e $VZ_STORAGE/$VHOST ] ; then
    echo "WARNING !! $VZ_STORAGE/$VHOST already exists !"
    if ${CONFIRM} ; then
	echo -n "Do you want to proceed (not recommended)? (y/N) "
	read RESPONSE
	case $RESPONSE in
	Y|y|yes) ;;
	*)  echo "Abort"; exit 1;;
	esac
    else
	echo "Abort"
	exit 1
    fi
fi

echo
echo "Virtual server creation: "
echo "nom:       $VHOST"
echo "ip:        $IP"
echo "model:     $FILEMODEL"
echo "veid:      $VEID"
echo "quota:     $QUOTA"
echo "domain:    $DOMAIN"
echo "parent:    $PARENT_NAME"
echo "mailhost:  $MAILHOST"
echo "dns:       $DNS"
echo "apt:       $APT"
echo

if ${CONFIRM} ; then
    if [ `readlink -m $FILEMODEL` = `readlink -m $VZ_STORAGE/$VHOST` ] ; then
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
	Y|y|yes) ;;
	*)  echo "Abort on user exit."; exit 0;;
    esac
fi

create_conf

mkdir -p $VZ_STORAGE/$VHOST

if [ `readlink -f $VZ_STORAGE` !=  `readlink -f $VZ_DIR/private` ] ; then
    ln -s $VZ_STORAGE/$VHOST $VZ_DIR/private/$VHOST
fi

mkdir -p $VZ_DIR/root/$VHOST

ve_conf
ve_local_conf

echo
echo "Le serveur a été crée : $VHOST.$DOMAIN (root/$VHOST)"
echo
echo "Vous pouvez lancer le serveur avec : vzctl start $VHOST"
