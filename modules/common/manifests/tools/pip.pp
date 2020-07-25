class common::tools::pip {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    if ($lsbdistcodename == "buster") {
		$what = [ "python3-pip", "python-pip" ]
	    } else { $what = "python-pip" }
	}
	"FreeBSD", "OpenBSD": {
	    $what = "py-pip"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
