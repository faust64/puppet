class nagios::rhel {
    common::define::package {
	[ "nrpe", "nagios-common" ]:
    }

    if ($os['release']['major'] == "7") {
	common::define::package {
	    [
		"nagios-plugins-disk", "nagios-plugins-load",
		"nagios-plugins-procs", "nagios-plugins-swap",
		"nagios-plugins-users"
	    ]:
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
		common::define::patchneeded { "nagios-archi-rhel": }
	    }
	}
    }

    Package["nrpe"]
	-> File["Install Nagios custom plugins"]
	-> File["Prepare nagios nrpe for further configuration"]
	-> Service[$nagios::vars::nrpe_service_name]
}
