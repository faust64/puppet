class dhcpd::config {
    $all_networks   = $dhcpd::vars::all_networks
    $conf_dir       = $dhcpd::vars::conf_dir
    $dns_ip         = $dhcpd::vars::dns_ip
    $local_networks = $dhcpd::vars::local_networks
    $netmask_crsp   = $dhcpd::vars::netmask_correspondance
    $office_netids  = $dhcpd::vars::netids
    $pxe_ip         = $dhcpd::vars::pxe_ip

    if ($conf_dir != "/etc" and $conf_dir != "/usr/local/etc") {
	file {
	    "Prepare DHCPD for further configuration":
		ensure => directory,
		group  => lookup("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => $conf_dir;
	}

	File["Prepare DHCPD for further configuration"]
	    -> File["Install DHCPD main configuration"]
    }

    file {
	"Install DHCPD main configuration":
	    content => template("dhcpd/dhcpd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["dhcpd"],
	    owner   => root,
	    path    => "$conf_dir/dhcpd.conf";
    }
}
