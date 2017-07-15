class nodejs::customservice {
    if ($lsbdistcodename == "wheezy" or $lsbdistcodename == "trusty") {
	file {
	    "Install Node.JS service init script":
		group  => lookup("gid_zero"),
		mode   => "0755",
		notify => Service["nodejs"],
		owner  => root,
		path   => "/etc/init.d/nodejs",
		source => "puppet:///modules/nodejs/debian.rc";
	}
    } else {
	file {
	    "Install Node.JS service init script":
		group  => lookup("gid_zero"),
		mode   => "0755",
		notify => Service["nodejs"],
		owner  => root,
		path   => "/usr/local/sbin/nodejsservice",
		source => "puppet:///modules/nodejs/debian.rc";
	    "Install Node.JS systemd service declaration":
		group  => lookup("gid_zero"),
		mode   => "0644",
		notify  => Exec["Reload systemd configuration"],
		owner  => root,
		path   => "/lib/systemd/system/nodejs.service",
		source => "puppet:///modules/nodejs/systemd";
	    "Enable Node.JS systemd":
		ensure  => link,
		force   => true,
		notify  => Exec["Reload systemd configuration"],
		path    => "/lib/systemd/system/multi-user.target.wants/nodejs.service",
		require => File["Install Node.JS systemd service declaration"],
		target  => "../nodejs.service";
	}
    }
}
