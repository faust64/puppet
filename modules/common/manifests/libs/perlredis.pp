class common::libs::perlredis {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libredis-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
