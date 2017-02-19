define common::define::static_lease($hname  = $name,
				    $hwaddr = "01:23:45:67:89:ab",
				    $ipaddr = "127.0.0.1") {
    if ($ipaddr != "127.0.0.1") {
	$declare = "cat <<EOF >>dhcpd.local

host $hname {
    hardware ethernet $hwaddr;
    fixed-address $ipaddr;
}
EOF
"

	@@exec {
	    "Declare $hname":
		command => $declare,
		cwd     => "/etc/dhcp",
		path    => "/usr/bin:/bin",
		require => File["Ensure dhcpd.local is there"],
		tag     => "dhcp-reserved-$domain",
		unless  => "grep '^host $hname ' dhcpd.local";
	}
    }
}
