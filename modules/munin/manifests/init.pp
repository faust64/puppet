class munin {
    include munin::vars
    include rrdcached

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include munin::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include munin::debian
	}
	default: {
	    common::define::patchneeded { "munin": }
	}
    }

    include munin::config
    include munin::collect
    include munin::filetraq
    include munin::scripts
    include munin::service
    include munin::webapp

    if ($kernel == "Linux") {
	include munin::logrotate
    }
    if (! defined(Class[Muninnode])) {
	include muninnode
    }
}
