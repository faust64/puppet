class nagios::debian {
    common::define::package {
	"nagios-nrpe-server":
    }

    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "buster") {
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

    if ($lsbdistcodename == "buster") {
	common::define::lined {
	    "Nagios should not use dedicated temporary directory":
		line    => "PrivateTmp=false",
		match   => "^PrivateTmp",
		notify  => Exec["Load nagios systemd configuration"],
		path    => "/etc/systemd/system/multi-user.target.wants/nagios-nrpe-server.service",
		require => Package["nagios-nrpe-server"];
	}

	exec {
	    "Load nagios systemd configuration":
		command     => "systemctl daemon-reload",
		cwd         => "/",
		notify      => Service[$nagios::vars::nrpe_service_name],
		path        => "/usr/local/bin:/usr/bin:/bin",
		refreshonly => true;
	}
    }

    if ($nagios::vars::watch_hpraid) {
	apt::define::aptkey {
	    "Hewlett-Packard":
#		url => "http://downloads.linux.hpe.com/SDR/repo/mcp/GPG-KEY-mcp";
#		url => "http://downloads.linux.hpe.com/SDR/hpPublicKey1024.pub";
#		url => "http://downloads.linux.hpe.com/SDR/hpPublicKey2048.pub";
#		url => "http://downloads.linux.hpe.com/SDR/hpPublicKey2048_key1.pub";
		url => "http://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub";

	}

	if ($lsbdistcodename == "buster" or $lsbdistcodename == "stretch") {
	    $fetch = "jessie"
	} else { $fetch = $lsbdistcodename }
	apt::define::repo {
	    "hp":
		baseurl  => "http://downloads.linux.hpe.com/SDR/repo/mcp/",
		branches => "non-free",
		codename => "$fetch/current",
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
	    "armv6l", "armv7l", "armv8l": {
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

    Common::Define::Package["nagios-nrpe-server"]
	-> File["Install Nagios custom plugins"]
	-> File["Prepare nagios nrpe for further configuration"]
	-> Common::Define::Service[$nagios::vars::nrpe_service_name]
}
