class common::tools::john {
    case $operatingsystem {
	"Debian", "Fedora", "Ubuntu": {
	    $what = "john"
	}
	"Gentoo": {
	    $what = "johntheripper"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
