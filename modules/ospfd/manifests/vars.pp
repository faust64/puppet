class ospfd::vars {
    $sasyncd_peer               = hiera("sasyncd_peer")
    $nagios_runtime_user        = hiera("nagios_runtime_user")
    $netids                     = hiera("office_netids")
    $ospf_auth_type             = hiera("ospf_auth")
    $ospf_conf_dir              = hiera("ospf_conf_dir")
    $ospf_database              = hiera("ospf_database")
    $ospf_hello_interval        = hiera("ospf_hello_interval")
    $ospf_map                   = hiera("ospf_map")
    $ospf_retransmit_interval   = hiera("ospf_retransmit_interval")
    $ospf_router_dead_interval  = hiera("ospf_router_dead_interval")
    $ospf_router_id             = hiera("ospf_router_id")
    $ospf_router_priority       = hiera("ospf_router_priority")
    $ospf_router_transmit_delay = hiera("ospf_router_transmit_delay")
    $ospf_service_name          = hiera("ospf_service_name")
    $ospf_spf_delay             = hiera("ospf_spf_delay")
    $ospf_spf_holdtime          = hiera("ospf_spf_holdtime")
    $ospf_stub_router           = hiera("ospf_stub_router")
    $ospf_no_redistribute       = hiera("ospf_no_redistribute")
    $ospf_redistribute          = hiera("ospf_redistribute")
    $sudo_conf_dir              = hiera("sudo_conf_dir")

    if ($ospf_auth_type == "crypt") {
	$ospf_authid            = hiera("ospf_authid")
	$ospf_authkey           = hiera("ospf_authkey")
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
