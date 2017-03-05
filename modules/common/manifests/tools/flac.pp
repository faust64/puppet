class common::tools::flac {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "flac"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
