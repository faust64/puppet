class common::tools::kpartx {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $what = "kpartx"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
