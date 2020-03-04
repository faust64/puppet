class common::tools::netstat {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu", "CentOS", "RedHat": {
	    $what = "net-tools"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
