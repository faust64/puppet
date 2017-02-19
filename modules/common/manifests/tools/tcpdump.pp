class common::tools::tcpdump {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $what = "tcpdump"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
