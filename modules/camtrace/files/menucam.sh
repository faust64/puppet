#!/bin/sh
#
#     CamTrace operator menu
#
# THIS IS CAMTRACE PROPERTY
# If someone asks: some unicorn lend it a while ago, ...

BINDIR=/usr/local/bin
SSHD=/usr/sbin/sshd
NTPDATE=/usr/sbin/ntpdate
NTPDBIN=`sed -n '/ntpd_program=/s/^[^=]*="\([^"]*\)".*$/\1/p' /etc/defaults/rc.conf`
NTPDFLG=`sed -n '/ntpd_flags=/s/^[^=]*="\([^"]*\)".*$/\1/p' /etc/defaults/rc.conf`
NTPLOCAL=127.127.1.0
DialogWait="$BINDIR/dialog --no-collapse --cr-wrap --colors"
DialogTime="$DialogWait --timeout 300"
DIALOG="$DialogTime"
CAMLANGS="$BINDIR/camlangs menucam"

RCCONF=/etc/rc.conf
RESOLV=/etc/resolv.conf
RCFILE=/etc/menucamrc
TIMEZONE=/etc/localtime
SSHDCNF=/etc/ssh/sshd_config
WPACNF=/etc/wpa_supplicant.conf
CNFFILE=/usr/local/etc/scamd.conf
KEYFILE=/usr/local/etc/scamd.key
TMPFILE=/tmp/menu.$$
STTY=`stty -g`

OSRel=`expr \`uname -r\` : '\([^\.]*\)\.'`
LOCAL="/disk/export"
EXPORT="/export"

test "$CT_DB" && DB=$CT_DB || DB=camtrace

if [ $OSRel -lt 5 ]; then
    CRON="cron"

    XSRV="XFree86 "
    XCFILE=/etc/X11/XF86Config
    ZMFILE=/root/.netscape/preferences.js

    TWED="3dmd$"
    TWERC=/usr/local/etc/rc.d/3dmd.sh
    TWECONF=/usr/local/etc/3dmd.conf
    IPFW=
else
    alias expr='expr -e'	# Use 64bit
    CRON="cron -s"

    XSRV=" \(Xorg\)$"
    XCFILE=/etc/X11/xorg.conf
    SLIMRC=/usr/local/etc/rc.d/slim
    SLIMCNF=/usr/local/etc/slim.conf
    XINITRC=~camtrace/.xinitrc
    AUTORC=~camtrace/.config/openbox/autostart.sh

    TWED="3dm2$"
    TWERC=/usr/local/etc/rc.d/3dm2.sh
    TWECONF=/usr/local/etc/3dm2.conf
    IPFW=/etc/ipfwrc
fi

if [ $OSRel -lt 6 ]; then
    APACHECNF=/usr/local/etc/apache/httpd.conf
    APACHESSL=/usr/local/etc/apache/httpd.conf
    APACHERC=/usr/local/etc/rc.d/005.apache.sh
    PGSQLRC=/usr/local/etc/rc.d/010.pgsql.sh
    SCAMDRC=/usr/local/etc/rc.d/020.scamd.sh
    CUA='cuaa'
else
    APACHECNF=/usr/local/etc/apache22/httpd.conf
    APACHESSL=/usr/local/etc/apache22/extra/httpd-ssl.conf
    APACHERC=/usr/local/etc/rc.d/apache22
    PGSQLRC=/usr/local/etc/rc.d/postgresql
    SCAMDRC=/usr/local/etc/rc.d/scamd
    TWERC=/usr/local/etc/rc.d/3dm2
    TWECONF=/usr/local/etc/3dm2/3dm2.conf
    CUA='cuad'
fi

if [ $OSRel -lt 7 ]; then
    LXPANELCNFD=.lxpanel
    LXPANELCNFL=
    LXPANELCNFF=default
else
    LXPANELCNFD=.config/lxpanel/default/panels
    LXPANELCNFL=locale/
    LXPANELCNFF=bottom
fi

if [ $OSRel -ge 5 ]; then
    WEBHOST="http://localhost"
    Port=`sed -n 's/^Listen[ 	]*\([0-9][0-9]*\)[ 	]*/\1/p' $APACHECNF | head -1`
    if [ "$Port" ]; then
	test "$Port" = 80 || WEBHOST="http://localhost:$Port"
    else
	WEBHOST="https://localhost"
	Port=`sed -n 's/^Listen[ 	]*\([0-9][0-9]*\)[ 	]*/\1/p' $APACHESSL | tail -1`
	test "$Port" -a "$Port" = 443 || WEBHOST="https://localhost:$Port"
    fi
    unset Port
    #echo -n "WEBHOST=$WEBHOST "; read a
fi

ARCD="archttp32 "
ARCRC="/usr/local/etc/rc.d/archttp32d"
SSLCSR="/usr/local/etc/apache22/ssl/server.csr"
SSLKEY="/usr/local/etc/apache22/ssl/server.key"
SSLCRT="/usr/local/etc/apache22/ssl/server.crt"
DHCPCCONF="/etc/dhclient.conf"
REDIRS=/usr/local/etc/redirs
USBGEN=~camtrace/usbgen
MaxSz=4294967296        # 2^32 sectors (maximum size in MBR)
MinSz=134217728         # 64 * 1024 * 1024 * 2 = 64 Gb in 512b blocks
MedSz=1310720           # Minimum size for install partition
BpG=2097152             # blocks per Gb
MaxFAT16=4194304
INFO_WAIT=2

Tmsg()
{
    local tag

    tag=$1
    shift
    printf "`gettext $tag`\n" "$@"
}

Tstr()
{
    printf "`gettext $1`"
}

Size()
{
    gettext "Siz$1"
}

#   GetScrSize "height=%r widthw=%c"
GetScrSize()
{
    local rows cols

    if [ "$1" ]; then
	eval `stty -a | sed -n 's/.*; \([0-9]*\) rows; \([0-9]*\) columns;$/rows=\1 cols=\2/p'`
	test "$rows" || rows=25
	test "$cols" || cols=80
	echo "$1" | sed -e "s/%r/$rows/g" -e "s/%c/$cols/g"
    fi
}

MsgLines()
{
    let `echo -e "$1" | wc -l` + 0$2
}

MsgChars()
{
    let `echo -e "$1" | sed 's/\\Z[0-7n]//g' | awk '{if(length()>n){n=length()}}END{print n}'` + 0$2
}

Box()
{
    local Opt Off Msg Lines Chars

    Opt="$1"
    Off="$2"
    shift 2
    Msg=`Tmsg "$@"`
    Lines=`echo "$Msg" | wc -l`
    Lines=$(($Lines + $Off))
    Chars=`echo -e "$Msg" | sed 's/\\Z[0-7n]//g' | awk '{if(length()>n){n=length()}}END{print n}'`
    Chars=$(($Chars + 4))
    $DIALOG $Opt "$Msg" $Lines $Chars
    return $?
}

InfoBox()
{
    Box "--infobox" 2 "$@"
    return $?
}

MsgBox()
{
    Box "--msgbox" 4 "$@"
    return $?
}

NoYesBox()
{
    Box "--defaultno --yesno" 4 "$@"
    return $?
}

YesNoBox()
{
    Box "--yesno" 4 "$@"
    return $?
}

WizardBox()
{
    local Opt Msg Lines Chars title step

    step=$1
    shift
    Msg="$NL`Tmsg "$@"`"
    Lines=`echo "$Msg" | wc -l`
    Lines=$(($Lines + 5))
    Chars=`echo -e "$Msg" | sed 's/\\Z[0-7n]//g' | awk '{if(length()>n){n=length()}}END{print n}'`
    Chars=$(($Chars + 4))
    $DIALOG --title " `Tstr ItmWizard` ($step) " --extra-button --defaultextra --ok-label "`Tstr MsgSetupPrevious`" --extra-label "`Tstr MsgSetupPerform`" --cancel-label "`Tstr MsgSetupSkip`" --yesno "$Msg" $Lines $Chars
    return $?
}

#   WipeTrack0 deviceName needPartTable
#   Assumes track 0 is 63 sectors (most modern disks)
WipeTrack0()
{
    local dev

    test "$1" || return
    expr "$1" : '/.*' >/dev/null && dev=$1 || dev=/dev/$1
    (
	dd bs=510 count=1 </dev/zero 2>/dev/null
	test "$2" && echo -e "\x55\xAA\c" || echo -e "\0\0\c"
	dd count=62 </dev/zero 2>/dev/null
    ) >$dev
    dsk $dev mbr
    sleep 1
}

UpdateRC()
{
    if [ -f $RCFILE ]; then
	echo -e "g/^$1=/d\n\$a\n$1=\"$2\"\n.\nw" | ed - $RCFILE
    else
	cat >$RCFILE <<-EOF
	#
	#	menucamrc - menucam configuration
	#
	$1=\"$2\"
EOF
    fi
    sync
}

UpdateConf()
{
    grep "^$1=" $RCCONF >/dev/null && echo -e "/^$1=/s/=\".*\$/=\"$2\"/\nw" | ed - $RCCONF || echo "$1=\"$2\"" >>$RCCONF
    sync
}

# FIXME: This needs to be reworked to try to avoid 3 mods to each config file
UpdateWebHost()
{
    local cmd cmds file dir http host state

    http=`echo $WEBHOST | cut -d '/' -f 1`
    host=`echo $WEBHOST | cut -d '/' -f 3`
    for dir in ~camtrace ~root
    do
	cmd="/^.*http.*localhost.*$/s/http[s]*:/$http/\nw"
	cmds="/^.*http.*localhost.*start.*$/s/http[s]*:/$http/\nw"
	for file in $dir/$LXPANELCNFD/$LXPANELCNFL$LXPANELCNFF-??_??
	do
	    echo -e "$cmd" | ed - $file
	    echo -e "$cmds" | ed - $file
	done
	echo -e "$cmd" | ed - $dir/.config/openbox/autostart.sh

	cmd="/^.*http.*localhost.*$/s/localhost[:]*[0-9]*/$host/\nw"
	cmds="/^.*http.*localhost.*start.*$/s/localhost[:]*[0-9]*/$host/\nw"
	for file in $dir/$LXPANELCNFD/$LXPANELCNFL$LXPANELCNFF-??_??
	do
	    echo -e "$cmd" | ed - $file
	    echo -e "$cmds" | ed - $file
	done
	echo -e "$cmd" | ed - $dir/.config/openbox/autostart.sh

	cmd="g/http.*localhost/s/http.*localhost[:]*[0-9]*/$http\/\/$host/\nw"
	for file in $dir/$LXPANELCNFD/$LXPANELCNFL$LXPANELCNFF-??_??
	do
	    echo -e "$cmd" | ed - $file
	done

	cmd="/\"browser\.startup\.homepage\"/s/http.*localhost[:]*[0-9]*/$http\/\/$host/\nw"
	test -d $dir/.mozilla/firefox && echo -e "$cmd" | ed - $dir/.mozilla/firefox/*.default/prefs.js
    done
    echo -e "$cmd" | ed - /usr/local/lib/firefox/defaults/profile/prefs.js
}

enter()
{
    echo
    Tstr MsgPressEnterForMenu >/dev/tty
    read dummy </dev/tty
}

pidof()
{
    local car cdr

    car=`expr "$1" : '\(.\).*'`
    cdr=`expr "$1" : '.\(.*\)'`
    ps ax | awk "BEGIN{n=0}/[$car]$cdr/{printf(n>0?\" %s\":\"%s\",\$1);n++}"
}

wkill()
{
    local i pid

    i=0
    while :
    do
	pid=`pidof "$1"`
	test "$pid" || return 0
	if [ $i -eq 0 ]; then
	    kill $pid
	elif [ $i -lt 20 ]; then
	    sleep 1
	else
	    break
	fi
	i=$(($i + 1))
    done
    kill -9 $pid
    return 1
}

cleanup()
{
    if [ -s $RCCONF ] && ! cmp -s $RCCONF $RCCONF.save; then
	cp -p $RCCONF $RCCONF.save
	sync
    fi
    clear
    stty "$STTY"
    rm -f $TMPFILE
    conscontrol mute off >/dev/null
    exit 0
}

# =====	Services ======================================================

WebService()
{
    case "$1" in
	active)	test "`pidof 'httpd'`"
		return $?
		;;
	halted)	test -z "`pidof 'httpd'`"
		return $?
		;;
	start)	InfoBox InfStartingWeb
		$APACHERC start >/dev/null
		;;
	stop)	InfoBox InfStoppingWeb
		$APACHERC stop >/dev/null
		;;
	restart) InfoBox InfRestartingWeb
		$APACHERC stop >/dev/null
		$APACHERC start >/dev/null
		;;
    esac
}

DBService()
{
    case "$1" in
	active)	if [ $OSRel -lt 6 ]; then
		    test "`pidof 'postmaster '`"
		else
		    test "`pidof 'postgres$'`"
		fi
		return $?
		;;
	halted)	if [ $OSRel -lt 6 ]; then
		    test -z "`pidof 'postmaster '`"
		else
		    test -z "`pidof 'postgres$'`"
		fi
		return $?
		;;
	start)	InfoBox InfStartingDB
		$PGSQLRC start >/dev/null
		;;
	stop)	InfoBox InfStoppingDB
		$PGSQLRC stop >/dev/null
		;;
    esac
}

CamService()
{
    case "$1" in
	allactive) test "`pidof 'scamd$'`" -a "`pidof 'scamdgate$'`"
		return $?
		;;
	active)	test "`pidof 'scamd$'`" -o "`pidof 'scamdgate$'`"
		return $?
		;;
	halted)	test -z "`pidof 'scamd$'`" -a -z "`pidof 'scamdgate$'`"
		return $?
		;;
	start)	InfoBox InfStartingCam
		nohup $SCAMDRC start >/dev/null
		;;
	stop)	InfoBox InfStoppingCam
		$SCAMDRC stop >/dev/null
		;;
	restart) InfoBox InfRestartingCam
		$SCAMDRC stop >/dev/null
		nohup $SCAMDRC start >/dev/null
		;;
    esac
}

ToggleWeb()
{
    local i lan ip

    if WebService halted; then
	i=0
	while :
	do
	    eval "lan=\$ITF$i ip=\$IPADR$i"
	    test -z "$lan" && break
	    test "$ip" && break
	    i=`expr $i + 1`
	done
	if [ -z "$ip" -a -z "$ISP" ]; then
	    MsgBox MsgMustConfigureNetwork
	    return 1
	fi
	WebService start
    else
	WebService stop
    fi
    return 0
}

ToggleDB()
{
    if DBService halted; then
	DBService start || return 1
    else
	if CamService active; then
	    MsgBox MsgMustStopCamServiceFirst
	    return 1
	else
	    DBService stop
	fi
    fi
    return 0
}

ToggleCam()
{
    local i lan ip

    if CamService halted; then
	i=0
	while :
	do
	    eval "lan=\$ITF$i ip=\$IPADR$i"
	    test -z "$lan" && break
	    test "$ip" && break
	    i=`expr $i + 1`
	done
	if [ -z "$ip" -a -z "$ISP" ]; then
	    MsgBox MsgMustConfigureNetwork
	    return 1
	fi
	if DBService active; then
	    CamService start
	else
	    MsgBox MsgMustStartDBServiceFirst
	    return 1
	fi
    else
	CamService stop
    fi
    return 0
}

StartServices()
{
    WebService halted && WebService start
    DBService halted  && DBService start
    CamService halted && CamService start
    return 0
}

StopServices()
{
    NoYesBox MsgConfirmStopServices || return 1

    CamService active && CamService stop
    DBService active  && DBService stop
    WebService active && WebService stop
    return 0
}

CTServices()
{
    local active halted State WItem DItem CItem Opt Itm1 Itm2 Cmd1 Cmd2

    while :
    do
	active=
	halted=
	State="`Tstr TxtWebService`"
	if WebService active; then
	    WItem=`Tstr ItmWebServiceStop`
	    State="$State$Active"
	    active=y
	else
	    WItem=`Tstr ItmWebServiceStart`
	    State="$State$Inactive"
	    halted=y
	fi

	State="$State\n`Tstr TxtDBService`"
	if DBService active; then
	    DItem=`Tstr ItmDBServiceStop`
	    State="$State$Active"
	    active=y
	else
	    DItem=`Tstr ItmDBServiceStart`
	    State="$State$Inactive"
	    halted=y
	fi

	State="$State\n`Tstr TxtCamService`"
	if CamService active; then
	    CItem=`Tstr ItmCamServiceStop`
	    CamService allactive && State="$State$Active" || State="$State$ActiveBad"
	    active=y
	else
	    CItem=`Tstr ItmCamServiceStart`
	    State="$State$Inactive"
	    halted=y
	fi

	Opt=0
	if [ "$halted" ]; then
	    Opt=$(($Opt + 1))
	    eval "Itm$Opt=\"`Tstr ItmStartServices`\""
	    eval "Cmd$Opt='StartServices'"
	fi
	if [ "$active" ]; then
	    Opt=$(($Opt + 1))
	    eval "Itm$Opt=\"`Tstr ItmStopServices`\""
	    eval "Cmd$Opt='StopServices'"
	fi

	if [ $Opt -eq 1 ]; then
	    $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" \
		--menu "`Tstr TitCTServices`\n\n$State\n" 15 `Size CTServices` 4 \
		1 "$Itm1" \
		2 "$WItem" \
		3 "$DItem" \
		4 "$CItem" || break
	    case "`cat $TMPFILE`" in
		1)  $Cmd1	    ;;
		2)  ToggleWeb  ;;
		3)  ToggleDB   ;;
		4)  ToggleCam  ;;
	    esac
	else
	    $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" \
		--menu "`Tstr TitCTServices`\n\n$State" 16 `Size CTServices` 5 \
		1 "$Itm1" \
		2 "$Itm2" \
		3 "$WItem" \
		4 "$DItem" \
		5 "$CItem" || break
	    case "`cat $TMPFILE`" in
		1)  $Cmd1	    ;;
		2)  $Cmd2	    ;;
		3)  ToggleWeb  ;;
		4)  ToggleDB   ;;
		5)  ToggleCam  ;;
	    esac
	fi
    done
    return 0
}

# =====	Graphical mode ================================================

X11Service()
{
    local pidfile

    case "$1" in
	active) test "`pidof "$XSRV"`"
		return $?
		;;
	halted)	test -z "`pidof "$XSRV"`"
		return $?
		;;
	start)	if [ $OSRel -lt 6 ]; then
		    case "`tty`" in
			/dev/ttyv*) MsgBox MsgAbortX11 ;;
		    esac
		    startx >/dev/null 2>&1
		else
		    UpdateConf slim_enable 'YES'
		    $SLIMRC start
		fi
		(
		    /usr/local/etc/rc.d/wrapperinit stop
		    /usr/local/etc/rc.d/wrapperinit start
		) >/dev/null 2>&1
		case "`tty`" in
		    /dev/ttyv*) exit 0 ;;
		esac
		;;
	stop)	if [ $OSRel -lt 6 ]; then
		    wkill "$XSRV"
		else
		    UpdateConf slim_enable 'NO'
		    /usr/local/etc/rc.d/wrapperinit stop >/dev/null 2>&1
		    if [ "$INX11" ]; then
			(sleep 1; $SLIMRC forcestop) &
			exit 0
		    elif test "`pidof openbox`"; then
			$SLIMRC forcestop
		    else	# In slim, but not logged-in
			eval `grep "^pidfile" $SLIMRC`
			rm -f $pidfile
			wkill "$XSRV"
			return $?
		    fi
		fi
		;;
    esac
}

StartStopX11()
{
    if X11Service active; then
	NoYesBox MsgConfirmStopX11 || return 1
	X11Service stop
    else
	NoYesBox MsgConfirmStartX11 || return 1
	X11Service start
    fi
    return 0
}

ScreenType()
{
    local type

    type=`sed -n '/^[ 	][ 	]*Monitor[ 	][ 	]*"/s/^[ 	]*Monitor[ 	]*"\(.*\)Monitor"$/\1/p' $XCFILE`
    test "$type" = "CRT" && type="TFTMonitor" || type="CRTMonitor"
    echo -e "/^[ \t][ \t]*Monitor[ \t][ \t]*\"/s/\"[^\"]*\"/\"$type\"/\nw" | ed - $XCFILE
    test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    return 0
}

ScreenRes()
{
    local mode mode_

    mode=`sed -n '/^[ 	][ 	]*Modes[ 	][ 	]*"/s/^[ 	]*Modes[ 	]*"\([^"]*\)"$/\1/p' $XCFILE`
    case "$mode" in
	640x480)    Item2=1	;;
	1024x768)   Item2=3	;;
	*)	    Item2=2	;;
    esac
    $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	--menu "`Tstr TitScreenRes`" 10 `Size ScreenRes` 3 \
	1 "640 x 480 (VGA)" \
	2 "800 x 600 (SVGA)" \
	3 "1024 x 768 (XGA)" || return 1
    Item2=`cat $TMPFILE`
    case "$Item2" in
	1)  mode_="640x480"	;;
	2)  mode_="800x600"	;;
	3)  mode_="1024x768"	;;
    esac
    if [ "$mode_" != "$mode" ]; then
	echo -e "/^[ \t][ \t]*Modes[ \t][ \t]*\"/s/\"[^\"]*\"/\"$mode_\"/\nw" | ed - $XCFILE
	test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    fi
    return 0
}

CheckZoomFactor()
{
    local valid

    valid=`expr "$1" : '\([0-9\.][0-9\.]*\)'`
    if [ "$1" != "$valid" ]; then
	MsgBox MsgInvalidZoomFactor
	return 1
    fi
    return 0
}

ZoomFactor()
{
    local Title zoom zoom_ cmd

    test $OSRel -ge 5 && return
    Title=`Tstr TitZoomFactor`
    zoom=`sed -n '/browser.startup.homepage/s/^.*zoom=\([^"]*\)".*$/\1/p' $ZMFILE`
    zoom_=$zoom
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title " --max-input 5 --inputbox "\n `Tstr InpZoomFactor`" 9 `Size ZoomFactor` "$zoom_" || return 1
	zoom_=`cat $TMPFILE`
	CheckZoomFactor "$zoom_" && break
    done
    if [ "$zoom_" != "$zoom" ]; then
	cmd="/browser.startup.homepage/s/zoom=[^\"]*/zoom=$zoom_/\nw"
	echo -e "$cmd" | ed - $ZMFILE
	test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    fi
    return 0
}

AutoLogin()
{
    local cmd

    if grep '^auto_login[ 	][ 	]*true' $SLIMCNF >/dev/null; then
	cmd="/default_user[ \t]/s/^/#/\n/auto_login[ \t]/s/^/#/\nw"
    else
	cmd="/default_user[ \t]/s/^[# ]*//\n/auto_login[ \t]/s/^[# ]*//\nw"
    fi
    echo -e "$cmd" | ed - $SLIMCNF
    test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    return 0
}

StartValues()
{
    local CMD Type User Desk

    CMD=`echo -e '/^# *Startup /+1' | ed - $AUTORC 2>/dev/null`
    if [ `expr "$CMD" : '.*http://[^/]*/login/login.php?.*desk='` -gt 0 ]; then
	Type='desk'
	User=`expr "$CMD" : '.*[?&]user=\([^"&]*\)["&]'`
	Desk=`expr "$CMD" : '.*[?&]desk=\([^"&]*\)["&]'`
    elif [ `expr "$CMD" : '.*/monitor.php"'` -gt 0 ]; then
	Type='monitor'
    elif [ `expr "$CMD" : '.*/start.php"'` -gt 0 ]; then
	Type='passive'
    elif [ "$CMD" ]; then
	Type='custom'
    fi
    echo "$1=$Type $2=\"$User\" $3=\"$Desk\""
}

StartParams()
{
    local Type User Desk

    eval `StartValues Type User Desk`
    case "$Type" in
	desk)	    Tmsg TxtDeskCmd "$User" "$Desk";;
	monitor)    Tstr TxtMonitorCmd;;
	passive)    Tstr TxtPassiveCmd;;
	custom)	    Tstr TxtCustomCmd;;
	*)	    echo "-";;
    esac
}

StartMonitor()
{
    local Type User Desk StopDB Name

    eval `StartValues Type User Desk`
    if [ "$Type" = 'custom' ]; then
	NoYesBox MsgDeleteCustomCmd || return
    fi
    if DBService halted; then
	StopDB=y
	DBService start || return
    fi
    Name=`psql -A -t -c "SELECT id_grp FROM groups WHERE name = 'monitor'" $DB camtrace`
    test "$StopDB" && DBService stop
    if [ "$Name" ]; then
	# FIXME: need to do this for ~root too
	test "$Type" && echo -e "/^# *Startup /+1d\nw" | ed - $AUTORC
	echo -e "/^# *Startup /a\nfirefox \"$WEBHOST/monitor.php\" &\n.\nw" | ed - $AUTORC
	test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
	AutoDefault
    else
	MsgBox MsgNoMonitorGroup
    fi
}

StartPassive()
{
    local Type User Desk

    eval `StartValues Type User Desk`
    if [ "$Type" = 'custom' ]; then
	NoYesBox MsgDeleteCustomCmd || return
    fi
    # TODO: check for localhost in screens ?
    test "$Type" && echo -e "/^# *Startup /+1d\nw" | ed - $AUTORC
    # FIXME: need to do this for ~root too
    echo -e "/^# *Startup /a\nfirefox \"$WEBHOST/start.php\" &\n.\nw" | ed - $AUTORC
    AutoDefault
    test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
}

StartDesk()
{
    local Title Type User Desk DefDesk StopDB Desks Resp Pass ret

    Title=`Tstr TitChangeStartDesk`
    #grep '^# *Startup /' $AUTORC >/dev/null || echo "# Startup command" >>$AUTORC
    eval `StartValues Type User Desk`
    if [ "$Type" = 'desk' ]; then
	DefDesk="--default-item \"$User:$Desk\""
    elif [ "$Type" = 'custom' ]; then
	NoYesBox MsgDeleteCustomCmd || return
    fi
    if DBService halted; then
	StopDB=y
	DBService start || return
    fi

    Desks=`psql -A -t -F: -c 'SELECT u.name AS user,d.name AS desk FROM desks d,users u WHERE d.id_usr = u.id_usr ORDER BY user,desk' $DB camtrace | awk '{printf("\\"%s\\" \\"\\" ",$0)}'`
    if [ "$Desks" ]; then
	eval $DIALOG 2>$TMPFILE --title "\" $Title \"" \
	    --cancel-label "\"$BtnBack\"" $DefDesk \
	    --menu "\"\\\n`Tstr TxtChooseDesk`\\\n\"" 16 `Size ChooseDesk` 8 "$Desks"
	ret=$?
    else
	MsgBox MsgNoDesk
	ret=1
    fi
    test "$StopDB" && DBService stop
    if [ $ret -eq 0 ]; then
	Resp=`cat $TMPFILE`
	User=`expr "$Resp" : '\([^:]*\):'`
	Pass=`psql -A -t -c "SELECT pass FROM users WHERE name = '$User'" $DB camtrace`
	Desk=`expr "$Resp" : '[^:]*:\([^:]*\)'`
	# FIXME: need to do this for ~root too
	test "$Type" && echo -e "/^# *Startup /+1d\nw" | ed - $AUTORC
	echo -e "/^# *Startup /a\nfirefox \"$WEBHOST/login/login.php?user=$User&pass=$Pass&desk=$Desk\" &\n.\nw" | ed - $AUTORC
	AutoDefault
	test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    fi
}

StartCustom()
{
    local CMD CMD_

    CMD=`echo -e '/^# *Startup/+1' | ed - $AUTORC 2>/dev/null`
    CMD_="$CMD"
    while :
    do
	$DIALOG 2>$TMPFILE --title " `Tstr TitCustomCmd` " --max-input 256 --inputbox "\n `Tstr InpCustomCmd`" 11 `Size CustomCmd` "$CMD_" || return 1
	CMD_=`cat $TMPFILE`
	break
    done
    if [ "$CMD" != "$CMD_" ]; then
	# FIXME: need to do this for ~root too
	test "$CMD" && echo -e "/^# *Startup /+1d\nw" | ed - $AUTORC
	test "$CMD_" && echo -e "/^# *Startup /a\n$CMD_\n.\nw" | ed - $AUTORC
	test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    else
	MsgBox MsgConfigNotModified
    fi
}

StartNone()
{
    local Type User Desk

    eval `StartValues Type User Desk`
    if [ "$Type" = 'custom' ]; then
	NoYesBox MsgDeleteCustomCmd || return
    fi
    if [ "$Type" ]; then
	# FIXME: need to do this for ~root too
	echo -e "/^# *Startup /+1d\nw" | ed - $AUTORC
	test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    fi
}

AutoDefault()
{
    su - camtrace -c 'crontab -l' | grep 'restart_browser' >/dev/null || { (su - camtrace -c 'crontab -l'; echo "5 1-23/3 * * * /usr/local/bin/restart_browser >/dev/null 2>&1") | su - camtrace -c 'crontab -'; MsgBox MsgAutoRestartEnabled; }
}

AutoValues()
{
    local Hour Mn Hr Fq

    Hr=0; Mn=0; Fq=0
    eval `su - camtrace -c 'crontab -l' | awk '/restart_browser/{printf("Mn=%s Hour=%s\n",$1,$2)}'`
    if [ "$Hour" ]; then
	Hr=`expr "$Hour" : '\([0-9]*\)'`
	if [ "$Hr" != "$Hour" ]; then
	    Fq=`expr "$Hour" : '.*/\([0-9]*\)'`
	    test "$Fq" || Fq='1'
	else
	    Fq=24
	fi
    fi
    echo "$1=$Hr $2=$Mn $3=$Fq"
}

AutoParams()
{
    local Hr Mn Fq

    if [ "$1" -a "$2" -a "$3" ]; then
	Hr=$1; Mn=$2; Fq=$3
    else
	eval `AutoValues Hr Mn Fq`
    fi
    case "$Fq" in
	0)	Tstr TxtAutoNever;;
	1)	Tmsg TxtAutoHour $Hr $Mn;;
	*)	Tmsg TxtAutoHours $Hr $Mn $Fq;;
    esac
}

CheckRestartTime()
{
    local ch cm

    ch=`expr "$1" : '\([0-9]*\)'`
    cm=`expr "$2" : '\([0-9]*\)'`
    if [ "$1" = "$ch" -a "$2" = "$cm" ]; then
	test "$1" -le $3 -a "$2" -le 59 && return 0
    fi
    MsgBox MsgInvalidRestartTime $3
    return 1
}

AutoRestart()
{
    local Hr Mn Fq Title Menu n Def Hr_ Mn_ Fq_ Max STDIFS Auto Auto_

    eval `AutoValues Hr Mn Fq`
    Title=`Tstr TitRestart`
    Menu="0 \"`Tstr TxtAutoDisable`\" 1 \"`Tstr TxtEveryHour`\""
    for n in 2 3 4 6 8 12 24
    do
	Menu="$Menu $n \"`Tmsg TxtEveryHours $n`\""
    done
    test $Fq -gt 0 && Def=$Fq || Def=3
    eval $DIALOG 2>$TMPFILE --title "\" $Title (1) \"" --default-item $Def \
	--cancel-label "\"$BtnBack\"" --menu "\"\n`Tstr TitRestartFreq`\n\"" \
	17 `Size RestartFreq` 9 $Menu || return
    Fq_=`cat $TMPFILE`
    Hr_=0
    Mn_=0
    if [ $Fq_ -gt 0 ]; then
	test $Fq -gt 0 && Time_=`printf "%02d:%02d" $Hr $Mn` || Time_='01:05'
	Max=`expr $Fq_ - 1`
	while :
	do
	    $DIALOG 2>$TMPFILE --title " $Title (2) " --max-input 5 --inputbox "\n`Tmsg InpRestartTime $Max`" 10 `Size RestartTime` "$Time_" || return 1
	    Time_=`cat $TMPFILE`
	    STDIFS="$IFS"
	    IFS=:
	    set $Time_
	    IFS="$STDIFS"
	    CheckRestartTime "$1" "$2" $Max && break
	done
	Hr_=`expr $1 - 0`
	Mn_=`expr $2 - 0`
    fi
    if [ "$Fq_" = "$Fq" -a "$Hr" = "$Hr_" -a "$Mn" = "$Mn_" ]; then
	MsgBox MsgConfigNotModified
	return
    fi
    #echo "Hr=[$Hr] Mn=[$Mn] Fq=[$Fq] Hr_=[$Hr_] Mn_=[$Mn_] Fq_=[$Fq_]"; read a;
    Auto=`AutoParams $Hr $Mn $Fq`
    Auto_=`AutoParams $Hr_ $Mn_ $Fq_`
    #echo "Auto=[$Auto] Auto_=[$Auto_]"; read a
    $DIALOG --title " $Title " --yesno "\n`Tmsg MsgRestartTimeConfig "$Auto" "$Auto_"`" 14 `Size RestartTimeConfig` || return 1

    if [ $Fq_ -eq 24 ]; then
	(su - camtrace -c 'crontab -l' | grep -v 'restart_browser'; echo "$Mn_ $Hr_ * * * /usr/local/bin/restart_browser >/dev/null 2>&1") | su - camtrace -c 'crontab -'
    elif [ $Fq_ -gt 1 ]; then
	(su - camtrace -c 'crontab -l' | grep -v 'restart_browser'; echo "$Mn_ $Hr_-23/$Fq_ * * * /usr/local/bin/restart_browser >/dev/null 2>&1") | su - camtrace -c 'crontab -'
    elif [ $Fq_ -gt 0 ]; then
	(su - camtrace -c 'crontab -l' | grep -v 'restart_browser'; echo "$Mn_ $Hr_-23 * * * /usr/local/bin/restart_browser >/dev/null 2>&1") | su - camtrace -c 'crontab -'
    else
	su - camtrace -c 'crontab -l' | grep -v 'restart_browser' | su - camtrace -c 'crontab -'
    fi
}

StartCmd()
{
    Item2=1
    while :
    do
	State="`Tstr TxtStartCmd``StartParams`"
	State="$State\n`Tstr TxtAutoParams``AutoParams`"
	$DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	    --menu "`Tstr TitGraphicsStartMenu`\n\n$State\n" 16 `Size GraphicsStartMenu` 6 \
	    1 "`Tstr ItmStartMonitor`" \
	    2 "`Tstr ItmStartPassive`" \
	    3 "`Tstr ItmStartDesk`" \
	    4 "`Tstr ItmStartCustom`" \
	    5 "`Tstr ItmStartNone`" \
	    6 "`Tstr ItmAutoRestart`" || return
	Item2=`cat $TMPFILE`
	case "$Item2" in
	    1)  StartMonitor	;;
	    2)  StartPassive	;;
	    3)  StartDesk	;;
	    4)  StartCustom	;;
	    5)  StartNone	;;
	    6)  AutoRestart	;;
	esac
    done
}

X11Lang()
{
    local Lines Dir Lg_Tr Lg Lang Code Items Data SizeY LgTr Iso Cmd

    Lines=0
    Dir=~camtrace/www/lib/locale
    for Lg_Tr in `ls ~camtrace/$LXPANELCNFD/$LXPANELCNFL$LXPANELCNFF-??_?? | sed "s/^.*$LXPANELCNFF-//"`
    do
	test -f ~camtrace/.config/openbox/menu-$Lg_Tr.xml -a -f ~camtrace/.mrxvt/default-$Lg_Tr.menu || continue
	Lines=$(($Lines + 1))
	Lg=`expr $Lg_Tr : '\(..\)'`
	test -f $Dir/$Lg/lang && Lang=`cat $Dir/$Lg/lang` || Lang=$Lg_Tr
	Code=`awk -F'	' "\\$2 == \\"$Lg\\"{print \\$1}" $Dir/codes`
	Items="$Items $Lines $Lang"
	Data="${Data}Lg=\"$Lg\" Lg_Tr=\"$Lg_Tr\" Code=\"$Code\"\n"
    done
    SizeY=$(($Lines + 7))
    $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" --menu "`Tstr TitSetupX11Lang`" $SizeY `Size SetupX11Lang` $Lines $Items || return 1
    eval `echo -e "$Data\c" | sed -n "\`cat $TMPFILE\`p"`
    for user in root camtrace
    do
	su - $user -c "rm -f $LXPANELCNFD/$LXPANELCNFF .config/openbox/menu.xml .mrxvt/default.menu"
	su - $user -c "cd $LXPANELCNFD; ln -s $LXPANELCNFL$LXPANELCNFF-$Lg_Tr $LXPANELCNFF"
	su - $user -c "cd .config/openbox; ln -s menu-$Lg_Tr.xml menu.xml"
	su - $user -c "cd .mrxvt; ln -s default-$Lg_Tr.menu default.menu"
	(eval cd ~$user; echo -e "/^export LANG=/s/=\".*\$/=\"$Code\"/\nw" | ed - .xinitrc)
    done
    # echo -n ": "; read a

    LgTr=`echo $Lg_Tr | tr '_[A-Z]' '-[a-z]'`
    Iso="ISO-`expr $Code : '.._..\.ISO\(.*\)'`"
    Cmd="/intl.accept_languages/s/\"[^\"]*\")/\"$LgTr,$Lg\")/\n"
    Cmd="$Cmd/intl.charsetmenu.browser.cache/s/\"[^\"]*\")/\"$Iso, UTF-8\")/\n"
    Cmd="$Cmd/extensions.qls.locale/s/\"[^\"]*\")/\"$LgTr\")/\n"
    Cmd="$Cmd/extensions.qls.contentlocale/s/\"[^\"]*\")/\"$LgTr\")/\n"
    Cmd="$Cmd/extensions.qls.fallbacklocale/s/\"[^\"]*\")/\"$LgTr\")/"
    # echo -n "Lg=$Lg Lg_Tr=$Lg_Tr LgTr=$LgTr Code=$Code Iso=$Iso "; read a
    for Dir in	~root/.mozilla/firefox/*.default \
		~camtrace/.mozilla/firefox/*.default \
		/usr/local/lib/firefox/defaults/profile
    do
	test -d $Dir || continue
	if grep 'general.useragent.locale' $Dir/prefs.js >/dev/null; then
	    Cmd="/general.useragent.locale/s/\"[^\"]*\")/\"$LgTr\")/\n$Cmd"
	else
	    Cmd="/intl.accept_languages/i\nuser_pref(\"general.useragent.locale\", \"$LgTr\");\n.\n$Cmd"
	fi
	echo -e "$Cmd" | ed - $Dir/prefs.js
    done
    sync
    test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
}

ToggleDrv()
{
    local cur new Scr Res cmd

    cur=`sed -n '/^Section "Device"/,$s/	Driver *"\(.*\)"$/\1/p' $XCFILE`
    for new in `ls /etc/X11/xorg.conf-* | sed 's;/etc/X11/xorg.conf-;;'`
    do
	test "$cur" != "$new" && break
    done
    Scr=`sed -n '/^[ 	][ 	]*Monitor[ 	][ 	]*"/s/^[ 	]*Monitor[ 	]*"\(.*Monitor\)"$/\1/p' $XCFILE`
    Res=`sed -n '/^[ 	][ 	]*Modes[ 	][ 	]*"/s/^[ 	]*Modes[ 	]*"\([^"]*\)"$/\1/p' $XCFILE`
    cp /etc/X11/xorg.conf-$new $XCFILE
    cmd="/^[ \t][ \t]*Monitor[ \t][ \t]*\"/s/\"[^\"]*\"/\"$Scr\"/\n"
    cmd="$cmd/^[ \t][ \t]*Modes[ \t][ \t]*\"/s/\"[^\"]*\"/\"$Res\"/\nw"
    echo -e "$cmd" | ed - $XCFILE
    test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
}

GraphicsMode()
{
    local ItemX11 ItemAuto State X11 Scr Res Zoom Auto CMD User Desk Code Lg Lang Drv

    if [ $OSRel -eq 5 ]; then
	MsgBox MsgFunctionNotAvailable
	return
    fi
    Item1=1
    while :
    do
	if [ "`pidof "$XSRV"`" ]; then
	    ItemX11=`Tstr ItmStopX11`
	    X11=`Tstr TxtX11Active`
	else
	    ItemX11=`Tstr ItmStartX11`
	    X11=`Tstr TxtX11Inactive`
	fi
	Scr=`sed -n '/^[ 	][ 	]*Monitor[ 	][ 	]*"/s/^[ 	]*Monitor[ 	]*"\(.*\)Monitor"$/\1/p' $XCFILE`
	Res=`sed -n '/^[ 	][ 	]*Modes[ 	][ 	]*"/s/^[ 	]*Modes[ 	]*"\([^"]*\)"$/\1/p' $XCFILE`
	State="`Tstr TxtX11State`$X11"
	State="$State\n`Tstr TxtScreenType`$Scr"
	State="$State\n`Tstr TxtScreenRes`$Res"
	if [ $OSRel -lt 5 ]; then
	    Zoom=`sed -n '/browser.startup.homepage/s/^.*zoom=\([^"]*\)".*$/\1/p' $ZMFILE`
	    State="$State\n`Tstr TxtZoomFactor`$Zoom"
	    $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
		--menu "`Tstr TitGraphicsMode`\n\n$State\n" 16 `Size GraphicsMode` 4 \
		1 "$ItemX11" \
		2 "`Tstr ItmScreenType`" \
		3 "`Tstr ItmScreenRes`" \
		4 "`Tstr ItmZoomFactor`" || break
	else
	    #	autologin
	    if grep '^auto_login[ 	][ 	]*true' $SLIMCNF >/dev/null; then
		ItemAuto=`Tstr ItmStopAuto`
		Auto=`Tstr TxtAutoActive`
	    else
		ItemAuto=`Tstr ItmStartAuto`
		Auto=`Tstr TxtAutoInactive`
	    fi
	    State="$State\n`Tstr TxtAutoState`$Auto"

	    State="$State\n`Tstr TxtStartCmd``StartParams`"

	    #	language
	    Code=`sed -n '/^export LANG=/s/^.* LANG="\([^"]*\)"/\1/p' $XINITRC`
	    Lg=`expr "$Code" : '\(..\)'`
	    if [ -f ~camtrace/www/lib/locale/$Lg/lang ]; then
		Lang=`cat ~camtrace/www/lib/locale/$Lg/lang`
	    else
		Lang=$Code
	    fi
	    State="$State\n`Tstr TxtX11Lang`$Lang"

	    #	video driver
	    Drv=`sed -n '/^Section "Device"/,$s/	Driver *"\(.*\)"$/\1/p' $XCFILE`
	    State="$State\n`Tstr TxtX11Driver`$Drv"

	    if [ `ls /etc/X11/xorg.conf-*|wc -l` -gt 1 ]; then
		$DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
		    --menu "`Tstr TitGraphicsMode`\n\n$State\n" 22 `Size GraphicsMode` 7 \
		    1 "$ItemX11" \
		    2 "`Tstr ItmScreenType`" \
		    3 "`Tstr ItmScreenRes`" \
		    4 "$ItemAuto" \
		    5 "`Tstr ItmStartCmd`" \
		    6 "`Tstr ItmX11Lang`" \
		    7 "`Tstr ItmToggleDrv`" || break
	    else
		$DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
		    --menu "`Tstr TitGraphicsMode`\n\n$State\n" 21 `Size GraphicsMode` 6 \
		    1 "$ItemX11" \
		    2 "`Tstr ItmScreenType`" \
		    3 "`Tstr ItmScreenRes`" \
		    4 "$ItemAuto" \
		    5 "`Tstr ItmStartCmd`" \
		    6 "`Tstr ItmX11Lang`" || break
	    fi
	fi
	Item1=`cat $TMPFILE`
	if [ $OSRel -lt 5 ]; then
	    case "$Item1" in
		1)  StartStopX11;;
		2)  ScreenType	;;
		3)  ScreenRes	;;
		4)  ZoomFactor	;;
	    esac
	else
	    case "$Item1" in
		1)  StartStopX11;;
		2)  ScreenType	;;
		3)  ScreenRes	;;
		4)  AutoLogin	;;
		5)  StartCmd	;;
		6)  X11Lang	;;
		7)  ToggleDrv	;;
	    esac
	fi
    done
}

# =====	System Configuration ==========================================

#	$1	blank separated list of services to stop if necessary
#	$2	name of global variable to receive services to restart
#	$3	if non-empty, indicates there has been config changes
#
SuspendServices()
{
    local srv StopWeb StopDB StopCam SrvMsg Restart

    for srv in $1
    do
	case "$srv" in
	    C)	if CamService active; then
		    StopCam=y
		    SrvMsg="$SrvMsg`Tstr MsgCamService`\n"
		    test "$Restart" && Restart="C $Restart" || Restart="C"
		fi
		;;
	    D)  if DBService active; then
		    StopDB=y
		    SrvMsg="$SrvMsg`Tstr MsgDBService`\n"
		    test "$Restart" && Restart="D $Restart" || Restart="D"
		fi
		;;
	    W)  if WebService active; then
		    StopWeb=y
		    SrvMsg="$SrvMsg`Tstr MsgWebService`\n"
		    test "$Restart" && Restart="W $Restart" || Restart="W"
		fi
		;;
	esac
    done
    test "$SrvMsg" || return 0

    until NoYesBox MsgConfirmSuspendServices "`echo -e \"$SrvMsg\"`"
    do
	test "$3" || return 1
	NoYesBox MsgConfirmDiscardChanges && return 1
    done

    test "$StopCam" && CamService stop
    test "$StopDB"  && DBService stop
    test "$StopWeb" && WebService stop
    eval $2="\"$Restart\""

    return 0
}

ResumeServices()
{
    local srv StartWeb StartDB StartCam

    test "$1" || return 0
    StartWeb=
    StartDB=
    StartCam=
    for srv in $1
    do
	case "$srv" in
	    W)  StartWeb=y 	;;
	    D)  StartDB=y	;;
	    C)	StartCam=y	;;
	esac
    done
    test "$StartWeb" && WebService start
    test "$StartDB"  && DBService start
    test "$StartCam" && CamService start
    return 0
}

SetupLang()
{
    local Items Lines SizeY

    Items=`$CAMLANGS | awk 'BEGIN{n=0}{printf(" %d %s",++n,$2)}'`
    Lines=`$CAMLANGS | wc -l`
    SizeY=$(($Lines + 7))
    $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" --menu "`Tstr TitSetupLang`" $SizeY `Size SetupLang` $Lines $Items || return 1
    LANG=`$CAMLANGS | awk -F'	' "NR==\`cat $TMPFILE\`{print \\$1}"`
    UpdateRC LANG $LANG
    BtnBack=`Tstr BtnBack`
    BtnApply=`Tstr BtnApply`
    Active=`Tstr TxtActive`
    ActiveBad=`Tstr TxtActiveBad`
    Inactive=`Tstr TxtInactive`
}

SetupKeyboard()
{
    eval `grep '^keymap=' $RCCONF`
    Item2=`(gettext TxtKeyboardMaps$OSRel;echo) | sort | awk -F'|' "\\\$2 == \"${keymap:-us.iso}\"{print NR}"`
    eval $DIALOG 2>$TMPFILE  --default-item $Item2 --cancel-label "\"$BtnBack\"" \
	    --menu "\"`Tstr TitKeyboardMenu`\\\n\\\n\"" 22 `Size KeyboardMenu` 15 \
	    "`(gettext TxtKeyboardMaps$OSRel;echo) | sort | awk -F'|' '{printf("%2d \\"%s\\" ",NR,$1)}'`" || return 1

    keymap=`(gettext TxtKeyboardMaps$OSRel;echo) | sort | awk -F'|' "NR == \`cat $TMPFILE\` {print \\\$2}"`
    xkb=`(gettext TxtKeyboardMaps$OSRel;echo) | sort | awk -F'|' "NR == \`cat $TMPFILE\` {print \\\$3}"`
    if grep '^keymap=' $RCCONF >/dev/null; then
	edCmd="/^keymap/s/=.*/=\"$keymap\"/\nw"
    else
	edCmd="/^kern_secure/a\nkeymap=\"$keymap\"\n.\nw"
    fi
    echo -e "$edCmd" | ed - $RCCONF
    kbdcontrol </dev/ttyv0 -l $keymap
    echo -e "/XkbLayout/s/\"[^\"]*\"[ \t]*\$/\"$xkb\"/\nw" | ed - $XCFILE
    test "`pidof "$XSRV"`" && MsgBox MsgNeedRestartX11
    return 0
}

SetupTimeZone()
{
    SuspendServices "C D W" Rst || return 1
    wkill "$CRON$"
    wkill 'ntpd '
    rm -f /etc/wall_cmos_clock
    if [ -L $TIMEZONE ]; then
	TimeZone=`ls -l $TIMEZONE | sed 's,^.* -> /usr/share/zoneinfo/,,'`
    else
	rm -rf $TIMEZONE
	TimeZone=
    fi
    tzen
    $NTPDBIN $NTPDFLG
    /usr/sbin/$CRON
    ResumeServices "$Rst"
}

SetTimeManually()
{
    local ret

    SuspendServices "C D W" Rst || return 1
    ret=0
    wkill "$CRON$"
    wkill 'ntpd '
    if $DIALOG 2>$TMPFILE --title " `Tstr TitSetTimeManually` (1) " --calendar "`Tstr TxtDateEntryKeys`" 8 `Size SetTimeManually`; then
	Date=`sed 's,\(..\)/\(..\)/\(....\),\3\2\1,' <$TMPFILE`
	if $DIALOG 2>$TMPFILE --title " `Tstr TitSetTimeManually` (2) " --timebox "`Tstr TxtTimeEntryKeys`" 7 `Size SetTimeManually`; then
	    Time=`sed 's/\(..\):\(..\):\(..\)/\1\2.\3/' <$TMPFILE`
	    date "$Date$Time" >/dev/null
	else
	    ret=2
	fi
    else
	ret=2
    fi
    $NTPDBIN $NTPDFLG
    /usr/sbin/$CRON
    ResumeServices "$Rst"
    return $ret
}

SetTimeFromNet()
{
    srv=`awk '/^server[ 	]*/{print $2}' /etc/ntpsync.conf`
    if [ "$srv" = $NTPLOCAL ]; then
	GATEWAY=`netstat -nr | awk '/^default/{print $2}'`
	if [ -z "$GATEWAY" ]; then
	    MsgBox MsgNeedPredefOrGateway
	    return 1
	fi
	YesNoBox MsgTryPredefined || return 1
	SuspendServices "C D W" Rst || return 1
	wkill "$CRON$"
	wkill 'ntpd '
	SRV1=`Tstr TxtNTPServer1`
	SRV2=`Tstr TxtNTPServer2`
	while :
	do
	    if ping -c 1 -t 3 "$SRV1" >/dev/null 2>&1; then
		$NTPDATE $SRV1 >/dev/null 2>&1 && break
	    fi
	    if ping -c 1 -t 3 "$SRV2" >/dev/null 2>&1; then
		$NTPDATE $SRV2 >/dev/null 2>&1 && break
	    fi
	    YesNoBox MsgRetryTimeServers $SRV1 $SRV2 || break
	done
	$NTPDBIN $NTPDFLG
	/usr/sbin/$CRON
	ResumeServices "$Rst"
    elif NoYesBox MsgUseNtpsync; then
	if [ "`pidof 'ntpd -c'`" ]; then
	    MsgBox MsgSettingInProgress
	    return 1
	fi
	/usr/local/bin/ntpsync &
    else
	test $? -eq 255 && return	# return if ESC on progressive/immediate Box
	SuspendServices "C D W" Rst || return 1
	wkill "$CRON$"
	wkill 'ntpd '
	while :
	do
	    if ping -c 1 -t 3 "$srv" >/dev/null 2>&1; then
		$NTPDATE $srv >/dev/null 2>&1 && break
	    fi
	    YesNoBox MsgRetryTimeServer "$srv" || break
	done
	$NTPDBIN $NTPDFLG
	/usr/sbin/$CRON
	ResumeServices "$Rst"
    fi
}

GetNTPServer()
{
    local srv

    srv=`awk '/^server[ 	]*/{print $2}' /etc/ntpsync.conf`
    test "$srv" != $NTPLOCAL && echo "$srv"
}

CheckNTPServer()
{
    Dots=`expr "$1" : '.*\.'`
    Spaces=`expr "$1" : '.* '`
    if [ -z "$1" ]; then
	if [ -z "$2" ]; then
	    MsgBox MsgCantDeleteTimeServer
	    return 3
	fi
	return 0
    fi
    if [ "$1" = $NTPLOCAL ]; then
	MsgBox MsgLocalReserved
	return 2
    fi
    if [ $Spaces -gt 0 -o $Dots -eq 0 ]; then
	MsgBox MsgInvalidHostName
	return 1
    fi
    return 0
}

SetTimeServer()
{
    local Title NTPSERV NTPSERV_ isLocal inCron CanDelete

    Title=`Tstr TitTimeServer`
    NTPSERV=`GetNTPServer`
    NTPSERV_="$NTPSERV"
    grep "^server[ 	]*$NTPLOCAL" /etc/ntp.conf >/dev/null && isLocal=y
    crontab -l | grep /usr/local/bin/ntpsync >/dev/null && inCron=y
    test "$isLocal" -a ! "$inCron" && CanDelete=y || CanDelete=
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title " --max-input 50 --inputbox "\n `Tstr InpTimeServer`" 9 `Size TimeServer` "$NTPSERV_" || return 1
	NTPSERV_=`cat $TMPFILE`
	CheckNTPServer "$NTPSERV_" "$CanDelete" && break
	test $? -gt 2 && NTPSERV_="$NTPSERV"
    done
    if [ "$NTPSERV_" = "$NTPSERV" ]; then
	MsgBox MsgConfigNotModified
	return 0
    fi
    $DIALOG --title " $Title " --yesno "\n`Tmsg MsgTimeServerConfig "$NTPSERV" "$NTPSERV_"`" 14 `Size TimeServerConfig` || return 1

    test "$NTPSERV_" || NTPSERV_=$NTPLOCAL
    echo -e "/^server[ 	]/s/^.*$/server $NTPSERV_ burst/\nw" | ed - /etc/ntpsync.conf
    if [ ! "$isLocal" ]; then
	echo -e "/^server[ 	]/s/^.*$/server $NTPSERV_/\nw" | ed - /etc/ntp.conf
	wkill 'ntpd '
	$NTPDBIN $NTPDFLG
    fi
    return 0
}

GetTimeSync()
{
    local srv mn hr dy mo wd cmd

    srv=`awk '/^server[ 	]*/{print $2}' /etc/ntp.conf`
    if [ "$srv" != $NTPLOCAL ]; then
	Tstr TxtSyncPermanent
	return
    fi
    crontab -l | grep /usr/local/bin/ntpsync >$TMPFILE
    read mn hr dy mo wd cmd <$TMPFILE
    if [ "$wd" ]; then
	echo "`Tstr TxtSyncDay$wd``Tmsg TxtSyncTime $hr $mn`"
	return
    fi
    Tstr TxtSyncNever
}

SyncTimeNever()
{
    local isLocal inCron

    grep "^server[ 	]*$NTPLOCAL" /etc/ntp.conf >/dev/null && isLocal=y
    crontab -l | grep /usr/local/bin/ntpsync >/dev/null && inCron=y
    if [ -z "$1" ]; then	# Not interactive
	if [ ! "$isLocal" -o "$inCron" ]; then
	    $DIALOG --title " `Tstr TitTimeSync` " --yesno "\n`Tmsg MsgSyncTimeConfig "\`GetTimeSync\`" "\`Tstr TxtSyncNever\`"`" 14 `Size SyncTimeConfig` || return 1
	fi
    fi
    if [ ! "$isLocal" ]; then
	cat >/etc/ntp.conf <<-EOF
	#
	#	ntp.conf - Config file for ntpd
	#	WARNING: this file will be overwritten by menucam
	#
	driftfile /etc/ntp.drift
	server $NTPLOCAL
	fudge $NTPLOCAL stratum 0
	disable ntp
EOF
	wkill 'ntpd '
	$NTPDBIN $NTPDFLG
    fi
    if [ "$inCron" ]; then
	crontab -l | grep -v /usr/local/bin/ntpsync | crontab -
    fi
}

CheckSyncTime()
{
    local ch cm

    ch=`expr "$1" : '\([0-9]*\)'`
    cm=`expr "$2" : '\([0-9]*\)'`
    if [ "$1" = "$ch" -a "$2" = "$cm" ]; then
	test "$1" -le 23 -a "$2" -le 59 && return 0
    fi
    MsgBox MsgInvalidSyncTime
    return 1
}

SyncTimePeriodic()
{
    local mn hr dy mo wd cmd STDIFS Title Time Time_ Sync Sync_ wd_ hr_ mn_

    crontab -l | grep /usr/local/bin/ntpsync >$TMPFILE
    read mn hr dy mo wd cmd <$TMPFILE

    Item3=0
    Time=
    if [ "$wd" ]; then
	Item3="$wd"
	test "$wd" = "*" && Item3=7
	Time="$hr:$mn"
    fi
    Title=`Tstr TitTimeSync`
    $DIALOG 2>$TMPFILE --title " $Title (1) " --default-item $Item3 \
	--cancel-label "$BtnBack" --menu "\n`Tstr InpSyncDay`\n" 16 `Size SyncDay` 8 \
	0 "`Tstr TxtSyncDay0`" \
	1 "`Tstr TxtSyncDay1`" \
	2 "`Tstr TxtSyncDay2`" \
	3 "`Tstr TxtSyncDay3`" \
	4 "`Tstr TxtSyncDay4`" \
	5 "`Tstr TxtSyncDay5`" \
	6 "`Tstr TxtSyncDay6`" \
	7 "`Tstr "TxtSyncDay*"`" || return 1
    Item3=`cat $TMPFILE`
    test "$Item3" = "7" && wd_="*" || wd_="$Item3"

    Time_="$Time"
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title (2) " --max-input 5 --inputbox "\n `Tstr InpSyncTime`" 9 `Size SyncTime` "$Time_" || return 1
	Time_=`cat $TMPFILE`
	STDIFS="$IFS"
	IFS=:
	set $Time_
	IFS="$STDIFS"
	CheckSyncTime "$1" "$2" && break
    done
    hr_="$1"
    mn_="$2"

    if [ "$wd_" = "$wd" -a "$Time_" = "$Time" ]; then
	MsgBox MsgConfigNotModified
	return 1
    fi
    Sync=`GetTimeSync`
    Sync_="`Tstr "TxtSyncDay$wd_"``Tmsg TxtSyncTime $hr_ $mn_`"
    $DIALOG --title " $Title " --yesno "\n`Tmsg MsgSyncTimeConfig "$Sync" "$Sync_"`" 14 `Size SyncTimeConfig` || return 1

    SyncTimeNever n
    (crontab -l; echo "$mn_ $hr_ * * $wd_ /usr/local/bin/ntpsync") | crontab -
}

SyncTimeAlways()
{
    local isLocal inCron srv

    grep "^server[ 	]*$NTPLOCAL" /etc/ntp.conf >/dev/null && isLocal=y
    crontab -l | grep /usr/local/bin/ntpsync >/dev/null && inCron=y
    if [ "$isLocal" ]; then
	$DIALOG --title " `Tstr TitTimeSync` " --yesno "\n`Tmsg MsgSyncTimeConfig "\`GetTimeSync\`" "\`Tstr TxtSyncPermanent\`"`" 14 `Size SyncTimeConfig` || return 1
	srv=`awk '/^server[ 	]*/{print $2}' /etc/ntpsync.conf`
	cat >/etc/ntp.conf <<-EOF
	#
	#	ntp.conf - Config file for ntpd
	#	WARNING: this file will be overwritten by menucam
	#
	driftfile /etc/ntp.drift
	server $srv
EOF
	wkill 'ntpd '
	$NTPDBIN $NTPDFLG
    fi
    if [ "$inCron" ]; then
	crontab -l | grep -v /usr/local/bin/ntpsync | crontab -
    fi
}

SetupTimeSync()
{
    local TimeServer TimeSync State

    TimeServer=`GetNTPServer`
    if [ -z "$TimeServer" ]; then
	MsgBox MsgNoTimeServer
	return 1
    fi
    Item2=1
    while :
    do
	TimeSync=`GetTimeSync`
	State="`Tstr TxtCurrentTimeServer`$TimeServer"
	State="$State\n`Tstr TxtCurrentTimeSync`$TimeSync"
	$DIALOG 2>$TMPFILE --default-item $Item2 --ok-label "`Tstr BtnSelect`" --cancel-label "`Tstr BtnValidate`" \
	    --menu "`Tstr TitTimeSyncMenu`\n\n$State\n" 13 `Size TimeSyncMenu` 3 \
	    1 "`Tstr ItmSyncTimeNever`" \
	    2 "`Tstr ItmSyncTimePeriodic`" \
	    3 "`Tstr ItmSyncTimeAlways`" || break
	Item2=`cat $TMPFILE`
	case "$Item2" in
	    1)  SyncTimeNever	;;
	    2)  SyncTimePeriodic;;
	    3)  SyncTimeAlways	;;
	esac
    done
}

GetLogging()
{
    local disk soft car cdr

    disk=`df | awk '/^\/dev/{if (max < $2) {max=$2; dsk=$6}} END{print dsk}'`
    tunefs -p $disk 2>&1 | sed -n '/soft updates/s/.*) *//p' | awk '{ printf("%s%s ", toupper(substr($0,1,1)), substr($0,2))}'
}

DetectMod()
{
    local version i Rs ni msg dev

    Rs=
    if [ "`pidof 'camiod'`" ]; then
	if CamService active; then
	    NoYesBox MsgConfirmSuspendServices "`Tstr MsgCamService`" || return
	    CamService stop
	    Rs=y
	fi
    fi

    i=0
    while :
    do
	test -e "/dev/$CUA$i" || break
	test "`grep "^$CUA$i[ 	]" /etc/ttys`" && i=`expr $i + 1` && continue
	if [ "`grep "archttp32_enable=\"YES\"" $RCCONF`" ]; then
	    version=`grep "archttp32_flags=" $RCCONF | cut -d ' ' -f 2`
	    if [ "$version" ]; then
		version=`expr $version - 1`
		test "$version" -eq "$i" && i=`expr $i + 1` && continue
	    fi
	fi
	version=`camiod -d /dev/$CUA$i -v`
	test "$version" && break
	i=`expr $i + 1`
    done

    dev=/dev/$CUA$i
    msg=`psql -A -t -c "SELECT io_tty FROM config" $DB camtrace`
    if [ "$dev" = "$msg" ]; then
	msg="`Tstr MsgModuleAlreadyConfigured`"
    elif [ -z "$msg" -a "$version" ]; then
	msg="`Tstr MsgModuleNotConfigured`"
    elif [ "$version" ]; then
	msg="`Tstr MsgModuleMisconfigured`"
    fi

    if [ "$i" -eq 0 -a -z "$version" ]; then
	MsgBox MsgNoSerialPort
    elif [ -z "$version" ]; then
	MsgBox MsgNoModuleDetected
    else
	i=`expr $i + 1`
	ni=
	if [ "$version" = "4.5" ]; then
	    ni=8
	    version=1
	elif [ "$version" = "8.1" ]; then
	    ni=8
	    version=2
	elif [ "$version" = "2.1" ]; then
	    ni=2
	    version=2
	else
	    msg="`Tmsg MsgUnknownModule $version $i `\n$msg"
	fi
	test -z "$ni" || msg="`Tmsg MsgModuleDesc $version $i $dev $ni`\n$msg"
	$DIALOG --msgbox "$msg" 7 50
    fi
    test "$Rs" && CamService start
    test -z "$msg" && sleep $INFO_WAIT
}

SelectModPort()
{
    local i last nb menu vers

    i=0
    nb=1
    menu=
    last=
    while :
    do
	test -e "/dev/$CUA$i" || break
	test "`grep "^$CUA$i[ 	]" /etc/ttys`" && i=`expr $i + 1` && continue
	if [ "`grep "archttp32_enable=\"YES\"" $RCCONF`" ]; then
	    vers=`grep "archttp32_flags=" $RCCONF | cut -d ' ' -f 2`
	    if [ "$vers" ]; then
		vers=`expr $vers - 1`
		test "$vers" -eq "$i" && i=`expr $i + 1` && continue
	    fi
	fi
	if [ "`camiod -d /dev/$CUA$i -v`" ]; then
	    i=`expr $i + 1`
	    last=$i
	    menu="$menu$nb \"COM$i\" "
	    nb=`expr $nb + 1`
	    continue
	fi
	i=`expr $i + 1`
    done

    nb=`expr $nb - 1`
    if [ "$nb" -eq "0" -a "$i" -eq "0" ]; then
	MsgBox MsgNoSerialPort || return
    elif [ "$nb" -eq "0" ]; then
	MsgBox MsgNoModuleDetected || return
    elif [ "$nb" -eq "1" ]; then
	MsgBox MsgAssumingPort $last || return
    fi
    if [ "$nb" -eq "0" -o "$nb" -eq "1" ]; then
#	sleep $INFO_WAIT
    else
	$DIALOG 2>$TMPFILE --cancel-label "$BtnBack" --menu \
		"`Tstr TitSelectCamIOPort`" $($nb + 7) 40 $nb $menu || nb=0
	test "$nb" = "0" && last= || last=`cat $TMPFILE`
    fi

    test "$last" && last="/dev/$CUA`expr $last - 1`"
    echo "$last" >$TMPFILE
}

InputMod()
{
    local Rs dev trace i menu obj state input inp wdog camiopid timeout

    Rs=
    if [ "`pidof 'camiod'`" ]; then
	if CamService active; then
	    NoYesBox MsgConfirmSuspendServices "`Tstr MsgCamService`" || return
	    CamService stop
	    Rs=y
	fi
    fi
    timeout=0
    SelectModPort || return
    dev=`cat $TMPFILE`
    if [ "$dev" ]; then
	trace=/tmp/camiodtrace
	test -e $input && rm -f $input
	camiod -d $dev -t $timeout >$trace 2>&1 &
	$DIALOG --title "`Tstr TitTestModInputs`" --tailbox $trace 15 40
	camiopid=`pidof 'camiod'`
	kill -SIGHUP $camiopid >/dev/null 2>&1
	fg >/dev/null 2>&1
	rm -f $trace
    fi
    test "$Rs" && CamService start
}

OutputMod()
{
    local Rs dev rows input trace timeout camiopid cur cmd

    Rs=
    if [ "`pidof 'camiod'`" ]; then
	if CamService active; then
	    NoYesBox MsgConfirmSuspendServices "`Tstr MsgCamService`" || return
	    CamService stop
	    Rs=y
	fi
    fi
    SelectModPort || return
    dev=`cat $TMPFILE`
    if [ "$dev" ]; then
	InfoBox TxtReinitOutputs
	camiod -d $dev -o >$TMPFILE
	trace=/tmp/camiodtrace
	input=/tmp/camiodinput
	timeout=3
	i=0
	test -e "$input" && rm -f $input
	mkfifo $input
	camiod -d $dev -i $input -t $timeout >$trace 2>&1 &
	echo "" >$input
	sleep 2
	camiopid=`pidof 'camiod'`
	rows=`cat $TMPFILE | wc -l | awk '{print $1}'`
	cmd=
	while :
	do
	    cur=`expr $i + 1`
	    test "$cur" -eq "$rows" && break		#exclude watchdog
	    if [ "`cat $TMPFILE | head -$cur | tail -1 | grep ":1$"`" ]
	    then
		echo "$i:0" >$input
		sleep 3
	    fi
	    i=$cur
	done
	wdog=$rows
	cur=0
	while :
	do
	    test "$cur" -eq "$wdog" && break
	    echo "$cur:1" >$input
	    InfoBox TxtClosingOutput $cur
	    sleep 3
	    echo "$cur:0" >$input
	    cur=`expr $cur + 1`
	done
	kill -SIGUSR1 $camiopid
	InfoBox TxtReinitWatchdog
	sleep `expr $timeout + 1`
	kill -SIGHUP $camiopid
	fg >/dev/null 2>&1
    fi
    test "$Rs" && CamService start
}

DebugMod()
{
    local Rs dev trace i menu state trace log inp wdog camiopid timeout

    Rs=
    if [ "`pidof 'camiod'`" ]; then
	if CamService active; then
	    NoYesBox MsgConfirmSuspendServices "`Tstr MsgCamService`" || return
	    CamService stop
	    Rs=y
	fi
    fi
    timeout=0
    SelectModPort || return
    dev=`cat $TMPFILE`
    if [ "$dev" ]; then
	trace=/tmp/camiodtrace
	log=/tmp/camiodlog
	camiod -x255 -d $dev -t $timeout -l $log >$trace 2>&1 &
	sleep 2
	eval `GetScrSize 'inp=%r state=%c'`
	inp=`expr $inp - 3`
	state=`expr $state - 3`
	$DIALOG --title "`Tstr TitModDebug`" --tailbox $log $inp $state
	camiopid=`pidof 'camiod'`
	kill -SIGHUP $camiopid >/dev/null 2>&1
	fg >/dev/null 2>&1
	rm -f $trace $log
    fi
    test "$Rs" && CamService start
}

CamIOMod()
{
    Item2=1
    while :
    do
	if $DIALOG 2>$TMPFILE --default-item "$Item2" --cancel-label \
		"$BtnBack" --menu "`Tstr TitContactMod`" 11 35 4 \
	    1 "`Tstr ItmDetectMod`" \
	    2 "`Tstr ItmInputMod`" \
	    3 "`Tstr ItmOutputMod`" \
	    4 "`Tstr ItmDebugMod`"
	then
	    Item2=`cat $TMPFILE`
	    case "$Item2" in
		1)  DetectMod	;;
		2)  InputMod	;;
		3)  OutputMod	;;
		4)  DebugMod	;;
	    esac
	else
	    break
	fi
    done
}

SHMConfig()
{
    local phys shmm shm shm_ min max ToMb

    phys=`sysctl -n hw.physmem`
    shmm=`sysctl -n kern.ipc.shmmax`
    if [ -z "$shmm" -o -z "$phys" ]; then
	MsgBox MsgCantGetSHMInfos
    fi
    ToMb=`expr 1024 '*' 1024`
    shm=`expr $shmm / $ToMb`
    shm_=$shm
    min=16
    max=`expr $phys / 4`
    max=`expr $max / $ToMb`
    while :
    do
	$DIALOG 2>$TMPFILE --inputbox "`Tmsg TitSHMConfig "$min" "$max"`" 9 60 "$shm_" || return
	shm_=`sed 's/"//g' $TMPFILE`
	if [   "$shm_" -lt $min ]; then
	    MsgBox MsgGivenTooSmall
	elif [ "$shm_" -gt $max ]; then
	    MsgBox MsgGivenTooBig
	elif [ "$shm_" -eq "$shmm" ]; then
	    MsgBox MsgGivenIsSame
	elif [ "$shm_" -gt 0 ]; then
	    shm=`expr $shm_ / 16`
	    if [ "`expr $shm '*' 16`" = "$shm_" ]; then
		break
	    else
		MsgBox MsgNeed16Pow
	    fi
	else
	    MsgBox MsgGivenTooAlpha
	fi
    done
    shm=`expr $shm_ '*' $ToMb`
    sysctl kern.ipc.shmmax=$shm >/dev/null
    if grep "kern.ipc.shmmax=" /etc/sysctl.conf >/dev/null; then
	echo -e "/kern.ipc.shmmax=/s/.*/kern.ipc.shmmax=$shm/\nw" | ed - /etc/sysctl.conf
    else
	echo "kern.ipc.shmmax=$shm" >>/etc/sysctl.conf
    fi
}

SysConfig()
{
    local KbdLayout TimeZone CurDate TimeServer Logging State

    Item1=1
    while :
    do
	eval `grep '^keymap=' $RCCONF`
	KbdLayout=`(gettext TxtKeyboardMaps$OSRel;echo) | awk -F'|' "\\\$2 == \"${keymap:-us.iso}\"{print \\\$1}"`
	if [ -L $TIMEZONE ]; then
	    TimeZone=`ls -l $TIMEZONE | sed 's,^.* -> /usr/share/zoneinfo/,,'`
	else
	    TimeZone=`Tstr MsgTimeZoneGMT`
	fi
	CurDate=`date "\`Tstr FmtDate\`"`
	TimeServer=`GetNTPServer`
	test "$TimeServer" || TimeServer="`Tstr TxtLocalTimeServer`"
	TimeSync=`GetTimeSync`
	Logging=`GetLogging`
	State="`Tstr TxtKeyboardLayout`$KbdLayout"
	State="$State\n`Tstr TxtCurrentTimeZone`$TimeZone"
	State="$State\n`Tstr TxtCurrentDate`$CurDate"
	State="$State\n`Tstr TxtCurrentTimeServer`$TimeServer"
	State="$State\n`Tstr TxtCurrentTimeSync`$TimeSync"
	State="$State\n`Tstr TxtLogging``Tstr TxtLog$Logging`"
	$DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
	    --menu "`Tstr TitSysConfigMenu`\n\n$State\n" 22 `Size SysConfigMenu` 8 \
	    1 "`Tstr ItmSetupLang`" \
	    2 "`Tstr ItmSetupKeyboard`" \
	    3 "`Tstr ItmSetupTimeZone`" \
	    4 "`Tstr ItmSetTimeManually`" \
	    5 "`Tstr ItmSetTimeFromNet`" \
	    6 "`Tstr ItmSetTimeServer`" \
	    7 "`Tstr ItmSetupTimeSync`" \
	    8 "`Tstr ItmCamIOMod`" || break
	Item1=`cat $TMPFILE`
	case "$Item1" in
	    1)  SetupLang	;;
	    2)  SetupKeyboard	;;
	    3)  SetupTimeZone	;;
	    4)  SetTimeManually	;;
	    5)  SetTimeFromNet	;;
	    6)  SetTimeServer	;;
	    7)  SetupTimeSync	;;
	    8)	CamIOMod	;;
	esac
    done
}

# =====	Network Configuration =========================================

CheckHostName()
{
    local Dots Spaces

    Dots=`expr "$1" : '.*\.'`
    Spaces=`expr "$1" : '.* '`
    if [ -z "$1" -o $Spaces -gt 0 -o $Dots -eq 0 -o "`echo $1 | grep -i '^localhost\.'`" ]; then
	MsgBox MsgInvalidHostName
	return 1
    fi
    return 0
}

CheckGenericName()
{
    local Fbd tmp msg

    Fbd=`echo "$1" | egrep "\^|\*|\.|\?|\"|'| "`
    if [ -z "$1" -o "$Fbd" ]; then
	test "$2" && msg="MsgInvalid"$2"Name" || return 1
	MsgBox $msg $1
	return 1
    fi
    return 0
}

CheckIP()
{
    ipcalc -c "$1" >/dev/null && return 0
    MsgBox MsgInvalidIP
    return 1
}

CheckMask()
{
    ipcalc -m "$1" >/dev/null && return 0
    MsgBox MsgInvalidMask
    return 1
}

CheckNetwork()
{
    local res

    # $1=ip $2=mask
    res=`ipcalc -n $1 $2`
    if [ "$1" = "$res" ]; then
	MsgBox MsgHostIsNetwork
	return 1
    fi
    return 0
}

CheckBdcast()
{
    local res

    # $1=ip $2=mask
    res=`ipcalc -b $1 $2`
    if [ "$1" = "$res" ]; then
	MsgBox MsgHostIsBdcast
	return 1
    fi
    return 0
}

CheckAuth()
{
    test `expr "$1" : '[^:][^:]*\:[^:]*$'` -gt 0
}

CheckNumber()
{
    test "`expr "$1" : '\([0-9]*\)$'`" = "$1" && return 0
    MsgBox MsgInvalidNumber
    return 1
}

CheckBandwidth()
{
    test "$1" -le 2147483 && return 0
    MsgBox MsgBandwidthTooLarge
    return 1
}

HostOnly()
{
    local Title HOSTNAM_ ip lan cip msk host i add del host edCmd

    Title=`Tstr TitHostOnly`
    HOSTNAM_="$HOSTNAM"
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title " --max-input 50 --inputbox "\n `Tstr InpFQDNPPP`" 10 `Size HostOnly` "$HOSTNAM_" || return 1
	HOSTNAM_=`cat $TMPFILE`
	if [ "$HOSTNAM_" = "?" ]; then
	    ip=`ifconfig -a | sed -n '/ --> /s/^	inet \([0-9\.]*\) --> .*/\1/p'`
	    host=`nslookup $ip | sed -n '/^Name:/s/^Name: *//p'`
	    if [ "$host" ]; then
		HOSTNAM_="$host"
		continue
	    fi
	fi
	CheckHostName "$HOSTNAM_" && break
    done
    if [ "$HOSTNAM_" = "$HOSTNAM" ]; then
	MsgBox MsgConfigNotModified
	return 1
    fi
    $DIALOG --title " $Title " --yesno "\n`Tmsg MsgHostConfig "$HOSTNAM" "$HOSTNAM_"`" 14 `Size HostConfig` || return 1

    edCmd="g/^hostname=/d\n1i\n.\n/^[^#]/i\nhostname=\"$HOSTNAM_\"\n.\nw"
    echo -e "$edCmd" | ed - $RCCONF
    i=0
    add=
    del=
    host=`expr "$HOSTNAM_" : '\([^.][^.]*\)\..*'`
    while :
    do
	eval "lan=\$ITF$i cip=\$IPADR$i msk=\$MASK$i"
	test "$lan" || break
	i=`expr $i + 1`
	test "$cip" || continue
	d="g/^$cip[ 	]/d"
	test "$del" && del="$del$NL$d" || del="$d"
	a="$cip	$HOSTNAM_ $host$NL$cip	$HOSTNAM_."
	test "$add" && add="$add$NL$a" || add="$a"
    done
    if [ "$del" -a "$add" ]; then
	ed - /etc/hosts <<-EOF
	$del
	1i
	.
	/127\.0\.0\.1/a
	$add
	.
	w
EOF
    fi
    hostname "$HOSTNAM_"
    if [ -e "$APACHESSL" ]; then
	ed - $APACHESSL <<-EOF
		g/^ServerName/s/^ServerName.*/ServerName $HOSTNAM_/
		w
EOF
    fi
    HOSTNAM="$HOSTNAM_"

    return 0
}

HostNameGate()
{
    local NAMESRV GATEWAY Title HOSTNAM_ NAMESRV_ GATEWAY_ edCmd host domain Domain Server i lan ip msk add del gw a d

    NAMESRV=
    test -f $RESOLV && NAMESRV=`awk '/^nameserver/{print $2;exit}' $RESOLV`
    GATEWAY=`sed -n '/^defaultrouter=/s/.*="\([^"]*\).*$/\1/p' $RCCONF`
    if [ -e $DHCPCCONF -a "`egrep "^[ 	]*(prepend|append)[ 	]*domain-name-servers[ 	]*" $DHCPCCONF`" ]; then
	d="`egrep "^[ 	]*(prepend|append)[ 	]*domain-name-servers[ 	]*" $DHCPCCONF | awk '{print $3}' | sed 's/;//g'`"
	test "$d" && NAMESRV="$d"
	d=
    fi
    Title=`Tstr TitHostNameGate`

    HOSTNAM_="$HOSTNAM"
    NAMESRV_=$NAMESRV
    GATEWAY_=$GATEWAY
    if [ "$IPFW" ]; then
	GBWIDTH=`sed -n 's/^pipe 1 config bw \([0-9]*\)Kbit.*/\1/p' $IPFW`
	GBWIDTH_=$GBWIDTH
    else
	GBWIDTH=
	GBWIDTH_=
    fi

    DefItem2="`Tstr InpSystemFQDN`"
    while :
    do
	if [ "$IPFW" ]; then
	    $DIALOG --ok-label "$BtnApply" --cancel-label "$BtnBack"			\
		--default-item "$DefItem2" --form "       $Title" 14 75 7		\
		"`Tstr InpSystemFQDN`"		1  2	"$HOSTNAM_"	1 46	30 50	\
		"`Tstr InpNameServerAddress`"	2  2	"$NAMESRV_"	2 46	16 15	\
		"`Tstr InpGatewayAddress`"	4  2	"$GATEWAY_"	4 46	16 15	\
		"`Tstr InpGatewayBandwidth`"	6  2	"$GBWIDTH_"	6 46	 9  8	\
		"`Tstr InpBlankForUnspecified`"	3  6	""		3 46	 0  0	\
		"`Tstr InpBlankForUnspecified`"	5  6	""		5 46	 0  0	\
		"`Tstr InpBlankForUnlimited`"	7  6	""		7 46	 0  0	\
		2>$TMPFILE || return 1
	else
	    $DIALOG --ok-label "$BtnApply" --cancel-label "$BtnBack"			\
		--default-item "$DefItem2" --form " $Title" 12 75 5			\
		"`Tstr InpSystemFQDN`"		1  2	"$HOSTNAM_"	1 46	30 50	\
		"`Tstr InpNameServerAddress`"	2  2	"$NAMESRV_"	2 46	16 15	\
		"`Tstr InpGatewayAddress`"	4  2	"$GATEWAY_"	4 46	16 15	\
		"`Tstr InpBlankForUnspecified`"	3  6	""		3 46	 0  0	\
		"`Tstr InpBlankForUnspecified`"	5  6	""		5 46	 0  0	\
		2>$TMPFILE || return 1
	fi

	exec		3<$TMPFILE
	read HOSTNAM_		<&3
	read NAMESRV_		<&3
	read GATEWAY_		<&3
	if [ "$IPFW" ]; then
	    read GBWIDTH_	<&3
	fi
	exec		3<&-

	DefItem2="`Tstr InpSystemFQDN`"
	CheckHostName "$HOSTNAM_" || continue

	if [ "$NAMESRV_" ]; then
	    DefItem2="`Tstr InpNameServerAddress`"
	    CheckIP "$NAMESRV_" || continue
	fi
	if [ "$GATEWAY_" ]; then
	    DefItem2="`Tstr InpGatewayAddress`"
	    CheckIP "$GATEWAY_" || continue
	fi
	if [ "$IPFW" -a "$GBWIDTH_" -a "$GATEWAY_" ]; then
	    DefItem2="`Tstr InpGatewayBandwidth`"
	    CheckNumber "$GBWIDTH_" || continue
	    CheckBandwidth "$GBWIDTH_" || continue
	fi

	if [ "$HOSTNAM_" = "$HOSTNAM" -a "$NAMESRV_" = "$NAMESRV" -a "$GATEWAY_" = "$GATEWAY" -a "$GBWIDTH_" = "$GBWIDTH" ]; then
	    MsgBox MsgConfigNotModified
	    return 0
	fi

	if [ "$IPFW" ]; then
	    $DIALOG --title " $Title " --yesno "\n`Tmsg MsgNameBWConfig "$HOSTNAM" "$NAMESRV" "$GATEWAY" "$GBWIDTH" "$HOSTNAM_" "$NAMESRV_" "$GATEWAY_" "$GBWIDTH_"`" 20 `Size NameBWConfig` || continue

	    if [ "$GBWIDTH" != "$GBWIDTH_" -o '(' "$GBWIDTH" -a "$GATEWAY" != "$GATEWAY_" ')' ]; then
		if [ "$GBWIDTH" ]; then
		    echo -e "g/pipe 1 /d\nw" | ed - $IPFW
		    ipfw delete 60100
		    ipfw pipe delete 1
		fi
		if [ "$GBWIDTH_" ]; then
		    if [ $GBWIDTH_ -lt 10 ]; then
			qsz=1500
		    else
			qsz=`expr $GBWIDTH_ '*' 100`
			test $qsz -gt 1048576 && qsz=1048576
		    fi
		    pipe="pipe 1 config bw ${GBWIDTH_}Kbit/s queue ${qsz}Bytes"
		    rule="add 60100 pipe 1 ip from any to $GATEWAY_ out"
		    echo "$pipe" >>$IPFW
		    echo "$rule" >>$IPFW
		    ipfw $pipe >/dev/null
		    ipfw $rule >/dev/null
		fi
	    fi
	else
	    $DIALOG --title " $Title " --yesno "\n`Tmsg MsgNameConfig "$HOSTNAM" "$NAMESRV" "$GATEWAY" "$HOSTNAM_" "$NAMESRV_" "$GATEWAY_"`" 18 `Size NameConfig` || continue
	fi
	break
    done

    edCmd="g/^hostname=/d\ng/^defaultrouter=/d\n1i\n.\n/^[^#]/i\nhostname=\"$HOSTNAM_\""
    test "$GATEWAY_" && edCmd="$edCmd\ndefaultrouter=\"$GATEWAY_\""
    edCmd="$edCmd\n.\nw"
    echo -e "$edCmd" | ed - $RCCONF

    i=0
    gw=
    add=
    del=
    host=`expr "$HOSTNAM_" : '\([^.][^.]*\)\..*'`
    while :
    do
	eval "lan=\$ITF$i ip=\$IPADR$i msk=\$MASK$i"
	test -z "$lan" && break
	i=`expr $i + 1`
	test -z "$ip" && continue
	ipcalc -s "$GATEWAY_" "$ip" "$msk" >/dev/null && gw=y
	d="g/^$ip[ 	]/d"
	test "$del" && del="$del$NL$d" || del="$d"
	a="$ip	$HOSTNAM_ $host$NL$ip	$HOSTNAM_."
	test "$add" && add="$add$NL$a" || add="$a"
    done
    domain=`expr "$HOSTNAM_" : '[^.][^.]*\.\(.*\)'`
    Domain=
    if [ "$GATEWAY_" != "$GATEWAY" ]; then
	route delete default >/dev/null
	if [ "$GATEWAY_" ]; then
	    if [ "$gw" ]; then
		route add default $GATEWAY_ >/dev/null
	    else
		MsgBox MsgRouteNotValidYet $GATEWAY_
	    fi
	fi
    fi
    if [ -e $DHCPCCONF -a "`egrep "^[ 	]*(supersede|prepend|append)[ 	]*domain-name(|-servers)" $DHCPCCONF`" ]; then
	if [ "`egrep "^[ 	]*supersede[ 	]*domain-name[ 	]*" $DHCPCCONF`" ]; then
	    ed - $DHCPCCONF <<-EOF
		g/^[ 	]*supersede[ 	]*domain-name[ 	]*.*/d
		w
EOF
	    echo "supersede domain-name \"$domain\";" >>$DHCPCCONF
	elif [ "`egrep "^[ 	]*append[ 	]*domain-name[ 	]*" $DHCPCCONF`" ]; then
	    ed - $DHCPCCONF <<-EOF
		g/^[ 	]*append[ 	]*domain-name[ 	]*.*/d
		w
EOF
	    echo "append domain-name \"$domain\";" >>$DHCPCCONF
	fi
	if [ "`egrep "^[ 	]*prepend[ 	]*domain-name-servers[ 	]*" $DHCPCCONF`" ]; then
	    ed - $DHCPCCONF <<-EOF
		g/^[ 	]*prepend[ 	]*domain-name-servers[ 	]*.*/d
		w
EOF
	    echo "prepend domain-name-servers $NAMESRV_;" >>$DHCPCCONF
	elif [ "`egrep "^[ 	]*append[ 	]*domain-name-servers[ 	]*" $DHCPCCONF`" ]; then
	    ed - $DHCPCCONF <<-EOF
		g/^[ 	]*append[ 	]*domain-name-servers[ 	]*.*/d
		w
EOF
	    echo "append domain-name-servers $NAMESRV_;" >>$DHCPCCONF
	fi
	if [ "`egrep "^[ 	]*supersede[ 	]*routers[ 	]*" $DHCPCCONF`" ]; then
	    ed - $DHCPCCONF <<-EOF
		g/^[ 	]*supersede[ 	]*routers[ 	]*.*/d
		w
EOF
	    echo "supersede routers $GATEWAY_;" >>$DHCPCCONF
	fi
    fi
    if [ "$del" -a "$add" ]; then
	ed - /etc/hosts <<-EOF
	$del
	1i
	.
	/127\.0\.0\.1/a
	$add
	.
	w
EOF
    fi
    hostname "$HOSTNAM_"

    if [ -e "$APACHESSL" ]; then
	ed - $APACHESSL <<-EOF
		g/^ServerName/s/^ServerName.*/ServerName $HOSTNAM_/
		w
EOF
    fi
    HOSTNAM="$HOSTNAM_"

    test "$domain" && Domain="domain $domain\n"
    Server=
    test "$NAMESRV_" && Server="nameserver $NAMESRV_\n"
    echo -e "$Domain$Server\c" >$RESOLV

    return 0
}

ADSLNet()
{
    local USER PASS Title ISP_ USER_ PASS_ host i

#    if [ -z "$IPADR0" ]; then
#	MsgBox MsgNoAvailableNIF
#	return 1
#    fi
    USER=
    PASS=
    if [ "$ISP" ]; then
	USER=`sed -n 's/^ *set authname //p' /etc/ppp/ppp.conf`
	PASS=`sed -n 's/^ *set authkey //p' /etc/ppp/ppp.conf`
    else
	NoYesBox MsgConfirmADSL || return 1
    fi
    Title=`Tstr TitADSLNet`

    ISP_="$ISP"
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title (1) " --max-input 15 --inputbox "\n `Tstr InpInternetServiceProvider`" 9 `Size ADSLNet` "$ISP_" || return 1
	ISP_=`cat $TMPFILE`
	test "$ISP_" && break
    done

    USER_="$USER"
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title (2) " --max-input 40 --inputbox "\n `Tstr InpADSLUSer`" 9 `Size ADSLNet` "$USER_" || return 1
	USER_=`cat $TMPFILE`
	test "$USER_" && break
    done

    PASS_="$PASS"
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title (3) " --max-input 20 --inputbox "\n `Tstr InpADSLPass`" 9 `Size ADSLNet` "$PASS_" || return 1
	PASS_=`cat $TMPFILE`
	test "$PASS_" && break
    done

    if [ "$ISP" = "$ISP_" -a "$USER" = "$USER_" -a "$PASS" = "$PASS_" ]; then
	MsgBox MsgConfigNotModified
	return 1
    fi

    $DIALOG --title " $Title " --yesno "\n`Tmsg MsgADSLConfig "$ISP" "$USER" "$PASS" "$ISP_" "$USER_" "$PASS_"`" 18 `Size ADSLConfig` || return 1

    SuspendServices "C W" Rst Chg || return 1

    test -f /etc/ppp/ppp.conf -a ! -f /etc/save/ppp.conf && mv /etc/ppp/ppp.conf /etc/save
    cat >/etc/ppp/ppp.conf <<-EOF
	#
	#	ppp.conf - PPP connection to "$ISP_"
	#
	default:
	    set log Phase Chat tun command
	    set device pppoe:$ITF0
	    set timeout 120
	    set ifaddr 10.0.0.1/0 10.0.0.2/0 255.255.255.0 0.0.0.0
	    add default HISADDR
	    enable dns
	    enable lqr
	    set lqrperiod 10
	    allow mode direct

	$ISP_:
	    set mru 1492
	    set mtu 1492
	    set authname $USER_
	    set authkey $PASS_
	    set redial 1 2000
	    set reconnect 1 2000
EOF
    ed - $RCCONF <<-EOF
	g/^ppp_profile=/d
	g/^ppp_mode=/d
	g/^ppp_user=/d
	g/^ppp_enable=/d
	\$a
	ppp_enable="YES"
	ppp_mode="ddial"
	ppp_profile="$ISP_"
	ppp_user="root"
	.
	w
EOF

    if [ "$IPADR0" ]; then
	echo -e "g/^defaultrouter=/d\ng/^ifconfig_$ITF0=/d\nw" | ed - $RCCONF
	echo -e "g/^$IPADR0[ 	]/d\nw" | ed - /etc/hosts
	ifconfig $ITF0 delete
	IPADR0= ; MASK0=
    fi
    rm -f $RESOLV
    grep '^ng_pppoe_load=' /boot/loader.conf >/dev/null || echo 'ng_pppoe_load="YES"' >>/boot/loader.conf
    kldstat -n 'ng_pppoe' >/dev/null 2>&1 || kldload ng_pppoe
    wkill 'ppp '
    /usr/sbin/ppp -quiet -ddial -nat $ISP_
    host=`hostname`
    if [ "$host" ]; then
	i=0
	while [ $i -lt 10 ]
	do
	    host "$host" >/dev/null 2>&1 && break
	    i=$(($i + 1))
	done
    fi
    ISP="$ISP_"

    ResumeServices "$Rst"
}

RemoveADSL()
{
    local host

    NoYesBox MsgConfirmRemoveADSL || return 1
    SuspendServices "C W" Rst || return 1
    wkill 'ppp '
    rm -f /etc/ppp/ppp.conf $RESOLV
    ed - $RCCONF <<-EOF
	g/^ppp_enable=/d
	g/^ppp_mode=/d
	g/^ppp_profile=/d
	g/^ppp_user=/d
	w
EOF
    echo -e "g/^ng_pppoe_load=/d\nw" | ed - /boot/loader.conf
    host=`hostname`
    if [ "$host" ]; then
	host "$host" >/dev/null 2>&1 || MsgBox MsgWarnHostName
    fi
    ResumeServices "$Rst"
    ISP=
}

Forwarding()
{
    local kn rc

    if [ "`sysctl -n net.inet.ip.forwarding`" = 1 ]; then
	kn=0
	rc=NO
    else
	kn=1
	rc=YES
    fi
    sysctl net.inet.ip.forwarding=$kn >/dev/null
    echo -e "/^gateway_enable/s/=.*/=\"$rc\"/\nw" | ed - $RCCONF
}

ApacheMode()
{
    local webprt sslprt ssval wwval cmd state sslfile Item2 Item2_ upd

    # FIXME: expr should do here
    sslfile=`echo $APACHESSL | sed -E "s;^.*/apache22/;;g"`	# FIXME: pas si $OSRel -lt 6
    webprt=`sed -n '/^[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHECNF | head -1`
    test "$webprt" || webprt=`sed -n '/^#*[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHECNF | head -1`
    sslprt=`sed -n '/^[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHESSL | tail -1`
    test "$sslprt" || sslprt=`sed -n '/^#*[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHESSL | tail -1`
    wwval=`egrep "^#*[ 	]*Listen[ 	]*$webprt[ 	]*$" $APACHECNF | grep '#.*Listen' >/dev/null 2>&1 || echo y`
    ssval=`egrep "^#*[ 	]*Include[ 	].*$sslfile[ 	]*$" $APACHECNF | grep '#.*Include' >/dev/null 2>&1 || echo y`
    Item2=1
    if [ "$ssval" ]; then
	test "$wwval" && Item2=2 || Item2=3
    fi

    Item2_=$Item2
    while :
    do
	$DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	    --menu "`Tstr TitApacheMode`" 10 `Size ApacheMode` 3 \
	    1 "`Tstr ItmApacheNormal`" \
	    2 "`Tstr ItmApacheBoth`" \
	    3 "`Tstr ItmApacheSSL`" || break
	Item2=`cat $TMPFILE`
	if [ "$Item2" = "$Item2_" ]; then
	    MsgBox MsgConfigNotModified
	    return
	fi
	upd=
	case "$Item2" in
	    1)  CheckPortAvailable $webprt http || continue
		cmd="/^#*[ 	]*Listen[ 	][ 	]*$webprt[ 	]*$/s/.*Listen.*/Listen $webprt/\nw"
		echo -e "$cmd" | ed - $APACHECNF
		cmd="/^[ 	]*Include[ 	].*`basename $APACHESSL`[ 	]*$/s/^[ 	]*/#/\nw" 2>/dev/null
		echo -e "$cmd" | ed - $APACHECNF
		if [ $OSRel -lt 6 ]; then
		    cmd="/^#*[ 	]*Port[ 	][ 	]*$webprt[ 	]*$/s/.*Port.*/Port $webprt/\nw"
		    echo -e "$cmd" | ed - $APACHECNF	# TODO: Test
		fi
		test "$webprt" = 80 && WEBHOST="http://localhost" || WEBHOST="http://localhost:$webprt"
		upd=y
		;;

	    2)  CheckPortAvailable $webprt http || continue
		CheckPortAvailable $sslprt https || continue
		cmd="/^#*[ 	]*Listen[ 	][ 	]*$webprt[ 	]*$/s/.*Listen.*/Listen $webprt/\nw"
		echo -e "$cmd" | ed - $APACHECNF
		cmd="/^##*[ 	]*Include[ 	].*`basename $APACHESSL`[ 	]*$/s/##*[ 	]*//\nw"
		echo -e "$cmd" | ed - $APACHECNF
		if [ $OSRel -lt 6 ]; then
		    cmd="/^#*[ 	]*Port[ 	][ 	]*$webprt[ 	]*$/s/.*Port.*/Port $webprt/\nw"
		    echo -e "$cmd" | ed - $APACHECNF	# FIXME: Test
		fi
		test "$webprt" = 80 && WEBHOST="http://localhost" || WEBHOST="http://localhost:$webprt"
		upd=y
		;;

	    3)  CheckPortAvailable $sslprt https || continue
		cmd="/^#*[ 	]*Listen[ 	][ 	]*$webprt[ 	]*$/s/.*Listen.*/#Listen $webprt/\nw"
		echo -e "$cmd" | ed - $APACHECNF
		cmd="/^##*[ 	]*Include[ 	].*`basename $APACHESSL`[ 	]*$/s/##*[ 	]*//\nw" 2>/dev/null
		echo -e "$cmd" | ed - $APACHECNF
		if [ $OSRel -lt 6 ]; then
		    cmd="/^#*[ 	]*Port[ 	][ 	]*$webprt[ 	]*$/s/.*Port.*/#Port $webprt/\nw"
		    echo -e "$cmd" | ed - $APACHECNF		#TESTME
		fi
		test "$sslprt" = 443 && WEBHOST="https://localhost" || WEBHOST="https://localhost:$sslprt"
		upd=y
		;;
	esac
	if [ "$upd" ]; then
	    UpdateWebHost
	    WebService active && WebService restart
	    if grep "firefox" $AUTORC >/dev/null; then
		if X11Service active; then
		    NoYesBox MsgConfirmStopX11
		    X11Service stop	# NOTE: will not return if we are in X11
		    X11Service start
		fi
	    fi
	    break
	fi
    done
}

CheckPort()
{
    local valid

    valid=`expr "$1" : '\([0-9][0-9]*\)'`
    if [ "$1" = "$valid" ]; then
	test $1 -gt 0 -a $1 -lt 65535 && return 0
    fi
    MsgBox MsgInvalidNetPort
    return 1
}

CheckPortAvailable()
{
    local PortSsh PortWeb PortSsl PortCam PortCtl PortPly PortRad use

    test "$2" && use=$2
    PortSsh=`sed -n '/^Port[ 	]/s/^Port[ 	]*\([0-9][0-9]*\).*/\1/p' $SSHDCNF`
    test "$PortSsh" || PortSsh=`sed -n '/^#Port[ 	]/s/^#Port[ 	]*\([0-9][0-9]*\).*/\1/p' $SSHDCNF`
    PortWeb=`sed -n '/^[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHECNF | head -1`
    test "$PortWeb" || PortWeb=`sed -n '/^#*[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHECNF | head -1`
    PortSsl=`sed -n '/^[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHESSL | tail -1`
    test "$PortSsl" || PortSsl=`sed -n '/^#*[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHESSL | tail -1`
    PortCam=`sed -n '/^http_port[ 	]*=/s/^http_port[ 	]*=[ 	]*\([0-9][0-9]*\).*/\1/p' $CNFFILE`
    PortCtl=`sed -n '/^ctrl_port[ 	]*=/s/^ctrl_port[ 	]*=[ 	]*\([0-9][0-9]*\).*/\1/p' $CNFFILE`
    PortPly=`sed -n '/^play_port[ 	]*=/s/^play_port[ 	]*=[ 	]*\([0-9][0-9]*\).*/\1/p' $CNFFILE`
    if [ -f $TWECONF ]; then
	PortRad=`sed -n '/^P[Oo][Rr][Tt][ 	]/s/^P[Oo][Rr][Tt][ 	]*\([0-9][0-9]*\).*/\1/p' $TWECONF`
    elif grep '^archttp32_flags *=' $RCCONF >/dev/null; then
	PortRad=`sed -n 's/^archttp32_flags *= *"\([0-9]*\)"/\1/p' $RCCONF`
    fi

    # FIXME! is $use really useful? It means we accept the port if it already has it's use
    case "$1" in
 	"$PortSsh")	test "$use" = ssh   || { MsgBox MsgPortUsedBySsh "$1"; return 1; };;
 	"$PortWeb")	test "$use" = http  || { MsgBox MsgPortUsedByWeb "$1"; return 1; };;
 	"$PortSsl")	test "$use" = https || { MsgBox MsgPortUsedBySsl "$1"; return 1; };;
 	"$PortCam")	test "$use" = cam   || { MsgBox MsgPortUsedByCam "$1"; return 1; };;
 	"$PortCtl")	test "$use" = ctl   || { MsgBox MsgPortUsedByCtl "$1"; return 1; };;
 	"$PortPly")	test "$use" = ply   || { MsgBox MsgPortUsedByPly "$1"; return 1; };;
 	"$PortRad")	test "$use" = raid  || { MsgBox MsgPortUsedByRad "$1"; return 1; };;
    esac
    if ! grep "^[ 	]*$1[ 	]*" $REDIRS >/dev/null || test "$ign" = redir; then
	test -z "`netstat -an | awk '{print $4}' | grep "\.$1\$"`" && return 0
    fi
    MsgBox MsgPortAlreadyInUse "$1"
    return 1
}

NetPort()
{
    local Title port port_ File edCmd Serv tvar restart

    retart=
    Title=`Tstr TitPort$1`
    eval port=\$Port$1
    port_=$port
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title " --max-input 5 --inputbox "\n `Tstr InpPort`" 9 `Size NetPort` "$port_" || return 1
	port_=`cat $TMPFILE`
	if [ "$port_" = "$port" ]; then
	    MsgBox MsgConfigNotModified
	    return
	fi
	CheckPort "$port_" || continue
	CheckPortAvailable "$port_" && break
    done
    case "$1" in
	Ssh)
	    File=$SSHDCNF
	    grep '^Port[ 	]' $SSHDCNF >/dev/null || echo -e "/^#Port/a\nPort $port\n.\nw" | ed - $SSHDCNF
	    edCmd="/^Port[ 	]/s/^Port.*/Port $port_/\nw"
	    Serv=Ssh
	    ;;
	Web)
	    File=$APACHECNF
	    edCmd="/^#*[ 	]*Listen[ 	][ 	]*$port[ 	]*$/s/Listen.*/Listen $port_/\nw"
	    Serv=Web
	    ;;
	Ssl)
	    File=$APACHESSL
	    edCmd="/^#*[ 	]*Listen[ 	][ 	]*$port[ 	]*$/s/Listen.*/Listen $port_/\nw"
	    Serv=Ssl
	    ;;
	Cam)
	    File=$CNFFILE
	    edCmd="/^http_port[ 	]*=/s/=.*$/= $port_/\nw"
	    Serv=Cam
	    ;;
	Ctl)
	    File=$CNFFILE
	    edCmd="/^ctrl_port[ 	]*=/s/=.*$/= $port_/\nw"
	    Serv=Cam
	    ;;
	Ply)
	    File=$CNFFILE
	    edCmd="/^play_port[ 	]*=/s/=.*$/= $port_/\nw"
	    Serv=Cam
	    ;;
	Rad)
	    if [ -f $TWECONF ]; then
		File=$TWECONF
		edCmd="/^P[Oo][Rr][Tt][ 	]/s/^P[Oo][Rr][Tt].*/Port $port_/\nw"
	    elif grep '^archttp32_flags *=' $RCCONF >/dev/null; then
		File=$RCCONF
		edCmd="/^archttp32_flags *=/s/ *=.*$/=\"$port_\"/\nw"
	    fi
	    Serv=Rad
	    ;;
    esac
    echo -e "$edCmd" | ed - $File
    case "$Serv" in
	Ssh)
	    pid=`pidof 'sshd$'`
	    test "$pid" && kill -1 $pid 2>/dev/null
	    ;;
	Web)	# FIXME: and what for FreeBSD 4.x ?
	    if [ $OSRel -lt 6 ]; then
		echo -e "/^#*[ 	]*Port[ 	][ 	]*$port[ 	]*$/s/^Port.*/Port $port_/\nw" | ed - $File
	    fi
	    WebService active && WebService restart
	    tvar=`echo $WEBHOST | cut -d ':' -f 1`
	    if [ "$tvar" = "http" ]; then
		test "$port_" -eq 80 && WEBHOST="http://localhost" || WEBHOST="http://localhost:$port_"
		UpdateWebHost
	    fi
	    if grep "firefox" $AUTORC >/dev/null; then
		if X11Service active; then
		    NoYesBox MsgConfirmStopX11
		    X11Service stop	# NOTE: will not return if we are in X11
		    X11Service start
		fi
	    fi
	    ;;
	Ssl)
	    echo -e "/^#*[ 	]*<VirtualHost[	 ]*.*:[	 ]*$port[ 	]*>[ 	]*$/s/^<VirtualHost.*/<VirtualHost _default_:$port_>/\nw" | ed - $File
	    WebService active && WebService restart
	    tvar=`echo $WEBHOST | cut -d ':' -f 1`
	    if [ "$tvar" = "https" ]; then
		test "$port_" -eq 443 && WEBHOST="https://localhost" || WEBHOST="https://localhost:$port_"
		UpdateWebHost
	    fi
	    if grep "firefox" $AUTORC >/dev/null; then
		if X11Service active; then
		    NoYesBox MsgConfirmStopX11
		    X11Service stop	# NOTE: will not return if we are in X11
		    X11Service start
		fi
	    fi
	    ;;
	Cam)
	    CamService active && CamService restart
	    ;;
	Rad)
	    if [ "`pidof "$TWED"`" ]; then
		InfoBox InfRestartingRad
		$TWERC stop >/dev/null 2>&1
		$TWERC start >/dev/null 2>&1
	    elif [ "`pidof "$ARCD"`" ]; then
		InfoBox InfRestartingRad
		$ARCRC stop >/dev/null 2>&1
		$ARCRC start >/dev/null 2>&1
	    fi
	    ;;
    esac
    return 0
}

NetPorts()
{
    local PortWeb PortSsl PortCam PortCtl PortPly PortRad State

    Item2=1
    while :
    do
	PortSsh=`sed -n '/^Port[ 	]/s/^Port[ 	]*\([0-9][0-9]*\).*/\1/p' $SSHDCNF`
	test "$PortSsh" || PortSsh=`sed -n '/^#Port[ 	]/s/^#Port[ 	]*\([0-9][0-9]*\).*/\1/p' $SSHDCNF`

	PortWeb=`sed -n '/^[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHECNF | head -1`
	test "$PortWeb" || PortWeb=`sed -n '/^#*[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHECNF | head -1`

	PortSsl=`sed -n '/^[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHESSL | tail -1`
	test "$PortSsl" || PortSsl=`sed -n '/^#*[ 	]*Listen[ 	][ 	]*[0-9]*[ 	]*#*$/s/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\).*/\1/p' $APACHESSL | tail -1`

	PortCam=`sed -n '/^http_port[ 	]*=/s/^http_port[ 	]*=[ 	]*\([0-9][0-9]*\).*/\1/p' $CNFFILE`
	PortCtl=`sed -n '/^ctrl_port[ 	]*=/s/^ctrl_port[ 	]*=[ 	]*\([0-9][0-9]*\).*/\1/p' $CNFFILE`
	PortPly=`sed -n '/^play_port[ 	]*=/s/^play_port[ 	]*=[ 	]*\([0-9][0-9]*\).*/\1/p' $CNFFILE`
	if [ -f $TWECONF ]; then
	    PortRad=`sed -n '/^P[Oo][Rr][Tt][ 	]/s/^P[Oo][Rr][Tt][ 	]*\([0-9][0-9]*\).*/\1/p' $TWECONF`
	elif grep '^archttp32_flags *=' $RCCONF >/dev/null; then
	    PortRad=`sed -n 's/^archttp32_flags *= *"\([0-9]*\)"/\1/p' $RCCONF`
	fi
	State="`Tstr TxtPortSsh`$PortSsh"
	State="$State\n`Tstr TxtPortWeb`$PortWeb"
	State="$State\n`Tstr TxtPortSsl`$PortSsl"
	State="$State\n`Tstr TxtPortCam`$PortCam"
	State="$State\n`Tstr TxtPortCtl`$PortCtl"
	State="$State\n`Tstr TxtPortPly`$PortPly"
	# FIXME: use dynamically built Item/Cmd lists
	if [ "$PortRad" ]; then
	    State="$State\n`Tstr TxtPortRad`$PortRad"
	    $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
		--menu "`Tstr TitNetPorts`\n\n$State\n" 22 `Size NetPorts` 7 \
	    1 "`Tstr ItmPortSsh`" \
	    2 "`Tstr ItmPortWeb`" \
	    3 "`Tstr ItmPortSsl`" \
	    4 "`Tstr ItmPortCam`" \
	    5 "`Tstr ItmPortCtl`" \
	    6 "`Tstr ItmPortPly`" \
	    7 "`Tstr ItmPortRad`" || break
	    Item2=`cat $TMPFILE`
	    case "$Item2" in
		1)  NetPort Ssh ;;
		2)  NetPort Web ;;
		3)  NetPort Ssl ;;
		4)  NetPort Cam ;;
		5)  NetPort Ctl ;;
		6)  NetPort Ply ;;
		7)  NetPort Rad ;;
	    esac
	else
	    $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
		--menu "`Tstr TitNetPorts`\n\n$State\n" 20 `Size NetPorts` 6 \
	    1 "`Tstr ItmPortSsh`" \
	    2 "`Tstr ItmPortWeb`" \
	    3 "`Tstr ItmPortSsl`" \
	    4 "`Tstr ItmPortCam`" \
	    5 "`Tstr ItmPortCtl`" \
	    6 "`Tstr ItmPortPly`" || break
	    Item2=`cat $TMPFILE`
	    case "$Item2" in
		1)  NetPort Ssh ;;
		2)  NetPort Web ;;
		3)  NetPort Ssl ;;
		4)  NetPort Cam ;;
		5)  NetPort Ctl ;;
		6)  NetPort Ply ;;
	    esac
	fi
    done
}

AddRedirs()
{
    local port rport rip elt menu

    DefItem="`Tstr ItmNewLocalPort`"
    while :
    do
	$DIALOG --ok-label "$BtnApply" --cancel-label "$BtnBack" \
	    --default-item "$DefItem" --form "      `Tstr ItmAddPort`" 10 50 3 \
	    "`Tstr ItmNewLocalPort`"   1  2  "$port"   1 26   7  6 \
	    "`Tstr ItmNewRemoteAddr`"  2  2  "$rip"    2 26  16 15 \
	    "`Tstr ItmNewRemotePort`"  3  2  "$rport"  3 26   7  6 \
	    2>$TMPFILE || return

	exec 3<$TMPFILE
	read port	<&3
	read rip	<&3
	read rport	<&3
	exec 3<&-

	DefItem="`Tstr ItmNewLocalPort`"
	[ -z "$port" ] && continue
	CheckPort "$port" || continue
	CheckPortAvailable "$port" || continue

	DefItem="`Tstr ItmNewRemoteAddr`"
	[ -z "$rip" ] && continue
	CheckIP "$rip" || continue

	DefItem="`Tstr ItmNewRemotePort`"
	[ -z "$rport" ] && continue
	elt=`cat $REDIRS | grep "$rip[ 	]*$rport$" | awk '{print $1}'`
	[ -z "$elt" ] && break
	DefItem="`Tstr ItmNewRemoteAddr`"
	MsgBox MsgRedirAlreadyUsed $rip $rport $elt
    done

    echo -e "$port\t$rip\t$rport" >>$REDIRS
    nohup redir --lport=$port --caddr=$rip --cport=$rport >/dev/null 2>&1 || \
	/usr/local/etc/rc.d/redir restart >/dev/null 2>&1 &
}

DelRedirs()
{
    local lines chars nbi items text row nbi max elt i ip iprt oprt

    i=1
    while :
    do
	eval "iprt=\$iprt$i"
	if [ "$iprt" ]; then
	    eval "iprt$i="
	else
	    break
	fi
	i=`expr $i + 1`
    done
    eval `cat $REDIRS | awk  '{print "iprt" NR "=" $1 " ip" NR "=" $2 " oprt" NR "=" $3}'`
    i=1
    items=
    while :
    do
	eval "iprt=\$iprt$i ip=\$ip$i oprt=\$oprt$i"
	[ -z "$iprt" ] && break
	pid=`ps axww | awk "/[r]edir .*--lport=$iprt/{print \\$1}"`
	eval "pid$i=$pid"
	items="$items $i \"$iprt => $ip:$oprt\" \"\""
	i=`expr $i + 1`
    done
    if [ "$i" = 1 ]; then
	MsgBox MsgNoRedirs
	return
    fi
    i=`expr $i - 1`
    text="`Tstr TitDelRedirs`"
    lines=`MsgLines "$text" 6`
    eval `GetScrSize 'row=%r'`
    max=`let $row - 1 - $lines`
    test $i -lt $max && nbi=$i || nbi=$max
    lines=`let $lines + $nbi`
    chars=`MsgChars "$items" 7`
    eval $DIALOG 2>$TMPFILE --checklist "\"$text\"" $lines $chars $nbi "$items"
    test $? -eq 0 -a -s $TMPFILE || return
    del=`sed 's/"//g' $TMPFILE`
    for elt in $del
    do
	eval "iprt=\$iprt$elt ip=\$ip$elt oprt=\$oprt$elt pid=\$pid$elt"
	cat $REDIRS | grep -v "[	 ]*$iprt[ 	]*$ip[ 	]*$oprt[ 	]*$" >/tmp/redir
	[ "$pid" ] && kill $pid
	mv /tmp/redir $REDIRS
    done
}

Redirs()
{
    if [ ! -e $REDIRS ]; then
	touch $REDIRS
	chown camtrace:camtrace $REDIRS
	chmod 644 $REDIRS
    fi
    Item2=1
    while :
    do
	$DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label \
	    "$BtnBack" --menu "`Tstr TitRedirs`" 9 45 2 \
		1 "`Tstr ItmAddPort`"	\
		2 "`Tstr ItmDelPort`" || break
	    Item2=`cat $TMPFILE`
	    case "$Item2" in
		1)  AddRedirs  ;;
		2)  DelRedirs  ;;
	    esac
    done
}

NetMask()
{
    local msk

    STDIFS="$IFS"
    IFS=.
    set $1
    IFS="$STDIFS"

    if [ "0$1" -lt 127 ]; then
	msk="255.0.0.0"
    elif [ "0$1" -gt 127 -a "0$1" -lt 192 ]; then
	msk="255.255.0.0"
    elif [ "0$1" -lt 224 ]; then
	msk="255.255.255.0"
    fi
    echo $msk
}

CamNet()
{
    local i ip lan mask

    i=1
    while :
    do
	eval "lan=\$ITF$i ip=\$IPADR$i mask=\$MASK$i"
	test -z "$lan" && break
	test "$ip" && break
	i=`expr $i + 1`
    done
    if [ -z "$ip" -a "$IPADR0" ]; then
	ip=$IPADR0
	mask=$MASK0
    fi
    if [ "$ip" ]; then
	ipcalc -n "$ip" "$mask"
    fi
}

GetMaskDec()
{
    local cpt val pow res

    ipcalc -m "$1" >/dev/null || return
    res=0
    for cpt in 1 2 3 4
    do
	val=`echo $1 | cut -d '.' -f $cpt`
	for pow in 128 64 32 16 8 4 2 1
	do
	    test "$val" -gt "0" || break
	    res=`expr $res + 1`
	    val=`expr $val - $pow`
	done
    done
    echo "$res"
}

CrossNetworkCheck()
{
    local testip lookip testmsk lookmsk ntm nlm tcpt lcpt max msg tan lan
    local ipn mskn

    max=`ipcalc -a | awk 'END{print NR}'`
    tcpt=0
    msg=
    while :
    do
	lcpt=0
	test "$tcpt" -eq "$max" && break
	test -z "$msg" || break
	eval "tan=\$LAN$tcpt testip=\$LANIP$tcpt testmsk=\$LANMSK$tcpt ipn=\$LANIP${tcpt}_ mskn=\$LANMSK${tcpt}_"
	test "$ipn" -o "$mskn" && testip=$ipn && testmsk=$mskn
	test -z "$testip" -o -z "$testmsk" && tcpt=`expr $tcpt + 1` && continue
	ntm=`GetMaskDec $testmsk`
	while :
	do
	    test "$lcpt" -eq "$max" && break
	    test "$lcpt" -eq "$tcpt" && lcpt=`expr $lcpt + 1` && continue
	    eval "lan=\$LAN$lcpt lookip=\$LANIP$lcpt lookmsk=\$LANMSK$lcpt ipn=\$LANIP${lcpt}_ mskn=\$LANMSK${lcpt}_"
	    lcpt=`expr $lcpt + 1`
	    test "$ipn$mskn" && lookip=$ipn && lookmsk=$mskn
	    test -z "$lookip" -o -z "$lookmsk" && continue
	    nlm=`GetMaskDec $lookmsk`
	    test "$ntm" -lt "$nlm" && lookmask=$testmask
	    ipcalc -s $testip $lookip $lookmsk >/dev/null && msg="$testip/$ntm $lookip/$nlm"
	done
	tcpt=`expr $tcpt + 1`
    done
    if [ "$msg" ]; then
	MsgBox MsgIPSameSubnet $msg
	return 1
    fi

    return
}

DHCPRange()
{
    local curi curj i i1 i2

    test -z "$1" -o -z "$2" && return 1
    i1=$1
    i2=$2
    i=1
    while :
    do
	curi=`echo $i1 | cut -d '.' -f $i`
	curj=`echo $i2 | cut -d '.' -f $i`
	i=`expr $i + 1`
	[ "$curi" -gt "$curj" ] && return 1
	[ "$i" -gt 4 -o "$curi" != "$curj" ] && break
    done
}

DHCPCheck()
{
    local dn ns rt rs msg lines cols rep1 rep2

    test -f $RESOLV || return 0
    ns=`awk '/^nameserver/{print $2;exit}' $RESOLV`
    dn=`awk '/^search/{print $2;exit}' $RESOLV`
    rt=`awk -F '"' '/^defaultrouter/{print $2}' $RCCONF`
    test -z "$dn" && dn=`awk '/^domain/{print $2;exit}' $RESOLV`
    if [ -z "`egrep "$dn|$ns" $DHCPCCONF 2>/dev/null`" ]; then
	msg="`Tstr MsgWIFINeedsDHCP`"
	if [ "$ns" -a "$dn" ]; then
	    msg="$msg\n`Tmsg MsgHowKeepDomainNameServer "$dn" "$ns"`"
	    rep1="`Tstr MsgUseDomainNameServerAsPrimary`"
	    rep2="`Tstr MsgUseDomainNameServerAsSecondary`"
	elif [ "$ns" ]; then
	    msg="$msg\n`Tmsg MsgHowKeepNameServer "$ns"`"
	    rep1="`Tstr MsgUseServerNameAsPrimary`"
	    rep2="`Tstr MsgUseServerNameAsSecondary`"
	else
	    msg="$msg\n`Tmsg MsgHowKeepDomain "$dn"`"
	    rep1="`Tstr MsgUseDomainAsPrimary`"
	    rep2="`Tstr MsgUseDomainAsSecondary`"
	fi
	lines=`MsgLines "$msg" 9`
	eval `GetScrSize 'cols=%c'`
	[ "$cols" -lt 75 ] || cols=75
	$DIALOG 2>$TMPFILE --menu "$msg" $lines $cols 2 \
		1 "$rep1" \
		2 "$rep2" || return 1
	rs=`cat $TMPFILE`
	if [ "$rs" = 1 ]; then
	    (
		[ "$dn" ] && echo "supersede domain-name \"$dn\";"
		[ "$rt" ] && echo "supersede routers $rt;"
		[ "$ns" ] && echo "prepend domain-name-servers $ns;"
	    ) >>$DHCPCCONF
	elif [ "$rs" = 2 ]; then
	    (
		[ "$dn" ] && echo "append domain-name \"$dn\";"
		[ "$ns" ] && echo "append domain-name-servers $ns;"
	    ) >>$DHCPCCONF
	else
	    return 1
	fi
    fi
}

WIFIClean()
{
    if [ -e "/usr/local/etc/dhcpd.conf" ]; then
	rm -f /usr/local/etc/dhcpd.conf.menu.*
	mv /usr/local/etc/dhcpd.conf /usr/local/etc/dhcpd.conf.menu.`date +%s`
    fi
    if [ "`ps axww | grep '[h]ostapd'`" ]; then
	(/etc/rc.d/hostapd stop || pkill hostapd || pkill -9 hostapd) >/dev/null 2>&1
    fi
    if [ "`ps axww | grep '[d]hcpd'`" ]; then
	(/usr/local/etc/rc.d/isc-dhcpd stop || pkill dhcpd || pkill -9 dhcpd) >/dev/null 2>&1
    fi
    if [ "`ps axww | grep '[w]pa_supplicant'`" ]; then
	(/etc/rc.d/wpa_supplicant stop || pkill wpa_supplicant || pkill -9 wpa_supplicant) >/dev/null 2>&1
    fi
    rm -f $WPACNF
    echo -e "g/^dhcpd_enable=/d\ng/hostapd_enable=/d\nw" | ed - $RCCONF
}

WIFIClient()
{
    local net nam ip msk pid end cpt i lines chars rows dec items strength
    local ssid chan rate str caps pref protect type text max nbi str prt
    local wpacnf wepcnf conf dhcp ip msk desc hostap itfexists rnam
    local text_ items_ lines_ chars_ nbi_

    net=$1
    [ -z "$net" ] && return 1
    eval "nam=\$LAN$net ip=\$LANIP$net"
    InfoBox MsgScanningWIFINetworks
    hostap=
    if [ $OSRel -lt 8 ]; then
	rnam=$nam
	itfexists=y
	ifconfig $rnam | grep "<hostap>" >/dev/null && { ifconfig $rnam -mediaopt hostap ; hostap=y ; }
	ifconfig $rnam delete >/dev/null 2>&1
    else
	cpt=0
	while :
	do
	    str=`sysctl -n net.wlan.$cpt.%parent 2>/dev/null`
	    test "$str" || break
	    test "$str" = "$nam" && break
	    cpt=`expr $cpt + 1`
	done
	rnam=wlan$cpt
	if sysctl -n net.wlan.$cpt >/dev/null 2>&1; then
	    ifconfig $rnam | grep "<hostap>" >/dev/null && hostap=y
	    itfexists=y
	    ifconfig $rnam destroy >/dev/null 2>&1
	fi
	ifconfig $rnam create wlandev $nam >/dev/null
    fi
    ifconfig $rnam up >/dev/null 2>&1
    ifconfig $rnam scan >/dev/null 2>&1 &
    pid=$!
    end=`date +%s`
    end=`expr $end + 30`
    while :
    do
	if [ -z "`ps ax | grep "^[ 	]$pid[ 	].*"`" ]; then
	    break;
	elif [ "`date +%s`" -ge "$end" ]; then
	    (kill $pid || kill -9 $pid) >/dev/null 2>&1
	    break;
	fi
	sleep 1
    done
    if [ "`expr $end - 25`" -gt "`date +%s`" ]; then
	sleep 5
    fi

    ifconfig -v $rnam list scan | sed -e 's/^\(.\{34\}\)\([^ ]*\) *\([^ ]*\) *\([^ ]*\) *\([^:]*\):\([^ ]*\) *\([^ ]*\) *\([^ ]*\) *\([^ ]*\)/SSID_="\1" BSSID="\2" CHAN="\3" RATE="\4" S="\5" N="\6" INT="\7" CAPS="\8" \9/' -e 's/</="/g' -e 's/> /" /g' -e 's/>$/"/' -e 's/  *"/"/' | sed -n '2,$p' | sed 's/ \?\?\?="[0-9a-fA-F]*"//g' | sed 's/ WME="[a-zA-Z 0]*\[.*\]"//g' | sed 's/ VEN="[a-f0-9]*"//g' >$TMPFILE
    cpt=`cat $TMPFILE | awk 'END{print NR}'`
    if [ "$cpt" = 0 ]; then
	MsgBox MsgNoSSIDNeighborhood
	InfoBox MsgRestoringWIFINetwork
	(
	    ifconfig $rnam down
	    test "$itfexists" || ifconfig $rnam destroy
	    test "$hostap" && ifconfig $rnam mediaopt hostap
	    test "$ip" && /etc/rc.d/netif restart
	) >/dev/null 2>&1
	sleep 1
	return 1
    fi
    i=0
    exec 3<$TMPFILE
    while :
    do
	read lines <&3
	eval "SSID= BSSID= CHAN= S= WPA= RSN= ERP= RATE= S= N= CAPS="
	eval $lines
	eval "SSID$i=\"$SSID\" BSSID$i=$BSSID CHAN$i=$CHAN RSN$i=\"$RNS\" ERP$i=\"$ERP\" WPA$i=\"$WPA\" RATE$i=$RATE S$i=$S N$i=$N CAPS$i=$CAPS"
	i=`expr $i + 1`
	[ "$i" -ge "$cpt" ] && break
    done
    exec 3<&-

    lines=$cpt
    cpt=0
    chars=0
    dec=0
    items=
    while :
    do
	eval "ssid=\"\$SSID$cpt\" chan=\$CHAN$cpt rate=\$RATE$cpt str=\$S$cpt caps=\$CAPS$cpt"
	[ "$cpt" -gt "$lines" ] && break
	[ -z "$ssid" ] && cpt=`expr $cpt + 1` && dec=`expr $dec + 1` && continue

	strength=`echo $str | cut -d '-' -f 2`
	if [ "$strength" -a "$strength" -lt 60 ]; then
	    pref="\\Z2" #vert
	elif [ "$strength" -a "$strength" -lt 80 ]; then
	    pref="\\Z3" #jaune
	elif [ "$strength" ]; then
	    pref="\\Z1" #rouge
	else
	    pref="\\Z0" #noir
	fi

	if [ "`echo "$caps" | grep "P"`" ]; then
	    protect="`Tstr MsgNetProtected`"
	    eval "PROT$cpt=y"
	else
	    protect="`Tstr MsgNetOpen`"
	    eval "PROT$cpt="
	fi
	if [ "`echo "$caps" | grep "E"`" ]; then
	    typ="`Tstr MsgModeInfra`"
	elif [ "`echo "$caps" | grep "I"`" ]; then
	    typ="`Tstr MsgModeAdHoc`"
	else
	    typ="`Tstr MsgModeUkn`"
	fi

	desc="$pref$ssid, $protect, $typ [#$chan@$rate]\\Zn"
	i=`MsgChars "$desc" 15`
	[ "$i" -gt "$chars" ] && chars=$i
	i=`expr $cpt + 1 - $dec`
	eval "CORRESP$i=$cpt"
	items="$items $i \"$desc\""
	cpt=`expr $cpt + 1`
    done
    cpt=`expr $cpt - $dec`
    i=$chars
    text="`Tstr TitSelectWIFINet`"
    lines=`MsgLines "$text" 6`
    eval `GetScrSize 'rows=%r'`
    max=`let $rows - 1 - $lines`
    test $cpt -lt $max && nbi=$cpt || nbi=$max
    lines=`let $lines + $nbi`
    chars=`MsgChars "$text" 6`
    [ "$chars" -lt "$i" ] && chars=$i

    text_="$text"
    items_=$items
    lines_="$lines"
    chars_="$chars"
    nbi_="$nbi"
    while :
    do
	eval $DIALOG 2>$TMPFILE --cancel-label \"`Tstr BtnRefresh`\" --menu "\"$text_\"" $lines_ $chars_ $nbi_ "$items_"
	pid=$?
	i=
	conf=
	wepcnf=
	wpacnf=
	if [ $pid -eq 1 ]; then
	    return 4
	elif [ ! $pid -eq 0 -o ! -s $TMPFILE ]; then
	    InfoBox MsgRestoringWIFINetwork
	    (
		ifconfig $rnam down
		test "$itfexists" || ifconfig $rnam destroy
		test "$hostap" && ifconfig $rnam mediaopt hostap
		test "$ip" && /etc/rc.d/netif restart
	    ) >/dev/null 2>&1
	    sleep 1
	    return 3
	fi

	cpt=`sed 's/"//g' $TMPFILE`
	eval "cpt=\$CORRESP$cpt"
	eval "ssid=\"\$SSID$cpt\" chan=\$CHAN$cpt rate=\$RATE$cpt str=\$S$cpt caps=\$CAPS$cpt prt=\$PROT$cpt"
	if [ "`echo $ssid | grep " "`" ]; then
	    MsgBox MsgCantUseSSIDWithSpaces "$ssid"
	    continue
	fi

	if [ "$prt" ]; then
	    prt=`ifconfig -v $rnam list scan | grep "^$ssid.*[ 	]WPA<"`
	    [ "$prt" ] && prt="WPA" || prt="WEP"
	    i=
	    if [ "$prt" = "WEP" ]; then
		while :
		do
		    $DIALOG 2>$TMPFILE  --max-input 64 --inputbox "`Tstr MsgEnterWEPPassphrase`" 9 70 "$i" || break
		    i=`cat $TMPFILE`
		    [ -z "$i" ] && continue
		    i=`echo "$i" | sed 's/://g'`
		    wepcnf="`echo -n "$i" | wc -c | awk '{print $1}'`"
		    if [ "`echo $i | sed 's/[0-9A-F]//g'`" ]; then
			MsgBox MsgWEPKeyBadChars
		    elif [ "$wepcnf" != 10 -a "$wepcnf" != 26 ]; then
			MsgBox MsgWEPKeyBadLen
		    else
			wepcnf=" wepmode on weptxkey 1 wepkey 1:0x$i"
			break
		    fi
		    wepcnf=
		done
	    else
		while :
		do
		    $DIALOG 2>$TMPFILE  --max-input 64 --inputbox "`Tstr MsgEnterWPAPassphrase`" 9 70 "$i" || break
		    i=`cat $TMPFILE`
		    [ -z "$i" ] && continue
		    [ "`echo "$i" | grep " "`" ] && MsgBox MsgWPANoSpaceInKeys && continue
		    wpacnf=`echo -n "$i" | wc -c | awk '{print $1}'`
		    if [ "$wpacnf" -lt 8 -o "$wpacnf" -gt 63 ]; then
			MsgBox MsgWPAKeyBadLen
			wpacnf=
			continue
		    fi
		    wpacnf=
		    break
		done
		if [ $OSRel -ge 8 ]; then
		    wpa_passphrase "$ssid" "$i"
		else
		    echo "network={"
		    echo "    ssid=\"$ssid\""
		    echo "    psk=\"$i\""
		    echo "}"
		fi >$WPACNF.nw
		wpacnf="WPA "
	    fi
	    [ "$wpacnf$wepcnf" ] && conf="${wpacnf}DHCP$wepcnf ssid $ssid"
	else
	    i="nopass"
	    conf="DHCP ssid $ssid"
	fi

	if [ "$conf" -a "$i" ]; then
	    (
		echo "`Tmsg MsgConfirmNewWIFIConfig "$nam" "$ssid"`"
		test "$wpacnf" && echo -e "`Tstr MsgNetworkProtectedWPA`"
		test "$wepcnf" && echo -e "`Tstr MsgNetworkProtectedWEP`"
		test "$nocnf"  && echo -e "`Tstr MsgNetworkNotProtected`"
		echo "`Tstr MsgWillActivateDHCP`"
		echo ""
		echo -e "`Tmsg MsgConfirmModifyWIFI "$ssid" "$nam"`"
	    ) >$TMPFILE
	    $DIALOG --yesno "`cat $TMPFILE`" 13 78 || continue
	    break
	fi
    done

    if [ "$conf" ]; then
	WIFIClean
	[ -e "$WPACNF.nw" ] && mv $WPACNF.nw $WPACNF
	grep -v "^ifconfig_$rnam=" $RCCONF >$RCCONF.tmp
	if [ $OSRel -ge 8 -a -z "`grep "^wlans_$nam=" $RCCONF`" ]; then
	    echo "wlans_$nam=\"$rnam\"" >>$RCCONF.tmp
	fi
	echo "ifconfig_$rnam=\"$conf\"" >>$RCCONF.tmp
	mv $RCCONF.tmp $RCCONF
	InfoBox MsgStartingWIFIInterface $nam
	(
	    ifconfig $rnam down
	    /etc/rc.d/netif restart
	) >/dev/null 2>&1
	ip=true
    else
	InfoBox MsgRestoringWIFINetwork
	(
	    ifconfig $rnam down
	    test "$hostap" && ifconfig $rnam mediaopt hostap
	    test "$itfexists" || ifconfig $rnam destroy
	    test "$ip" && /etc/rc.d/netif restart
	) >/dev/null 2>&1
    fi
    test "$ip" && sleep 5
}

WIFIHub()
{
#TODO (ou pas): proposer de spécifier le channel ? (sinon, préciser que ce sera sur le 11)
    local nam net ip msk ssid _ip _msk _ssid DefItem2 i conf
    local sttip _sttip stpip _stpip

    net=$1
    [ -z "$net" ] && return 2
    eval "nam=\$LAN$net ssid= ip= msk= _ip= _msk= _ssid="
    [ -z "`ifconfig $nam list caps | grep ",HOSTAP,"`" ] && MsgBox MsgNoAPCaps && return 2
    DefItem2="SSID"
    while :
    do
#NET BASE CONF
	$DIALOG --default-item "$DefItem2" --form			   \
		"`Tmsg TitConfigureInterface "$nam"`"  12  50  5	   \
		"`Tstr ItmSSID`"	    1  2  "$ssid"    1 25    31 30 \
		"`Tstr ItmIPAddress`"	    2  2  "$ip"	     2 25    16 15 \
		"`Tstr ItmNetMask`"	    3  2  "$msk"     3 25    16 15 \
		"`Tstr ItmDHCPFieldStart`"  4  2  "$sttip"   4 25    16 15 \
		"`Tstr ItmDHCPFieldStop`"   5  2  "$stpip"   5 25    16 15 \
		2>$TMPFILE
	i=$?
	if [ "$i" != 0 ]; then
	    [ "$i" = 255 ] && return 1
	    return 2
	fi

	exec          3<$TMPFILE
	read _ssid  <&3
	read _ip    <&3
	read _msk   <&3
	read _sttip <&3
	read _stpip <&3
	exec          3<&-

	DefItem2=`Tstr ItmSSID`
	[ -z "$_ssid" ] && continue
	if [ "`echo $_ssid | grep " "`" ]; then
	    MsgBox MsgCantCreateSSIDWithSpaces
	    continue
	fi
	ssid=$_ssid

	DefItem2="`Tstr ItmIPAddress`"
	[ -z "$_ip" ] && continue
	i=`ipcalc -c $_ip`
	if [ "$i" = "$_ip" ]; then
	else
	    MsgBox MsgInvalidIP
	    continue
	fi
	ip=$_ip

	DefItem2="NetMask"
	[ -z "$_msk" ] && continue
	i=`ipcalc -m $_msk`
	if [ "$i" = "$_msk" ]; then
	else
	    MsgBox MsgInvalidMask
	    continue
	fi
	msk=$_msk

#pour créer un réseau AdHoc, on reprend le début, on décommente les suivantes, ... TADA
#	conf="inet $ip netmask $msk mediaopt adhoc ssid $ssid"
#	grep -v "^ifconfig_$nam=" $RCCONF >$RCCONF.tmp
#	echo "ifconfig_$nam=\"$conf\"" >>$RCCONF.tmp
#	mv $RCCONF.tmp $RCCONF
#	ifconfig $nam down
#	InfoBox MsgStartingWIFIInterface $nam
#	/etc/rc.d/netif start
#	sleep 1
#	break

	DefItem2="Start DHCP IP"
	[ -z "$_sttip" ] && continue
	i=`ipcalc -c $_sttip`
	if [ "$i" = "$_sttip" ]; then
	else
	    MsgBox MsgInvalidIP
	    continue
	fi
	if [ -z "`ipcalc -s $ip $_sttip $msk`" ]; then
	    MsgBox MsgInvalidDHCPStart
	    continue
	fi
	sttip=$_sttip

	DefItem2="Stop DHCP IP"
	[ -z "$_stpip" ] && continue
	i=`ipcalc -c $_stpip`
	if [ "$i" = "$_stpip" ]; then
	else
	    MsgBox MsgInvalidIP
	    continue
	fi
	if ! DHCPRange $sttip $_stpip ; then
	    MsgBox MsgInvalidDHCPRange
	    continue
	fi
	if [ -z "`ipcalc -s $ip $_stpip $msk`" ]; then
	    MsgBox MsgInvalidDHCPStop
	    continue
	fi
	stpip=$_stpip

#SECURITY
	while :
	do
	    text="`Tstr TitSelectSecPolicy`"
	    lines=`MsgLines "$text" 6`
	    eval `GetScrSize 'rows=%r'`
	    max=`let $rows - 1 - $lines`
	    test 5 -lt $max && nbi=5 || nbi=$max
	    lines=`let $lines + $nbi`
	    chars=`MsgChars "$text" 6`
	    $DIALOG 2>$TMPFILE --menu "$text" $lines $chars $nbi \
		1 `Tstr ItmWPA1`	\
		2 `Tstr ItmWPA2`	\
		3 `Tstr ItmWPA3`	\
		4 `Tstr ItmWEP`		\
		5 `Tstr ItmOpen`
	    i=$?
	    prt=`sed 's/"//g' $TMPFILE`
	    wepcnf=
	    wpacnf=
	    nocnf=
	    [ $i -eq 0 -a -s $TMPFILE ] || break
	    i=
	    if [ "$prt" = 5 ]; then
		nocnf=true
	    elif [ "$prt" = 4 ]; then
		while :
		do
		    $DIALOG 2>$TMPFILE  --max-input 64 --inputbox "`Tstr MsgEnterWEPPassphrase`" 9 70 || break
		    i=`cat $TMPFILE`
		    i=`echo "$i" | sed 's/://g'`
		    [ -z "$i" ] && continue
		    wepcnf=`echo -n "$i" | wc -c | awk '{print $1}'`
		    if [ "`echo $i | sed 's/[0-9A-Fa-f]//g'`" ]; then
			MsgBox MsgWEPKeyBadChars
		    elif [ "$wepcnf" != 10 -a "$wepcnf" != 26 ]; then
			MsgBox MsgWEPKeyBadLen
		    else
			wepcnf="$i"
			break
		    fi
		    wepcnf=
		    i=
		done
		[ "$wepcnf" ] || continue
	    elif [ "$prt" = 1 -o "$prt" = 2 -o "$prt" = 3 ]; then
		while :
		do
		    $DIALOG 2>$TMPFILE  --max-input 64 --inputbox "`Tstr MsgEnterWPAPassphrase`" 9 70 || break
		    i=`cat $TMPFILE`
		    [ -z "$i" ] && continue
		    [ "`echo "$i" | grep " "`" ] && MsgBox MsgWPANoSpaceInKeys && continue
		    wpacnf=`echo -n "$i" | wc -c | awk '{print $1}'`
		    if [ "$wpacnf" -lt 8 -o "$wpacnf" -gt 63 ]; then
			MsgBox MsgWPAKeyBadLen
			i=
			wpacnf=
		    fi
		    wpacnf="$i"
		    break
		done
	    fi
	    [ "$wpacnf$wepcnf$nocnf" ] || continue
	    break
	done
	break
    done

    if [ "$wpacnf$wepcnf$nocnf" ]; then
#CLIENTS MANAGING
#TODO
# une confirmation serait la bienvenue
# préciser domain si absent
# hostapd ne tournera pas sans kldload wlan_xauth
#     de toute façon, le chip marche pas en hostap...
	WIFIClean
	netaddr=`ipcalc -n $ip $msk`
	bc=`ipcalc -b $ip $msk`
	domain=`awk '/^search[ 	]*/{print $2;exit}' $RESOLV`
	test -z "$domain" && domain=`awk '/^domain[ 	]*/{print $2;exit}' $RESOLV`
	test -z "$domain" && domain="mydomain.com"
	(
	    echo "#generated by CamTrace::menucam"
	    echo "authoritative;"
	    echo "option domain-name \"$domain\";";
	    echo "default-lease-time 600;"
	    echo "max-lease-time 7200;"
	    echo "log-facility local7;"
	    echo "subnet $netaddr netmask $msk {"
	    echo "range $sttip $stpip;"
	    echo "option routers $ip;"
	    echo "option broadcast-address $bc;"
	    echo "}"
	    echo "ddns-update-style ad-hoc;"
	) >/usr/local/etc/dhcpd.conf
	netaddr="inet $ip netmask $msk"
	grep -v "^ifconfig_$nam=" $RCCONF >$RCCONF.tmp
	(
	    echo "interface=$nam"
	    echo "debug=1"
	    echo "ctrl_interface=/var/run/hostapd"
	    echo "ctrl_interface_group=wheel"
	    echo "ssid=$ssid"
	    echo "ap_max_inactivity=300"
	) >/etc/hostapd.conf
	if [ "$wpacnf" ]; then
	    wpalvl=`expr $prt - 2`
	    (
		echo "wpa=$wpalvl"
		echo "wpa_passphrase=$wpacnf"
		echo "wpa_key_mgmt=WPA-PSK"
		echo "wpa_pairwise=CCMP TKIP"
	    ) >>/etc/hostapd.conf
	    echo "hostapd_enable=\"YES\"" >>$RCCONF.tmp
	    echo "ifconfig_$nam=\"$netaddr ssid $ssid mode 11g mediaopt hostap\"" >>$RCCONF.tmp
	elif [ "$wepcnf" ]; then
	    echo "wep_rekey_period=0" >>/etc/hostapd.conf
	    echo "ifconfig_$nam=\"$netaddr ssid $ssid wepmode on weptxkey 1 wepkey 1:0x$wepcnf mode 11g mediaopt hostap\"" >>$RCCONF.tmp
	else
	    echo "auth_algs=0" >>/etc/hostapd.conf
	    echo "ifconfig_$nam=\"$netaddr ssid $ssid mode 11g mediaopt hostap\"" >>$RCCONF.tmp
	fi
	echo "dhcpd_enable=\"YES\"" >>$RCCONF.tmp
	mv $RCCONF.tmp $RCCONF
	sync
	ifconfig $nam down
	ifconfig $nam delete
	/usr/local/etc/rc.d/isc-dhcpd start
	/etc/rc.d/hostapd start
	/etc/rc.d/netif start
    fi
}

WIFIToggle()
{
    local stt ip nam

    nam=$1
    [ -z "$nam" ] && return #un message d'erreur ferait pas de mal
    eval `ipcalc -i $nam "stt=%l"`
    test $OSRel -ge 8 && rnam=`grep "wlans_$nam=" $RCCONF | sed 's/.*="\(.*\)"/\1/'` || rnam=$nam
    if [ "$stt" = "DOWN" ]; then
	InfoBox MsgTurningOnWIFI
	ed - $RCCONF <<-EOF
	    g/^#ifconfig_$rnam=.*/s/#ifconfig_$rnam=/ifconfig_$rnam=/
	    w
EOF
	/etc/rc.d/netif restart >/dev/null 2>&1
    else
	InfoBox MsgTurningOffWIFI
	ifconfig $rnam down >/dev/null
	ed - $RCCONF <<-EOF
	    g/^ifconfig_$rnam=.*/s/ifconfig_$rnam=/#ifconfig_$rnam=/
	    w
EOF
    fi
}

WIFIChangeKey() # $nam $chg
{
    local itf ritf type len pass pass_ ssid

    itf=$1
    type=$2
    test $OSRel -ge 8 && ritf=`grep "^wlans_$itf=" $RCCONF | sed 's/.*="\(.*\)"/\1/'` || ritf=$itf
    [ -z "$ritf" -o -z "$type" ] && return
    if [ $type = "WEP" ]; then
	pass_=`awk "/#?ifconfig_$ritf=/{print \\$7}" $RCCONF | sed 's/1:0x//g'`
    else
	pass_=`awk -F '=' "/psk=\"/{print \\$2}" $WPACNF | sed 's/"//g'`
    fi
    ssid=`egrep "^#?ifconfig_$ritf=" $RCCONF | sed 's/.*ssid //g' | sed 's/"//g'`
    while :
    do
	$DIALOG 2>$TMPFILE --inputbox "`Tmsg TitInputNewKey "$ssid"`" 8 64 "$pass_" || break
	pass=`sed 's/"//g' $TMPFILE`
	if [ -z "$pass" ]; then
	    continue
	elif [ "$pass" = "$pass_" ]; then
	    MsgBox MsgSameKey
	    pass=
	    continue
	elif [ "$type" = "WEP" ]; then
	    pass=`echo $pass | sed 's/://g'`
	    len=`echo -n $pass | wc -c | awk '{print $1}'`
	    if [ "`echo $pass | sed 's/[0-9A-F]//g'`" ]; then
		MsgBox MsgWEPKeyBadChars
		pass_=$pass
		continue
	    elif [ "$len" != 10 -a "$len" != 26 ]; then
		MsgBox MsgWEPKeyBadLen
		pass_=$pass
		continue
	    else
		break
	    fi
	elif [ "$type" = "WPA" ]; then
	    len=`echo -n $pass | wc -c | awk '{print $1}'`
	    if [ "`echo $pass | grep " "`" ]; then
		MsgBox MsgWPANoSpaceInKeys
		pass_=$pass
		continue
	    elif [ "$len" -lt 8 -o "$len" -gt 63 ]; then
		MsgBox MsgWPAKeyBadLen
		pass_=$pass
		continue
	    else
		break
	    fi
	fi
    done
    if [ -z "$pass" ]; then
	MsgBox MsgNoChangeDone
	return
    elif [ "$type" = "WPA" ]; then
	if [ $OSRel -ge 8 ]; then
	    wpa_passphrase "$ssid" "$pass"
	else
	    echo "network={"
	    echo "    ssid=\"$ssid\""
	    echo "    psk=\"$pass\""
	    echo "}"
	fi >$WPACNF
    elif [ "$type" = "WEP" ]; then
	ed - $RCCONF <<-EOF
		g/^ifconfig_$ritf=/s/wepkey 1:0x$pass_/wepkey 1:0x$pass/
		w
		g/^#ifconfig_$ritf=/s/wepkey 1:0x$pass_/wepkey 1:0x$pass/
		w
EOF
    else
	return
    fi
    NoYesBox MsgKeyChangedSuccess || return
    (
	ifconfig $rnam down
	/etc/rc.d/netif restart
    ) >/dev/null 2>&1
}

WIFIConfig()
{
    local n i nam rnam typ rat sta menu cpt text lines chars nbi items conf dhcp net
    local pref ssid chan rate str caps strength protect var _items conf nip nmsk
    local DefItem _cpt pid dec line wepcnf wpacnf chg

    n=`ipcalc -w | awk 'END{print NR}'`
    eval `ipcalc -w "LAN%i=%n LANIP%i='%a' LANMSK%i='%m' LANRATE%i='%s' LANSTATE%i='%l'\n"`
    i=0
    cpt=1
    items=
    while :
    do
	test "$i" -eq "$n" && break
	eval "nam=\$LAN$i rat=\$LANRATE$i sta=\$LANSTATE$i ip=\$LANIP$i"
	test "$ip" && stt="`Tstr MsgStateUp`" || stt="`Tstr MsgStateDown`"
	desc=`printf "%-6s %s" $nam "$stt"`
	items="$items $cpt \"$desc\" "
	cpt=`expr $cpt + 1`
	i=`expr $i + 1`
    done
    if [ -z "$items" ]; then
	MsgBox TxtNoWIFIInterface
	return
    fi
    cpt=`expr $cpt - 1`
    DHCPCheck || return
    while :
    do
	if [ "$cpt" -gt 1 ]; then
	    text=`Tstr TitWIFIConfig`
	    lines=`MsgLines "$text" 6`
	    eval `GetScrSize 'rows=%r'`
	    max=`let $rows - 1 - $lines`
	    test $cpt -lt $max && nbi=$cpt || nbi=$max
	    lines=`let $lines + $nbi`
	    chars=`MsgChars "$text" 10`
	    eval $DIALOG 2>$TMPFILE --menu "\"$text\"" $lines $chars $nbi "$items"
	    test $? -eq 0 -a -s $TMPFILE || return
	    net=`sed 's/"//g' $TMPFILE`
	else
	    net=1
	fi
	net=`expr $net - 1`
	eval "nam=\$LAN$net ip=\$LANIP$net msk=\$LANMSK$net"
	eval `ipcalc -i $nam "stt=%l"`
	if [ $OSRel -ge 8 ]; then
	    max=0
	    while :
	    do
		chg=`sysctl -n net.wlan.$max.%parent 2>/dev/null`
		test "$chg" || break
		test "$chg" = "$nam" && break
		max=`expr $max + 1`
	    done
	    if [ "$chg" = "$nam" ]; then
		rnam=wlan$max
	    else
		rnam=
	    fi
	else
	    rnam=$nam
	fi
	text="`Tmsg MsgConfigWIFIItf "$nam"`"
	lines=`MsgLines "$text" 6`
	eval `GetScrSize 'rows=%r'`
	max=`let $rows - 1 - $lines`
	if [ "$stt" = "UP" ]; then
	    test 3 -lt $max && nbi=3 || nbi=$max
	    lines=`let $lines + $nbi`
	    chars=`MsgChars "$text" 25`
	    if grep "^ifconfig_$rnam=\"WPA" $RCCONF >/dev/null; then
		chg="WPA"
	    elif grep "^ifconfig_$rnam=.* wepmode " $RCCONF >/dev/null; then
		chg="WEP"
	    else
		nbi=`expr $nbi - 1`
		lines=`expr $lines - 1`
		chg=
	    fi
	    if [ "$chg" ]; then
		$DIALOG 2>$TMPFILE --menu "$text" $lines $chars $nbi \
			1 "`Tstr ItmWIFIAsClient`" \
			2 "`Tmsg ItmWIFIChangeKey "$nam"`" \
			3 "`Tmsg ItmWIFIDeactivate "$nam"`"
#			2 "`Tstr ItmWIFIAsAP`" \
	    else
		$DIALOG 2>$TMPFILE --menu "$text" $lines $chars $nbi \
			1 "`Tstr ItmWIFIAsClient`" \
			2 "`Tmsg ItmWIFIDeactivate "$nam"`"
#			2 "`Tstr ItmWIFIAsAP`" \
	    fi
	    i=`sed 's/"//g' $TMPFILE`
	else
	    test 3 -lt $max && nbi=3 || nbi=$max
	    if grep "^#ifconfig_$rnam=\"WPA" $RCCONF >/dev/null; then
		chg="WPA"
	    elif grep "^#ifconfig_$rnam= .* wepmode " $RCCONF >/dev/null; then
		chg="WEP"
	    else
		chg=
		stt=
		nbi=1
	    fi
	    lines=`let $lines + $nbi`
	    chars=`MsgChars "$text" 25`
	    if [ "$chg" ]; then
		$DIALOG 2>$TMPFILE --menu "$text" $lines $chars $nbi \
			1 "`Tstr ItmWIFIAsClient`" \
			2 "`Tmsg ItmWIFIChangeKey "$nam"`" \
			3 "`Tmsg ItmWIFIActivate "$nam"`"
#			2 "`Tstr ItmWIFIAsAP`" \
		i=`sed 's/"//g' $TMPFILE`
	    else
		i=1
	    fi
	fi
	while :
	do
	    if [ "$i" = 1 ]; then
		WIFIClient $net
		text=$?
		[ "$text" = 0 ] && return			#evrything's OK
		[ "$text" = 1 -a "$cpt" -gt 1 ] && break	#no '$net'
		[ "$text" = 1 ] && return			#same thing, having one net, so exit
		[ "$text" = 2 ] && continue			#return while selecting protection
		[ "$text" = 3 -a "$stt" ] && break		#escape while choosing ssid having 'restore' capability
		[ "$text" = 3 ] && return			#same thing, but no previous wifi conf
		[ "$text" = 4 ] && continue			#refresh SSID netlist
#	    elif [ "$i" = 2 ]; then
#		WIFIHub $net
#		text=$?
#		[ "$text" = 0 ] && return
#		[ "$text" = 1 -a "$cpt" -gt 1 ] && break
#		[ "$text" = 1 ] && return
#		[ "$text" = 2 ] && break
#		return
#	    elif [ "$i" = 3 ]; then
	    elif [ -z "$chg" -a "$i" = 2 ]; then
		WIFIToggle $nam
		return
	    elif [ "$chg" -a "$i" = 2 ]; then
		WIFIChangeKey $nam $chg
		return
	    elif [ "$chg" -a "$i" = 3 ]; then
		WIFIToggle $nam
		return
	    else
		return
	    fi
	done
    done
}

IPConfig()
{
    local DefItem fld mod sep host itf ip nip msk nmsk lim nlim Report \
	i n list hdr menu row len Rst Chg a d hadd hdel radd rdel gw gway curgw \
	msg lines chars rows cols pipe rule qsz l1 l2 chk

    list=`ipcalc -l '%i\n'`
    n=`ipcalc -l | awk 'END{print NR}'`
    test -z "$n" && n=0
    eval "LAN0="
    eval `ipcalc -l "LAN%i=%n LANIP%i='%a' LANMSK%i='%m' LANRATE%i='%s'\n"`
    if [ -z "$list" -o "$n" = 0 ]; then
	MsgBox MsgNoAvailableNIF
	return 1
    elif [ "$n" = 1 -a "$ISP" ]; then
	MsgBox MsgNoConfigurableNIF
	return 1
    fi
    hdr="\"`Tstr MsgNetConf`\" `expr $n + 8` 76 `expr $n + 1`"
    hdr="$hdr		\"`Tstr TxtIpAddr`\"	 1  8	\"\"	 1   7	 0  0"
    hdr="$hdr		\"`Tstr TxtNetmask`\"	 1 26	\"\"	 1  25	 0  0"
    if [ "$IPFW" ]; then
	hdr="$hdr	\"`Tstr TxtBWLimit`\"	 1 44	\"\"	 1  43	 0  0"
	hdr="$hdr	\"`Tstr TxtLinkStt`\"	 1 59	\"\"	 1  58	 0  0"
    else
	hdr="$hdr	\"`Tstr TxtLinkStt`\"	 1 44	\"\"	 1  43	 0  0"
    fi

    chk=
    for i in $list
    do
	eval "chk=\"\$chk LANIP$i LANMSK$i LIM$i\""
	lim=
	pipe=`expr $i + 2`
	test "$IPFW" && lim=`sed -n "s/^pipe $pipe config bw \\([0-9]*\\)Kbit.*/\\1/p" $IPFW`
	eval "LANIP${i}_=\$LANIP${i} LANMSK${i}_=\$LANMSK${i} LIM$i=$lim LIM${i}_=$lim"
    done

    while :
    do
	menu="$hdr"
	row=2
	for i in $list
	do
	    eval "itf=\$LAN${i} ip=\$LANIP${i}_ msk=\$LANMSK${i}_ lim=\$LIM${i}_ rate=\$LANRATE$i"
	    [ -z "$rate" ] && rate="[down]" || rate="[$rate]"
	    test "$i" = 0 -a "$ISP" && len=-16 || len=16
	    menu="$menu		\"$itf\"  $row  2 \"$ip\"  $row  8 $len 15"
	    menu="$menu		\"\"      $row 25 \"$msk\" $row 26 $len 15"
	    if [ "$IPFW" ]; then
		menu="$menu	\"Kbps\"  $row 51 \"$lim\" $row 44    7  6"
		menu="$menu	\"$rate\" $row 59 \"\"     $row 69    0  0"
	    else
		menu="$menu	\"$rate\" $row 44 \"\"     $row 54    0  0"
	    fi
	    row=`expr $row + 1`
	done
	test -z "$DefItem" && DefItem=$LAN0
	test -z "$DefItem" && DefItem=a	#if not, dialog crashes (missing option)

	eval $DIALOG --title "\"`Tstr TitNetConf`\"" --ok-label "$BtnApply" --cancel-label "$BtnBack" --default-item "$DefItem" --form $menu 2>$TMPFILE || return 1

	exec 3<$TMPFILE
	Chg=
	for i in $list
	do
	    lim=
	    read ip <&3
	    read msk <&3
	    test "$IPFW" && read lim <&3
	    eval "LANIP${i}_=$ip LANMSK${i}_=$msk LIM${i}_=$lim"
	done
	exec 3<&-

	Report=
	DefItem=
	lines=0
	for i in $list
	do
	    eval "itf=\$LAN$i ip=\$LANIP$i nip=\$LANIP${i}_ msk=\$LANMSK$i nmsk=\$LANMSK${i}_ lim=\$LIM$i nlim=\$LIM${i}_"
	    if [ "$ip" != "$nip" -o "$msk" != "$nmsk" ]; then
		DefItem="$itf"
		if [ "$nip" -a -z "$nmsk" ]; then
		    continue 2
		elif [ "$nip" -a "$nmsk" ]; then
		    CheckIP "$nip" || continue 2
		    CheckMask "$nmsk" || continue 2
		    CheckBdcast $nip $nmsk || continue 2
		    CheckNetwork "$nip" "$nmsk" || continue 2
		fi
		if [ $i -eq 0 -a "$ISP" -a "$nip$nmsk" ]; then
		    MsgBox MsgCantChangeITF0 $itf; continue 2
		elif [ "$ip" -a "$msk" -a "$nip" -a "$nmsk" ]; then
		    Report="`Tmsg TxtItfChanged $itf $nip $nmsk $ip $msk`"
		    lines=`expr $lines + 2`
		elif [ "$ip" -a "$msk" ]; then
		    Report="`Tmsg TxtItfRemoved $itf`"
		    lines=`expr $lines + 1`
		elif [ "$nip" -a "$nmsk" ]; then
		    Report="`Tmsg TxtItfAdded $itf $nip $nmsk`"
		    lines=`expr $lines + 1`
		fi
		test "$Chg" && Chg="$Chg\n$Report" || Chg="$Report"
		DefItem=
	    fi
	    if [ "$lim" != "$nlim" -a -z "$DefItem" ]; then
		DefItem="$itf"
		if [ "$nlim" -a $nip ]; then
		    CheckNumber "$nlim" || continue 2
		    CheckBandwidth "$nlim" || continue 2
		fi
		if [ "$lim" -a "$nlim" ]; then
		    Report="`Tmsg TxtBlimChanged $itf $nlim $lim`"
		    lines=`expr $lines + 2`
		elif [ "$lim" ]; then
		    Report="`Tmsg TxtBlimRemoved $itf`"
		    lines=`expr $lines + 1`
		elif [ "$nlim" ]; then
		    Report="`Tmsg TxtBlimAdded $itf $nlim`"
		    lines=`expr $lines + 1`
		fi
		test "$Chg" && Chg="$Chg\n$Report" || Chg="$Report"
		DefItem=
	    fi
	done
	CrossNetworkCheck || continue

	mod=
	sep=
	for fld in $chk
	do
	    if eval "[ \"\$$fld\" != \"\$${fld}_\" ]"; then
		mod="$mod$sep$fld"
		sep=" "
	    fi
	done
	test "$mod" && break
	MsgBox MsgConfigNotModified
	return 0
    done

    msg="`Tmsg MsgConfigInterfaces "$Chg"`"
    lines=`expr $lines + 5`
    chars=`MsgChars "$msg" 6`
    eval `GetScrSize 'rows=%r cols=%c'`
    test "$chars" -ge "$cols" && chars=$cols
    test "$lines" -ge "$rows" && lines=$rows
    $DIALOG --title "`Tstr TitNetConf`" --defaultno --yesno "$msg" $lines $chars || return 1
    SuspendServices "C W" Rst Chg || return 1

    test "$HOSTNAM" || HOSTNAM=`hostname`
    host=`expr "$HOSTNAM" : '\([^.][^.]*\)\..*'`
    #   Gateway may have been configured before local network
    gway=`sed -n '/^defaultrouter=/s/.*="\([^"]*\).*$/\1/p' $RCCONF`
    gw=
    hdel=
    hadd=
    rdel=
    radd=
    for i in $list
    do
	eval "itf=\$LAN$i ip=\$LANIP$i nip=\$LANIP${i}_ msk=\$LANMSK$i nmsk=\$LANMSK${i}_ lim=\$LIM$i nlim=\$LIM${i}_"
	if [ "$ip" != "$nip" -o "$msk" != "$nmsk" ]; then
	    ifconfig $itf delete 2>/dev/null
	    test "$nip" && ifconfig $itf inet $nip netmask $nmsk
	fi
	d="g/^$ip[ 	]/d"
	test "$hdel" && hdel="$hdel$NL$d" || hdel="$d"
	d="g/^ifconfig_$itf=/d"
	test "$rdel" && rdel="$rdel$NL$d" || rdel="$d"
	if [ "$nip" ]; then
	    a="$nip	$HOSTNAM $host$NL$nip	$HOSTNAM."
	    test "$hadd" && hadd="$hadd$NL$a" || hadd="$a"
	    a="ifconfig_$itf=\"inet $nip netmask $nmsk\""
	    test "$radd" && radd="$radd$NL$a" || radd="$a"
	fi
	eval "IPADR$i=$nip MASK$i=$nmsk"
	test "$gway" -a "$nip" && ipcalc -s "$gway" "$nip" "$nmsk" >/dev/null && gw=y
	if [ "$lim" != "$nlim" ]; then
	    pipe=`expr $i + 2`
	    rule=`expr $i '*' 100 + 60200`
	    if [ "$lim" ]; then
		echo -e "g/pipe $pipe /d\nw" | ed - $IPFW
		ipfw delete $rule
		ipfw pipe delete $pipe
	    fi
	    if [ "$nlim" -a "$nip" -a "$nmsk" ]; then
		if [ $nlim -lt 10 ]; then
		    qsz=1500
		else
		    qsz=`expr $nlim '*' 100`
		    test $qsz -gt 1048576 && qsz=1048576
		fi
		l1="pipe $pipe config bw ${nlim}Kbit/s queue ${qsz}Bytes"
		l2="add $rule pipe $pipe ip from any to any out xmit $itf"
		echo "$l1" >>$IPFW
		echo "$l2" >>$IPFW
		ipfw $l1 >/dev/null
		ipfw $l2 >/dev/null
	    fi
	fi
    done
    test "$hadd" && hadd="1i$NL.$NL/127\\.0\\.0\\.1/a$NL$hadd$NL.${NL}w" || hadd='w'
    test "$radd" && radd="1i$NL.$NL/^gateway_enable=/i$NL$radd$NL.${NL}w" || radd='w'

    if [ "$gway" ]; then
	curgw=`netstat -nr | awk '/^default/{print $2}'`
	test "$curgw" && route delete default >/dev/null
	test -z "$curgw" && curgw=$gway
	if [ "$gw" ]; then
	    route add default $gway >/dev/null
	elif [ "$curgw" ]; then
	    MsgBox MsgRouteDeleted $curgw
	fi
    fi

    if [ "$hdel" ]; then
	ed - /etc/hosts <<-EOF
		$hdel
		$hadd
EOF
    fi
    if [ "$rdel" ]; then
	ed - $RCCONF <<-EOF
		$rdel
		$radd
EOF
    fi
    ResumeServices "$Rst"
    return 0
}

NetConfig()
{
    local Addr Rate ssl_capable state webprt sslprt wwval ssval
    local first cpt curlan curip currate curstt nrow nwfi neth

    Item1=1
    # FIXME: this function has become huge and cluttered
    #		We need to use dynamically built item and command lists
    while :
    do
	AdrL=
	test -e $SSLCRT && ssl_capable="1" || ssl_capable=
	if [ "$ISP" ]; then
	    AdrL=`Tmsg MsgADSLProvider "$ISP"`
	    Itm1=`Tstr ItmHostOnly`
	    Cmd1=HostOnly
	    Itm2=`Tstr ItmADSLNet`
	    Cmd2=ADSLNet
	    Itm3=`Tstr ItmNetInterConfig`
	    Cmd3=IPConfig
	    Itm4=`Tstr ItmRemoveADSL`
	    Cmd4=RemoveADSL
	    Itm5= #port forwarding
	    Cmd5=Forwarding
	    Itm6=`Tstr ItmNetPorts`
	    Cmd6=NetPorts
	    Itm7=`Tstr ItmRedirs`
	    Cmd7=Redirs
	    Itm8=
	else
	    Itm1=`Tstr ItmHostNameGate`
	    Cmd1=HostNameGate
	    Itm2=`Tstr ItmNetInterConfig`
	    Cmd2=IPConfig
	    Itm3=`Tstr ItmSetupADSL`
	    Cmd3=ADSLNet
	    Itm4= #port forwarding
	    Cmd4=Forwarding
	    Itm5=`Tstr ItmNetPorts`
	    Cmd5=NetPorts
	    Itm6=`Tstr ItmRedirs`
	    Cmd6=Redirs
	    Itm7=
	fi
	if [ "$ssl_capable" ]; then
	    if [ -z "$Itm7" ]; then
		Itm7=$Itm6
		Cmd7=$Cmd6
		Itm6=`Tstr ItmApacheMode`
		Cmd6=ApacheMode
		Itm8=
	    else
		Itm8=$Itm7
		Cmd8=$Cmd7
		Itm7=$Itm6
		Cmd7=$Cmd6
		Itm6=`Tstr ItmApacheMode`
		Cmd6=ApacheMode
	    fi
	fi

	first=0
	State=
	test "$AdrL" && { first=1; State="$AdrL\n"; }
	State="$State`Tstr MsgNetLinkStates`"
	eval `ipcalc -a "LAN%i=%n LANIP%i=%a LANRATE%i='%s' LANTYP%i=%t\n"`
	cpt=$first
	while :
	do
	    eval "curlan=\$LAN$cpt curip=\$LANIP$cpt currate=\"\$LANRATE$cpt\" curtyp=\$LANTYP$cpt"
	    test "$curlan" || break
	    test "$currate" || currate=down
	    test "$curip" && Addr="$curip" || Addr="`Tstr TxtNotConfigured`"
	    test "$currate" = "down" -o "$currate" = "no link" && Rate="\\Z2[$currate]\\Zn" || Rate="\\Z5($currate)\\Zn"
	    case "$curtyp" in
		E)	neth=1	;;
		W)	nwfi=1	;;
		*)		;;
	    esac
	    test $cpt -gt $first && State="$State\n`Tstr MsgNetLinkStatesPad`"
	    State="$State`printf '%-5s %-15s %-20s' $curlan "$Addr" "$Rate"`"
	    cpt=`expr $cpt + 1`
	done
	nrow=$cpt

	State="$State\n"
	if [ "`sysctl -n net.inet.ip.forwarding`" = 1 ]; then
	    State="$State`Tstr TxtNetForwarding``Tstr TxtEnabled`"
	    if [ "$ISP" ]; then
		Itm5=`Tstr ItmDisableForwarding`
	    else
		Itm4=`Tstr ItmDisableForwarding`
	    fi
	else
	    State="$State`Tstr TxtNetForwarding``Tstr TxtDisabled`"
	    if [ "$ISP" ]; then
		Itm5=`Tstr ItmEnableForwarding`
	    else
		Itm4=`Tstr ItmEnableForwarding`
	    fi
	fi
	if [ "$neth" -a "$nwfi" -a $OSRel -ge 7 ]; then
	    Itm9=$Itm8
	    Cmd9=$Cmd8
	    Itm8=$Itm7
	    Cmd8=$Cmd7
	    Itm7=$Itm6
	    Cmd7=$Cmd6
	    Itm6=$Itm5
	    Cmd6=$Cmd5
	    Itm5=$Itm4
	    Cmd5=$Cmd4
	    if [ -z "$ISP" ]; then
		Itm4=$Itm3
		Cmd4=$Cmd3
		Itm3=`Tstr ItmWifiConf`
		Cmd3=WIFIConfig
	    else
		Itm4=`Tstr ItmWifiConf`
		Cmd4=WIFIConfig
	    fi
	elif [ "$nwfi" -a $OSRel -ge 7 ]; then
	    if [ -z "$ISP" ]; then
		Itm2=`Tstr ItmWifiConf`
		Cmd2=WIFIConfig
	    else
		Itm3=`Tstr ItmWifiConf`
		Cmd3=WIFIConfig
	    fi
	fi
	nrow=`expr $nrow + 1`
	if [ "$ssl_capable" ]; then
	    webprt=`sed -n 's/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\)[ 	]*$/\1/p' $APACHECNF | head -1`
	    sslprt=`sed -n 's/^#*[ 	]*Listen[ 	]*\([0-9][0-9]*\)[ 	]*$/\1/p' $APACHESSL | tail -1`
	    # FIXME: this can be simplified
	    wwval=`egrep "^#*[ 	]*Listen[ 	]*$webprt[ 	]*$" $APACHECNF | grep '#' >/dev/null && echo 0 || echo 1`
	    ssval=`egrep "^#*[ 	]*Include[ 	].*`basename $APACHESSL`[ 	]*$" $APACHECNF | grep '#' >/dev/null && echo 0 || echo 1`
	    test "$ssval" = "0" -a "$wwval" = "1" && state="`Tstr TxtCurrentState``Tstr ItmApacheNormal`"
	    test "$ssval" = "1" -a "$wwval" = "1" && state="`Tstr TxtCurrentState``Tstr ItmApacheBoth`"
	    test "$ssval" = "1" -a "$wwval" = "0" && state="`Tstr TxtCurrentState``Tstr ItmApacheSSL`"
	    test "$ssval" = "0" -a "$wwval" = "0" && state="`Tstr TxtApacheDeaf`"
	    test -z "$state" && state=`Tstr TxtApacheUnknown`
	    State="$State\n$state"
	    nrow=`expr $nrow + 1`
	fi
	if [ -z "$Itm7" ]; then
	    if $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label \
		"$BtnBack" --menu "`Tstr TitNetConfigMenu`\n\n$State\n" \
		`expr $nrow + 14` `Size NetConfigMenu` 6 \
		    1 "$Itm1" \
		    2 "$Itm2" \
		    3 "$Itm3" \
		    4 "$Itm4" \
		    5 "$Itm5" \
		    6 "$Itm6"
		then
		    Item1=`cat $TMPFILE`
		    case "$Item1" in
			1)  $Cmd1 ;;
			2)  $Cmd2 ;;
			3)  $Cmd3 ;;
			4)  $Cmd4 ;;
			5)  $Cmd5 ;;
			6)  $Cmd6 ;;
		    esac
	    else
		break
	    fi
	elif [ -z "$Itm8" ]; then
	    if $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label \
		"$BtnBack" --menu "`Tstr TitNetConfigMenu`\n\n$State\n" \
		`expr $nrow + 15` `Size NetConfigMenu` 7 \
		    1 "$Itm1" \
		    2 "$Itm2" \
		    3 "$Itm3" \
		    4 "$Itm4" \
		    5 "$Itm5" \
		    6 "$Itm6" \
		    7 "$Itm7"
		then
		    Item1=`cat $TMPFILE`
		    case "$Item1" in
			1)  $Cmd1 ;;
			2)  $Cmd2 ;;
			3)  $Cmd3 ;;
			4)  $Cmd4 ;;
			5)  $Cmd5 ;;
			6)  $Cmd6 ;;
			7)  $Cmd7 ;;
		    esac
	    else
		break
	    fi
	elif [ -z "$Itm9" ]; then
	    if $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label \
		"$BtnBack" --menu "`Tstr TitNetConfigMenu`\n\n$State\n" \
		`expr 16 + $nrow` `Size NetConfigMenu` 8 \
		    1 "$Itm1" \
		    2 "$Itm2" \
		    3 "$Itm3" \
		    4 "$Itm4" \
		    5 "$Itm5" \
		    6 "$Itm6" \
		    7 "$Itm7" \
		    8 "$Itm8"
		then
		    Item1=`cat $TMPFILE`
		    case "$Item1" in
			1)  $Cmd1 ;;
			2)  $Cmd2 ;;
			3)  $Cmd3 ;;
			4)  $Cmd4 ;;
			5)  $Cmd5 ;;
			6)  $Cmd6 ;;
			7)  $Cmd7 ;;
			8)  $Cmd8 ;;
		    esac
	    else
		break
	    fi
	else
	    if $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label \
		"$BtnBack" --menu "`Tstr TitNetConfigMenu`\n\n$State\n" \
		`expr 17 + $nrow` `Size NetConfigMenu` 9 \
		    1 "$Itm1" \
		    2 "$Itm2" \
		    3 "$Itm3" \
		    4 "$Itm4" \
		    5 "$Itm5" \
		    6 "$Itm6" \
		    7 "$Itm7" \
		    8 "$Itm8" \
		    9 "$Itm9"
		then
		    Item1=`cat $TMPFILE`
		    case "$Item1" in
			1)  $Cmd1 ;;
			2)  $Cmd2 ;;
			3)  $Cmd3 ;;
			4)  $Cmd4 ;;
			5)  $Cmd5 ;;
			6)  $Cmd6 ;;
			7)  $Cmd7 ;;
			8)  $Cmd8 ;;
			9)  $Cmd9 ;;
		    esac
	    else
		break
	    fi
	fi
	eval `ipcalc -a "LAN%i=%n ITF%i=%n LANIP%i=%a IPADR%i=%a MASK%i=%m LANRATE%i='%s' LANTYP%i=%t\n"`
    done
}

# =====	Camera Configuration ==========================================

CheckMAC()
{
    local n valid

    STDIFS="$IFS"
    IFS=:
    set $1
    IFS="$STDIFS"
    for n in "$1" "$2" "$3" "$4" "$5" "$6"
    do
	valid=`expr "$n" : '\([0-9a-f]\{2\}\)'`
	if [ -z "$n" -o "$n" != "$valid" ]; then
	    MsgBox MsgInvalidMAC
	    return 1
	fi
    done
    return 0
}

ListCameras()
{
    local typeopt

    MsgBox MsgNoteCameraDetection || return
    ChooseCameraTypes typeopt
    test "$typeopt" = "bad" && return
    InfoBox InfDetectingCameras
    lscam $typeopt >$TMPFILE 2>/dev/null
    if [ -s $TMPFILE ]; then
	eval `GetScrSize 'Max=%r'`
	Max=$(($Max - 1))
	SizeY=`wc -l <$TMPFILE`
	SizeY=$(($SizeY + 8))
	test $SizeY -gt $Max && SizeY=$Max
	echo -e "1i\n`Tstr TitCameraListHeader`\n\n.\nw" | ed - $TMPFILE
	$DIALOG --title " `Tstr TitCameraList` " --tab-correct --textbox $TMPFILE $SizeY `Size CameraList`
    else
	MsgBox MsgNoActiveCameras
    fi
}

SetupCamera()
{
    local resume pid i ip lan ifaces

    Title=`Tstr TitSetupCamera`
    i=1
    ifaces=
    while :
    do
	eval "lan=\$ITF$i ip=\$IPADR$i"
	test -z "$lan" && break
	test -z "$ifaces" && ifaces=$lan || ifaces="$ifaces $lan"
	test "$ip" && break
	i=`expr $i + 1`
    done
    if [ -z "$ip" -a "$IPADR0" ]; then
	ip=$IPADR0
    fi
    if [ -z "$ip" -a -z "$ISP" ]; then
	MsgBox MsgMustConfigureNetwork
	return 1
    fi

    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title (1) " --max-input 17 --inputbox "\n `Tstr InpCameraMACAddress`" 9 `Size SetupCamera` "$CAMMAC" || return 1
	CAMMAC=`tr ABCDEF abcdef <$TMPFILE`
	CheckMAC "$CAMMAC" && break
    done

    CAMIP=`CamNet`
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title (2) " --max-input 15 --inputbox "\n `Tstr InpCameraIPAddress`" 9 `Size SetupCamera` "$CAMIP" || return 1
	CAMIP=`cat $TMPFILE`
	CheckIP "$CAMIP" && break
    done

    OUI=`expr "$CAMMAC" : '\(..:..:..\)'`
    case "$OUI" in
	# Hunt    Sony1    Sony2    Sony3    Sony4
	00:0f:0d|00:01:4a|00:13:a9|00:1a:80|08:00:46)
	    CAMMASK=`NetMask $CAMIP`
	    while :
	    do
		$DIALOG 2>$TMPFILE --title " $Title (3) " --max-input 15 --inputbox "\n `Tstr InpCameraMask`" 9 `Size SetupCamera` "$CAMMASK" || return 1
		CAMMASK=`cat $TMPFILE`
		CheckMask "$CAMMASK" && break
	    done
	    ;;
    esac

    case "$OUI" in
	# Hunt    Sony1    Sony2    Sony3    Sony4
	00:0f:0d|00:01:4a|00:13:a9|00:1a:80|08:00:46)
	    while :
	    do
		$DIALOG 2>$TMPFILE --title " $Title (4) " --max-input 15 --inputbox "\n `Tstr InpCameraGateway`" 9 `Size SetupCamera` "$CAMGW" || return 1
		CAMGW=`cat $TMPFILE`
		if CheckIP "$CAMGW"; then
		    ipcalc -s $CAMIP $CAMGW $CAMMASK >/dev/null && break
		    MsgBox MsgNotOnSameNet
		fi
	    done

	    while :
	    do
		$DIALOG 2>$TMPFILE --title " $Title (5) " --max-input 15 --inputbox "\n `Tstr InpCameraAuth`" 9 `Size SetupCamera` "$CAMID" || return 1
		CAMID=`cat $TMPFILE`
		CheckAuth "$CAMID" && break
	    done
	    ;;
    esac

    if [ "$OUI" = "00:01:4a" -o "$OUI" = "00:13:a9" -o "$OUI" = "00:1a:80" -o "$OUI" = "08:00:46" ]; then	# Sony
	$DIALOG --title " $Title " --yesno "\n`Tmsg MsgCameraParams3 "$CAMMAC" "$CAMIP" "$CAMMASK" "$CAMGW" "$CAMID"`" 14 `Size CameraParams`
    elif [ "$OUI" = "00:0f:0d" ]; then	# Hunt
	$DIALOG --title " $Title " --yesno "\n`Tmsg MsgCameraParams2 "$CAMMAC" "$CAMIP" "$CAMMASK"`" 12 `Size CameraParams`
    else	# Axis
	$DIALOG --title " $Title " --yesno "\n`Tmsg MsgCameraParams "$CAMMAC" "$CAMIP"`" 11 `Size CameraParams`
    fi
    if [ $? -eq 0 ]; then
	if arp -an | grep "at $CAMMAC on" >/dev/null; then
	    SuspendServices C Rst || return 1
	    resume=y
	    arp -an | sed -n "/at $CAMMAC on /s/? (\([^)]*\)) at .*$/\1/p" | while read ip
	    do
		arp -d $ip >/dev/null
	    done
	fi
	if [ "$OUI" = "00:01:4a" -o "$OUI" = "00:13:a9" -o "$OUI" = "00:1a:80" -o "$OUI" = "08:00:46" ]; then
	    for i in $ifaces
	    do
		seen="y"
		if [ $OSRel -lt 5 ]; then
		    bc="255.255.255.255"
		else
		    bc=`ifconfig $i | sed -n 's/.* broadcast \([^ ]*\)$/\1/p'`
		fi
		sonycams $bc $CAMMAC $CAMID $CAMIP $CAMMASK $CAMGW >$TMPFILE 2>/dev/null
		test -s $TMPFILE && break
	    done
	    if [ "$seen" ]; then
		test -s $TMPFILE && MsgBox MsgCameraSetupSuccess || MsgBox MsgCameraSetupFailed
	    else
		MsgBox MsgNoAvailableNIF
	    fi
	elif [ "$OUI" = "00:0f:0d" ]; then
	    for i in $ifaces
	    do
		seen="y"
		if [ $OSRel -lt 5 ]; then
		    bc="255.255.255.255"
		else
		    bc=`ifconfig $i | sed -n 's/.* broadcast \([^ ]*\)$/\1/p'`
		fi
		huntcams $bc $CAMMAC $CAMIP $CAMMASK >$TMPFILE 2>/dev/null
		test -s $TMPFILE && break
	    done
	    if [ "$seen" ]; then
		test -s $TMPFILE && MsgBox MsgCameraSetupSuccess || MsgBox MsgCameraSetupFailed
	    else
		MsgBox MsgNoAvailableNIF
	    fi
	else
	    arp -s $CAMIP $CAMMAC 2>/dev/null
	    if MsgBox MsgWarnCameraReboot; then
		eval `GetScrSize 'Rows=%r Cols=%c'`
		Rows=$(($Rows - 1))
		Cols=$(($Cols - 3))
		ping -c 3600 -s 408 $CAMIP >$TMPFILE 2>&1 &
		pid=$!
		$DIALOG --title " `Tmsg TitTesting $CAMMAC $CAMIP` " --tab-correct --tailbox $TMPFILE $Rows $Cols
		kill $pid 2>/dev/null
	    fi
	    arp -d $CAMIP >/dev/null
	fi
	UpdateRC CAMMAC $OUI
	test "$resume" && ResumeServices "$Rst"
    fi
    return 1
}

PingCamera()
{
    local ip pid i lan

    i=1
    while :
    do
	eval "lan=\$ITF$i ip=\$IPADR$i"
	test -z "$lan" && break
	test "$ip" && break
	i=`expr $i + 1`
    done
    if [ -z "$ip" -a "$IPADR0" ]; then
	ip=$IPADR0
    fi
    if [ -z "$ip" -a -z "$ISP" ]; then
	MsgBox MsgMustConfigureNetwork
	return 1
    fi
    eval `GetScrSize 'Rows=%r Cols=%c'`
    Rows=$(($Rows - 1))
    Cols=$(($Cols - 3))
    Title=`Tstr TitPingCamera`

    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title " --max-input 15 --inputbox "\n `Tstr InpIPAddress`" 9 `Size PingCamera` "`CamNet`" || return 1
	ip=`cat $TMPFILE`
	CheckIP "$ip" && break
    done

    ping -c 3600 $ip >$TMPFILE 2>&1 &
    pid=$!
    $DIALOG --title " `Tmsg TitPinging $ip` " --tab-correct --tailbox $TMPFILE $Rows $Cols
    kill $pid >/dev/null 2>&1
    return 0
}

ChooseCameraTypes()
{
    local str bad

    $DIALOG 2>$TMPFILE --checklist "`Tmsg MsgChooseCamType`" 12 40 4 \
	1 "Axis"    "on" \
	2 "Sony"    "on" \
	3 "CamIP"   "on" \
	4 "Mobotix" "on" || bad=$?

    test "$bad" && eval "$1=bad" && return
    grep "1" $TMPFILE >/dev/null && str=" -t axis "
    grep "2" $TMPFILE >/dev/null && str="$str -t sony "
    grep "3" $TMPFILE >/dev/null && str="$str -t hunt "
    grep "4" $TMPFILE >/dev/null && str="$str -t mobo "
    test "$str" || str="bad"

    eval "$1='$str'"
}

AddCameras()
{
    local StopDB line char lscams nb rows cols i j spc spcl bspc typeopt names
    local ip name ptz firstid curid insert cmd title menu dsl dnm dip dpt
    local dmu dmp errmess Added name_ spc_ ptz_ tspc cmdt user pass

    MsgBox MsgNoteCameraDetection || return 7
    ChooseCameraTypes typeopt
    test "$typeopt" = "bad" && return 1
    if [ "`grep "^pipe [0-9]* config bw " $IPFW`" ]; then
	MsgBox MsgMustNotHaveBWLimit
	return 6
    fi
    if DBService halted; then
	StopDB=y
	DBService start || return 2
    fi
    InfoBox InfDetectingCameras
    i=0
    nb=0
    eval `psql -A -t -F ' ' -c "SELECT id_spc,path FROM spaces" $DB camtrace | awk '{print "cspc" $1 "=" $2 "\n"}'`
    spc=$cspc0
    bspc=$spc0
    while :
    do
	test -z "$spc"  && break
	i=`expr $i + 1`
	eval "spc=\$cspc$i"
    done
    # FIXME: create for example WORKFILE=/tmp/work.$$ and use it here
    lscams=/tmp/lscams
    test -f $lscams || lscam -a $typeopt >$lscams
    cut -d '(' -f 3 $lscams | cut -d ',' -f 2-8 | sed "s/'//g" >$TMPFILE
    eval `awk -F ',' '{print "spc"NR-1"=\""$1"\" ip"NR-1"=\""$3"\" name"NR-1"=\""$4"\" user"NR-1"=\""$5"\" pass"NR-1"=\""$6"\" ptz"NR-1"=\""$7"\" model"NR-1"=\""$2"\""}' $TMPFILE`
    i=`awk 'END{print NR}' $TMPFILE`
    if [ "$i" -eq '0' ]; then
	MsgBox MsgNoCameraAdded
	rm -f $lscams
	return 5
    fi
    line=10
    char=79
    nb=`expr $i + 1` #+header
    eval `GetScrSize 'rows=%r cols=%c'`
    test "$char" -gt "$cols" && char=`expr $cols - 2`

    if [ "`expr $line + $nb`" -ge $rows ]; then
	nb=`expr $rows - 10`
	line=$rows
    else
	line=`expr $line + $nb`
    fi
    title="`Tstr MsgNetConf`\n`Tstr MsgSpacesMng`\n`Tstr MsgSpacesExplain`"
    i=`Tstr TxtCameraSpc | awk '{print substr($1, 0, 1)}'`
    menu="\"$title\"	$line	$char	$nb
	\"`Tstr TxtCameraSpc`\"		 0  1	\"$i\"	 1  1	-1  0
	\"`Tstr TxtCameraName`\"	 0 15	\"\"	 1 15	 0  0
	\"`Tstr TxtCameraIP`\"		 0 30	\"\"	 1 31	 0  0
	\"`Tstr TxtCameraPTZ`\"		 0 44	\"\"	 1 44	 0  0
	\"`Tstr TxtCameraUserName`\"	 0 53	\"\"	 1 54	 0  0
	\"`Tstr TxtCameraPassword`\"	 0 62	\"\"	 1 63	 0  0"
    nb=`awk 'END{print NR}' $TMPFILE`
    i=0
    line=2
    dsl=
    dnm=
    dip=
    dpt=
    dmu=
    dmp=
    while :
    do
	test "$i" -ge $nb && break
	eval "ip=\$ip$i name=\$name$i user=\$user$i pass=\$pass$i spc=\$spc$i ptz=\$ptz$i"
	test -z "$ip" -o -z "$name" && i=`expr $i + 1` && continue
	test "$ptz" = "TRUE" && ptz="x" || ptz=""
	eval "ptz$i=$ptz"
	dsl="$dsl  \"\"		$line  1    \"$spc\"	$line  3     2  1"
	dnm="$dnm  \"\"		$line  8    \"$name\"	$line  9    16 15"
	dip="$dip  \"$ip\"	$line 27    \"\"	$line 28     0  0"
	dpt="$dpt  \"\"		$line 44    \"$ptz\"	$line 45     2  1"
	dmu="$dmu  \"\"		$line 50    \"$user\"	$line 51     8 32"
	dmp="$dmp  \"\"		$line 59    \"$pass\"	$line 60     8 32"
	line=`expr $line + 1`
	i=`expr $i + 1`
    done

    errmess=
    menu="$menu$dsl$dnm$dip$dpt$dmu$dmp"
    while :
    do
	eval $DIALOG --ok-label "$BtnApply" --cancel-label "$BtnBack" \
	    --title "\"`Tstr TitAddCamera`\"" --form $menu 2>$TMPFILE || errmess=1
	test "$errmess" && rm -f $lscams && return 3

	exec 3<$TMPFILE
	i=0
	j=0
	# FIXME: if needed, start database and stop it when done
	names=`psql -A -t -c "SELECT name FROM cameras" $DB camtrace`
	while :
	do
	    spc=
	    name=
	    ptz=
	    test "$j" = 0 && read spc  <&3
	    test "$j" = 1 && read name <&3
	    test "$j" = 2 && read ptz  <&3
	    test "$j" = 3 && read user <&3
	    test "$j" = 4 && read pass <&3

	    test "$spc" && test "$spc" = "s" -o "$spc" = "S" && spc=0

	    test "$j" = 0 && eval "spc${i}_=$spc"
	    test "$j" = 1 && eval "name${i}_=$name"
	    test "$j" = 2 && eval "ptz${i}_=$ptz"
	    test "$j" = 3 && eval "user${i}_=$user"
	    test "$j" = 4 && eval "pass${i}_=$pass"

	    if [ "$j" = "0" -a "$spc" ]; then
		echo "$spc" | grep "[0-9]" >/dev/null || spc=0
		eval "tspc=\$cspc$spc"
		if [ -z "$tspc" ]; then
		    MsgBox MsgUnknownSpace $spc
		    exec 3<&-
		    continue 2
		fi
	    elif [ "$j" = "1" ]; then
		eval "spc=\$spc${i}_"
		if [ "$spc" ]; then
		    test "$names" && names="$names$NL$name" || names="$name"
		fi
	    fi

	    i=`expr $i + 1`
	    test "$i" -lt "$nb" && continue
	    test "$i" = "$nb" && j=`expr $j + 1` && i=0
	    test "$j" -lt 5 && continue
	    break
	done
	exec 3<&-

	echo -e "$names" | sort >$TMPFILE
	if [ "`sort -u $TMPFILE | cmp - $TMPFILE 2>&1`" ]; then
	    MsgBox MsgNamesDoublon
	    continue
	fi

	i=0
	firstid=`psql -A -t -c "SELECT MAX(id_cam) FROM cameras" $DB camtrace`
	[ -z "$firstid" ] && firstid=0
	firstid=`expr $firstid + 1`
	insert=
	j=0
	while :
	do
	    eval "name=\$name$i name_=\$name${i}_ model=\$model$i user=\$user$i user_=\$user${i}_ pass=\$pass$i pass_=\$pass${i}_ spc=\$spc$i spc_=\$spc${i}_ ip=\$ip$i ptz=\$ptz$i ptz_=\$ptz${i}_"
	    i=`expr $i + 1`
	    test "$i" -gt "$nb" && break
	    test -z "$spc_" -o -z "$name_" && continue
	    test "$ptz_" && ptz_=TRUE || ptz_=FALSE
	    test "$ptz" && ptz=TRUE || ptz="FALSE"
	    if [ -z "$cspc1" -a "$spc" != "$spc_" ]; then
		spc_=$spc
	    fi
	    CheckGenericName "$name_" "Camera" || errmess="1"
	    test -z "$errmess" || break
	    cmd=`grep "'$ip','$name'" $lscams`
	    curid=`echo $cmd | cut -d '(' -f 3 | cut -d ',' -f 1`
	    cmd=`echo $cmd | sed "s/($curid,/($firstid,/g"`
	    if [ "$user" = "$user_" -a "$pass" = "$pass_" ]; then
		cmd=`echo $cmd | sed "s/($firstid,$spc,'$model','$ip','$name','$user','$pass',$ptz/($firstid,$spc_,'$model','$ip','$name_',$ptz_/" | sed 's/,cam_user,cam_pass//'`
	    else
		cmd=`echo $cmd | sed "s/($firstid,$spc,'$model','$ip','$name','$user','$pass',$ptz/($firstid,$spc_,'$model','$ip','$name_','$user_','$pass_',$ptz_/"`
	    fi
	    insert="$insert$cmd"
	    firstid=`expr $firstid + 1`
	    j=`expr $j + 1`
	done
	if [ "$errmess" ]; then
	    test "$errmess" = "1" || MsgBox $errmess
	    continue
	fi
	break
    done

    if [ "$insert" ]; then
	echo "$insert" | psql -q $DB camtrace >/dev/null 2>&1
	ids=`psql -A -t -c "SELECT id_cam FROM cameras WHERE ptz ORDER BY id_cam" $DB camtrace`
	reload=y
	if [ "$ids" ]; then
	    out=/tmp/campt.out
	    test -f $out || chown=y
	    campt - - 1 $ids >$out 2>&1 && reload=
	    test "$chown" && chown camtrace:camtrace $out
	fi
	test "$reload" && CamService active && CamService restart
	MsgBox MsgCamerasAdded $j
    else
	MsgBox MsgNoCameraAdded
    fi

    test "$StopDB" && DBService stop
    rm -rf $lscams
}

NbCams()
{
    echo $(($# / 2))
}

CamDesc()
{
    ip="$1"
    shift
    while [ "$1" ]
    do
	if [ "$1" = "$ip" ]; then
	    echo "$2"
	    return
	fi
	shift 2
    done
}

RebootCamera()
{
    local i ip lan

    i=1
    while :
    do
	eval "lan=\$ITF$i ip=\$IPADR$i"
	test -z "$lan" && break
	test "$ip" && break
	i=`expr $i + 1`
    done
    if [ -z "$ip" -a "$IPADR0" ]; then
	ip=$IPADR0
    fi
    if [ -z "$ip" -a -z "$ISP" ]; then
	MsgBox MsgMustConfigureNetwork
	return 1
    fi
    eval `GetScrSize 'Rows=%r Cols=%c'`
    Rows=$(($Rows - 1))
    Cols=$(($Cols - 3))
    Max=$(($Cols - 62))
    Manual=`Tstr TxtManualInput`
    Item=`printf "%-$(($Cols - 22))s" "\`Tstr ItmManualInput\`"`

    InfoBox InfDetectingCameras
    Cams=`lscam -m $Max`
    nb=`eval NbCams "$Cams"`
    nb=$(($nb + 1))
    lines=$(($nb + 8))
    while :
    do
	eval $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" --menu "\"`Tstr TitChooseRebootCamera`\"" \
	    $lines $Cols $nb "$Cams" "\"$Manual\"" "\"$Item\"" || return 1
	ip=`cat $TMPFILE`
	if [ "$ip" = "$Manual" ]; then
	    ip=`CamNet`
	    while :
	    do
		$DIALOG 2>$TMPFILE --title " `Tstr TitChooseRebootCamera` " --max-input 15 --inputbox "\n `Tstr InpIPAddress`" 9 `Size ChooseCamera` "$ip" || return 1
		ip=`cat $TMPFILE`
		CheckIP "$ip" || continue
		if ping -c 1 -t 1 "$ip" >/dev/null 2>&1; then
		    cam="$ip"
		    break
		fi
		MsgBox MsgCannotPing "$ip"
	    done
	else
	    cam=`eval CamDesc $ip "$Cams" | sed 's/ *$//'`
	fi
	if NoYesBox MsgConfirmReboot "$cam"; then
	    trap : 2 3
	    rbcam "$ip"
	    trap '' 2 3
	    enter
	    break
	fi
    done
    return 0
}

CheckCDROM()
{
    df /cdrom | grep ' /cdrom$' && return 0
    while :
    do
	if mount /cdrom 2>/dev/null; then
	    Mounted=y
	    return 0
	fi
	MsgBox MsgInsertCDROM || return 1
    done
}

GetFile()	# GetFile prompt-message start-dir default-dir result-variable
{
    local ini def dir file

    test "$#" -eq 4 || return 1
    ini=`pwd`
    if [ "$2" ]; then
	dir="$2"
	def="$3"
    else
	dir="$3"
	def=
    fi
    case "$dir" in
	/cdrom*)    CheckCDROM ;;
    esac
    until cd "$dir" 2>/dev/null
    do
	dir=`dirname $dir`
	if [ "$dir" = / ]; then
	    if [ -d "$def" ]; then
		dir="$def"
		def=
	    else
		break
	    fi
	fi
    done
    dir=`pwd`
    while eval $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" --menu "\"$1\\\n\\\n $dir\\\n\"" 23 77 14 "`LANG=C ls -alT | awk '$1 != "total" && $10 != "."{printf("\\"%-32.32s\\" \\"%s %10d %s %2d %5.5s %d\\" ",$10,substr($1,1,1),$5,$6,$7,$8,$9)}'`"
    do
	file=`sed 's/ *$//' $TMPFILE`
	if [ -d "$file" ]; then
	    test "$dir" = / -a "$file" = cdrom && CheckCDROM
	    cd "$file"
	    dir=`pwd`
	    if [ "$dir" = / -a "$Mounted" ]; then
		umount /cdrom 2>/dev/null
		Mounted=
	    fi
	elif [ -f "$file" ]; then
	    test "$dir" = "/" && dir=
	    eval "$4=$dir/$file"
	    cd "$ini"
	    return 0
	fi
    done
    cd "$ini"
    if [ "$Mounted" ]; then
	umount /cdrom 2>/dev/null
	Mounted=
    fi
    return 1
}

FlashCamera()
{
    local i ip lan

    i=1
    while :
    do
	eval "lan=\$ITF$i ip=\$IPADR$i"
	test -z "$lan" && break
	test "$ip" && break
	i=`expr $i + 1`
    done
    if [ -z "$ip" -a "$IPADR0" ]; then
	ip=$IPADR0
    fi
    if [ -z "$ip" -a -z "$ISP" ]; then
	MsgBox MsgMustConfigureNetwork
	return 1
    fi
    eval `GetScrSize 'Rows=%r Cols=%c'`
    Rows=$(($Rows - 1))
    Cols=$(($Cols - 3))
    Max=$(($Cols - 62))
    Manual=`Tstr TxtManualInput`
    Item=`printf "%-$(($Cols - 22))s" "\`Tstr ItmManualInput\`"`

    InfoBox InfDetectingCameras
    Cams=`lscam -m $Max`
    nb=`eval NbCams "$Cams"`
    nb=$(($nb + 1))
    lines=$(($nb + 8))
    while :
    do
	eval $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" --menu "\"`Tstr TitChooseFlashCamera`\"" \
	    $lines $Cols $nb "$Cams" "\"$Manual\"" "\"$Item\"" || break
	ip=`cat $TMPFILE`
	if [ "$ip" = "$Manual" ]; then
	    ip=`CamNet`
	    while :
	    do
		$DIALOG 2>$TMPFILE --title " `Tstr TitChooseFlashCamera` " --max-input 15 --inputbox "\n `Tstr InpIPAddress`" 9 `Size ChooseCamera` "$ip" || break 2
		ip=`cat $TMPFILE`
		CheckIP "$ip" || continue
		if ping -c 1 -t 1 "$ip" >/dev/null 2>&1; then
		    cam="$ip"
		    break
		fi
		MsgBox MsgCannotPing "$ip"
	    done
	else
	    cam=`eval CamDesc $ip "$Cams" | sed 's/ *$//'`
	fi
	while :
	do
	    if [ -z "$FIRMDIR" ]; then
		FIRMDIR=~camtrace/upload
		test -e $FIRMDIR -a ! -d $FIRMDIR && rm -f $FIRMDIR
		if [ ! -d $FIRMDIR ]; then
		    mkdir $FIRMDIR
		    chown camtrace:camtrace $FIRMDIR
		fi
	    fi
	    GetFile "`Tstr MsgChooseFlashFile`" "$FIRMDIR" /root flash || break
	    FIRMDIR=`dirname $flash`
	    UpdateRC FIRMDIR $FIRMDIR
	    siz=`wc -c <$flash`
	    rel=`strings <$flash | grep 'ready\.$' | sed -e 's/^ //' -e 's/ ready\.$//' -e 's/^.*banner//' -e 's/^f>//'`
	    test $siz -eq 2097176 -o $siz -eq 4194328 -o $siz -eq 8388632 && sizOK=y || sizOK=
	    test "$rel" && relOK=y || relOK=
	    if [ "$sizOK" -a "$relOK" ]; then
		if NoYesBox MsgConfirmUpgrade "$cam" "$rel"; then
		    updcam $ip $flash >/dev/null
		    while :
		    do
			$DIALOG --title " `Tmsg TitFlashing $ip \`basename $flash\`` " --tab-correct --tailbox /tmp/$ip.out $Rows $Cols
			NoYesBox MsgStopFollowing && break
		    done
		    break 2
		fi
	    else
		MsgBox MsgNotAxisFirmware
	    fi
	done
    done
    if [ "$Mounted" ]; then
	umount /cdrom 2>/dev/null
	Mounted=
    fi
}

CamConfig()
{
    Item1=1
    while $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
	--menu "`Tstr TitCamConfigMenu`" 13 `Size CamConfigMenu` 6 \
	1 "`Tstr ItmListCameras`" \
	2 "`Tstr ItmAddCameras`" \
	3 "`Tstr ItmSetupCamera`" \
	4 "`Tstr ItmPingCamera`" \
	5 "`Tstr ItmRebootCamera`" \
	6 "`Tstr ItmFlashCamera`"
    do
	Item1=`cat $TMPFILE`
	case "$Item1" in
	    1)	ListCameras	;;
	    2)	AddCameras	;;
	    3)	SetupCamera	;;
	    4)	PingCamera	;;
	    5)	RebootCamera	;;
	    6)	FlashCamera	;;
	esac
    done
}

# =====	Storage Spaces ================================================

ListDelSpaces()
{
    local mil n ids items itext id mnt dev inq len sz size ids
    local text lines chars rows max nbi keep del nc

    mil=32
    psql -A -t -c "SELECT id_spc,path FROM spaces WHERE id_spc > 0 ORDER BY id_spc" $DB camtrace | sed 's/|\/\(.*\)\/images/ \1/' >$TMPFILE
    if [ -s $TMPFILE ]; then
	n=0
	ids=
	items=
	itext=
	while read id mnt
	do
	    case $mnt in
		disk*)
		    dev=`readlink /dev/$mnt | sed 's,.*/,,'`
		    case "$dev" in
			"")  ;;
			ad*) inq=`atacontrol list | sed -n "/$dev/s/.*<\(.*\)>.*\$/\1/p"`;;
			da*) inq=`camcontrol devlist | sed -n "/$dev/s/.*<\(.*\)>.*\$/\1/p"`;;
			*)   echo -n "dev=$dev ? "; read a;;
		    esac
		    ;;
		net*)
		    inq=`sed -n "/[ 	]\/$mnt[ 	]/s/[ 	].*\$//p" /etc/fstab`
		    ;;
	    esac
	    len=`expr "$inq" : '.*'`
	    test $len -gt $mil && inq=`expr "$inq" : "\(.\{$mil\}\)"`
	    sz="`df -k | awk "\\$6 == \\\"/$mnt\\\"{print \\$2}"`"
	    size=
	    test "$sz" && size=`expr $sz / 1048576`
	    test "$size" || size=`fstype /dev/$mnt '%g'`
	    test "$size" || size='???'
	    size="$size `Tstr TxtUnitGb`"
	    items="$items $id \"$size <$inq>\" \"\""
	    itext="$itext\n    (x) $id $size <$inq>    "
	    test "$ids" && ids="$ids $id" || ids=$id
	    eval "mnt$id=$mnt"
	    n=`expr $n + 1`
	done <$TMPFILE
	text=`Tstr TitListDelSpaces`
	lines=`MsgLines "$text" 6`
	eval `GetScrSize 'rows=%r'`
	max=`let $rows - 1 - $lines`
	test $n -lt $max && nbi=$n || nbi=$max
	lines=`let $lines + $nbi`
	chars=`MsgChars "$text$itext" 6`
	#echo -n :;read a
	eval $DIALOG 2>$TMPFILE --checklist "\"$text\"" $lines $chars $nbi "$items" || return
	del=`sed 's/"//g' $TMPFILE`
	#echo -n "del=[$del] "; read a
	for id in $del
	do
	    nc=`psql -A -t -c "SELECT COUNT(id_cam) FROM cameras WHERE id_spc = $id" $DB camtrace`
	    if [ $nc -eq 0 ]; then
		eval "mnt=\$mnt$id"
		if ! df | grep /$mnt >/dev/null || umount /$mnt 2>/dev/null; then
		    psql -c "DELETE FROM spaces WHERE id_spc = $id" $DB camtrace >/dev/null
		    expr "$mnt" : 'disk' >/dev/null && rm -f /dev/$mnt
		    rmdir /$mnt 2>/dev/null
		else
		    #echo -n :;read a
		    MsgBox MsgCannotUmountSpace $id
		fi
	    else
		#echo -n :;read a
		MsgBox MsgSpaceHasCameras $id $nc
	    fi
	    #echo -n "mnt=/$mnt "; read a
	done
	scamdctl reload
    else
	MsgBox MsgNoSpaceDeclared
    fi
}

#   returns true if $1 = $2 +- ($2/$3)%
About()
{
    test $1 -gt `expr $2 - '(' $2 / $3 ')'` -a $1 -lt `expr $2 + '(' $2 / $3 ')'` && return 0
    return 1
}

SlcSize()
{
    local Mb Gb BpG sz

    Mb=`Tstr TxtUnitMb`
    Gb=`Tstr TxtUnitGb`
    BpG=2097152		# blocks per Gb (1024 * 2048)

    sz=`expr $1 / $BpG`
    test $sz -gt 0 && About $1 `expr $sz '*' $BpG` 20 && { echo "$sz $Gb"; return; }
    sz=`expr $1 / 2048`
    echo "$sz $Mb"
}

DiskState()
{
    local dev size max np ids id off len tag rest num slc lbl win inq
    local aoff alen doff dlen eoff elen foff flen goff glen

    dev=$1
    size=$2
    case $dev in
	ad*) inq=" `atacontrol list | sed -n "/$dev/s/.*\(<.*>\).*\$/\1/p"`";;
	da*) inq=" `camcontrol devlist | sed -n "/$dev/s/.*\(<.*>\).*\$/\1/p"`";;
    esac
    >$TMPFILE
    max=4294967296 # 2^32 sectors (maximum size in MBR)
    test $size -lt $max && fdisk -s $dev 2>/dev/null | grep '^   [1-9]:' | sort -n +1 >$TMPFILE
    if [ -s $TMPFILE ]; then
	ids=
	np=`awk 'END{print NR}' $TMPFILE`
	while read id off len tag rest
	do
	    num=`expr $id : '\([0-9]\):'`
	    case $tag in
		0xa5)	# FreeBSD
		    eval `bsdlabel ${dev}s$num | awk '$4 == "4.2BSD"{sub(":","",$1);printf("%soff=%d %slen=%d\n",$1,$3,$1,$2); p = (p == "") ? $1 : p " " $1} END{printf("slc=\"%s\"\n",p)}'`
		    for s in $slc
		    do
			eval `fstype ${dev}s$num$s "${s}fs=%t\n"`
		    done
		    #
		    # CT 2.x slc 1: 4 fs
		    #	a=root(256M:524288)
		    #	[b=swap(1G)]
		    #	e=/var(512M:1048576)
		    #	f=/tmp(256M:524288)
		    #	g=/usr(reste)
		    #
		    if [ $num -eq 1 -a "$slc" = 'a e f g' -a "$afs" = 'ufs' -a "$efs" = 'ufs' -a "$ffs" = 'ufs' -a "$gfs" = 'ufs' ] && About $alen 525000 20 && About $elen 1050000 20 && About $flen 525000 20; then
			lbl='CTSystem'
		    #
		    # CT 3+.x slc 1: 2 fs
		    #	a=root(1G:2097152)
		    #	[b=swap(1G)]
		    #	d=/disk(reste)
		    #
		    elif [ $num -eq 1 -a "$slc" = 'a d' -a "$afs" = 'ufs' -a "$dfs" = 'ufs' ] && About $alen 2100000 10; then
			lbl='CTSystem'
		    #
		    # CT 7+.x slc 1: 2 fs
		    #	a=root(2G:4194304)
		    #	[b=swap(2G)]
		    #	d=/disk(reste)
		    #
		    elif [ $num -eq 1 -a "$slc" = 'a d' -a "$afs" = 'ufs' -a "$dfs" = 'ufs' ] && About $alen 4190000 10; then
			lbl='CTSystem'

		    #
		    # CT medium (USB flash drive)
		    #	a=medium(320-704M)
		    #
		    elif [ $num -eq 2 -a "$slc" = 'a' -a "$afs" = 'ufs' ] && About $alen 1050000 40; then
			lbl='CTMedium'
		    #
		    # Rescue: slc 2 (~200M): 1 seul fs s2a avec script /root/rescue
		    #
		    elif [ $num -eq 2 -a "$slc" = 'a' -a "$afs" = 'ufs' ] && About $alen 400000 8; then
			lbl='CTRescue'
		    else
			lbl='FreeBSD'
		    fi
		    ;;
		*)  # Other partition types
		    eval `fstype ${dev}s$num "typ=%t\nver=\"%v\"\n"`
		    if [ "$typ" = 'vfat' ]; then
			lbl="$ver"
		    elif [ "$typ" = 'ntfs' ]; then
			test "$ver" = '3.1' && win='WinXP' || win='Win2k'
			lbl="$win"
		    else
			# XXX derive lbl from tag ?
			lbl=`echo "$typ" | awk '{print toupper()}'`
		    fi
		    ;;
	    esac
	    eval "s${num}lbl=\"$lbl\""
	    eval "s${num}len=$len"
	    test "$ids" && ids="$ids $num" || ids=$num
	done <$TMPFILE
	if [ $np -eq 1 -a "$s1lbl" = 'CTSystem' ]; then
	    st='CTSystem'
	    dc="`SlcSize $size` - `Tmsg Txt$st`$inq"
	elif [ $np -eq 2 -a "$s1lbl" = 'CTSystem' -a "$s2lbl" = 'CTRescue' ]; then
	    st='CTSystem'
	    dc="`SlcSize $size` - `Tmsg Txt$st`$inq"
	else
	    st='PartDisk'
	    dc="`SlcSize $size` - `Tmsg Txt$st`$inq"
	    if [ "$ids" ]; then
		if [ $np -gt 1 ]; then
		    for num in $ids
		    do
			eval "lbl=\"\$s${num}lbl\" len=\$s${num}len"
			test "$tbl" && tbl="$tbl + $lbl:`SlcSize $len`" || tbl="$lbl:`SlcSize $len`"
		    done
		else
		    eval "lbl=\"\$s${ids}lbl\" len=\$s${ids}len"
		    tbl="$lbl"
		fi
		dc="$dc ($tbl)"
	    fi
	fi
    else	# An fdisk MBR is acceptable if it is empty
	np=0
	fs=`fstype $dev '%t' | awk '{print toupper()}'`
	if [ "$fs" = 'UFS' ] && echo 'ls' | fsdb -r /dev/$dev | grep "directory, \`images'" >/dev/null; then
	    st='CTImages'
	    dc="`SlcSize $size` - `Tmsg Txt$st`$inq"
	elif [ "$fs" = 'MBR' -o "$fs" = 'UNKNOWN' ]; then
	    st='BlankDisk'
	    dc="`SlcSize $size` - `Tmsg Txt$st`$inq"
	else
	    st='BareDisk'
	    dc="`SlcSize $size` - `Tmsg Txt$st` ($fs)$inq"
	fi
    fi
    echo "$3" | sed -e "s/%n/$np/g" -e "s/%t/$st/g" -e "s~%D~$dc~g"
}

AddDiskSpace()
{
    local min root spcs n id ids items itext dev sz sd type desc
    local text lines chars rows max nbi add sid id_spc

    eval `df | awk '$6 == "/" {sub("^/dev/","",$1);sub("s1a$","",$1);print "root=" $1} $6 == "'$EXPORT'" {sub("^/dev/","",$1);sub("s.$","",$1);print "exp=" $1}'`
    #echo -n "root=$root exp=$exp "; read a
    spcs=`psql -A -t -c "SELECT path FROM spaces WHERE id_spc > 0 ORDER BY id_spc" $DB camtrace | sed -n 's/^\/\(disk[0-9]*\)\/images$/\1/p'`
    n=0
    id=1
    items=
    itext=
    for dev in `sysctl -n kern.disks`
    do
	expr $dev : 'md' >/dev/null && continue
	test $dev = $root && continue
	test "$exp" -a $dev = "$exp" && continue
	test "`ps ax | sed -n '/[0-9] ntfs-3g /s;.* /dev/\([^ ]*\)s[0-9] .*;\1;p' | grep $dev`" && continue
	dd if=/dev/$dev bs=1k count=1 >/dev/null 2>&1 || continue
	for spc in $spcs
	do
	    sd=`readlink /dev/$spc | sed 's,.*/,,'`
	    test "$dev" = "$sd" && continue 2
	done
	while :
	do
	    echo "$spcs" | grep "disk$id" >/dev/null || break
	    id=`expr $id + 1`
	done
	eval `dsk $dev 'sz=%t\n' 2>/dev/null`
	eval "`DiskState $dev $sz 'type=%t desc="%D"'`"
	items="$items $id \"$desc\" \"\""
	itext="$itext\n    ( ) $desc    "
	eval "dev$id=$dev type$id=$type desc$id=\"$desc\" size$id=$sz"
	id=`expr $id + 1`
	n=`expr $n + 1`
    done
    if [ -z "$items" ]; then
	MsgBox MsgNoNewDisk
	return
    fi
    text=`Tstr TitAddDiskSpace`
    lines=`MsgLines "$text" 6`
    eval `GetScrSize 'rows=%r'`
    max=`let $rows - 1 - $lines`
    test $n -lt $max && nbi=$n || nbi=$max
    lines=`let $lines + $nbi`
    chars=`MsgChars "$text$itext" 6`
    #echo -n "n=$n ":;read a
    eval $DIALOG 2>$TMPFILE --checklist "\"$text\"" $lines $chars $nbi "$items"
    test $? -eq 0 -a -s $TMPFILE || return
    add=`sed 's/"//g' $TMPFILE`
    for id in $add
    do
	eval "dev=\$dev$id type=\$type$id desc=\"\$desc$id\" sz=\$size$id"
	if [ "$type" != 'BlankDisk' ]; then
	    #echo -n :;read a
	    NoYesBox MsgConfirmDiskAdd "$desc" || continue
	fi
	WipeTrack0 $dev
	#echo -n :;read a
	(newfs -L "disk$id" -U $dev | awk -F, "/^ [0-9]/{b=(\$NF!=\"\")?\$NF:\$(NF-1);printf(\"%d\n\",(b*100)/$sz);fflush()}"; echo 100; sleep 1) | $DialogWait --gauge "\n`Tmsg MsgCreatingFileSystem /disk$id`" 8 70
	rm -f /dev/disk$id
	ln -s /dev/$dev /dev/disk$id
	test -d /disk$id || mkdir /disk$id
	while :
	do
	    mount /dev/disk$id /disk$id >/dev/null 2>&1 && break
	    NoYesBox MsgUnableToMountDisk || continue 2
	done
	mkdir /disk$id/images
	chown camtrace:camtrace /disk$id/images
	sid=`psql -A -t -c "SELECT id_spc FROM spaces WHERE id_spc > 0 ORDER BY id_spc" $DB camtrace | awk 'BEGIN{id=0}{if (id == 0 && $1 != NR)id=NR}END{if(id == 0)id=NR+1;print id}'`
	psql -c "INSERT INTO spaces VALUES((SELECT MAX(id_spc) + 1 FROM spaces),'/disk$id/images')" $DB camtrace >/dev/null
	id=`expr $id + 1`
    done
    scamdctl reload
    #echo -n :;read a
}

AddExport()
{
    local min root spcs StopDB n id ids items itext dev sz sd type desc text lines mnt
    local chars rows max nbi add prev sid id_spc fstype fsvers fstv fssize rdev
    local cyl hpc sec sig sz spc mod s1off s1len use lost tmp
    local dchars dnbi dlines dtext ditems

    root=`df / | sed -n 's;^/dev/\(.*\)s1a .*;\1;p'`
    spcs=`psql -A -t -c "SELECT path FROM spaces WHERE id_spc > 0 ORDER BY id_spc" $DB camtrace | sed -n 's;^/\(disk[0-9]*\)/images$;\1;p'`
    if ps ax | grep '[/]usr/local/bin/postgres' >/dev/null; then
	spcs=`psql -A -t -c "SELECT path FROM spaces WHERE id_spc > 0 ORDER BY id_spc" $DB camtrace | sed -n 's/^\/\(disk[0-9]*\)\/images$/\1/p'`
    fi
    if [ -z "$spcs" -a -x /usr/local/bin/pgfsck ]; then
	spcs=`pgfsck -dh $DB spaces 2>/dev/null | egrep -v "^(--|id_spc|0).*" | awk -F '/' '{print $2}'`
    elif [ -z "$spcs" ]; then
	if DBService halted; then
	    DBService start || return 1
	    StopDB=y
	fi
	spcs=`psql -A -t -c "SELECT path FROM spaces" $DB camtrace | awk -F '/' '{print $2}'`
	test "$StopDB" && DBService stop
    fi
    id=1
    items=
    itext=
    for dev in `sysctl -n kern.disks`
    do
	expr $dev : 'md' >/dev/null && continue
	dd if=/dev/$dev bs=1k count=1 >/dev/null 2>&1 || continue
	test $dev = $root && continue
	for spc in $spcs
	do
	    sd=`readlink /dev/$spc | sed 's,.*/,,'`
	    test "$dev" = "$sd" && continue 2
	done
	eval `dsk $dev 'sz=%t\n' 2>/dev/null`
	eval "`DiskState $dev $sz 'type=%t desc="%D"' 2>/dev/null`"
	ditems="$ditems $id \"$desc\" "
	itext="$itext\n    ( ) $desc    "
	eval "dev$id=\$dev type$id=\$type desc$id=\"$desc\""
	id=`expr $id + 1`
    done
    if [ -z "$ditems" ]; then
	MsgBox MsgNoNewDisk
	return 1
    fi
    n=`expr $id - 1`
    dtext=`Tstr TitAddExportSpace`
    dlines=`MsgLines "$dtext" 6`
    eval `GetScrSize 'rows=%r'`
    max=`let $rows - 1 - $dlines`
    test $n -lt $max && dnbi=$n || dnbi=$max
    dlines=`let $dlines + $dnbi`
    dchars=`MsgChars "$text$itext" 6`
    while :
    do
	eval $DIALOG 2>$TMPFILE --menu "\"$dtext\"" $dlines $dchars $dnbi "$ditems"
	test $? -eq 0 -a -s $TMPFILE || break
	id=`sed 's/"//g' $TMPFILE`
	eval "dev=\$dev$id type=\$type$id desc=\"\$desc$id\""
	while :
	do
	    rdev=$dev
	    fstype=
	    fsvers=
	    fssize=
	    fsname=
	    items=
	    itext=
	    id=1
	    for n in `ls /dev/$dev*`
	    do
		eval `fstype $n "fstype=\"%t\" fsvers=\"%v\" fssize=\"%mMo\" fsname=\"%l\""`
		if [ "$fstype" = ext2 ]; then
		    fsvers=`tune2fs -l $n 2>/dev/null | grep "^Inode size" | awk '{print $3}'`
		    test "$fsvers" != "128" && continue
		elif [ "$fstype" = vfat ]; then
		elif [ $OSRel -ge 6 -a "$fstype" = ntfs ]; then
		elif [ "$fstype" = ufs ]; then
		else
		    continue
		fi
		test "$fsname" = "" && fsname=`Tstr TxtNoFSName`
		test "$fsvers" = "" && fstv=$fstype || fstv="$fstype $fsvers"
		desc="$n - $fsname ($fssize) - $fstv"
		items="$items $id \"$desc\" "
		itext="$itext\n    ( ) $desc    "
		eval "dev$id=$n type$id=$fstype vers$id=$fsvers"
		id=`expr $id + 1`
	    done
	    n=$id
	    if [ -z "$items" ]; then
		text=`Tstr TitNoPartSoFormat`
	    else
		text=`Tstr TitSelectPartOrFormat`
	    fi
	    items="$items $id \"`Tstr TxtFormatDisk`\""
	    itext="$itext\n    ( ) `Tstr TxtFormatDisk`"
	    lines=`MsgLines "$text" 6`
	    eval `GetScrSize 'rows=%r'`
	    max=`let $rows - 1 - $lines`
	    test $id -lt $max && nbi=$n || nbi=$max
	    lines=`let $lines + $nbi`
	    chars=`MsgChars "$text$itext" 6`
	    eval $DIALOG 2>$TMPFILE --menu "\"$text\"" $lines $chars $nbi "$items" || break
	    id=`sed 's/"//g' $TMPFILE`
	    test "$id" || continue

	    if [ $id = $n ] ; then	#format
		dev="/dev/$rdev"
		eval `dsk $dev 'sz=%t\n' 2>/dev/null`
		text=`Tstr TitSelectFSType`
		itext=
		if which -s mkntfs; then
		    n=3			#nombre FStypes
		    itext="$itext\n    ( ) `Tstr ItmFSNTFS`"
		    itext="$itext\n    ( ) `Tstr ItmFSEXT2`"
		    itext="$itext\n    ( ) `Tstr ItmFSFAT32`"
		else
		    n=2
		    itext="$itext\n    ( ) `Tstr ItmFSEXT2`"
		    itext="$itext\n    ( ) `Tstr ItmFSFAT32`"
		fi
		lines=`MsgLines "$text" 6`
		max=`let $rows - 1 - $lines`
		test $id -lt $max && nbi=$n || $nbi=$max
		lines=`let $lines + $nbi`
		chars=`MsgChars "$text$itext" 6`
		while :
		do
		    if [ $n -eq 3 ]; then
			$DIALOG 2>$TMPFILE --menu "$text" $lines $chars $nbi \
			    1 "`Tstr ItmFSNTFS`" \
			    2 "`Tstr ItmFSEXT2`" \
			    3 "`Tstr ItmFSFAT32`" || continue 2
			test -s $TMPFILE || continue 2
			add=`sed 's/"//g' $TMPFILE`
		    else
			$DIALOG 2>$TMPFILE --menu "$text" $lines $chars $nbi \
			    1 "`Tstr ItmFSEXT2`" \
			    2 "`Tstr ItmFSFAT32`" || continue 2
			test -s $TMPFILE || continue 2
			add=`sed 's/"//g' $TMPFILE`
			add=`expr $add + 1`
		    fi
		    if [ "$add" = 3 ]; then
			NoYesBox MsgConfirmFAT32Looser || continue
		    fi
		    eval `dsk $dev 'cyl=%c hpc=%h sec=%s sig=%m sz=%t'`
		    spc=`expr $hpc '*' $sec`
		    lost=`expr $sz % $spc`
		    use=`expr $sz - $lost`
		    s1off=$sec
		    s1len=`expr $use - $s1off`
		    WipeTrack0 $dev y
		    tmp="/tmp/fdisk.in"
		    echo "g c$cyl h$hpc s$sec" >$tmp
		    if [ $add -eq 2 ]; then		#ext2
			mnt="mke2fs -I 128 -L export"
			fstype="ext2"
			fsvers="1.0"
			echo "p 1 0x83 $s1off $s1len" >>$tmp
		    elif [ $add -eq 3 ]; then		#fat32
			mnt="newfs_msdos -L export -p"
			fstype="vfat"
			fsvers="FAT32"
			echo "p 1 0x0b $s1off $s1len" >>$tmp
		    elif [ $add -eq 1 ]; then		#ntfs
			mnt="mkntfs -f -L export"
			fstype="ntfs"
			fsvers="3.1"			#3.0 = 2000 ; 3.1 = XP
			echo "p 1 0x07 $s1off $s1len" >>$tmp
		    fi
		    echo "a 1" >>$tmp
		    fdisk -if $tmp $dev >/dev/null 2>&1
		    usleep 300
		    rm $tmp
		    if [ "$fstype" = "vfat" ]; then
			$mnt ${dev}s1 2>&1 | $DialogWait --gauge "`Tstr TxtPleaseWaitFormat`" 7 60
			if [ "$?" -ne 0 ]; then
			    NoYesBox MsgFormatFailedKeepTrying || continue
			fi
		    else
			InfoBox TxtPleaseWaitFormat
			$mnt ${dev}s1 >/dev/null 2>&1
			if [ "$?" -ne 0 ]; then
			    NoYesBox MsgFormatFailedKeepTrying || continue
			fi
		    fi
		    dev="${dev}s1"
		    break
		done
	    else
		eval "dev=\$dev$id fstype=\$type$id fsvers=\$vers$id"
	    fi
	    mnt=
	    case "$fstype" in
		ntfs)	if [ $OSRel -lt 6 ]; then
			    MsgBox MsgUnknownFSType
			    continue
			fi
			if ntfs-3g.probe --readwrite $dev; then	# c'est tellement bancal...
			    mnt="ntfs-3g -o uid=1001"
			else
			    MsgBox MsgCantMount
			    continue
			fi
			;;

		vfat)	mnt="mount_msdosfs"
			test "$fsvers" = 'FAT32' -a $OSRel -ge 7 && mnt="$mnt -o large"
			test "$fsvers" = 'FAT16' && mnt="$mnt -l"
			mnt="$mnt -o noexec -o rw -o nosuid -u 1001"
			;;

		ext2)	mnt="mount -t ext2fs -o noexec,nosuid" ;;

		ufs)	mnt="mount -o noexec,nosuid" ;;

		'')	mnt="cnt" ;;

		*)	MsgBox MsgUnknownFSType ; mnt="cnt" ;;
	    esac
	    test "$mnt" = "cnt" && continue

	    test -d $EXPORT || mkdir $EXPORT
	    if $mnt $dev $EXPORT 2>/dev/null; then
		test "$fstype" = ext2 && chown camtrace:camtrace $EXPORT
		MsgBox MsgExportSpaceSuccessfullyMounted
		return 0
	    else
		MsgBox MsgCantMount
		continue
	    fi
	done
    done
    return 1
}

DelExport()
{
    if mount | grep " $EXPORT " >/dev/null; then
	NoYesBox MsgDelExportSpace || return 1
	umount $EXPORT && return
	MsgBox MsgCantDelExportSpace
    else
	MsgBox MsgCantFindExportSpace	# Ceinture et bretelles !
    fi
    return 1
}

SelectToExport()
{
    local text list items item it lines max nbi chars checker nb format site sz dsp

    checker=
    list=`ls -1 $LOCAL/$1 2>/dev/null | cut -d '/' -f 4` && checker="OK"
    test "$list" || checker=
    if [ "$checker" != "OK" ]; then
	MsgBox TxtNoFileToExport $1
	return 1
    fi
    text=`Tstr TitChooseExport`
    lines=`MsgLines "$text" 6`
    items=
    max=0
    it=0
    for item in $list
    do
	chars=`MsgChars "$item"`
	if [ $chars > $max ]; then
	    max=$chars
	fi
	it=`expr $it + 1`
	items="$items $it \"$item\" ''"
    done
    nb=`let $it - 1`
    chars=`let $max + 15`
    eval `GetScrSize 'rows=%r'`
    max=`let $rows - 1 - $lines`
    test $it -lt $max && nbi=$it || nbi=$max
    test $chars -lt 60 && chars=60
    lines=`let $lines + $nbi`
    eval $DIALOG 2>$TMPFILE --checklist "\"$text\"" $lines $chars $nbi "$items" || return
    it=`sed 's/"//g' $TMPFILE`
    site=`psql -A -t -c "SELECT site_name FROM config" $DB camtrace | sed 's/[\\\/:*?"<>|]/_/g'`
    test "$site" || site='CamTrace'
    for nbi in $it
    do
	item=`echo $items | sed -E "s/.*$nbi \"//g" | sed -E 's/".*$//g'`
	dsp=`df | grep " $EXPORT" | awk '{print $4}'`
	dsp=`expr $dsp '*' 1024`
	sz=`stat -f %z $LOCAL/$item`
	text=`Tstr TxtCopyingItm $item`
	if [ "$1" = "*.avi" ]; then
	    idcam=`echo $item | cut -d '_' -f 1`
	    camdir=`psql -A -t -c "SELECT name FROM cameras WHERE id_cam=$idcam" $DB camtrace 2>/dev/null`
	    test "$camdir" || camdir="Camera$idcam"
	    test -d $EXPORT/$site/$camdir || mkdir -p $EXPORT/$site/$camdir
	    if [ -e $EXPORT/$site/$camdir/$item ]; then
		InfoBox TxtAlreadyCopied "$item"
		sleep $INFO_WAIT
		continue
	    elif [ "$dps" -a "$sz" -a "$dps" -lt "$sz" ]; then
		InfoBox TxtNoSpaceLeft
		sleep $INFO_WAIT
		continue
	    fi
	    pcp -b "XXX$NL`gettext TxtCopyingItm`${NL}XXX$NL" $LOCAL/$item $EXPORT/$site/$camdir 2>/dev/null | $DialogWait --gauge "\"$text\"" 7 70
	else
	    test -d $EXPORT/$site/archives || mkdir -p $EXPORT/$site/archives
	    if [ -e $EXPORT/$site/archives/$item ]; then
		InfoBox TxtAlreadyCopied "$item"
		sleep $INFO_WAIT
		continue
	    elif [ "$dps" -a "$sz" -a "$dps" -lt "$sz" ]; then
		InfoBox TxtNoSpaceLeft
		sleep $INFO_WAIT
		continue
	    fi
	    pcp -b "XXX$NL`gettext TxtCopyingItm`${NL}XXX$NL" $LOCAL/$item $EXPORT/$site/archives 2>/dev/null | $DialogWait --gauge "\"$text\"" 7 70
	fi
    done

    return 0
}

ExportFromDB()
{
    local file avi nbr id cam start stop site dir folder itm size left
    local beg end nbi max text items rows cols chars total

    nbr=`psql -A -t -c "SELECT COUNT(p_start) FROM p_records" $DB camtrace`
    if [ $nbr -eq 0 ]; then
	MsgBox MsgNoEltToExport
	return
    fi
    site=`psql -A -t -c "SELECT site_name FROM config" $DB camtrace | sed 's/[\\\/:*?"<>|]/_/g'`
    dir=`psql -A -t -c "SELECT space_path FROM config" $DB camtrace`
    test "$site" || site='CamTrace'
    test "$dir" || dir=/disk/images
    eval `psql -A -t -F' ' -c "SELECT p.id_cam,name,p_start,p_stop FROM p_records p,cameras c WHERE p.id_cam = c.id_cam ORDER BY p.id_cam,p_start" $DB camtrace | awk '{ print "id"NR"="$1" cam"NR"="$2" start"NR"="$3" stop"NR"="$4"\n"}'`
    text="`gettext TitChooseExport`"
    items=
    nbi=1
    total=
    while :
    do
	eval "id=\$id$nbi cam=\$cam$nbi start=\$start$nbi stop=\$stop$nbi"
	test -z "$start$stop" && break
	beg="`date -ur $start '+%Y%m%d-%H%M%S'`"
	end="`date -ur $stop  '+%Y%m%d-%H%M%S'`"
	items="$items $nbi '$cam: $beg -> $end' ''"
	total="`echo $total $nbi`"
	nbi=`expr $nbi + 1`
    done
    nbi=`expr $nbi - 1`
    if [ $nbi -eq 0 ]; then
	MsgBox MsgNoEltToExport
	return
    fi
    lines=`MsgLines "$text" 6`
    eval `GetScrSize 'row=%r'`
    max=`let $row - 1 - $lines`
    test $nbi -lt $max || nbi=$max
    lines=`let $lines + $nbi`
    chars=`MsgChars "$items" 5`
    eval $DIALOG --extra-button --extra-label \"`Tstr MsgExportAll`\" 2>$TMPFILE --checklist "\"$text\"" $lines $chars $nbi $items
    ret=$?
    if [ "$ret" = 3 ]; then
	echo "$total" >$TMPFILE
    elif [ "$ret" -eq 0 -a -s $TMPFILE ]; then
    else
	return
    fi
    for itm in `sed 's/"//g' $TMPFILE`
    do
	eval "id=\$id$itm cam=\$cam$itm start=\$start$itm stop=\$stop$itm"
	folder="$dir/`printf %06d $id`/sequs"
	folder="$folder/`date -ur $start '+%Y%m%d-%H%M%S'`"
	folder="${folder}_`date -ur $stop '+%Y%m%d-%H%M%S'`"
	if [ -d "$folder" ]; then
	    folder=`ls -l $folder | awk '{print $5}'`
	    size=0
	    for itm in $folder
	    do
		size=`expr $size + $itm`
	    done
	    folder=`df | grep " $EXPORT" | awk '{print $4}'`
	    folder=`expr $folder '*' 1024`
	else
	    folder=
	fi
	test -d $EXPORT/$site/$cam || mkdir -p $EXPORT/$site/$cam
	file="`date -r $start '+%Y%m%d-%H%M%S'`_`date -r $stop '+%Y%m%d-%H%M%S'`"
	avi=$EXPORT/$site/$cam/$id"_"$file".avi"
	if [ -e "$avi" ]; then
	    InfoBox TxtAlreadyGenerated "$file ($cam)"
	    sleep $INFO_WAIT
	    continue
	elif [ "$folder" -a "$size" -a "$folder" -lt "$size" ]; then
	    InfoBox TxtNoSpaceLeft
	    sleep $INFO_WAIT
	    continue
	fi
	nice -20 seqtoavi -c $id -b $start -e $stop -r $start -p $stop -n -o "$avi" 2>/dev/null | $DialogWait --gauge "`Tmsg TxtGenerating "$file ($cam)"`" 7 80
    done
}

ExportProt()
{
    local text items nbi lines chars choice choices rows

    test -d $EXPORT || MsgBox MsgCantFindExportSpace
    test -d $EXPORT || return
    text=`Tstr TitSelectWhatExport`
    items="1 \"`Tstr ItmExpArchives`\" '' 2 \"`Tstr ItmExpFiles`\" '' 3 \"`Tstr ItmExpProtected`\" ''"
    lines=`MsgLines "$text" 6`
    eval `GetScrSize 'rows=%r'`
    max=`let $rows - 1 - $lines`
    test 4 -lt $max && nbi=3 || nbi=$max
    lines=`let $lines + $nbi`
    chars=`MsgChars "$text" 6`
    eval $DIALOG 2>$TMPFILE --checklist "\"$text\"" $lines $chars $nbi "$items"
    choices=`sed 's/"//g' $TMPFILE` || return
    for choice in $choices
    do
	case "$choice" in
	    1)	SelectToExport "*.zip";;
	    2)	SelectToExport "*.avi";;
	    *)	ExportFromDB;;
	esac
    done
    return
}

AddNetSpace()
{
    local Title share srv i j p pid id spcs prev sid

    Title=`Tstr TitAddNetSpace`
    while :
    do
	$DIALOG 2>$TMPFILE --title " $Title " --max-input 50 --inputbox "\n `Tstr InpShareName`" 9 `Size AddNetSpace` "$share" || return 1
	share=`cat $TMPFILE`
	srv=`expr "$share" : '\([^:]*\):.*'`
	if [ -z "$srv" ]; then
	    MsgBox MsgInvalidShareName
	    continue
	elif grep "^$share	" /etc/fstab >/dev/null; then
	    MsgBox MsgShareAlreadyInUse
	    continue
	fi
	(
	    p=0
	    i=4
	    trap '' 14
	    while [ $i -gt 0 ]
	    do
		if ping -c 1 -t 1 $srv >/dev/null; then
		    mount_nfs $share /mnt 2>/dev/null &
		    pid=$!
		    j=5
		    while [ $j -gt 0 ]
		    do
			p=$(($p + 5))
			echo $p
			test -d /proc/$pid || break
			sleep 1
			j=$(($j - 1))
		    done
		    test $j -gt 0 && break || kill $pid
		fi
		i=$(($i - 1))
	    done
	    echo 100
	    sleep 1
	    trap 14
	) | $DIALOG --gauge "\n`Tmsg MsgTryingShareMount $share`" 8 70
	if df | grep ' /mnt$' >/dev/null; then
	    umount /mnt 2>/dev/null
	    break
	fi
	MsgBox MsgCannotMountShare
    done
    #echo -n :;read a
    id=1
    spcs=`psql -A -t -c "SELECT path FROM spaces WHERE id_spc > 0 ORDER BY id_spc" $DB camtrace | sed -n 's/^\/\(net[0-9]*\)\/images$/\1/p'`
    while :
    do
	echo "$spcs" | grep "net$id" >/dev/null || break
	id=`expr $id + 1`
    done
    grep "	/net$id	" /etc/fstab >/dev/null && echo -e "/\t\/net$id\t/d\nw" | ed - /etc/fstab
    if [ $id -gt 1 ]; then
	prev=`expr $id - 1`
	prev="/net$prev"
	grep "	$prev	" /etc/fstab >/dev/null || prev=	# Should not happen
    else
	prev=`awk '$2 ~ /\/disk[0-9][0-9]*/{mnt=$2}END{print mnt}' /etc/fstab`
	test "$prev" || prev="/proc"
    fi
    if [ "$prev" ]; then
	echo -e "/\t\\$prev\t/a\n$share\t/net$id\tnfs\trw\t\t2\t2\n.\nw" | ed - /etc/fstab
    else
	echo -e "$share\t/net$id\tnfs\trw\t\t2\t2" >>/etc/fstab
    fi
    test -d /net$id || mkdir /net$id
    mount /net$id 2>/dev/null
    test -d /net$id/images || mkdir /net$id/images
    chown camtrace:camtrace /net$id/images
    sid=`psql -A -t -c "SELECT id_spc FROM spaces WHERE id_spc > 0 ORDER BY id_spc" $DB camtrace | awk 'BEGIN{id=0}{if (id == 0 && $1 != NR)id=NR}END{if(id == 0)id=NR+1;print id}'`
    psql -c "INSERT INTO spaces VALUES($sid,'/net$id/images')" $DB camtrace >/dev/null # FIXME: in x.9.5+, replace $sid with next_id('id_spc','spaces')
    scamdctl reload
    #echo -n :;read a
}

MigrateRecs()
{
    MsgBox MsgFunctionNotAvailable
}

StorageSpaces()
{
    local StopDB State PORT MPORT ItemModem ItemLogin ExportMounted size pct

    if DBService halted; then
	StopDB=y
	DBService start || return
    fi
    Item1=1
    while :
    do
	mount | grep " $EXPORT " >/dev/null && ExportMounted=y || ExportMounted=
	State=`psql -A -t -c "SELECT COUNT(id_spc) FROM spaces WHERE id_spc > 0" $DB camtrace`
	State="`Tstr TxtDeclaredSpaces`$State"
	if [ -z "$ExportMounted" ]; then
	    $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
		--menu "`Tstr TitSpacesMenu`\n\n$State\n" 14 `Size SpacesMenu` 5 \
		1 "`Tstr ItmListDelSpaces`" \
		2 "`Tstr ItmAddDiskSpace`" \
		3 "`Tstr ItmAddNetSpace`" \
		4 "`Tstr ItmMigrateRecs`" \
		5 "`Tstr ItmAddExport`" || break
	    Item1=`cat $TMPFILE`
	    case "$Item1" in
		1)	ListDelSpaces	;;
		2)	AddDiskSpace	;;
		3)	AddNetSpace	;;
		4)	MigrateRecs	;;
		5)	AddExport	;;
	    esac
	else
	    eval `df | awk '$6 == "'$EXPORT'" {print "size="int($4/1024)" pct="$5}'`
	    State="$State\n`Tmsg TxtUsingSpace "$pct" "$size"`"
	    $DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
		--menu "`Tstr TitSpacesMenu`\n\n$State\n" 16 `Size SpacesMenu` 6 \
		1 "`Tstr ItmListDelSpaces`" \
		2 "`Tstr ItmAddDiskSpace`" \
		3 "`Tstr ItmAddNetSpace`" \
		4 "`Tstr ItmMigrateRecs`" \
		5 "`Tstr ItmExportProtected`" \
		6 "`Tstr ItmDelExport`" || break
	    Item1=`cat $TMPFILE`
	    case "$Item1" in
		1)	ListDelSpaces	;;
		2)	AddDiskSpace	;;
		3)	AddNetSpace	;;
		4)	MigrateRecs	;;
		5)	ExportProt	;;
		6)	DelExport	;;
	    esac
	fi
    done
    test "$StopDB" && DBService stop
    return 0
}

# =====	Maintenance ===================================================

ViewFiles()
{
    Item2=1
    while $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	--menu "`Tstr TitViewFiles`" 18 `Size ViewFiles` 11 \
	1 "httpd-access.log" \
	2 "httpd-error.log" \
	3 "pgsql.log" \
	4 "scamd.log" \
	5 "predir.log" \
	6 "player.log" \
	7 "dbpurge.log" \
	8 "trace.log" \
	9 "camctl.log" \
	a "messages" \
	b "rc.conf"
    do
	Item2=`cat $TMPFILE`
	case "$Item2" in
	    1)	Type=dsp; File=/var/log/httpd-access.log;;
	    2)	Type=dsp; File=/var/log/httpd-error.log	;;
	    3)	Type=dsp; File=/var/log/pgsql.log	;;
	    4)	Type=dsp; File=/var/log/scamd.log	;;
	    5)	Type=dsp; File=/var/log/predir.log	;;
	    6)	Type=dsp; File=/var/log/player.log	;;
	    7)	Type=dsp; File=/var/log/dbpurge.log	;;
	    8)	Type=chk; File=/var/log/trace.log	;;
	    9)	Type=chk; File=/var/log/camctl.log	;;
	    a)	Type=dsp; File=/var/log/messages	;;
	    b)	Type=edt; File=$RCCONF			;;
	esac
	Base=`basename $File`
	Len=`expr "$Base" : '.*'`
	if [ ! -f "$File" ]; then
	    if [ "$Type" = chk ]; then
		Siz=$(($Len + `Size AskForFileCreation`))
		$DIALOG --yesno "`Tmsg MsgAskForFileCreation "$Base"`" 7 $Siz || continue
		>$File
		chown camtrace:camtrace $File
		chmod 644 $File
	    else
		Siz=$(($Len + `Size FileDoesNotExist`))
		$DIALOG --msgbox "`Tmsg MsgFileDoesNotExist "$Base"`" 5 $Siz
		continue
	    fi
	fi
	eval `GetScrSize 'Rows=%r Cols=%c'`
	Rows=$(($Rows - 1))
	Cols=$(($Cols - 1))
	case "$Type" in
	    edt)
		$DIALOG --title " `Tmsg TitViewing "$File"` " --exit-label "`Tstr LblEditFile`" --tab-correct --textbox $File $Rows $Cols && ee $File
		;;
	    dsp|chk)
		while :
		do
		    $DIALOG --title " `Tmsg TitFollowing "$File"` " --exit-label "`Tstr LblViewFile`" --tab-correct --tailbox $File $Rows $Cols || break
		    $DIALOG --title " `Tmsg TitViewing "$File"` " --exit-label "`Tstr LblFollowFile`" --tab-correct --textbox $File $Rows $Cols || break
		done
		if [ "$Type" = chk ]; then
		    Siz=$(($Len + `Size AskForFileDeletion`))
		    $DIALOG --yesno "`Tmsg MsgAskForFileDeletion "$Base"`" 5 $Siz && rm -f $File
		fi
		;;
	esac
    done
}

# SelectPort title size var
SelectPort()
{
    local SIOS IOSIO NCOM COMItems s Com Itm Title TH

    if [ $OSRel -lt 5 ]; then
	SIOS=`dmesg | sed -n  's/^sio\([0-9]\): .*/\1/p' | sort -nu`
    else
	SIOS=`sysctl dev.sio 2>/dev/null | sed -n 's/.*\.sio\.\([0-9]\)\.%driver.*$/\1/p'`
    fi
    IOSIO=
    DBService active && IOSIO=`psql -A -t -c "SELECT io_tty FROM config" $DB camtrace | sed "s,/dev/$CUA,,"`
    NCOM=0
    COMItems=
    for s in $SIOS
    do
	if [ "$IOSIO" ]; then
	    test $s -eq $IOSIO && continue
	fi
	Com=$(($s + 1))
	Itm=`Tstr ItmCOM$Com`
	COMItems="$COMItems $Com \"$Itm\""
	NCOM=$(($NCOM + 1))
    done
    Title="$1"
    if [ "$IOSIO" ]; then
	Com=$(($IOSIO + 1))
	Title="$Title\n\n`Tmsg MsgContactPortIs $Com`"
    fi
    TH=`echo -e "$Title" | wc -l`
    eval $DIALOG 2>$TMPFILE --cancel-label "\"$BtnBack\"" --menu "\"$Title\"" $((6 + $TH + $NCOM)) $2 $NCOM "$COMItems" || return 1
    eval $3=`cat $TMPFILE`
    return 0
}

SetupModem()
{
    local PORT edCmd

    PORT=`sed -n "s/^$CUA\([0-3]\).*pppd.*/\1/p" /etc/ttys`
    if [ "$PORT" ]; then	# Active -> Inactive
	edCmd="/^$CUA[0-3].*pppd/s/^/#/\nw"
    else			# Inactive -> Active
	SelectPort "`Tstr TitModemSerialPort`" `Size ModemSerialPort` PORT || return 1
	PORT=$(($PORT - 1))
	edCmd="g/$CUA.*pppd/d\n1i\n.\n/^ttyd0/i\n$CUA$PORT\t\"/usr/sbin/pppd\"\t\tdialup\ton\n.\nw"
    fi
    echo -e "$edCmd" | ed - /etc/ttys
    kill -1 1
}

SetupLogin()
{
    local edCmd

    if [ "`pidof 'sshd$'`" ]; then
	NoYesBox MsgConfirmDisableLogin || return 1
	wkill 'sshd$'
	edCmd="/^sshd_enable/s/=.*/=\"NO\"/\nw"
    else
	$SSHD
	edCmd="/^sshd_enable/s/=.*/=\"YES\"/\nw"
    fi
    echo -e "$edCmd" | ed - $RCCONF
}

PurgeSpace()
{
    local items nm sz bn n max lines chars text i j ret

    if NoYesBox MsgConfirmPurgeDisks; then
	InfoBox MsgCheckingIfNeeded
	cleaner -c
	ret=$?
	if [ "$ret" = 1 ]; then
	    MsgBox MsgPurgeNotNeeded
	    return
	elif [ "$ret" = 2 ]; then
	    MsgBox MsgCronPerformingPurge
	    return
	fi

	InfoBox MsgPleaseWaitWhileCleaning
	echo -n '' >$TMPFILE
	cleaner -s -l $TMPFILE >/dev/null 2>&1 &
	while :
	do
	    if [ -z "`ps ax | grep '[/]sh.*cleaner'`" ]; then
		break
	    else
		sleep 1
	    fi
	done
	if [ "`wc -l $TMPFILE | awk '{print $1}'`" = 0 ]; then
	    MsgBox MsgPurgeNothingDone
	    return
	fi
	$DIALOG --textbox $TMPFILE 20 70
	if [ "`wc -l /tmp/todelete | awk '{print $1}'`" -gt 0 ]; then
	    items=
	    n=0
	    chars=30
	    for i in `cat /tmp/todelete | egrep -v "^($|[ 	]*#)"`
	    do
		sz=`echo $i | cut -d '|' -f 1`
		nm=`echo $i | cut -d '|' -f 2-99`
		bn=`basename $nm`
		[ -z "$sz" -o -z "$nm" -o -z "$bn" ] && continue
		items="$items$n \"$bn ${sz}b [$nm]\" \"\" "
		eval "itm$n=$nm"
		[ "`MsgChars "12345$nm$sz$bn" 6`" -gt "$chars" ] && chars=`MsgChars "12345$nm$sz$bn" 6`
		n=`expr $n + 1`
	    done
	    while :
	    do
		if [ "$items" ]; then
		    text="`Tstr MsgDeleteUselessFiles`"
		    lines=`MsgLines "$text" 6`
		    eval `GetScrSize 'max=%r'`
		    max=`let $max - 1 - $lines`
		    [ "$n" -lt $max ] || n=$max
		    [ "`MsgChars "$text" 6`" -gt "$chars" ] && chars=`MsgChars "$text" 6`
		    lines=`expr $lines + $n`
		    eval `GetScrSize 'max=%r'`
		    [ "$max" -lt "$lines" ] && lines=$max
		    eval `GetScrSize 'max=%c'`
		    [ "$max" -lt "$chars" ] && chars=$max
		    eval $DIALOG 2>$TMPFILE --checklist "\"$text\"" $lines $chars $n "$items" || return
		    nm=`sed 's/"//g' $TMPFILE`
		    sz=
		    bn=
		    j=0
		    ret=0
		    for i in $nm
		    do
			eval "itm=\$itm$i"
			sz="$sz $itm"
			[ "$bn" ] && bn="$bn\n$itm" || bn=$itm
			if [ "`MsgChars "$itm" 6`" -gt "$ret" ]; then
			    ret=`MsgChars "$itm" 6`
			fi
			j=`expr $j + 1`
		    done
		    j=`expr $j + 5`
		    [ "$ret" -gt "$max" ] && ret=$max
		    $DIALOG --yesno "`Tstr MsgConfirmDelete`\n$bn" $j $ret || continue
		    rm -rf $sz >/dev/null 2>&1
		    break
		else
		    break
		fi
	    done
	fi
    fi
}

EraseImages()
{
    local StopDB

    if NoYesBox MsgConfirmEraseImages; then
	SuspendServices C Rst || return 1
	StopDB=
	if DBService halted; then
	    StopDB=y
	    DBService start || return
	fi
	InfoBox MsgErasingTables
	echo "DELETE FROM r_records; DELETE FROM r_slices; DELETE FROM r_index; DELETE FROM a_records; DELETE FROM a_slices; DELETE FROM a_index; DELETE FROM p_records; DELETE FROM p_slices" | psql -q $DB camtrace
	sleep 1

	InfoBox MsgErasingImages
	for space in `echo "SELECT space_path FROM config; SELECT path FROM spaces WHERE id_spc > 0" | psql -A -t $DB camtrace`
	do
	    rm -rf $space/[0-9][0-9][0-9][0-9][0-9][0-9]	# IdFmt
	done
	sleep 1

	test "$StopDB" && DBService stop
	ResumeServices "$Rst"
    fi
}

PurgeLogs()
{
    local Rst Dir

    if NoYesBox MsgConfirmPurgeLogs; then
	SuspendServices "C D W" Rst || return 1

	Dir=/var/log
	for f in httpd-access httpd-error pgsql scamd predir player dbpurge discon alarms
	do
	    >$Dir/$f.log; rm -f $Dir/$f.log.*
	done

	rm -f /var/log/trace.log

	enter
	ResumeServices "$Rst"
    fi
}

PurgeAll()
{
    Item2=1
    while $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	--menu "`Tstr TitPurgeMenu`" 10 `Size PurgeMenu` 3 \
	1 "`Tstr ItmPurgeSpaces`" \
	2 "`Tstr ItmEraseImages`" \
	3 "`Tstr ItmPurgeLogs`"
    do
	Item2=`cat $TMPFILE`
	case "$Item2" in
	    1)	PurgeSpace	;;
	    2)	EraseImages	;;
	    3)	PurgeLogs	;;
	esac
    done
}

FollowCmd()
{
    local log cmd Rows Cols pid rpid StopDB Rst follow ret

    log=/var/log/$1.out
    cmd=$2
    shift 2
    eval `GetScrSize 'Rows=%r Cols=%c'`
    Rows=$(($Rows - 1))
    Cols=$(($Cols - 1))
    pid=`pidof "$cmd"`
    if [ "$pid" ]; then
	YesNoBox MsgKillingSpurious || return
	kill $pid || kill -9 $pid
    fi
    StopDB=
    if [ -f $log ]; then
	if YesNoBox MsgViewPreviousLog; then
	    $DIALOG --title " `Tmsg TitViewing "$log"` " --tab-correct --textbox $log $Rows $Cols
	    return 0
	elif [ $? -gt 1 ]; then
	    return 1
	fi
    fi
    if [ $cmd = pgfsck ]; then
	SuspendServices "C D W" Rst || return 1
	nohup $cmd "$@" >$log 2>&1 &
	pid=$!
	follow=y
    elif [ $cmd = dbcheck ]; then
	SuspendServices C Rst || return 1
	if DBService halted; then
	    StopDB=y
	    DBService start || return 1
	fi
	rm -rf /tmp/dbcheck-gauge #safe
	mkfifo /tmp/dbcheck-gauge
	trap '' 13
	$cmd "$@" >/tmp/dbcheck-gauge 2>$log &
	pid=$!
    fi
    while :
    do
	if [ "$pid" -a "$cmd" = pgfsck ]; then
	    if [ "$follow" ]; then
		$DialogWait --title " `Tmsg TitFollowing "$log"` " --exit-label "`Tstr LblViewFile`" --tab-correct --tailbox $log $Rows $Cols
		ret=$?
	    else
		$DialogWait --title " `Tmsg TitViewing "$log"` " --exit-label "`Tstr LblFollowFile`" --tab-correct --textbox $log $Rows $Cols
		ret=$?
	    fi
	elif [ "$pid" -a "$cmd" = dbcheck ]; then
	    ret=0
	    </tmp/dbcheck-gauge $DialogWait --gauge "`Tstr MsgFollowDBCheck`" 6 60 || ret=1
	    test -z "`pidof "$cmd"`" && ret=0
	elif [ -z "$pid" ]; then
	    $DIALOG --title " `Tmsg TitViewing "$log"` " --tab-correct --textbox $log $Rows $Cols
	    ret=1
	fi
	pid=`pidof "$cmd"`
	if [ "$ret" -ne 0 ]; then
	    test "$pid" || break
	    if NoYesBox MsgAbortProg; then
		kill $pid || kill -9 $pid
		break
	    fi
	else
	    test "$follow" && follow= || follow=y
	fi
    done

    test -f /tmp/dbcheck-gauge && rm -f /tmp/dbcheck-gauge
    ResumeServices "$Rst"
    test "$StopDB" && DBService stop
}

RepairDB()
{
    local cmd log

    if ! which -s pgfsck; then
	FollowCmd "dbcheck-s" dbcheck -s -r
	return $?
    fi
    Item2=1
    while $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	--menu "`Tstr TitDBRepairMenu`" 9 `Size DBRepairMenu` 2 \
	1 "`Tstr ItmCompleteRepair`" \
	2 "`Tstr ItmLowLevelCheck`"
    do
	Item2=`cat $TMPFILE`
	case "$Item2" in
	    1)	cmd="dbcheck -s -r";	log="dbcheck-s"	;;
	    2)	cmd="pgfsck camtrace";	log="pgfsck"	;;
	esac
	FollowCmd $log $cmd
    done
}

SetLicenseKey()
{
    local Title SNO TYP USR POC SYS VER CLM CAM CLI SCR EXT KEY SNO_ TYP_ USR_ POC_ VER_ CLM_ CAM_ CLI_ SCR_ EXT_ KEY_ Mod DefItem2

    if [ -z "`cut -d '|' -f 12 $KEYFILE`" ]; then
	IFS='|' read SNO TYP USR POC SYS VER CLI CAM KEY <$KEYFILE
	CLM=
	SCR=2	# Demo values
	EXT=1
    else
	IFS='|' read SNO TYP USR POC SYS VER CLM CAM CLI SCR EXT KEY <$KEYFILE
    fi
    Title=" `Tstr TitSetLicenseKey` "

    DefItem2="`Tstr InpSerialNumber`"
    while :
    do
	$DIALOG --ok-label "$BtnApply" --cancel-label "$BtnBack" 		\
		--title "$Title" --form "" 17 70 11				\
		"`Tstr InpSerialNumber`"	 1   2 "$SNO"   1  38	10  9	\
		"`Tstr InpSoftwareType`"	 2   2 "$TYP"   2  38	 2  1	\
		"`Tstr InpLicensee`"	   	 3   2 "$USR"   3  38	17 40	\
		"`Tstr InpPostalCode`"	 	 4   2 "$POC"   4  38	 9  8	\
		"`Tstr InpVersion`"	    	 5   2 "$VER"   5  38	12 11	\
		"`Tstr InpClusterMode`"		 6   2 "$CLM"   6  38	 2  1	\
		"`Tstr InpMaxCameras`"	 	 7   2 "$CAM"   7  38	 7  6	\
		"`Tstr InpMaxClients`"	 	 8   2 "$CLI"   8  38	 7  6	\
		"`Tstr InpMaxPassiveScreens`"	 9   2 "$SCR"   9  38	 7  6	\
		"`Tstr InpMaxOverlaySources`"	10   2 "$EXT"  10  38	 7  6	\
		"`Tstr InpKey`"			11   2 "$KEY"  11  38	17 16	\
		2>$TMPFILE || break

	exec		  3<$TMPFILE
	read SNO_	<&3
	read TYP_	<&3
	read USR_	<&3
	read POC_	<&3
	read VER_	<&3
	read CLM_	<&3
	read CAM_	<&3
	read CLI_	<&3
	read SCR_	<&3
	read EXT_	<&3
	read KEY_	<&3
	exec		  3<&-

	if [ "$SNO" = "$SNO_" -a "$TYP" = "$TYP_" -a "$USR" = "$USR_" -a "$POC" = "$POC_" -a "$VER" = "$VER_" -a "$CLM" = "$CLM_" -a "$CAM" = "$CAM_" -a "$CLI" = "$CLI_" -a "$SCR" = "$SCR_" -a "$EXT" = "$EXT_" -a "$KEY" = "$KEY_" -a -z "$Mod" ]; then
	    MsgBox MsgLicenseNotModified
	    break
	fi
	Mod=y
	SNO="$SNO_"
	TYP="$TYP_"
	USR="$USR_"
	POC="$POC_"
	VER="$VER_"
	CLM="$CLM_"
	CAM="$CAM_"
	CLI="$CLI_"
	SCR="$SCR_"
	EXT="$EXT_"
	KEY="$KEY_"

	if [ "$CLM" = 'x' -o "$CMS" = 'X' -o "$CLM" = 'c' -o "$CLM" = 'C' ]; then
	    CLM=C
	    CLM_=`Tstr BtnYes`	# ReUse CLM_ for presentation
	else
	    CLM=
	    CLM_=`Tstr BtnNo`
	fi

	if $DIALOG --title "$Title" --yesno "\n`Tmsg MsgLicenseKey "$SNO" "$USR" "$POC" "$VER" "$CLM_" "$CAM" "$CLI" "$SCR" "$EXT" "$KEY"`" 20 `Size LicenseKey`; then
	    InfoBox MsgCheckingLicense
	    KEY_="$SNO|$TYP|$USR|$POC|$SYS|$VER|$CLM|$CAM|$CLI|$SCR|$EXT|$KEY"
	    if scamd -k "$KEY_"; then
		InfoBox MsgSavingLicense
		echo -e "$KEY_\c" >$KEYFILE
		sleep 1
		CamService active && CamService restart
		return 0
	    fi
	    MsgBox MsgInvalidLicense || break
	fi
    done
    return 1
}

DoInstall()
{
    local Prg

    test -x $1 || return 1
    clear
    Prg=`basename $0`
    cp -fp /usr/local/bin/$Prg /usr/tmp
    $1
    cmp /usr/tmp/$Prg /usr/local/bin/$Prg >/dev/null || MsgBox MsgRestartMenucam
    rm -f /usr/tmp/$Prg
}

UpdateCDROM()
{
    local Date

    while :
    do
	umount /cdrom 2>/dev/null
	MsgBox MsgInsertCamTraceCD || return 1
	mount /cdrom 2>/dev/null || continue
	test -f /cdrom/Version.txt || continue
	read Name w2 CVers w4 SType SVers rest </cdrom/Version.txt
	test "$Name" = CamTrace || continue
	Date=`LANG=$LANG ls -lT /cdrom/Version.txt | awk '{print $6,$7,$9}'`
	NoYesBox MsgCamTraceCDVersion "$CVers" "$Date" "$SType" "$SVers" && break
	umount /cdrom 2>/dev/null
	return 1
    done
    DoInstall /cdrom/install
    enter
    umount /cdrom 2>/dev/null
    return 0
}

CheckUpdateFile()
{
    eval $2=
    test -s "$1" || return 1
    if isohdr -A "$1" 2>/dev/null | grep "^CamTrace " >/dev/null; then
	eval $2="iso"
	return 0
    fi
    if tar tzf "$1" 2>/dev/null | awk '/^www\/help\/doc-.._..\.pdf/{n++} END{exit((n > 0 && n == NR) ? 0 : 1)}'; then
	eval $2="doc"
	return 0
    fi
    if tar xzf "$1" camtrace/Version.txt 2>/dev/null; then
	read Name rest <camtrace/Version.txt
	if [ "$Name" = "CamTrace" ]; then
	    eval $2="tgz"
	    return 0
	fi
    fi
    return 1
}

InstallUpdate()	# file type msgtag
{
    local Date dev

    case "$2" in
	tgz)
	    read Name w2 CVers w4 SType SVers rest <camtrace/Version.txt
	    Date=`LANG=$LANG ls -lT camtrace/Version.txt | awk '{print $6,$7,$9}'`
	    if NoYesBox "$3" "$CVers" "$Date" "$SType" "$SVers"; then
		if tar xzf "$1"; then
		    DoInstall camtrace/install
		fi
		enter
	    fi
	    ;;
	iso)
	    umount /mnt 2>/dev/null
	    if [ $OSRel -lt 5 ]; then
		vnconfig -u /dev/vn0c 2>/dev/null
		vnconfig /dev/vn0c "$1"
		mount -r -t cd9660 /dev/vn0c /mnt
	    else
		dev=`mdconfig -a -t vnode -f "$1" >/dev/null 2>&1`
		test -c /dev/$dev && mount -r -t cd9660 /dev/$dev /mnt
	    fi
	    read Name w2 CVers w4 SType SVers rest </mnt/Version.txt
	    Date=`LANG=$LANG ls -lT /mnt/Version.txt | awk '{print $6,$7,$9}'`
	    if NoYesBox "$3" "$CVers" "$Date" "$SType" "$SVers"; then
		DoInstall /mnt/install
		enter
	    fi
	    umount /mnt
	    if [ $OSRel -lt 5 ]; then
		vnconfig -u /dev/vn0c
	    elif [ -c "$dev" ]; then
		mdconfig -d -u $dev 2>/dev/null
	    fi
	    ;;
	doc)
	    if NoYesBox "$3"; then
		if tar xzf "$1"; then
		    mv www/help/doc-*.pdf ~camtrace/www/help
		    chown camtrace:camtrace ~camtrace/www/help/doc-*.pdf
		    chmod 644 ~camtrace/www/help/doc-*.pdf
		    rmdir www/help www
		fi
		enter
	    fi
	    ;;
    esac
}

UpdateUSB()
{
    local disk disks fstype dev mnt
    local Name w2 CVers w4 SType SVers rest Date

    mnt=/mnt
    while :
    do
	disks=`sysctl -n kern.disks`
	for disk in $disks
	do
	    expr $disk : 'ad' >/dev/null && continue
	    test -e "/dev/${disk}s2a" || continue
	    eval `fstype ${disk}s2a 'fstype=%t' 2>/dev/null`
	    test "$fstype" = 'ufs' || continue
	    mount "/dev/${disk}s2a" $mnt 2>/dev/null || continue
	    if [ -s $mnt/Version.txt ]; then
		read Name w2 CVers w4 SType SVers rest <$mnt/Version.txt
		Date=`LANG=$LANG ls -lT $mnt/Version.txt | awk '{print $6,$7,$9}'`
	    fi
	    umount $mnt 2>/dev/null || umount -f $mnt 2>/dev/null
	    if [ "$Name" = 'CamTrace' ]; then
		test "$dev" && dev='*' || dev="/dev/${disk}s2a"
	    fi
	done

	if [ ! "$dev" ]; then
	    MsgBox MsgInsertCamTraceUSB || return
	    continue
	elif [ "$dev" = '*' ]; then
	    MsgBox MsgMoreThanOneCTKey || return
	    continue
	fi
	NoYesBox MsgCamTraceUSBVersion "$CVers" "$Date" "$SType" "$SVers" && break || return
    done
    mount $dev $mnt 2>/dev/null
    DoInstall $mnt/install
    enter
    umount $mnt 2>/dev/null
    return 0
}

UpdateNet()
{
    local URL tgz ret file UPDURL tag i ip lan

    i=1
    while :
    do
	eval "lan=\$ITF$i ip=\$IPADR$i"
	test -z "$lan" && break
	test "$ip" && break
	i=`expr $i + 1`
    done
    if [ -z "$ip" -a "$IPADR0" ]; then
	ip=$IPADR0
    fi
    if [ -z "$ip" -a -z "$ISP" ]; then
	MsgBox MsgMustConfigureNetwork
	return 1
    fi
    test -d /usr/tmp || mkdir /usr/tmp
    chmod 777 /usr/tmp
    cd /usr/tmp
    URL=$UPDURL
    while :
    do
	tgz=
	$DIALOG 2>$TMPFILE --title " `Tstr TitUpdateNet` " --inputbox "\n`Tstr TxtUpdateNet`\n\n" 15 `Size UpdateNet` "$URL" || break
	URL=`cat $TMPFILE`
	case "$URL" in
	    http://*|ftp://*)
		trap : 2 3
		fetch "$URL"
		ret=$?
		trap '' 2 3
		test "$ret" -eq 0 || continue
		file=`expr "$URL" : '[a-z]*://\(.*\)'`
		;;
	    scp://*)
		file=`expr "$URL" : 'scp://\(.*\)'`
		trap : 2 3
		scp "$file" .
		ret=$?
		trap '' 2 3
		test "$ret" -eq 0 || continue
		;;
	    *)	MsgBox MsgInvalidURL
		continue
		;;
	esac
	tgz=`basename $file`
	UPDURL="$URL"
	CheckUpdateFile "$tgz" type && break
	MsgBox MsgNotCamTraceNet
    done
    case "$type" in
	doc)	tag=MsgCamTraceNetDoc;;
	*)	tag=MsgCamTraceNetVersion;;
    esac
    if [ "$tgz" ]; then
	InstallUpdate "$tgz" "$type" "$tag"
	UpdateRC UPDURL "$UPDURL"
    fi
    rm -rf camtrace "$tgz"
}

UpdateFile()
{
    local tgz UPDDIR tag

    while :
    do
	tgz=
	GetFile "`Tstr MsgChooseUpdateFile`" "$UPDDIR" ~camtrace/updates tgz || break
	UPDDIR=`dirname $tgz`
	CheckUpdateFile "$tgz" type && break
	MsgBox MsgNotCamTraceFile
    done
    case "$type" in
	doc)	tag=MsgCamTraceFileDoc;;
	*)	tag=MsgCamTraceFileVersion;;
    esac
    if [ "$tgz" ]; then
	InstallUpdate "$tgz" "$type" "$tag"
	UpdateRC UPDDIR "$UPDDIR"
    fi
    rm -rf camtrace
}

UpdateCamTrace()
{
    Item2=1
    while $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	--menu "`Tstr TitUpdateMenu`" 11 `Size UpdateMenu` 4 \
	1 "`Tstr ItmUpdateCDROM`" \
	2 "`Tstr ItmUpdateUSB`" \
	3 "`Tstr ItmUpdateNet`" \
	4 "`Tstr ItmUpdateFile`"
    do
	Item1=`cat $TMPFILE`
	case "$Item1" in
	    1)	UpdateCDROM	;;
	    2)	UpdateUSB	;;
	    3)	UpdateNet	;;
	    4)	UpdateFile	;;
	esac
    done
}

SelectSource()	# Format_of_output_to_$TMPFILE
{
    local n f items title lines rows max nbi choice mnt dev ver
    local w1 w2 w4 SType SVers rest

    n=0
    cd $USBGEN
    for f in [Cc]am[Tt]race-*.iso
    do
	test -f $f || break
	items="$items $n $f"
	eval "itm$n=$f"
	n=`expr $n + 1`
    done
    if [ "$n" -eq 0 ]; then
	MsgBox MsgNoISOFiles $USBGEN
	return 1
    fi
    title=`Tstr TitSelectISOSource`
    lines=`MsgLines "$title" 6`
    eval `GetScrSize 'rows=%r'`
    max=`let $rows - 1 - $lines`
    test $n -lt $max && nbi=$n || nbi=$max
    lines=`let $lines + $nbi`
    n=`expr $n - 1`
    while $DIALOG 2>$TMPFILE --default-item $n --menu "$title" $lines 50 $nbi $items
    do
	eval "choice=\$itm`sed 's/"//g' $TMPFILE`"
	mnt="/tmp/$choice"
	test -e $mnt && rm -rf $mnt
	mkdir -p $mnt
	dev=`mdconfig -a -f $USBGEN/$choice 2>/dev/null`
	if mount -r -t cd9660 /dev/$dev $mnt 2>/dev/null; then
	    read w1 w2 ver w4 SType SVers rest <$mnt/Version.txt
	    Date=`LANG=$LANG ls -lT $mnt/Version.txt | awk '{print $6,$7,$9}'`
	    echo "$1" | sed -e "s|%m|$mnt|g" -e "s|%d|$dev|g" -e "s|%v|$ver|g" >$TMPFILE
	    NoYesBox MsgCamTraceCDVersion "$ver" "$Date" "$SType" "$SVers" && return 0
	    umount $mnt 2>/dev/null
	else
	    MsgBox MsgUnableToMount $choice
	fi
	mdconfig -d -u $dev 2>/dev/null
    done
    return 1
}

SelectDest()	# previously_selected_dev
{
    local dev sz nms nb items itext title lines chars rows max nbi

    while :
    do
	nb=0
	items=
	itext=
	for dev in `sysctl -n kern.disks`
	do
	    expr $dev : 'md' >/dev/null && continue
	    expr $dev : 'ad' >/dev/null && continue
	    eval `dsk $dev 'sz=%t\nms=%m\n' 2>/dev/null || echo 'sz= ms='`
	    test -z "$sz" && continue #en deux fois, sinon test échoue (et on passe pas dans continue)
	    test $sz -gt $MinSz && continue
	    nb=`let $nb + 1`
	    eval "`DiskState $dev $sz 'type=%t desc="%D"' 2>/dev/null`"
	    items="$items $nb \"$desc\""
	    itext="$itext\n    ( ) $nb $desc    "
	    eval "dev$nb=$dev sz$nb=$sz"
	done
	if [ "$nb" -eq 0 ]; then
	    MsgBox MsgNoStickYet && continue || return
	fi
	title=`Tstr TitSelectStick`
	lines=`MsgLines "$title" 6`
	eval `GetScrSize 'rows=%r'`
	max=`let $rows - 1 - $lines`
	test $nb -lt $max && nbi=$nb || nbi=$max
	lines=`let $lines + $nbi`
	chars=`MsgChars "$title$itext" 4`
	dev=
	eval $DIALOG 2>$TMPFILE --menu "\"$title\"" $lines $chars $nbi "$items"
	case $? in
	    0)			;;
	    3)	continue	;;
	    *)	return 1	;;
	esac
	max=`sed 's/"//g' $TMPFILE`
	test "$max" || continue
	eval "dev=\$dev$max sz=\$sz$max"
	if [ $sz -lt $MedSz ]; then
	    MsgBox MsgDiskTooSmall
	    continue
	fi
	if [ "$dev" ]; then
	    echo $dev >$TMPFILE
	    break
	fi
    done
}

ErrBox()
{
    local Msg Lines Chars pid ret

    Msg="`Tmsg "$@"`\n`Tstr MsgDiscardStick`"
    Lines=`echo -e "$Msg" | wc -l`
    Lines=$(($Lines + 4))
    Chars=`echo -e "$Msg" | sed 's/\\Z[0-7n]//g' | awk '{l=length();if(l>n){n=l}}END{print n}'`
    Chars=$(($Chars + 4))
    beeper -t -r 0 2 18 &
    pid=$!
    $DialogWait --msgbox "$Msg" $Lines $Chars
    ret=$?
    kill $pid
    wait 2>/dev/null
    return $ret
}

CreateStick()	# device mountdir CT_Version
{
    local dev tree vers cyl hpc sec sig spc mod s1off s1len s2typ s2off s2len inf
    local lost use msz slc sz version msz

    dev=$1
    tree=$2
    vers=$3
    #	Make sure /mnt is not mounted on
    df | grep ' /mnt$' >/dev/null && umount /mnt 2>/dev/null
    if df | grep ' /mnt$' >/dev/null; then
	MsgBox MsgMountPointBusy
	return 1
    fi

    #	Partition device
    InfoBox MsgPartitioning
    rm -rf /mnt/* >/dev/null 2>&1
    version=`expr "$vers" : '\([0-9]*\)'`
    eval `dsk $dev 'cyl=%c hpc=%h sec=%s sig=%m sz=%t'`
    spc=`expr $hpc '*' $sec`
    mod=`expr $MedSz % $spc`
    s2len=$MedSz
    test $mod -gt 0 && s2len=`expr $s2len + $spc - $mod`
    lost=`expr $sz % $spc`
    use=`expr $sz - $lost`
    s2off=`expr $use - $s2len`
    s1off=$sec
    s1len=`expr $s2off - $s1off`
    WipeTrack0 $dev y
    inf=/tmp/fdisk-$dev.in
    echo "g c$cyl h$hpc s$sec"     >$inf
    echo "p 1 0x0b $s1off $s1len" >>$inf
    echo "p 2 0xa5 $s2off $s2len" >>$inf
    echo "a 2"                    >>$inf
    fdisk -if $inf $dev >/dev/null 2>&1
    mbrsig $dev >/dev/null
    if [ ! -e "/dev/${dev}s2" ]; then
	ErrBox MsgFdiskFailure
	return 1
    fi
    sleep 1

    #	Make Win filesystem
    newfs_msdos -L "CamTrace$version" -p /dev/${dev}s1 2>&1 >/dev/null | $DialogWait --gauge "`Tstr MsgMakingWinFS`" 6 70
    mbrsig ${dev}s1 >/dev/null

    #	Subpartition and make Sys filesystem
    bsdlabel -w -B ${dev}s2
    slc=/dev/${dev}s2a
    ssz=`bsdlabel ${dev}s2 2>/dev/null | awk '/^  a:/{print $2}'`
    (
	newfs -L "CamTrace$version" -O1 -n $slc 2>/dev/null | tr -u ',' '\n' | \
	    awk "/^ [0-9]*\$/{print int(100*\$0/$ssz);fflush()}"
	echo 100
	sleep 1
    ) | $DialogWait --gauge "`Tstr MsgMakingSysFS`" 6 70

    #	Copy system files
    if ! mount $slc /mnt 2>/dev/null; then
	ErrBox MsgErrorMountingSys $slc
	return 1
    fi
    cd $tree
    find . -type f | sed 's/^..//' | xargs stat -f '%z %N' >$TMPFILE
    ssz=`du -s | sed 's/	.*$//'`
    (
	tar -cf - . | p100 $ssz | tar xfC - /mnt
	echo 100
    ) 2>&1 | $DialogWait --gauge "`Tstr MsgCopyingSystem`" 6 70
    cd /
    umount /mnt 2>/dev/null

    #	Check system files
    if ! mount $slc /mnt 2>/dev/null; then
	ErrBox MsgErrorMountingSys $slc
	return 1
    fi
    Done=0
    cd $tree
    while read size name
    do
	echo 'XXX'
	Tmsg MsgCheckingSystem $name
	echo 'XXX'
	expr '(' '(' $Done + 512 ')' '*' 100 ')' / '(' $ssz '*' 1024 ')'
	if ! cmp $name /mnt/$name >/dev/null 2>&1; then
	    >$TMPFILE.
	    break
	fi
	Done=`expr $Done + $size`
    done <$TMPFILE | $DialogWait --gauge "" 8 70
    cd /
    umount /mnt 2>/dev/null
    if [ -f $TMPFILE. ]; then
	rm -f $TMPFILE.
	ErrBox MsgErrorCopyingSys
	return 1
    fi

    #	Copy tools, docs and demo
    if ! mount_msdosfs /dev/${dev}s1 /mnt >/dev/null 2>&1; then
	ErrBox MsgErrorMountingWin
	return 1
    fi
    mkdir /mnt/Tools
    cd $tree/wintools
    files="*.msi *.exe *.txt"
    pcp -b "`gettext MsgCopyingTools`" $files /mnt/Tools | $DialogWait --gauge "" 8 70

    if [ -d "$USBGEN/docs" ]; then
	mkdir /mnt/Docs
	cd $USBGEN/docs
	ssz=`du -s $USBGEN/docs | sed 's/	.*//'`
	(
	    tar -cf - . | p100 $ssz | tar xfC - /mnt/Docs
	    echo 100
	) 2>&1 | $DialogWait --gauge "`Tstr MsgCopyingDocs`" 6 70
    fi
    if [ -d "$USBGEN/demo" ]; then
	mkdir /mnt/Demo
	cd $USBGEN/demo
	ssz=`du -s $USBGEN/demo | sed 's/	.*//'`
	(
	    tar -cf - . | p100 $ssz | tar xfC - /mnt/Demo
	    echo 100
	) 2>&1 | $DialogWait --gauge "`Tstr MsgCopyingDemo`" 6 70
    fi

    #	Copy update files and Version.txt
    files=
    test -f $tree/update/camtrace-*-min.tgz && files="update/camtrace-*-min.tgz "
    files="${files}update/camtrace-*-upd.tgz Version.txt"
    cd $tree
    pcp -b "`gettext MsgCopyingUpdate`" $files /mnt | $DialogWait --gauge "" 8 70
    cd /
    umount /mnt 2>/dev/null

    #	Check docs and demo
    if ! mount_msdosfs /dev/${dev}s1 /mnt >/dev/null 2>&1; then
	ErrBox MsgErrorMountingWin
	return 1
    fi
    InfoBox MsgCheckingTools
    cd $tree/wintools
    find . -type f | sort >$TMPFILE
    cd /mnt/Tools
    find . -type f | sort | cmp $TMPFILE - >/dev/null || {
	ErrBox MsgErrorCopyingTools
	cd /
	return 1
    }
    if [ -d "$USBGEN/docs" ]; then
	InfoBox MsgCheckingDocs
	cd $USBGEN/docs
	find . -type f | sort >$TMPFILE
	cd /mnt/Docs
	find . -type f | sort | cmp $TMPFILE - >/dev/null || {
	    ErrBox MsgErrorCopyingDocs
	    cd /
	    return 1
	}
    fi
    if [ -d "$USBGEN/demo" ]; then
	InfoBox MsgCheckingDemo
	cd $USBGEN/demo
	find . -type f | sort >$TMPFILE
	cd /mnt/Demo
	find . -type f | sort | cmp $TMPFILE - >/dev/null || {
	    ErrBox MsgErrorCopyingDemo
	    cd /
	    return 1
	}
    fi
    Done=0
    cd $tree
    ssz=`du $files | awk '{ s += $1}END{print s}'`
    for name in $files
    do
	echo 'XXX'
	Tmsg MsgCheckingUpdate $name
	echo 'XXX'
	expr '(' '(' $Done + 512 ')' '*' 100 ')' / '(' $ssz '*' 1024 ')'
	if ! cmp $name /mnt/`basename $name` >/dev/null 2>&1; then
	    >$TMPFILE.
	    break
	fi
	size=`stat -f '%z' $name`
	Done=`expr $Done + $size`
    done <$TMPFILE | $DialogWait --gauge "" 8 70
    cd /
    umount /mnt 2>/dev/null

    if [ -f $TMPFILE. ]; then
	rm -f $TMPFILE.
	ErrBox MsgErrorCopyingUpdate
	return 1
    fi
    return 0
}

MakeStick()
{
    local tree mdev dev beg end len min sec dur pid

    test -d "$USBGEN" || return
    SelectSource 'tree=%m mdev=%d vers=%v' || return
    eval "`cat $TMPFILE`"

    conscontrol mute on >/dev/null
    dev=
    while :
    do
	SelectDest $dev || break
	dev=`cat $TMPFILE`
	beg=`date '+%s'`
	CreateStick $dev $tree $vers || break
	end=`date '+%s'`
	len=`expr $end - $beg`
	min=`expr $len / 60`
	sec=`expr $len % 60`
	dur="$sec `Tstr TxtSeconds`"
	test $min -gt 0 && dur="$min `Tstr TxtMinutes` $dur"
	desc=`camcontrol devlist | sed -n "/($dev/s/^<\([^>]*\)>.*/\1/p"`
	test -f $USBGEN/log && date "+%Y-%m-%d%t%H:%M:%S%t$vers%t${len}s%t$desc" >>$USBGEN/log
	beeper -t -r 0 20 &
	pid=$!
	DIALOG="$DialogWait"
	end=
	NoYesBox MsgDoItAgain $vers "$dur" "$desc" || end=y
	DIALOG="$DialogTime"
	kill $pid 2>/dev/null
	wait 2>/dev/null
	test "$end" && break
    done
    conscontrol mute off >/dev/null
    umount $tree 2>/dev/null
    rmdir $tree
    mdconfig -d -u $mdev 2>/dev/null
}

ChangePasswords()
{
    local Title User Pass StopDB

    Item2=1
    while $DIALOG 2>$TMPFILE --default-item $Item2 --cancel-label "$BtnBack" \
	--menu "`Tstr TitChangePasswords`" 10 `Size ChangePasswords` 3 \
	1 "`Tstr ItmChangeRootPassword`" \
	2 "`Tstr ItmChangeCamTracePassword`" \
	3 "`Tstr ItmChangeUserPassword`"
    do
	Item2=`cat $TMPFILE`
	case "$Item2" in
	    1)  Title=`Tstr TitChangeSysPassword`
		User=root
		;;
	    2)  Title=`Tstr TitChangeSysPassword`
		User=camtrace
		;;
	    3)  Title=`Tstr TitChangeUserPassword`
		if DBService halted; then
		    StopDB=y
		    DBService start || return
		fi
		if eval $DIALOG 2>$TMPFILE --title "\" $Title \"" --cancel-label "\"$BtnBack\"" \
		--menu "\"\\\n`Tstr TxtChooseUser`\\\n\"" 16 `Size ChooseUser` 8 \
		"`psql -A -t -c 'SELECT name FROM users ORDER BY name' $DB camtrace | awk '{printf("\\"%s\\" \\"\\" ",$0)}'`"; then
		    User=`cat $TMPFILE`
		else
		    continue
		fi
		;;
	esac

	while :
	do
	    $DIALOG 2>$TMPFILE --title " $Title (1) " --max-input 32 --inputbox "\n `Tmsg InpPassword1 $User`" 9 `Size InputPassword` || continue 2
	    Pass=`cat $TMPFILE`

	    $DIALOG 2>$TMPFILE --title " $Title (2) " --max-input 32 --inputbox "\n `Tmsg InpPassword2 $User`" 9 `Size InputPassword` || continue 2
	    test "$Pass" = "`cat $TMPFILE`" && break
	    MsgBox MsgPasswordsDontMatch
	done
	case "$Item2" in
	    1|2)    echo "$Pass" | pw usermod -n $User -h 0
		    test "$User" = root && MsgBox MsgWarnRootPassword
		    ;;
	    3)	    psql -c "UPDATE users SET pass = '`echo -n $Pass | md5`' WHERE name = '$User'" $DB camtrace >/dev/null
		    test "$StopDB" && DBService stop
		    ;;
	esac
    done
}

TermEmul()
{
    local tcp com rate PORT S SPEED StartRad

    SelectPort "`Tstr TitSelectSerialPort`" `Size SelectSerialPort` PORT || return 1
    $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" \
	--menu "`Tstr TitSelectPortSpeed`" 16 `Size SelectPortSpeed` 9 \
	1 "115200 bps" \
	2 "57600 bps" \
	3 "38400 bps" \
	4 "19200 bps" \
	5 "9600 bps" \
	6 "4800 bps" \
	7 "2400 bps" \
	8 "1200 bps" \
	9 "300 bps" \
	|| return 1
    S=`cat $TMPFILE`
    case "$S" in
	1) SPEED=115200	;;
	2) SPEED=57600	;;
	3) SPEED=38400	;;
	4) SPEED=19200	;;
	5) SPEED=9600	;;
	6) SPEED=4800	;;
	7) SPEED=2400	;;
	8) SPEED=1200	;;
	9) SPEED=300	;;
    esac
    MsgBox MsgPressCtrlOtoExit || return 1
    eval "`sed -n '/^archttp32_flags=/s/.*="\\\\"\\([0-9]*\\) \\([0-9]*\\) \\([0-9]*\\)\\\\""$/tcp=\\1 com=\\2 rate=\\3/p' $RCCONF`"
    if [ "$com" -a "$com" = $PORT -a "`pidof "$ARCD"`" ]; then
	InfoBox InfStoppingRad
	$ARCRC stop >/dev/null 2>&1; sleep 1
	StartRad=y
    fi
    clear
    com $PORT $SPEED x
    if [ "$StartRad" ]; then
	InfoBox InfRestartingRad
	$ARCRC start >/dev/null 2>&1; sleep 1
    fi
}

Maintenance()
{
    local State PORT MPORT ItemModem ItemLogin shm

    Item1=1
    while :
    do
	State=`idhost`
	test -z "$State" && State="`Tstr TxtUnknown`"
	State="`Tstr TxtHardwareSig`$State"
	State="$State\n`Tstr TxtVersion``scamd -v 2>/dev/null | sed -n '/^CamTrace/s/^.*version \([^)]*)\).*/\1/p'`"
	scamd -v 2>/dev/null | grep '^CamTrace.*DEMO$' >/dev/null && State="$State \\Z1DEMO\\Zn"
	State="$State\n`Tstr TxtModem`"
	PORT=`sed -n "s/^$CUA\([0-3]\).*pppd.*/\1/p" /etc/ttys`
	shmm=`sysctl -n kern.ipc.shmmax`
	shmm="`expr $shmm / \`expr 1024 '*' 1024\``Mb"
	if [ "$PORT" ]; then
	    MPORT=$(($PORT + 1))
	    State="$State`Tmsg TxtOnCOM "$MPORT"`"
	    ItemModem=`Tstr ItmDisableModem`
	else
	    State="$State`Tstr TxtDisabled`"
	    ItemModem=`Tstr ItmEnableModem`
	fi
	State="$State\n`Tstr TxtLogin`"
	if [ "`pidof 'sshd$'`" ]; then
	    State="$State`Tstr TxtEnabled`"
	    ItemLogin=`Tstr ItmDisableLogin`
	else
	    State="$State`Tstr TxtDisabled`"
	    ItemLogin=`Tstr ItmEnableLogin`
	fi
	State="$State\n`Tstr TxtSHMAmount`$shmm"
	$DIALOG 2>$TMPFILE --default-item $Item1 --cancel-label "$BtnBack" \
	    --menu "`Tstr TitMaintenanceMenu`\n\n$State\n" 24 `Size MaintenanceMenu` 11 \
	    1 "`Tstr ItmViewFiles`" \
	    2 "$ItemModem" \
	    3 "$ItemLogin" \
	    4 "`Tstr ItmPurgeAll`" \
	    5 "`Tstr ItmRepairDB`" \
	    6 "`Tstr ItmSetLicenseKey`" \
	    7 "`Tstr ItmUpdateCamTrace`" \
	    8 "`Tstr ItmMakeStick`" \
	    9 "`Tstr ItmChangePasswords`" \
	    A "`Tstr ItmSHMConfig`" \
	    B "`Tstr ItmTermEmul`" || break
	Item1=`cat $TMPFILE`
	case "$Item1" in
	    1)	ViewFiles	;;
	    2)	SetupModem	;;
	    3)	SetupLogin	;;
	    4)	PurgeAll	;;
	    5)	RepairDB	;;
	    6)	SetLicenseKey	;;
	    7)	UpdateCamTrace	;;
	    8)	MakeStick	;;
	    9)	ChangePasswords	;;
	    A)	SHMConfig	;;
	    B)  TermEmul	;;
	esac
    done
}

# ===== Wizard =======================================================

Wizard()
{
    local ret step prev ntp_time cams StopDB

    prev=0
    step=1
    while :
    do
	case "$step" in
	    1)	MsgBox MsgSetupWelcome
		ret=$?
		;;

	    2)	WizardBox "1/7" MsgSetupLang
		ret=$?
		if [ "$ret" = 3 ]; then
		    ret=0
		    SetupLang
		    test "$?" = 0 || ret=42
		elif [ "$ret" = 1 ]; then
		    ret=250
		else
		    ret=255
		fi
		;;

	    3)	WizardBox "2/7" MsgSetupKeyboard
		ret=$?
		if [ "$ret" = 3 ]; then
		    ret=0
		    SetupKeyboard
		    test "$?" = 0 || ret=43
		elif [ "$ret" = 1 ]; then
		    ret=250
		else
		    ret=255
		fi
		;;

	    4)	WizardBox "3/7" MsgSetupTZdata
		ret=$?
		if [ "$ret" = 3 ]; then
		    ret=0
		    SetupTimeZone
		    test "$?" = 0 || ret=44
		elif [ "$ret" = 1 ]; then
		    ret=250
		else
		    ret=255
		fi
		;;

	    5)	WizardBox "4/7" MsgSetupNetworkITF
		ret=$?
		if [ "$ret" = 3 ]; then
		    ret=0
		    IPConfig
		    test "$?" = 0 || ret=45
		elif [ "$ret" = 1 ]; then
		    ret=250
		else
		    ret=255
		fi
		;;

	    6)	WizardBox "5/7" MsgSetupHostNameGate
		ret=$?
		if [ "$ret" = 3 ]; then
		    ret=0
		    HostNameGate
		    test "$?" = 0 || ret=46
		elif [ "$ret" = 1 ]; then
		    ret=250
		else
		    ret=255
		fi
		;;

	    7)	WizardBox "6a/7" MsgSetupNetworkTime
		ret=$?
		if [ "$ret" = 3 ]; then
		    SetTimeServer
		    ret=$?
		    if [ "$ret" = 0 ]; then
			ret=0
			SetupTimeSync
			test "$?" = 0 || ret=49
		    elif [ "$ret" ]; then
			ret=48
		    fi
		elif [ "$ret" = 1 ]; then
		    while :
		    do
			WizardBox "6b/7" MsgSetupTimeManually
			ret=$?
			if [ "$ret" = 3 ]; then
			    ret=0
			    SetTimeManually
			    test "$?" = 0 || ret=47
			    test "$ret" = 47 && continue
			elif [ "$ret" = 1 ]; then
			    ret=250
			else
			    ret=59
			fi
			break
		    done
		else
		    ret=255
		fi
		;;


	    8)	WizardBox "7/7" MsgSetupCameras
		ret=$?
		if [ "$ret" = 3 ]; then
		    ret=0
		    AddCameras
		    test "$?" = 0 || ret=50
		elif [ "$ret" = 1 ]; then
		    ret=250
		else
		    ret=255
		fi
		;;

	    *)	MsgBox MsgConfigDone
		StopDB=
		test "`pidof postgres`" || cams=n
		if [ -z "`ipcalc -a "%a"`" ]; then
		    MsgBox MsgMissingIP
		    cams=
		elif [ "$cams" ]; then
		    if which -s pgfsck; then
			cams=`pgfsck -dh $DB cameras | egrep -v "(Lost[0-9]*|Wrong number of |^$)" | wc -l`
			# le wrong number pour FreeBSD 7.2, pgfsck ayant quelques ratés...
			test "$cams" -gt 6 || cams=
		    else
			if DBService halted; then
			    DBService start && StopDB=y
			fi
			cams=`psql -A -t -c "SELECT COUNT(id_cam) FROM cameras" $DB camtrace`
			test "$cams" -a "$cams" -gt 0 || cams=
			test "$StopDB" && DBService stop
		    fi
		elif [ -z "$cams" ]; then
		    if DBService halted; then
			DBService start && StopDB=y
		    fi
		    cams=`psql -A -t -c "SELECT * FROM cameras" $DB camtrace | grep -v "Lost[0-9]*"`
		    test "$StopDB" && DBService stop
		fi
		if [ "$cams" ]; then
		    if CamService halted; then
			CamService start
		    fi
		    if DBService halted; then
			DBService start
		    fi
		    if WebService halted; then
			WebService start
		    fi
		elif [ "`ipcalc -a "%a"`" ]; then
		    MsgBox MsgMissingCameras
		fi
		break
		;;
	esac

	if [ "$ret" = 0 -o "$ret" = 250 ]; then
	    prev=$step
	    step=`expr $step + 1`
	elif [ "$ret" -gt 41 -a "$ret" -lt 60 ]; then	# code "d'erreur"
	    continue	# différents, à voir si on veut afficher une info
	elif [ "$step" -gt 1 ]; then	# pour certains d'entre-eux
	    prev=$step
	    step=`expr $step - 1`
	else
	    break
	fi
    done
}

# =====	SysShutdown ===================================================

SysShutdown()
{
    local stop

    if $DIALOG 2>$TMPFILE --cancel-label "$BtnBack" \
	--menu "`Tstr TitHaltMenu`" 9 `Size HaltMenu` 2 \
	1 "`Tstr ItmHaltSystem`" \
	2 "`Tstr ItmRebootSystem`"
    then
	case "`cat $TMPFILE`" in
	    1)
		CamService active && CamService stop
		DBService active || DBService start
		ctbackup >/dev/null 2>&1
		DBService stop
		rm -f /var/run/vncwrapper
		/sbin/shutdown -p now
		exit 0
		;;
	    2)
		CamService active && CamService stop
		DBService active || DBService start
		ctbackup >/dev/null 2>&1
		DBService stop
		rm -f /var/run/vncwrapper
		/sbin/shutdown -r now
		exit 0
		;;
	esac
    fi
}

# ===== Main ==========================================================

inX11()
{
    local tty term

    test $OSRel -lt 6 && term='xterm' || term='mrxvt'
    if [ "$OSRel" -lt 8 ]; then
	tty=`tty | sed 's/tty/pty/'`
	test -c $tty || return 1
	fstat $tty | grep $term >/dev/null
    else
	tty=`tty | sed 's|/dev/||'`
	fstat | grep "$term.*$tty " >/dev/null
    fi
    return $?
}

CenteredName()
{
    local str len wid pad

    str="`hostname -s`"
    len=`expr "$str" : '.*'`
    wid=`Size MainMenu`
    pad=$((\( $wid - \( $len + 4 \) \) / 2))
    while [ $pad -gt 0 ]
    do
	echo -e " \c"
	pad=$(($pad - 1))
    done
    echo -e "$str\c"
}

# Main starts here

test -f $RCFILE && . $RCFILE

parpid=$PPID
parcmd=`ps -p $parpid | awk 'NR > 1 {print $5}'`
if [ $parcmd != lockf ]; then
    base=`basename $0 .sh`
    TEXTDOMAIN=$base
    if [ "$LC_ALL" ]; then
	LANG=$LC_ALL
	unset LC_ALL
    elif [ -z "$LANG" ]; then
	LANG="en_US.ISO8859-1"
    fi
    export TEXTDOMAIN LANG
    Tmsg ErrNotMenucamSh "$base" >&2
    exit 1
fi

conscontrol mute on >/dev/null
trap cleanup 0 1 15
trap '' 2 3

# Globals
NL='
'
INX11=
ISP=
eval `ipcalc -a "ITF%i=%n IPADR%i='%a' MASK%i='%m'\n"`
HOSTNAM=

if inX11; then
    INX11='y'
    export TERM=xterm-color
fi

if [ ! -s $RCCONF ]; then
    if [ -f $RCCONF.save ]; then
	cp -p $RCCONF.save $RCCONF
	sync
	Tstr MsgConfRestored
    else
	Tstr MsgConfMissing
    fi
fi
if grep '^ppp_enable="[Yy][Ee][Ss]"' $RCCONF >/dev/null; then
    ISP=`sed -n '/^ppp_profile=/s/.*="\([^"]*\).*$/\1/p' $RCCONF`
fi
HOSTNAM=`sed -n '/^hostname=/s/.*="\([^"]*\).*$/\1/p' $RCCONF`
test "$HOSTNAM" || HOSTNAM=`hostname`

BtnBack=`Tstr BtnBack`
BtnApply=`Tstr BtnApply`
Active=`Tstr TxtActive`
ActiveBad=`Tstr TxtActiveBad`
Inactive=`Tstr TxtInactive`
Item0=1

if scamd -v 2>/dev/null | grep '^CamTrace.*DEMO$' >/dev/null; then
    MsgBox InfDemoMode || exit 0
fi

while :
do
    State="`Tstr TxtWebService`"
    WebService active && State="$State$Active" || State="$State$Inactive"

    State="$State\n`Tstr TxtDBService`"
    DBService active && State="$State$Active" || State="$State$Inactive"

    State="$State\n`Tstr TxtCamService`"
    if CamService active; then
	CamService allactive && State="$State$Active" || State="$State$ActiveBad"
    else
	State="$State$Inactive"
    fi

    if $DIALOG 2>$TMPFILE --default-item $Item0 --no-cancel \
	--menu "`Tstr TitMainMenu`\n`CenteredName`\n\n$State" 22 `Size MainMenu` 10 \
	 1 "`Tstr ItmCTServices`" \
	 2 "`Tstr ItmGraphicsMode`" \
	 3 "`Tstr ItmSysConfig`" \
	 4 "`Tstr ItmNetConfig`" \
	 5 "`Tstr ItmCamConfig`" \
	 6 "`Tstr ItmStorageSpaces`" \
	 7 "`Tstr ItmMaintenance`" \
	 8 "`Tstr ItmWizard`" \
	 9 "`Tstr ItmSysShutdown`" \
	 0 "`Tstr ItmExitMenucam`"
    then
	Item0=`cat $TMPFILE`
	case "$Item0" in
	    1)	CTServices	;;
	    2)	GraphicsMode	;;
	    3)	SysConfig	;;
	    4)	NetConfig	;;
	    5)	CamConfig	;;
	    6)  StorageSpaces	;;
	    7)	Maintenance	;;
	    8)  Wizard		;;
	    9)	SysShutdown	;;
	    0)	break	;;
	esac
    elif [ -s $TMPFILE ]; then
	break
    else
	Item0=0
    fi
    sync
done

exit 0
