class common::config::wget {
    $cache_ip = hiera("squid_ip")

    file {
	"Install wget main configuration":
	    content => template("common/wgetrc.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/wgetrc";
    }
}
