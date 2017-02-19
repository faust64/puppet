class common::libs::rrdtool {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $what = "rrdtool"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
