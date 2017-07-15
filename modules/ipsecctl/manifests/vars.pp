class ipsecctl::vars {
    $contact_alerts           = lookup("contact_alerts")
    $contact_alerts_ipsecctl  = lookup("contact_alerts_ipsecctl")
    $ipsec_tunnels            = lookup("ipsec_tunnels")
    $ipsec_defaults           = lookup("default_ipsec_settings")
    $ipsecctl_default_backend = lookup("ipsecctl_default_backend")
    $main_networks            = lookup("net_ifs")
    $nagios_runtime_user      = lookup("nagios_runtime_user")
    $netids                   = lookup("office_netids")
    $sudo_conf_dir            = lookup("sudo_conf_dir")

    if ($contact_alerts_ipsecctl) {
	$alerts = $contact_alerts_ipsecctl
    } else {
	$alerts = $contact_alerts
    }
}
