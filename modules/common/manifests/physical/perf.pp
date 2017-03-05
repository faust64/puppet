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
	common::define::package {
	    [ "linux-tools" ]:
	}
    }
}
