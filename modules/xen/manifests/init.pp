class xen {
    include xen::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include xen::debian
	}
	default: {
	    common::define::patchneeded { "xen": }
	}
    }

    include common::tools::xfs
    include xen::backups
    include xen::collectd
    include xen::config
    include xen::filetraq
    include xen::modeles
    include xen::munin
    include xen::scripts
    include xen::service
}
