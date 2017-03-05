class common::tools::unrar {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "unrar"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
