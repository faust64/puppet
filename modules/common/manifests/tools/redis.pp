class common::tools::redis {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "redis-tools"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
