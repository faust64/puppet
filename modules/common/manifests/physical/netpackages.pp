class common::physical::netpackages {
    include common::tools::tcpdump

    if ($kernel == "OpenBSD") {
	if ($kernelversion != "5.8" and $kernelversion != "6.6") {
	    common::define::package {
		[ "pftop", "pfstat", "arping" ]:
	    }
	} else {
# fontconfig, freetype.24.0 & pthreads-stubs.2.0 somehow unavailable (5.8)
# fontconfig (6.6)
# gd2 missing its dependencies, pfstat missing gd2
	    common::define::package {
		[ "pftop", "arping" ]:
	    }
	}
    } elsif ($kernel == "Linux") {
	inclue common::tools::netstat

	common::define::package {
	    [ "ethtool", "iftop" ]:
	}

	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan" or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"arping":
	    }
	}
    }
}
