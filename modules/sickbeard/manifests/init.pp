class sickbeard {
    include sickbeard::vars
    include sickbeard::install
    include common::tools::pip

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include sickbeard::debian
	}
	default: {
	    common::define::patchneeded { "sickbeard": }
	}
    }

    include sickbeard::config
    include sickbeard::filetraq
    include sickbeard::nagios
    include sickbeard::scripts
    include sickbeard::service
    include sickbeard::webapp
}
