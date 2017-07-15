class openldap::vars {
    $admin_ssha            = lookup("openldap_admin_ssha_hash")
    $conf_dir              = lookup("openldap_conf_dir")
    $contact               = lookup("openldap_contact")
    $ldap_slave            = lookup("openldap_ldap_slave")
    $ldap_suffix           = lookup("openldap_ldap_suffix")
    $ldap_id               = lookup("ldap_id")
    $munin_conf_dir        = lookup("munin_conf_dir")
    $munin_ldap_pass       = lookup("openldap_munin_passphrase")
    $munin_ldap_user       = lookup("openldap_munin_user")
    $munin_monitored       = lookup("openldap_munin")
    $munin_probes          = lookup("openldap_munin_probes")
    $munin_service_name    = lookup("munin_node_service_name")
    $repl_dn_passwd        = lookup("openldap_repl_passphrase")
    $run_dir               = lookup("openldap_run_dir")
    $runtime_group         = lookup("openldap_runtime_group")
    $runtime_user          = lookup("openldap_runtime_user")
    $service_name          = lookup("openldap_service_name")
    $slack_hook            = lookup("openldap_slack_hook_uri")
    $ssp_bind_dn           = lookup("openldap_ssp_bind_dn")
    $ssp_bind_pw           = lookup("openldap_ssp_bind_pw")
    $ssp_keyphrase         = lookup("openldap_ssp_keyphrase")
    $ssp_mail_from         = lookup("openldap_ssp_mail_from")
    $the_dir               = lookup("openldap_dir_dir")
    $web_front             = lookup("openldap_web_front")

    case $myoperatingsystem {
	"CentOS", "RedHat":		{ $cert_dir = "/etc/pki/tls/certs" }
	"Debian", "Devuan", "Ubuntu":	{ $cert_dir = "/etc/ssl/certs" }
	"FreeBSD":			{ $cert_dir = "/usr/local/share/certs" }
	"OpenBSD":			{ $cert_dir = "/etc/ssl" }
    }
}
