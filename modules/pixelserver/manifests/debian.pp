class pixelserver::debian {
    file {
	"Install pixelserver rc script":
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    notify => Service["pixelserver"],
	    owner  => root,
	    path   => "/etc/init.d/pixelserver",
	    source => "puppet:///modules/pixelserver/debian.rc";
    }

    if ($lsbdistcodename == "jessie") {
	file {
	    "Install pixelservice script":
		group  => hiera("gid_zero"),
		mode   => "0750",
		notify => Service["pixelserver"],
		owner  => root,
		path   => "/usr/local/sbin/pixelservice",
		source => "puppet:///modules/pixelserver/debian.rc";
	    "Install pixelserver systemd service declaration":
		group  => hiera("gid_zero"),
		mode   => "0644",
		notify  => Exec["Reload systemd configuration"],
		owner  => root,
		path   => "/lib/systemd/system/pixelserver.service",
		source => "puppet:///modules/pixelserver/systemd";
	    "Enable pixelserver systemd":
		ensure  => link,
		force   => true,
		notify  => Exec["Reload systemd configuration"],
		path    => "/lib/systemd/system/multi-user.target.wants/pixelserver.service",
		require => File["Install pixelserver systemd service declaration"],
		target  => "../pixelserver.service";
	}

	File["Install pixelservice script"]
	    -> File["Install pixelserver systemd service declaration"]
	    -> File["Enable pixelserver systemd"]
	    -> File["Install pixelserver rc script"]
    }

    File["Install pixelserver rc script"]
	-> File["Install pixelserver"]
	-> Service["pixelserver"]
}
