class opennebula::vars {
    $controller          = hiera("nebula_controller")
    $db_backend          = hiera("nebula_db_backend")
    $db_pass             = hiera("nebula_db_passphrase")
    $db_user             = hiera("nebula_db_user")
    $do_oneflow          = hiera("nebula_do_oneflow")
    $do_onegate          = hiera("nebula_do_onegate")
    $do_sunstone         = hiera("nebula_do_sunstone")
    $ldap_base           = hiera("nebula_searchuser")
    $ldap_slave          = hiera("openldap_ldap_slave")
    $oneflow_check       = hiera("nebula_oneflow")
    $oneflow_gw          = hiera("nebula_oneflow_gw")
    $onegate_check       = hiera("nebula_onegate")
    $onegate_gw          = hiera("nebula_onegate_gw")
    $nagios_conf_dir     = hiera("nagios_conf_dir")
    $nagios_runtime_user = hiera("nagios_runtime_user")
    $rdomain             = hiera("root_domain")
    $runtime_group       = hiera("nebula_runtime_group")
    $runtime_user        = hiera("nebula_runtime_user")
    $version             = hiera("nebula_version")

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
