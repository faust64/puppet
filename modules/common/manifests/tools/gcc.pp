class common::tools::gcc {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $what = "gcc"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
