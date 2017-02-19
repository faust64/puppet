class common::tools::flac {
    case $operatingsystem {
	"CentOS", "Debian", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "flac"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
