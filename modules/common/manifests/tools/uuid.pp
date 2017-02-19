class common::tools::uuid {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $what = "uuid"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
