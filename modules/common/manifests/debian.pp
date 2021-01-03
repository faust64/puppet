class common::debian {
    include apt
    include mysysctl

    $iface = lookup("ifplugd_iface")

    common::define::package {
	[ "avahi-daemon", "inetutils-inetd", "nis", "prelink", "rsh-client", "rsh-redone-client", "talk" ]:
	    ensure => absent;
	[ "locales", "locales-all" ]:
	    notify => Exec["Refresh Locales"];
	[ "bc", "bsd-mailx", "coreutils", "dnsutils", "expect", "file", "less",
	  "libpam-cracklib", "logtail", "lsb-release", "pwgen", "sysstat",
	  "tcpd", "unattended-upgrades", "util-linux", "whois" ]:
    }

# are these still relevant on Stretch? ifplugd & initscripts not installed
    file {
	"Setup rcS configuration":
	    content => template("common/rcS.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/default/rcS";
	"Set default ifplugd configuration - even if packages absent":
	    content => template("common/ifplugd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/default/ifplugd";
    }

    exec {
	"Refresh Locales":
	    command     => "locale-gen",
	    cwd         => "/",
	    path        => "/sbin:/bin:/usr/sbin:/usr/bin",
	    refreshonly => true;
    }

    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "xenial") {
	include common::systemd
    }
    if ($operatingsystem == "Debian") {
	common::define::package {
	    "debian-keyring":
	}
    } elsif ($myoperatingsystem == "Devuan") {
	common::define::package {
	    "devuan-keyring":
	}
    } elsif ($operatingsystem == "Ubuntu") {
	common::define::package {
	    [ "apport", "biosdevname", "whoopsie" ]:
		ensure => absent;
	}

	file {
	    "Install CIS Ubuntu modprobe configuration":
		group  => lookup("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/etc/modprobe.d/CIS.conf",
		source => "puppet:///modules/common/modprobe-ubuntu-CIS.conf";
	}
    }

    Package["libpam-cracklib"]
	-> File["Install common-password configuration"]
}
