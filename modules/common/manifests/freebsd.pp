class common::freebsd {
    $ports     = lookup("deported_ports")
    $download  = lookup("download_cmd")
    $with_dbus = lookup("freebsd_with_dbus")

    case $kernelversion {
	/9\.[1-9]/, /[1-9][0-9]\./: {
	    include pkgng

	    $forceports = false
	    $portsource = "http://ftp.freebsd.org/pub/FreeBSD/releases/$hardwaremodel/$operatingsystemrelease/ports.txz"
	}
	/8\.4/: {
	    $forceports = true
	    $portsource = "http://ftp.freebsd.org/pub/FreeBSD/releases/$hardwaremodel/$operatingsystemrelease/ports/ports.tgz"
	}
	default: {
	    $forceports = true
	    $portsource = "http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/old-releases/$hardwaremodel/$operatingsystemrelease/ports/ports.tgz"
	}
    }

    common::define::package {
	[ "expect", "pwgen" ]:
    }

    file {
	"Prepare FreeBSD services configuration directory":
	    ensure => directory,
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/etc/rc.conf.d";
	"Install FreeBSD free command":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/free",
	    source  => "puppet:///modules/common/fbsd/free";
	"Ensure /boot/loader.conf exists":
	    content => "",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/boot/loader.conf",
	    replace => no;
    }

    if ($forceports) {
# having the ports tree installed is *mandatory*
# puppet package type may invoke /usr/local/sbin/portversion, which requires
# to run both make fetch index and make index from
# /usr/ports/port-mgmt/portupgrade
# having no ports tree, package calls may result in "!  error - port broken"
# error messages. depending on ressources relationships, could prevent some
# part of your catalog from being processed.
	exec {
	    "Download FreeBSD ports tree":
		command     => "$download $portsource",
		cwd         => "/tmp",
		notify      => Exec["Extract FreeBSD ports tree"],
		path        => "/usr/bin:/bin",
		unless      => "test -d /usr/ports/net";
	    "Extract FreeBSD ports tree":
		command     => "if test -s /tmp/ports.tgz; then tar -xzf /tmp/ports.tgz; elif test -s /tmp/ports.txz; then tar -xJf /tmp/ports.txz; else exit 42; fi",
		cwd         => "/usr",
		path        => "/usr/bin:/bin",
		refreshonly => true;
	    "Install FreeBSD ports directory index":
		command     => "find . -d 2 -type d >DIRS",
		cwd         => "/usr/ports",
		onlyif      => "test -d net",
		path        => "/usr/bin:/bin",
		unless      => "test -s DIRS";
	}
    }

    if ($with_dbus) {
	common::define::package {
	    "dbus":
	}

	common::define::lined {
	    "Enable dbus service":
		line   => 'dbus_enable="YES"',
		match  => '^dbus_enable=',
		notify => Service["dbus"],
		path   => "/etc/rc.conf";
	}

	common::define::service {
	    "dbus":
	}

	Package["dbus"]
	    -> Common::Define::Lined["Enable dbus service"]
	    -> Service["dbus"]
    }
}
