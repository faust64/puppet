class cups::vars {
    $conf_dir             = lookup("cups_conf_dir")
    $gid_zero             = lookup("gid_zero")
    $log_dir              = lookup("cups_log_dir")
    $nagios_printers      = lookup("cups_nagios_printers")
    $permissions          = lookup("cups_permissions")
    $public               = lookup("cups_public")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $run_dir              = lookup("cups_run_dir")
    $runtime_group        = lookup("cups_runtime_group")
    $runtime_user         = lookup("cups_runtime_user")
    $service_name         = lookup("cups_service_name")
    $share_dir            = lookup("cups_share_dir")
    $snmp_community       = lookup("snmp_community")
    $with_hplip           = lookup("cups_with_hplip")

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
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $sysadmin = lookup("cups_lpadmin")
	}
	default: {
	    $sysadmin = lookup("gid_zero")
	}
    }
}
