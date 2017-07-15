class pf::ipsec {
    $all_networks   = $pf::vars::all_networks
    $all_openvpns   = $pf::vars::all_openvpns
    $ipsec_offices  = false
    $ipsec_tunnels  = $pf::vars::ipsec_tunnels
    $main_networks  = $pf::vars::main_networks
    $ovpn_networks  = $pf::vars::ovpn_networks
    $local_networks = $pf::vars::local_networks

    file {
	"Pf IPSEC configuration":
	    content => template("pf/ipsec.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/IPSEC",
	    require => File["Pf Configuration directory"];
    }
}
