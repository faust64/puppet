class common::libs::perlswitch {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libswitch-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
