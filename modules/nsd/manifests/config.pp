class nsd::config {
    $conf_dir     = $nsd::vars::conf_dir
    $listen_addr  = $nsd::vars::listen_addr
    $listen_port  = $nsd::vars::listen_port
    $run_dir      = $nsd::vars::run_dir
    $runtime_user = $nsd::vars::runtime_user
    $zones_dir    = $nsd::vars::zones_dir

    file {
	"Prepare NSD for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare NSD services configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/nsd.conf.d",
	    require => File["Prepare NSD for further configuration"];
	"Install NSD server configuration":
	    content => template("nsd/server.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nsd"],
	    owner   => root,
	    path    => "$conf_dir/nsd.conf.d/server.conf",
	    require => File["Prepare NSD services configuration directory"];
	"Install NSD main configuration":
	    content => template("nsd/nsd.erb"),
	    group   => hiera("gid_zero"),
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
