class common::tools::checkpolicy {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    $what = "checkpolicy"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
