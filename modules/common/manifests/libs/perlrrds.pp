class common::libs::perlrrds {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "librrds-perl"
	}
	"CentOS", "RedHat": {
	    $what = "rrdtool-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
