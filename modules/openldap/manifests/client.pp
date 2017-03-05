class openldap::client {
    include openldap::vars

    $cert_dir   = $openldap::vars::cert_dir
    $conf_dir   = $openldap::vars::conf_dir
    $ldap_base  = $openldap::vars::ldap_suffix
    $ldap_slave = $openldap::vars::ldap_slave

    if (! defined(Class[Openldap])) {
	case $myoperatingsystem {
	    "CentOS", "RedHat": {
		include openldap::rhel
	    }
	    "Debian", "Devuan", "Ubuntu": {
		include openldap::debian
	    }
	    "OpenBSD": {
		include openldap::openbsd
	    }
	    default: {
		common::define::patchneeded { "openldap-client": }
	    }
	}
    }

    file {
	"Prepare OpenLDAP for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install OpenLDAP client minimal configuration":
	    content => template("openldap/ldap.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/ldap.conf",
	    require => File["Prepare OpenLDAP for further configuration"];
    }
}
