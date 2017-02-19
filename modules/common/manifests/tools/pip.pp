class common::tools::pip {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $what = "python-pip"
	}
	"FreeBSD", "OpenBSD": {
	    $what = "py-pip"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
