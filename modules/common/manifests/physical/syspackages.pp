class common::physical::syspackages {
    common::define::package {
	"smartmontools":
    }

    if (lookup("no_linprocfs") == false) {
	common::define::package {
	    [ "htop", "lsof" ]:
	}
    }

    if ($kernel == "Linux") {
	common::define::package {
	    [ "iotop", "pv", "screen", "tmux" ]:
	}
    } elsif ($operatingsystem == "OpenBSD" and versioncmp($kernelversion, '5.7') <= 0) {
	common::define::package {
	    [ "screen", "tmux" ]:
	}
    } elsif ($operatingsystem == "OpenBSD") {
	common::define::package {
	    "screen":
	}
    }

    if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan") {
	common::define::package {
	    "locales-all":
	}
    }
    if (lookup("has_serial_io")) {
	common::define::package {
	    "minicom":
	}
    }
    if (lookup("has_lm_sensors")) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan" or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"lm-sensors":
	    }

	    if (lookup("with_nagios") == true) {
		Package["lm-sensors"]
		    -> Nagios::Define::Probe["sensors"]
	    }
	}
	elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"lm_sensors":
	    }

	    if (lookup("with_nagios") == true) {
		Package["lm_sensors"]
		    -> Nagios::Define::Probe["sensors"]
	    }
	}
    }
}
