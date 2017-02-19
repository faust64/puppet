class ipsecctl::vars {
    $contact_alerts           = hiera("contact_alerts")
    $contact_alerts_ipsecctl  = hiera("contact_alerts_ipsecctl")
    $ipsec_tunnels            = hiera("ipsec_tunnels")
    $ipsec_defaults           = hiera("default_ipsec_settings")
    $ipsecctl_default_backend = hiera("ipsecctl_default_backend")
    $main_networks            = hiera("net_ifs")
    $nagios_runtime_user      = hiera("nagios_runtime_user")
    $netids                   = hiera("office_netids")
    $sudo_conf_dir            = hiera("sudo_conf_dir")

    if ($contact_alerts_ipsecctl) {
	$alerts = $contact_alerts_ipsecctl
    } else {
	$alerts = $contact_alerts
    }
}
