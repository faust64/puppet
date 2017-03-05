class common::tools::kpartx {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $what = "kpartx"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
