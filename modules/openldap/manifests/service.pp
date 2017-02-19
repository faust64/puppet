class openldap::service {
    common::define::service {
	$openldap::vars::service_name:
	    ensure => running;
    }

    if ($openldap::vars::ldap_slave == false) {
	cron {
	    "Backup OpenLDAP applicative data":
		command => "/usr/local/sbin/OpenLDAPbackup >/dev/null 2>&1",
		hour    => 22,
		minute  => 21,
		require => File["Install OpenLDAP backup script"],
		user    => root;
	}
    }
}
