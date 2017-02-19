class common::libs::pythonrequests {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "python-requests"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
