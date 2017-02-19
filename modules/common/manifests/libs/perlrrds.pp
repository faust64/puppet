class common::libs::perlrrds {
    case $operatingsystem {
	"Debian", "Ubuntu": {
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
