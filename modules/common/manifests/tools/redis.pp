class common::tools::redis {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "redis-tools"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
