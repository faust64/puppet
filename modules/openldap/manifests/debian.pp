class openldap::debian($server = false) {
    $conf_dir      = $openldap::vars::conf_dir
    $runtime_group = $openldap::vars::runtime_group
    $runtime_user  = $openldap::vars::runtime_user

    if ($server) {
	$ensure = "present"
    } else {
	$ensure = "absent"
    }

    common::define::package {
	[ "slapd", "gosa-plugin-ssh-schema" ]:
	    ensure => $ensure;
	"ldap-utils":
    }

    if ($server) {
	if ($openldap::vars::ldap_slave == false) {
	    if ($openldap::vars::web_front == "phpldapadmin") {
		$ldapadmin = "present"
	    } else {
		$ldapadmin = "absent"
	    }

	    common::define::package {
		"phpldapadmin":
		    ensure => $ldapadmin;
	    }
	}

	file {
	    "Install OpenLDAP service defaults":
		content => template("openldap/debian-defaults.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service[$openldap::vars::service_name],
		owner   => root,
		path    => "/etc/default/slapd";
	}

	Package["slapd"]
	    -> File["Install OpenLDAP service defaults"]
	    -> File["Prepare OpenLDAP for further configuration"]
	    -> Service[$openldap::vars::service_name]
    }
}
