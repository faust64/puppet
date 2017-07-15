define mysysctl::define::setfile($source = false) {
    if ($source) {
	file {
	    "Install $name sysctl configuration":
		group  => lookup("gid_zero"),
		mode   => "0644",
		notify => Exec["Import $name sysctl configuration"],
		owner  => root,
		path   => "/etc/sysctl.d/$name.conf",
		source => "puppet:///modules/$source";
	}

	exec {
	    "Import $name sysctl configuration":
		command     => "sysctl -p /etc/sysctl.d/$name.conf",
		cwd         => "/",
		refreshonly => true,
		path        => "/sbin:/bin";
	}
    }
}
