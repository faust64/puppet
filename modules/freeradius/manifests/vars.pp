class freeradius::vars {
    $authorized_clients  = lookup("freeradius_authorized_clients")
    $conf_dir            = lookup("freeradius_conf_dir")
    $default_passphrase  = lookup("freeradius_default_passphrase")
    $ldap_account        = lookup("freeradius_ldap_account")
    $ldap_base           = lookup("freeradius_ldap_base")
    $ldap_passphrase     = lookup("freeradius_ldap_passphrase")
    $ldap_slave_primary  = lookup("freeradius_ldap_slave")
    $ldap_slave_fallback = lookup("openldap_ldap_slave")
    $lib_dir             = lookup("freeradius_lib_dir")
    $log_dir             = lookup("freeradius_log_dir")
    $run_dir             = lookup("freeradius_run_dir")
    $runtime_group       = lookup("freeradius_runtime_group")
    $runtime_user        = lookup("freeradius_runtime_user")
    $service_name        = lookup("freeradius_service_name")

    if ($ldap_slave_primary) {
	$ldap_slave = $ldap_slave_primary
    } else {
	$ldap_slave = $ldap_slave_fallback
    }

    case $myoperatingsystem {
	"CentOS", "RedHat":		{ $cert_dir = "/etc/pki/tls/certs" }
	"Debian", "Devuan", "Ubuntu":	{ $cert_dir = "/etc/ssl/certs" }
	"FreeBSD":			{ $cert_dir = "/usr/local/share/certs" }
	"OpenBSD":			{ $cert_dir = "/etc/ssl" }
    }
}
