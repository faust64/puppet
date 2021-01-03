class common::tools::xfs {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "xfsprogs"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
