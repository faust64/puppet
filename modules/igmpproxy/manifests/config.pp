class igmpproxy::config {
    $all_networks   = $igmpproxy::vars::all_networks
    $local_networks = $igmpproxy::vars::local_networks

    file {
	"Install IGMP proxy main configuration":
	    content => template("igmpproxy/config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/igmpproxy.conf";
    }
}
