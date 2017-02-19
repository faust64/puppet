class openldap::pam::setup($with_session = false) {
    include openldap::client

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include openldap::pam::rhel
	}
	"Debian", "Ubuntu": {
	    include openldap::pam::debian
	}
    }

    include openldap::pam::config
}
