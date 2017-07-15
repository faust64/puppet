class ipfw::config {
    $all_networks      = $ipfw::vars::all_networks
    $all_openvpns      = $ipfw::vars::all_openvpns
    $local_networks    = $ipfw::vars::local_networks
    $munin_ip          = $ipfw::vars::munin_ip
    $munin_listenaddr  = $ipfw::vars::munin_listenaddr
    $munin_port        = $ipfw::vars::munin_port
    $myvlan            = $ipfw::vars::myvlan
    $nagios_ip         = $ipfw::vars::nagios_ip
    $nagios_listenaddr = $ipfw::vars::nagios_listenaddr
    $nagios_port       = $ipfw::vars::nagios_port
    $netids            = $ipfw::vars::netids
    $ovpn_networks     = $ipfw::vars::ovpn_networks
    $snmp_ip           = $ipfw::vars::snmp_ip
    $snmp_listenaddr   = $ipfw::vars::snmp_listenaddr

    file {
	"Install ipfw main configuration":
	    content => template("ipfw/ipfw.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["ipfw"],
	    owner   => root,
	    path    => "/etc/ipfwrc";
    }
}
