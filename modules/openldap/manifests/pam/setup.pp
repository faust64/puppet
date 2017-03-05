class openldap::pam::setup($with_session = false) {
    include openldap::client

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include openldap::pam::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include openldap::pam::debian
	}
    }

    include openldap::pam::config
}
