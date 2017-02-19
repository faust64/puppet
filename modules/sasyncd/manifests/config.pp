class sasyncd::config {
    $main_networks     = $sasyncd::vars::main_networks
    $sasyncd_group     = $sasyncd::vars::sasyncd_group
    $sasyncd_interface = $sasyncd::vars::sasyncd_interface
    $sasyncd_peer      = $sasyncd::vars::sasyncd_peer
    $sasyncd_sharedkey = $sasyncd::vars::sasyncd_sharedkey

    file {
	"Sasyncd configuration":
	    content => template("sasyncd/sasyncd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service["sasyncd"],
	    owner   => root,
	    path    => "/etc/sasyncd.conf",
	    require => Class[Ipsecctl];
    }
}
