class smokeping::config {
    $conf_dir = $smokeping::vars::conf_dir
    $netids   = $smokeping::vars::netids
    $targets  = $smokeping::vars::targets

    file {
	"Prepare smokeping for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare smokeping config.d directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/config.d",
	    require => File["Prepare smokeping for further configuration"];

	"Install smokeping targets configuration":
	    content => template("smokeping/targets.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["smokeping"],
	    owner   => root,
	    path    => "$conf_dir/config.d/Targets",
	    require => File["Prepare smokeping config.d directory"];
    }
}
