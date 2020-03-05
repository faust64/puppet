class unbound::vars {
    $conf_dir           = lookup("unbound_conf_dir")
    $do_cache           = lookup("unbound_do_cache")
    $do_dnssec          = lookup("unbound_do_dnssec")
    $do_public          = lookup("unbound_do_public")
    $fail2ban_unbound   = lookup("fail2ban_do_unbound")
    $forwards           = lookup("unbound_forwarders")
    $munin_conf_dir     = lookup("munin_conf_dir")
    $munin_monitored    = lookup("unbound_munin")
    $munin_probes       = lookup("unbound_munin_probes")
    $munin_service_name = lookup("munin_node_service_name")
    $mypixeladdress     = lookup("unbound_pixel_address")
    $recurse_networks   = lookup("unbound_recurse_networks")
    $rdomain            = lookup("root_domain")
    $rotate             = lookup("unbound_rotate")
    $run_dir            = lookup("unbound_run_dir")
    $runtime_group      = lookup("unbound_runtime_group")
    $runtime_user       = lookup("unbound_runtime_user")
    $var_dir            = lookup("unbound_var_dir")
    $with_collectd      = lookup("unbound_collectd")

    if ($mypixeladdress) {
	$pixeladdress   = $mypixeladdress
    } else {
	$pixeladdress   = $ipaddress
    }
    if (defined(Class["pf"])) {
	$pf_svc_ip      = hiera("pf_svc_ip")
    } else {
	$pf_svc_ip      = false
    }
}
