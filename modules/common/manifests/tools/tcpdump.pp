class common::tools::tcpdump {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $what = "tcpdump"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
