class openldap {
    include openldap::client

    case $operatingsystem {
	"CentOS", "RedHat": {
	    class {
		openldap::rhel:
		    server => true;
	    }
	}
	"Debian", "Ubuntu": {
	    class {
		openldap::debian:
		    server => true;
	    }
	}
	"OpenBSD": {
	    class {
		openldap::openbsd:
		    server => true;
	    }
	}
	default: {
	    common::define::patchneeded { "openldap": }
	}
    }

    include openldap::config
    include openldap::filetraq
    include openldap::munin
    include openldap::nagios
    include openldap::scripts
    include openldap::service

    if ($openldap::vars::web_front) {
	include openldap::webapp
    }
}
