class common::libs::perljson {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libjson-perl"
	}
	"CentOS", "RedHat": {
	    $what = "perl-JSON"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
