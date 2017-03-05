class common::physical::triggerhappy {
    if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan") {
	common::define::package {
	    "triggerhappy":
		ensure => purged;
	}
    }
}
