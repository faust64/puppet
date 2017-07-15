class unbound::scripts {
    $conf_dir     = $unbound::vars::conf_dir
    $pixeladdress = $unbound::vars::pixeladdress

    file {
	"Install blocklist generation script":
	    content => template("unbound/blockgen.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    notify  => Exec["Regenerate unbound blocklist.conf"],
	    owner   => root,
	    path    => "/usr/local/sbin/blocklist_gen",
	    require => File["Prepare unbound for further configuration"];
    }

    if ($unbound::vars::fail2ban_unbound == true) {
	file {
	    "Install unbound stats script":
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/local/bin/unbound_stats",
		require => File["Prepare unbound for further configuration"],
		source  => "puppet:///modules/unbound/stats";
	}
    } else {
	file {
	    "Install unbound stats script":
		ensure  => absent,
		force   => true,
		path    => "/usr/local/bin/unbound_stats",
		require => File["Prepare unbound for further configuration"];
	}
    }
}
