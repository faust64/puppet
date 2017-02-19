class freeradius::vars {
    $authorized_clients  = hiera("freeradius_authorized_clients")
    $conf_dir            = hiera("freeradius_conf_dir")
    $default_passphrase  = hiera("freeradius_default_passphrase")
    $ldap_account        = hiera("freeradius_ldap_account")
    $ldap_base           = hiera("freeradius_ldap_base")
    $ldap_passphrase     = hiera("freeradius_ldap_passphrase")
    $ldap_slave_primary  = hiera("freeradius_ldap_slave")
    $ldap_slave_fallback = hiera("openldap_ldap_slave")
    $lib_dir             = hiera("freeradius_lib_dir")
    $log_dir             = hiera("freeradius_log_dir")
    $run_dir             = hiera("freeradius_run_dir")
    $runtime_group       = hiera("freeradius_runtime_group")
    $runtime_user        = hiera("freeradius_runtime_user")
    $service_name        = hiera("freeradius_service_name")

    if ($ldap_slave_primary) {
	$ldap_slave = $ldap_slave_primary
    }
    else {
	$ldap_slave = $ldap_slave_fallback
    }

    case $operatingsystem {
	"CentOS", "RedHat":	{ $cert_dir = "/etc/pki/tls/certs" }
	"Debian", "Ubuntu":	{ $cert_dir = "/etc/ssl/certs" }
	"FreeBSD":              { $cert_dir = "/usr/local/share/certs" }
	"OpenBSD":              { $cert_dir = "/etc/ssl" }
    }
}
