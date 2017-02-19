class samba {
    include samba::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include samba::rhel
	}
	"Debian", "Ubuntu": {
	    include samba::debian
	}
	default: {
	    common::define::patchneeded { "samba": }
	}
    }

    if ($samba::vars::samba_over_nfs) {
	include samba::nfs
    }

    include openldap::pam::setup
    include samba::scripts
    include samba::config
    include samba::service
    include samba::nagios
}
