class collection3 {
    include collection3::vars
    include common::libs::perlrrds

    if (! defined(Class["collectd"])) {
	include collectd
    }

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include collection3::debian
	}
	default: {
	    common::define::patchneeded { "collection3": }
	}
    }

    include collection3::webapp
}
