class nsd::zones {
    $conf_dir    = $nsd::vars::conf_dir
    $listen_port = $nsd::vars::listen_port
    $rndc_keys   = $nsd::vars::rndc_keys
    $zones       = $nsd::vars::zones
    $zones_dir   = $nsd::vars::zones_dir

    file {
	"Prepare NSD zones directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $zones_dir,
	    require => File["Prepare NSD for further configuration"];
	"Install NSD zones configuration":
	    content => template("nsd/zones.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service["nsd"],
	    owner   => root,
	    path    => "$conf_dir/nsd.conf.d/zones.conf",
	    require => File["Prepare NSD services configuration directory"];
    }

    each($zones) |$zone| {
	file {
	    "Install NSD zone $zone":
		content => template("named/db.erb"),
		group   => $nsd::vars::runtime_group,
		mode    => "0644",
		notify  => Service["nsd"],
		owner   => $nsd::vars::runtime_user,
		path    => "$zones_dir/db.$zone",
		replace => no,
		require => File["Prepare NSD zones directory"];
	}

	File["Install NSD zone $zone"]
	    -> File["Install NSD zones configuration"]
    }
}
