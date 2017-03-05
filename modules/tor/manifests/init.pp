class tor {
    include tor::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include tor::debian
	}
	default: {
	    common::define::patchneeded { "tor": }
	}
    }

    include tor::config
    include tor::service

    if ($kernel == "Linux") {
	include tor::logrotate
    }
}
