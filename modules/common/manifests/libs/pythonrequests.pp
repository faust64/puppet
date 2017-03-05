class common::libs::pythonrequests {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "python-requests"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
