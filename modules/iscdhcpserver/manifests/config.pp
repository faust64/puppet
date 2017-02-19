class iscdhcpserver::config {
    $ad_ip                  = $iscdhcpserver::vars::ad_ip
    $all_networks           = $iscdhcpserver::vars::all_networks
    $dhcp_conf_dir          = $iscdhcpserver::vars::dhcp_conf_dir
    $dhcp_ip                = $iscdhcpserver::vars::dhcp_ip
    $dns_ip                 = $iscdhcpserver::vars::dns_ip
    $local_networks         = $iscdhcpserver::vars::local_networks
    $mydomain               = $iscdhcpserver::vars::mydomain
    $netmask_correspondance = $iscdhcpserver::vars::netmask_correspondance
    $office_netids          = $iscdhcpserver::vars::office_netids
    $pxe_ip                 = $iscdhcpserver::vars::pxe_ip
    $rndc_key               = $iscdhcpserver::vars::rndc_key
    $search                 = $iscdhcpserver::vars::search

    file {
	"Prepare isc-dhcp-server for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => $dhcp_conf_dir;
	"Install isc-dhcp-server main configuration":
	    content => template("iscdhcpserver/dhcpd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$iscdhcpserver::vars::service_name],
	    owner   => root,
	    path    => "$dhcp_conf_dir/dhcpd.conf",
	    require => File["Prepare isc-dhcp-server for further configuration"];
	"Install rndc.key":
	    content => template("named/rndc.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    notify  => Service[$iscdhcpserver::vars::service_name],
	    owner   => root,
	    path    => "$dhcp_conf_dir/rndc.key",
	    require => File["Prepare isc-dhcp-server for further configuration"];
	"Ensure dhcpd.local is there":
	    content => "# Local definitions go there
",
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$iscdhcpserver::vars::service_name],
	    owner   => root,
	    path    => "$dhcp_conf_dir/dhcpd.local",
	    replace => no,
	    require => File["Prepare isc-dhcp-server for further configuration"];
    }
}
