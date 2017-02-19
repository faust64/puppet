class rsync::config {
    $conf_dir = $rsync::vars::conf_dir
    $remotes  = $rsync::vars::clients
    $shares   = $rsync::vars::shares

    if ($shares or $remotes) {
	file {
	    "Install Rsync main configuration":
		content => template("rsync/rsyncd.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service[$rsync::vars::service_name],
		owner   => root,
		path    => "$conf_dir/rsyncd.conf";
	}
    }
}
