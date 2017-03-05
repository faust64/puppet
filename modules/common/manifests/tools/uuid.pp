class common::tools::uuid {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $what = "uuid"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
