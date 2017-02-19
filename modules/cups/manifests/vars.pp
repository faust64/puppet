class cups::vars {
    $conf_dir             = hiera("cups_conf_dir")
    $gid_zero             = hiera("gid_zero")
    $log_dir              = hiera("cups_log_dir")
    $nagios_printers      = hiera("cups_nagios_printers")
    $permissions          = hiera("cups_permissions")
    $public               = hiera("cups_public")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $rsyslog_version      = hiera("rsyslog_version")
    $runtime_group        = hiera("cups_runtime_group")
    $runtime_user         = hiera("cups_runtime_user")
    $service_name         = hiera("cups_service_name")
    $share_dir            = hiera("cups_share_dir")
    $snmp_community       = hiera("snmp_community")
    $with_hplip           = hiera("cups_with_hplip")

    if ($permissions["/admin"] != false) {
	if ($permissions["/admin"]["Allow"] =~ /[0-9]\.[0-9]/) {
	    $admin_filter = $permissions["/admin"]["Allow"]
	} else {
	    $admin_filter = "from 127.0.0.1"
	}
    } else {
	$admin_filter = false
    }
    if ($public) {
	if ($public != true) {
	    $listen_addr = $public
	} else {
	    $listen_addr = $ipaddress
	}
    } else {
	$listen_addr = "127.0.0.1"
    }
}
