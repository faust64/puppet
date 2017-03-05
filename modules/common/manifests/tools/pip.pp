class common::tools::pip {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
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
