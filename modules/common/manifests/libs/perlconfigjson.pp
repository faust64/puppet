class common::libs::perlconfigjson {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libconfig-json-perl"
	}
	"CentOS", "RedHat": {
	    if ($os['release']['major'] == "7") {
		$what = "perl-Config-Any"
	    } else {
		$what = "perl-Config-JSON"
	    }
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
