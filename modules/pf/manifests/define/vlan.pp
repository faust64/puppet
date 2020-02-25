define pf::define::vlan($as_if       = false,
			$l2filter    = "",
			$root_if     = $name,
			$routeto     = "",
			$routetopriv = "",
			$vlanname    = $name) {
    $all_networks      = $pf::vars::all_networks
    $bbb_ip            = $pf::vars::bbb_ip
    $ftpproxy_port     = $pf::vars::ftpproxy_port
    $git_ip            = $pf::vars::git_ip
    $local_networks    = $pf::vars::local_networks
    $main_networks     = $pf::vars::main_networks
    $ovpn_networks     = $pf::vars::ovpn_networks
    $pubmx_ip          = $pf::vars::pubmx_ip
    $pxe_is_here       = $pf::vars::pxe_is_here
    $squid_ip          = $pf::vars::squid_ip
    $tftpproxy_port    = $pf::vars::tftpproxy_port
    $xmpp_ip           = $pf::vars::xmpp_ip

    if ! defined(File["Pf LAN $vlanname configuration"]) {
	file {
	    "Pf LAN $vlanname configuration":
		content => template("pf/private-rset.erb"),
		group   => lookup("gid_zero"),
		mode    => "0600",
		notify  => Exec["Reload pf configuration"],
		owner   => root,
		path    => "/etc/pf.d/VLAN-$vlanname",
		require => File["Pf Interfaces Configuration"];
	}
    }
}
