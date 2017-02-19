class bgpd::config {
    $bgp_auth            = $bgpd::vars::bgp_auth
    $bgp_as_no           = $bgpd::vars::bgp_as_no
    $bgp_allow_networks  = $bgpd::vars::bgp_allow_networks
    $bgp_conf_dir        = $bgpd::vars::bgp_conf_dir
    $bgp_database        = $bgpd::vars::bgp_database
    $bgp_deny_networks   = $bgpd::vars::bgp_deny_networks
    $bgp_holdtime        = $bgpd::vars::bgp_holdtime
    $bgp_log_updates     = $bgpd::vars::bgp_log_updates
    $bgp_map             = $bgpd::vars::bgp_map
    $bgp_max_pfx_len     = $bgpd::vars::bgp_max_pfx_len
    $bgp_min_pfx_len     = $bgpd::vars::bgp_min_pfx_len
    $bgp_pass            = $bgpd::vars::bgp_pass
    $bgp_redistribute    = $bgpd::vars::bgp_redistribute
    $bgp_route_collector = $bgpd::vars::bgp_route_collector
    $bgp_router_id       = $bgpd::vars::bgp_router_id
    $gre_tunnels         = $bgpd::vars::gre_tunnels

    file {
	"Install Bgpd configuration":
	    content => template("bgpd/bgpd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload bgp configuration"],
	    owner   => root,
	    path    => "$bgp_conf_dir/bgpd.conf";
    }
}
