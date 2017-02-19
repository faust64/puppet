class mongodb::config {
    $conf_dir = $mongodb::vars::conf_dir
    $dbpath   = $mongodb::vars::dbpath
    $journal  = $mongodb::vars::journal
    $listen   = $mongodb::vars::listen
    $log_dir  = $mongodb::vars::log_dir
    $port     = $mongodb::vars::port

    file {
	"Prepare MongoDB database directory":
	    ensure  => directory,
	    group   => $mongodb::vars::runtime_group,
	    mode    => "0755",
	    owner   => $mongodb::vars::runtime_user,
	    path    => $dbpath,
	    require => Package["mongodb"];
	"Prepare MongoDB logs directory":
	    ensure  => directory,
	    group   => $mongodb::vars::runtime_group,
	    mode    => "0755",
	    owner   => $mongodb::vars::runtime_user,
	    path    => $log_dir,
	    require => Package["mongodb"];
    }
    if ($mongodb::vars::do_service) {
	file {
	    "Install MongoDB main configuration":
		content => template("mongodb/mongodb.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service["mongodb"],
		owner   => root,
		path    => "$conf_dir/mongodb.conf",
		require =>
		    [
			File["Prepare MongoDB database directory"],
			File["Prepare MongoDB logs directory"]
		    ];
	}
    } else {
	file {
	    "Install MongoDB main configuration":
		content => template("mongodb/mongodb.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "$conf_dir/mongodb.conf",
		require =>
		    [
			File["Prepare MongoDB database directory"],
			File["Prepare MongoDB logs directory"]
		    ];
	}
    }
}
