class common::tools::unzip {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "unzip"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
