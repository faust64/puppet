class ospfd::config {
    $has_carp                   = $ospfd::vars::has_carp
    $linkvaldb                  = $ospfd::vars::linkvaldb
    $office_id                  = $ospfd::vars::netids
    $ospf_auth_type             = $ospfd::vars::ospf_auth_type
    $ospf_authid                = $ospfd::vars::ospf_authid
    $ospf_authkey               = $ospfd::vars::ospf_authkey
    $ospf_database              = $ospfd::vars::ospf_database
    $ospf_conf_dir              = $ospfd::vars::ospf_conf_dir
    $ospf_hello_interval        = $ospfd::vars::ospf_hello_interval
    $ospf_map                   = $ospfd::vars::ospf_map
    $ospf_retransmit_interval   = $ospfd::vars::ospf_retransmit_interval
    $ospf_router_dead_interval  = $ospfd::vars::ospf_router_dead_interval
    $ospf_router_id             = $ospfd::vars::ospf_router_id
    $ospf_router_priority       = $ospfd::vars::ospf_router_priority
    $ospf_router_transmit_delay = $ospfd::vars::ospf_router_transmit_delay
    $ospf_spf_delay             = $ospfd::vars::ospf_spf_delay
    $ospf_spf_holdtime          = $ospfd::vars::ospf_spf_holdtime
    $ospf_stub_router           = $ospfd::vars::ospf_stub_router
    $ospf_no_redistribute       = $ospfd::vars::ospf_no_redistribute
    $ospf_redistribute          = $ospfd::vars::ospf_redistribute

    file {
	"Install Ospfd configuration":
	    content => template("ospfd/ospfd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload ospf configuration"],
	    owner   => root,
	    path    => "$ospf_conf_dir/ospfd.conf";
    }
}
