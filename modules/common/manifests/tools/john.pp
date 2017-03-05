class common::tools::john {
    case $myoperatingsystem {
	"Debian", "Devuan", "Fedora", "Ubuntu": {
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
