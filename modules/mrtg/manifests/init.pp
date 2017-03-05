class mrtg {
    include mrtg::vars
    include common::libs::perlrrds
    include common::libs::rrdtool

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include mrtg::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include mrtg::debian
	}
	default: {
	    common::define::patchneeded { "mrtg": }
	}
    }

    include mrtg::cgi14all
    include mrtg::scripts
    include mrtg::webapp
    include mrtg::collect
    include mrtg::jobs
}
