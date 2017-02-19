class common::physical::triggerhappy {
    if ($operatingsystem == "Debian") {
	common::define::package {
	    "triggerhappy":
		ensure => purged;
	}
    }
}
