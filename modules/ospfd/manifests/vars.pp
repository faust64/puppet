class ospfd::vars {
    $sasyncd_peer               = lookup("sasyncd_peer")
    $nagios_runtime_user        = lookup("nagios_runtime_user")
    $netids                     = lookup("office_netids")
    $ospf_auth_type             = lookup("ospf_auth")
    $ospf_conf_dir              = lookup("ospf_conf_dir")
    $ospf_database              = lookup("ospf_database")
    $ospf_hello_interval        = lookup("ospf_hello_interval")
    $ospf_map                   = lookup("ospf_map")
    $ospf_retransmit_interval   = lookup("ospf_retransmit_interval")
    $ospf_router_dead_interval  = lookup("ospf_router_dead_interval")
    $ospf_router_id             = lookup("ospf_router_id")
    $ospf_router_priority       = lookup("ospf_router_priority")
    $ospf_router_transmit_delay = lookup("ospf_router_transmit_delay")
    $ospf_service_name          = lookup("ospf_service_name")
    $ospf_spf_delay             = lookup("ospf_spf_delay")
    $ospf_spf_holdtime          = lookup("ospf_spf_holdtime")
    $ospf_stub_router           = lookup("ospf_stub_router")
    $ospf_no_redistribute       = lookup("ospf_no_redistribute")
    $ospf_redistribute          = lookup("ospf_redistribute")
    $sudo_conf_dir              = lookup("sudo_conf_dir")

    if ($ospf_auth_type == "crypt") {
	$ospf_authid            = lookup("ospf_authid")
	$ospf_authkey           = lookup("ospf_authkey")
    }
    else {
	$ospf_authid            = false
	$ospf_authkey           = false
    }

    $linkvaldb =
	{
	    'sdslsdsl' => 1,
	    'sdsladsl' => 2,
	    'sdslsip' => 3,
	    'adslsdsl' => 4,
	    'adsladsl' => 5,
	    'adslsip' => 6,
	    'sipsdsl' => 7,
	    'sipadsl' => 8,
	    'sipsip' => 9
	}

    if ($sasyncd_peer == false) {
	$has_carp = false
    }
    else {
	$has_carp = true
    }
}
