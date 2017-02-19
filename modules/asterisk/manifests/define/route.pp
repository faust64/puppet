define asterisk::define::route($cidforce = false,
			       $intra    = false,
			       $patterns = hiera("asterisk_public_patterns"),
			       $remote   = false,
			       $routes   = false) {
    $conf_dir     = $asterisk::vars::conf_dir

    if ($remote != $domain and $routes) {
	file {
	    "Install Asterisk route $name configuration":
		content => template("asterisk/route.erb"),
		group   => $asterisk::vars::runtime_group,
		mode    => "0640",
		notify  => Exec["Reload dialplan configuration"],
		owner   => $asterisk::vars::runtime_user,
		path    => "$conf_dir/routes.d/$name.conf",
		require => File["Prepare Asterisk outbound routes directory"];
	}

	File["Install Asterisk route $name configuration"]
	    -> File["Install Asterisk extensions main configuration"]
    }
}
