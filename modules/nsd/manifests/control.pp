class nsd::control {
    $conf_dir           = $nsd::vars::conf_dir
    $control_enabled    = $nsd::vars::control_enabled
    $control_listenaddr = $nsd::vars::control_listenaddr
    $control_listenport = $nsd::vars::control_listenport

    if ($control_enabled) {
	exec {
	    "Generate NSD control key pairs":
		command => "nsd-control-setup",
		creates => "$conf_dir/nsd_control.key",
		cwd     => $conf_dir,
		notify  => Service["nsd"],
		path    => "/usr/sbin:/sbin:/usr/bin:/bin",
		require => File["Prepare NSD for further configuration"];
	}
    }

    file {
	"Install NSD control configuration":
	    content => template("nsd/remote-control.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nsd"],
	    owner   => root,
	    path    => "$conf_dir/nsd.conf.d/remote-control.conf",
	    require => File["Prepare NSD services configuration directory"];
    }
}
