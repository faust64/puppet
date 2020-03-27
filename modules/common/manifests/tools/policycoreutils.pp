class common::tools::policycoreutils {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    $what = [ "policycoreutils", "policycoreutils-python" ]
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
