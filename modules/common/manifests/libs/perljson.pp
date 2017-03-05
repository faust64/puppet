class common::libs::perljson {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
