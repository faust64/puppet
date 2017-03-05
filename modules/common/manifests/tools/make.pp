class common::tools::make {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    $what = "make"
	}
	"Debian", "Devuan", "Ubuntu": {
	    $what = [ "build-essential", "make" ]
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
