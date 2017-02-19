class elasticsearch {
    if (! defined(Class[java])) {
	include java
    }
    include common::tools::pip
    include elasticsearch::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include elasticsearch::debian
	}
	default: {
	    common::define::patchneeded { "elasticsearch": }
	}
    }

    include elasticsearch::config
    include elasticsearch::jobs
    include elasticsearch::munin
    include elasticsearch::nagios
    include elasticsearch::scripts
    include elasticsearch::service
}
