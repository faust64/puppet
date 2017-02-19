class common::libs::perllwpua {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "liblwp-useragent-determined-perl"
	}
	"CentOS", "RedHat": {
	    $what = "perl-LWP-UserAgent-Determined"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
