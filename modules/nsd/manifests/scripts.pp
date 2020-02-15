class nsd::scripts {
    $conf_dir      = $nsd::vars::conf_dir
    $jumeau        = $nsd::vars::jumeau
    $runtime_group = $nsd::vars::runtime_group
    $runtime_user  = $nsd::vars::runtime_user
    $ssh_port      = $nsd::vars::ssh_port
    $zones         = $nsd::vars::zones
    $zones_dir     = $nsd::vars::zones_dir

    file {
	"Install dnsgen script":
	    content => template("nsd/generate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/dnsgen";
    }
}
