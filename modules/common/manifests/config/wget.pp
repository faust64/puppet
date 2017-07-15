class common::config::wget {
    $cache_ip = lookup("squid_ip")

    file {
	"Install wget main configuration":
	    content => template("common/wgetrc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/wgetrc";
    }
}
