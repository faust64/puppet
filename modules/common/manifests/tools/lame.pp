class common::tools::lame {
    case $operatingsystem {
	"CentOS", "Debian", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "lame"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
