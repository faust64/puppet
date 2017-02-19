class common::tools::unzip {
    case $operatingsystem {
	"CentOS", "Debian", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "unzip"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
