class nsd::config {
    $conf_dir     = $nsd::vars::conf_dir
    $listen_addr  = $nsd::vars::listen_addr
    $listen_port  = $nsd::vars::listen_port
    $rndc_keys    = $nsd::vars::rndc_keys
    $run_dir      = $nsd::vars::run_dir
    $runtime_user = $nsd::vars::runtime_user
    $zones_dir    = $nsd::vars::zones_dir

    file {
	"Prepare NSD for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare NSD services configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/nsd.conf.d",
	    require => File["Prepare NSD for further configuration"];
	"Install NSD server configuration":
	    content => template("nsd/server.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nsd"],
	    owner   => root,
	    path    => "$conf_dir/nsd.conf.d/server.conf",
	    require => File["Prepare NSD services configuration directory"];
	"Install NSD RNDC keys configuration":
	    content => template("nsd/dhcp.erb"),
	    group   => $nsd::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["nsd"],
	    owner   => root,
	    path    => "$conf_dir/nsd.conf.d/dhcp.conf",
	    require => File["Prepare NSD services configuration directory"];
	"Install NSD main configuration":
	    content => template("nsd/nsd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nsd"],
	    owner   => root,
	    path    => "$conf_dir/nsd.conf",
	    require =>
		[
		    File["Install NSD server configuration"],
		    File["Install NSD zones configuration"]
		];
    }
}
