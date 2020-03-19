class common::tools::jq {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "jq"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
