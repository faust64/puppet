class ifstated::config {
    $bypass         = $ifstated::vars::bypass
    $carp_advbase   = $ifstated::vars::carp_advbase
    $conf_dir       = $ifstated::vars::conf_dir
    $contact_alerts = $ifstated::vars::contact_alerts
    $dhcp_ip        = $ifstated::vars::dhcp_ip
    $do_relay_dhcp  = $ifstated::vars::do_relay_dhcp
    $gw             = $ifstated::vars::alt_gateway
    $has_ipsecctl   = $ifstated::vars::has_ipsecctl
    $has_ftpproxy   = $ifstated::vars::has_ftpproxy
    $has_ospfd      = $ifstated::vars::has_ospfd
    $has_openvpn    = $ifstated::vars::has_openvpn
    $has_pf         = $ifstated::vars::has_pf
    $has_relayd     = $ifstated::vars::has_relayd
    $has_tftpproxy  = $ifstated::vars::has_tftpproxy
    $has_unbound    = $ifstated::vars::has_unbound
    $local_networks = $ifstated::vars::local_networks[$domain]
    $main_networks  = $ifstated::vars::main_networks
    $munin_ip       = $ifstated::vars::munin_ip
    $sasyncd_fml    = $ifstated::vars::sasyncd_fml
    $sync_peer      = $ifstated::vars::sync_peer
    $vlan_database  = $ifstated::vars::vlan_database

    if ($gw) {
	file {
	    "Install alternative gateway configuration":
		content => template("network/gateway.erb"),
		group   => hiera("gid_zero"),
		mode    => "0640",
		owner   => root,
		path    => "/etc/myigate";
	}
	File["Install alternative gateway configuration"]
	    -> File["Ifstated configuration"]
    }

    file {
	"Ifstated configuration":
	    content => template("ifstated/ifstated.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    notify  => Exec["Reload Ifstated configuration"],
	    owner   => root,
	    path    => "$conf_dir/ifstated.conf";
    }
}
