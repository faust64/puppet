class common::libs::perlconfigjson {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
