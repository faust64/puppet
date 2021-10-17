class common::tools::policycoreutils {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    if ($os['release']['major'] == '6' or $os['release']['major'] == '7') {
		$what = [ "policycoreutils", "policycoreutils-python" ]
	    } else {
		$what = [ "policycoreutils", "policycoreutils-python-utils" ]
	    }
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
