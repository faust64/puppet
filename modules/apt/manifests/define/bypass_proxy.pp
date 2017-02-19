define apt::define::bypass_proxy($host = false) {
    if ($host != false) {
	file {
	    "Install apt proxy bypass configuration for $name":
		content => template("apt/bypass.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/apt/apt.conf.d/90bypass$name",
		require => File["Prepare APT for further configuration"];
	}

	File["Install apt proxy bypass configuration for $name"]
	    -> Exec["Update APT local cache"]
    }
}
