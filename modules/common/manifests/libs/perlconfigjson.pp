class common::libs::perlconfigjson {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libconfig-json-perl"
	}
	"CentOS", "RedHat": {
	    $what = "perl-Config-JSON"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
