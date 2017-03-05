class common::libs::rrdtool {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $what = "rrdtool"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
