class squid::debian {
    if ($lsbdistcodename == "stretch" or $lsbdistcodename == "ascii" or $lsbdistcodename == "buster" or $lsbdistcodename == "beowulf") {
	common::define::package {
	    "squid":
	}

	Package["squid"]
	    -> File["Prepare Squid for further configuration"]
    } else {
	common::define::package {
	    "squid3":
	}

	Package["squid3"]
	    -> File["Prepare Squid for further configuration"]
    }

    if ($squid::vars::apt_cacher != false) {
	include jesred
    }
}
