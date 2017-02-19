class common::libs::perlswitch {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libswitch-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
