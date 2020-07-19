class vebackup($do_kvm    = false,
	       $do_openvz = false,
	       $do_xen    = false) {
    include vebackup::vars

    if ($do_openvz == true and ! defined(Class["rsync"])) {
	include rsync
	include rsync::nagios
    }

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include vebackup::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include vebackup::debian
	}
	default: {
	    common::define::patchneeded { "vebackup": }
	}
    }

    include vebackup::key
    include vebackup::config
    include vebackup::scripts
    include vebackup::jobs
    include vebackup::nagios
}
