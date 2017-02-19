class ripd::config {
    $rip_auth                = $ripd::vars::rip_auth
    $rip_authid              = $ripd::vars::rip_authid
    $rip_authkey             = $ripd::vars::rip_authkey
    $rip_conf_dir            = $ripd::vars::rip_conf_dir
    $rip_hello_interval      = $ripd::vars::rip_hello_interval
    $rip_map                 = $ripd::vars::rip_map
    $rip_no_redistribute     = $ripd::vars::rip_no_redistribute
    $rip_redistribute        = $ripd::vars::rip_redistribute
    $rip_splithorizon_method = $ripd::vars::rip_splithorizon_method

    file {
	"Install Ripd configuration":
	    content => template("ripd/ripd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload rip configuration"],
	    owner   => root,
	    path    => "$rip_conf_dir/ripd.conf";
    }
}
