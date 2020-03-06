class openldap::rhel($server = false) {
    if ($server) {
	$ensure = "present"
    } else {
	$ensure = "absent"
    }

    common::define::package {
	"openldap-servers":
	    ensure => $ensure;
	"openldap-clients":
    }

    if ($server) {
	if ($openldap::vars::ldap_slave == false) {
	    if ($openldap::vars::web_front) {
		$ldapadmin = "present"
	    } else {
		$ldapadmin = "absent"
	    }

	    common::define::package {
		"phpldapadmin":
		    ensure => $ldapadmin;
	    }
	}

	Common::Define::Package["openldap-servers"]
	    -> File["Prepare OpenLDAP for further configuration"]
	    -> Common::Define::Service[$openldap::vars::service_name]
    }
}
