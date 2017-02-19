class common::tools::unrar {
    case $operatingsystem {
	"CentOS", "Debian", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "unrar"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
