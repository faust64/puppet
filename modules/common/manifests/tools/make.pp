class common::tools::make {
    case $operatingsystem {
	"CentOS", "RedHat": {
	    $what = "make"
	}
	"Debian", "Ubuntu": {
	    $what = [ "build-essential", "make" ]
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
