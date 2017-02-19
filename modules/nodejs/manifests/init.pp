class nodejs {
    include nodejs::vars
    include common::tools::make


    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include nodejs::debian
	}
	default: {
	    common::define::patchneeded { "nodejs": }
	}
    }

    include nodejs::config

    if ($nodejs::vars::service_name == "nodejs") {
	include nodejs::customconfig
	include nodejs::customservice
    } elsif ($nodejs::vars::service_name == "pm2") {
	nodejs::define::module { "pm2": }
	include nodejs::pm2config
	include nodejs::pm2service
    }
    if ($nodejs::vars::service_name) {
	include nodejs::service
    }
}
