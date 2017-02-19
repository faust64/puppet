class unbound::logrotate {
    $rotate   = $unbound::vars::rotate
    $rungroup = $unbound::vars::runtime_group
    $runuser  = $unbound::vars::runtime_user

    if ($unbound::vars::fail2ban_unbound == true) {
	file {
	    "Install unbound logrotate configuration":
		content => template("unbound/logrotate.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/logrotate.d/unbound",
		require => File["Prepare Logrotate for further configuration"];
	}
    } else {
	file {
	    "Drop unbound logrotate coniguration":
		ensure => absent,
		force  => true,
		path    => "/etc/logrotate.d/unbound",
		require => File["Prepare Logrotate for further configuration"];
	}
    }
}
