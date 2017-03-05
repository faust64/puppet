class common::physical::syspackages {
    common::define::package {
	"smartmontools":
    }

    if (hiera("no_linprocfs") == false) {
	common::define::package {
	    [ "htop", "lsof" ]:
	}
    }

    if ($kernel == "Linux") {
	common::define::package {
	    [ "iotop", "pv", "screen" ]:
	}
    } elsif ($operatingsystem == "OpenBSD" and versioncmp($kernelversion, '5.7') <= 0) {
	common::define::package {
	    "tmux":
	}
    }

    if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan") {
	common::define::package {
	    "locales-all":
	}
    }
    if (hiera("has_serial_io")) {
	common::define::package {
	    "minicom":
	}
    }
    if (hiera("has_lm_sensors")) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan" or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"lm-sensors":
	    }

	    if (hiera("with_nagios") == true) {
		Package["lm-sensors"]
		    -> Nagios::Define::Probe["sensors"]
	    }
	}
	elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"lm_sensors":
	    }

	    Package["lm_sensors"]
		-> Nagios::Define::Probe["sensors"]
	}
    }
}
