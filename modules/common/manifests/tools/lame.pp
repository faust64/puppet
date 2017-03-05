class common::tools::lame {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "lame"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
