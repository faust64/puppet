class isakmpd::config {
    $conf_dir             = $isakmpd::vars::conf_dir
    $ipsec_tunnels        = $isakmpd::vars::ipsec_tunnels
    $isakmpd_dpd_interval = $isakmpd::vars::isakmpd_dpd_interval
    $isakmpd_listen       = $isakmpd::vars::isakmpd_listen
    $isakmpd_lifetimep1   = $isakmpd::vars::isakmpd_lifetimep1
    $isakmpd_lifetimep2   = $isakmpd::vars::isakmpd_lifetimep2

    file {
	"Prepare Isakmpd for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install Isakmpd main configuration":
	    content => template("isakmpd/isakmpd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service["isakmpd"],
	    owner   => root,
	    path    => "$conf_dir/isakmpd.conf",
	    require => File["Prepare Isakmpd for further configuration"];
    }
}
