class openldap::vars {
    $admin_ssha            = hiera("openldap_admin_ssha_hash")
    $conf_dir              = hiera("openldap_conf_dir")
    $contact               = hiera("openldap_contact")
    $ldap_slave            = hiera("openldap_ldap_slave")
    $ldap_suffix           = hiera("openldap_ldap_suffix")
    $ldap_id               = hiera("ldap_id")
    $munin_conf_dir        = hiera("munin_conf_dir")
    $munin_ldap_pass       = hiera("openldap_munin_passphrase")
    $munin_ldap_user       = hiera("openldap_munin_user")
    $munin_monitored       = hiera("openldap_munin")
    $munin_probes          = hiera("openldap_munin_probes")
    $munin_service_name    = hiera("munin_node_service_name")
    $repl_dn_passwd        = hiera("openldap_repl_passphrase")
    $run_dir               = hiera("openldap_run_dir")
    $runtime_group         = hiera("openldap_runtime_group")
    $runtime_user          = hiera("openldap_runtime_user")
    $service_name          = hiera("openldap_service_name")
    $slack_hook            = hiera("openldap_slack_hook_uri")
    $ssp_bind_dn           = hiera("openldap_ssp_bind_dn")
    $ssp_bind_pw           = hiera("openldap_ssp_bind_pw")
    $ssp_keyphrase         = hiera("openldap_ssp_keyphrase")
    $ssp_mail_from         = hiera("openldap_ssp_mail_from")
    $the_dir               = hiera("openldap_dir_dir")
    $web_front             = hiera("openldap_web_front")

    case $operatingsystem {
	"CentOS", "RedHat":	{ $cert_dir = "/etc/pki/tls/certs" }
	"Debian", "Ubuntu":	{ $cert_dir = "/etc/ssl/certs" }
	"FreeBSD":              { $cert_dir = "/usr/local/share/certs" }
	"OpenBSD":              { $cert_dir = "/etc/ssl" }
    }
}
