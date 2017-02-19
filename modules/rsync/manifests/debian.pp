class rsync::debian {
    common::define::package {
	"rsync":
    }

    if ($rsync::vars::shares or $rsync::vars::clients) {
	file {
	    "Install Rsync defaults configuration":
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service[$rsync::vars::service_name],
		owner   => root,
		path    => "/etc/default/rsync",
		require => Package["rsync"],
		source  => "puppet:///modules/rsync/debian-defaults";
	}
    }
}
