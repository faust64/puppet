class pf::qos {
    $main_networks      = $pf::vars::main_networks
    $ipsec_offices      = false
    $ipsec_tunnels      = $pf::vars::ipsec_tunnels
    $qos_bw_bulk        = $pf::vars::qos_bw_bulk
    $qos_bw_data        = $pf::vars::qos_bw_data
    $qos_bw_interactive = $pf::vars::qos_bw_interactive
    $qos_bw_voip        = $pf::vars::qos_bw_voip
    $qos_root_if        = $pf::vars::qos_root_if
    $qos_root_bandwidth = $pf::vars::qos_root_bandwidth

    file {
	"Pf QoS Configuration":
	    content => template("pf/qos.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/QoS",
	    require => File["Pf Configuration directory"];
	"Pf Shaping Configuration":
	    content => template("pf/shaping.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/Shaping",
	    require => File["Pf Configuration directory"];
    }
}
