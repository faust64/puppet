class common::debian {
    include apt
    include mysysctl

    $iface = hiera("ifplugd_iface")

    common::define::package {
	[ "bc", "bsd-mailx", "coreutils", "dnsutils", "expect", "less",
	  "libpam-cracklib", "logtail", "lsb-release", "pwgen", "sysstat",
	  "tcpd", "unattended-upgrades", "util-linux", "whois" ]:
    }

    file {
	"Setup rcS configuration":
	    content => template("common/rcS.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/default/rcS";
	"Set default ifplugd configuration - even if packages absent":
	    content => template("common/ifplugd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/default/ifplugd";
    }

    common::define::package {
	[ "avahi-daemon", "inetutils-inetd", "nis", "prelink", "rsh-client", "rsh-redone-client", "talk" ]:
	    ensure => absent;
    }

    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "xenial") {
	include common::systemd
    }
    if ($operatingsystem == "Debian") {
	common::define::package {
	    "debian-keyring":
	}
    } elsif ($operatingsystem == "Ubuntu") {
	common::define::package {
	    [ "apport", "biosdevname", "whoopsie" ]:
		ensure => absent;
	}

	file {
	    "Install CIS Ubuntu modprobe configuration":
		group  => hiera("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/etc/modprobe.d/CIS.conf",
		source => "puppet:///modules/common/modprobe-ubuntu-CIS.conf";
	}
    }

    Package["libpam-cracklib"]
	-> File["Install common-password configuration"]
}
