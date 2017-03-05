class common::libs::perllwpua {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
