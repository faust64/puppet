class ifstated::scripts {
    $carp_advbase   = $ifstated::vars::carp_advbase
    $contact_alerts = $ifstated::vars::contact_alerts
    $has_ospfd      = $ifstated::vars::has_ospfd
    $main_networks  = $ifstated::vars::main_networks

    file {
	"Ifstated application script":
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/ifstated_resync",
	    source  => "puppet:///modules/ifstated/resync";
	"Install custom UPTIME command":
	    content => template("ifstated/uptime.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/myuptime";
	"Install custom REBOOT command":
	    content => template("ifstated/reboot.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/myreboot";
    }
}
