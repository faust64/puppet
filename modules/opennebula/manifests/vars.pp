class opennebula::vars {
    $controller          = lookup("nebula_controller")
    $db_backend          = lookup("nebula_db_backend")
    $db_pass             = lookup("nebula_db_passphrase")
    $db_user             = lookup("nebula_db_user")
    $do_oneflow          = lookup("nebula_do_oneflow")
    $do_onegate          = lookup("nebula_do_onegate")
    $do_sunstone         = lookup("nebula_do_sunstone")
    $ldap_base           = lookup("nebula_searchuser")
    $ldap_slave          = lookup("openldap_ldap_slave")
    $oneflow_check       = lookup("nebula_oneflow")
    $oneflow_gw          = lookup("nebula_oneflow_gw")
    $onegate_check       = lookup("nebula_onegate")
    $onegate_gw          = lookup("nebula_onegate_gw")
    $nagios_conf_dir     = lookup("nagios_conf_dir")
    $nagios_runtime_user = lookup("nagios_runtime_user")
    $rdomain             = lookup("root_domain")
    $runtime_group       = lookup("nebula_runtime_group")
    $runtime_user        = lookup("nebula_runtime_user")
    $version             = lookup("nebula_version")

    if ($controller == $fqdn or $controller == true) {
	$do_controller = true
    } else {
	$do_controller = false
    }
    if ($oneflow_check) {
	$oneflow = $oneflow_check
    } else {
	$oneflow = "oneflow"
    }
    if ($onegate_check) {
	$onegate = $onegate_check
    } else {
	$onegate = "onegate"
    }
}
