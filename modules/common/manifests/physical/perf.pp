class common::physical::perf {
    if ($operatingsystem == "Ubuntu") {
	common::define::package {
	    [
		"linux-tools-common",
		"linux-tools-generic",
		"linux-tools-$kernelrelease"
	    ]:
	}
    } elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan") {
	if ($lsbdistcodename == "buster") {
	    common::define::package {
		[ "linux-perf-4.19" ]:
	    }
	} else {
	    common::define::package {
		[ "linux-tools" ]:
	    }
	}
    }
}
