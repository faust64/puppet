class nagios::debian {
    common::define::package {
	"nagios-nrpe-server":
    }

    if ($lsbdistcodename == "jessie") {
	common::define::package {
	    "monitoring-plugins-standard":
		options => [ "--no-install-recommends" ];
	}

	Package["monitoring-plugins-standard"]
	    -> Package["nagios-nrpe-server"]
    } else {
	common::define::package {
	    "nagios-plugins":
		options => [ "--no-install-recommends" ];
	}

	Package["nagios-plugins"]
	    -> Package["nagios-nrpe-server"]
    }

    if ($nagios::vars::watch_hpraid) {
	apt::define::aptkey {
	    "Hewlett-Packard":
		url => "http://downloads.linux.hpe.com/SDR/repo/mcp/GPG-KEY-mcp";
	}

	apt::define::repo {
	    "hp":
		baseurl  => "http://downloads.linux.hpe.com/SDR/repo/mcp/",
		branches => "non-free",
		codename => "$lsbdistcodename/current",
		require  => Apt::Define::Aptkey["Hewlett-Packard"];
	}

	common::define::package {
	    "hpacucli":
		require =>
		    [
			Apt::Define::Repo["hp"],
			Exec["Update APT local cache"]
		    ];
	}
    }

    if ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn") {
	case $architecture {
	    "amd64", "i386", "x86_64": {
		common::define::package {
		    [ "dmidecode", "ipmitool" ]:
		}
	    }
	    "armv6l": {
		file {
		    "Install minimalistic sysinfo script":
			group   => lookup("gid_zero"),
			mode    => "0755",
			owner   => root,
			path    => "/usr/local/bin/sysinfo",
			require => Package["bc"],
			source  => "puppet:///modules/nagios/sysinfo";
		}
	    }
	    default: {
		common::define::patchneeded { "nagios-deb-$architecture": }
	    }
	}
    }

    if ($nagios::vars::watch_hpraid) {
	common::define::package {
	    "cciss-vol-status":
	}
    }

    Package["nagios-nrpe-server"]
	-> File["Install Nagios custom plugins"]
	-> File["Prepare nagios nrpe for further configuration"]
	-> Service[$nagios::vars::nrpe_service_name]
}
