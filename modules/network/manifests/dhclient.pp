class network::dhclient {
    $dns_ip = $network::vars::dns_ip

    if (! defined(File["Ensure dhclient doesn't wipe out our resolv.conf"])) {
	file {
	    "Ensure dhclient doesn't wipe out our resolv.conf":
		content => template("network/dhclient.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/dhclient.conf";
	}
    }
}
