define common::define::package($ensure   = "present",
			       $options  = false,
			       $provider = false,
			       $source   = false,
			       $uselocal = true) {
    if ($source) {
	$the_source = $source
    } elsif ($operatingsystem == "OpenBSD") {
	if ($architecture != "") {
	    $myarch = $architecture
	} elsif ($isa != "") {
	    $myarch = $architecture
	} else {
	    $myarch = "amd64"
	}
	if ($uselocal) {
	    $the_source = "http://repository.$domain/openbsd/$kernelversion/packages/$myarch/"
	} else {
	    $the_source = "http://ftp.nluug.nl/pub/OpenBSD/$kernelversion/packages/$myarch/"
	}
    } elsif ($operatingsystem == "FreeBSD" and $kernelversion =~ /[678]\./) {
	if ($uselocal) {
	    $the_source = "http://repository.$domain/freebsd/releases/$hardwaremodel/$operatingsystemrelease/packages/Latest/$name.tbz"
	} else {
	    $the_source = "http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/old-releases/$hardwaremodel/$operatingsystemrelease/packages/Latest/$name.tbz"
	}
    } elsif ($operatingsystem == "FreeBSD") {
	if ($uselocal) {
	    $the_source = "http://repository.$domain/freebsd/releases/$hardwaremodel/$operatingsystemrelease/packages/Latest/$name.txz"
	} else {
	    case $hardwaremodel {
		"amd64": { $hw = "x86:64" }
		"i386":  { $hw = "x86:32" }
		default: {
		    notify{ "unsupported architecture": }
		    $hw = false
		}
	    }
	    if ($hw) {
		$the_source = "http://pkg.freebsd.org/freebsd:$operatingsystemmajrelease:$hw/latest/Latest/$name.txz"
	    }
	}
    } else {
	$the_source = false
    }

    if ($provider and ! defined(Package[$name])) {
	if ($the_source) {
	    if ($options) {
		package {
		    $name:
			ensure          => $ensure,
			install_options => $options,
			provider        => $provider,
			source          => $the_source;
		}
	    } else {
		package {
		    $name:
			ensure          => $ensure,
			provider        => $provider,
			source          => $the_source;
		}
	    }
	} elsif ($options) {
	    package {
		$name:
		    ensure          => $ensure,
		    install_options => $options,
		    provider        => $provider;
	    }
	} else {
	    package {
		$name:
		    ensure          => $ensure,
		    provider        => $provider;
	    }
	}
    } elsif (! defined(Package[$name])) {
	if ($the_source) {
	    if ($options) {
		package {
		    $name:
			ensure          => $ensure,
			install_options => $options,
			source          => $the_source;
		}
	    } else {
		package {
		    $name:
			ensure          => $ensure,
			source          => $the_source;
		}
	    }
	} elsif ($options and $ensure != "absent") {
	    package {
		$name:
		    ensure          => $ensure,
		    install_options => $options;
	    }
	} else {
	    package {
		$name:
		    ensure          => $ensure;
	    }
	}
    }

    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu") {
	if ($name != "apt-cacher-ng") {
	    File["Install APT main configuration"]
		-> Package[$name]
	}
    }
}
