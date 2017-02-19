class common::libs::perlredis {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libredis-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
