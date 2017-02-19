class xen {
    include xen::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include xen::debian
	}
	default: {
	    common::define::patchneeded { "xen": }
	}
    }

    include xen::backups
    include xen::collectd
    include xen::config
    include xen::filetraq
    include xen::modeles
    include xen::munin
    include xen::scripts
}
