class ceph {
    include ceph::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include ceph::debian
	}
	default: {
	    common::define::patchneeded { "ceph": }
	}
    }

    if ($ceph::vars::do_dashboard) {
	include ceph::dashboard
    }

    if ($kernel == "Linux") {
	include ceph::logrotate
    }

    include ceph::munin
    include ceph::nagios
    include ceph::scripts
}
